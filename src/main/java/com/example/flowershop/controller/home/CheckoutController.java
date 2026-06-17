package com.example.flowershop.controller.home;

import com.example.flowershop.model.Order;
import com.example.flowershop.dao.home.CustomerOrderDAO;
import com.example.flowershop.dao.home.OrderInfo;
import com.example.flowershop.dao.home.HomeCategoryDAO;
import com.example.flowershop.model.CartItem;
import com.example.flowershop.model.Category;
import com.example.flowershop.model.CheckoutInfo;
import com.example.flowershop.model.Product;
import com.example.flowershop.model.User;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/checkout")
public class CheckoutController {

    @Autowired
    private CustomerOrderDAO customerOrderDAO;

    @Autowired
    private HomeCategoryDAO homeCategoryDAO;

    // ================== HÀM TIỆN ÍCH ==================

    /**
     * Lấy giỏ hàng từ session – ĐÚNG với CartController hiện tại
     * Key: "CART_ITEMS", kiểu: List<CartItem>
     */
    @SuppressWarnings("unchecked")
    private List<CartItem> getCartItems(HttpSession session) {
        Object obj = session.getAttribute("CART_ITEMS");
        if (obj instanceof List<?> list) {
            return (List<CartItem>) list;
        }
        return new ArrayList<>();
    }

    /** Tính subtotal / ship / total từ danh sách item đã chọn */
    private void prepareSummary(List<CartItem> items, Model model) {
        BigDecimal subtotal = BigDecimal.ZERO;

        for (CartItem item : items) {
            Product p = item.getProduct();
            if (p == null) continue;

            BigDecimal unitPrice =
                    (p.getDiscountPrice() != null
                            && p.getDiscountPrice().compareTo(BigDecimal.ZERO) > 0)
                            ? p.getDiscountPrice()
                            : p.getPrice();

            if (unitPrice == null) unitPrice = BigDecimal.ZERO;

            subtotal = subtotal.add(
                    unitPrice.multiply(BigDecimal.valueOf(item.getQuantity()))
            );
        }

        BigDecimal freeThreshold = new BigDecimal("500000"); // >= 500k free ship
        BigDecimal shippingFee = BigDecimal.ZERO;
        BigDecimal shippingUnder = new BigDecimal("60000");  // < 500k: 60k ship

        if (subtotal.compareTo(BigDecimal.ZERO) > 0 &&
                subtotal.compareTo(freeThreshold) < 0) {
            shippingFee = shippingUnder;
        }

        BigDecimal totalAmount = subtotal.add(shippingFee);

        model.addAttribute("checkoutSubtotal", subtotal);
        model.addAttribute("checkoutShipping", shippingFee);
        model.addAttribute("checkoutTotal", totalAmount);
        model.addAttribute("freeShipping", shippingFee.compareTo(BigDecimal.ZERO) == 0);
    }

    // ================== BƯỚC 0: AI GET /checkout thì về giỏ ==================

    @GetMapping
    public String redirectToCart() {
        return "redirect:/cart";
    }

    // ================== BƯỚC 1: LƯU THÔNG TIN TỪ GIỎ HÀNG ==================

    /**
     * Nhận info từ cart.jsp (buyer/receiver) -> lưu vào session,
     * sau đó redirect sang /home/payment để chọn phương thức thanh toán.
     *
     * Form ở cart.jsp: action = "${ctx}/checkout/info"
     */
    @PostMapping("/info")
 public String saveCheckoutInfo(
        @RequestParam("buyerName") String buyerName,
        @RequestParam("buyerPhone") String buyerPhone,
        @RequestParam(value = "buyerEmail", required = false) String buyerEmail,
        @RequestParam("receiverName") String receiverName,
        @RequestParam("receiverPhone") String receiverPhone,
        @RequestParam("receiverAddress") String receiverAddress,
        @RequestParam(value = "shopNote", required = false) String shopNote,
        @RequestParam(value = "cardMessage", required = false) String cardMessage,
        HttpSession session,
        RedirectAttributes redirectAttributes
) {
        // Lấy giỏ hàng
        List<CartItem> cart = getCartItems(session);
        if (cart.isEmpty()) {
            redirectAttributes.addFlashAttribute("cartError",
                    "Giỏ hàng đang trống, không thể đặt hàng.");
            return "redirect:/cart";
        }

        // Lấy các dòng đang được tick
        List<CartItem> selectedItems = cart.stream()
                .filter(CartItem::isSelected)
                .collect(Collectors.toList());

        if (selectedItems.isEmpty()) {
            redirectAttributes.addFlashAttribute("cartError",
                    "Bạn chưa chọn sản phẩm nào để đặt hàng.");
            return "redirect:/cart";
        }

// Lưu info vào session
    CheckoutInfo info = new CheckoutInfo();
    info.setBuyerName(buyerName);
    info.setBuyerPhone(buyerPhone);
    info.setBuyerEmail(buyerEmail);
    info.setReceiverName(receiverName);
    info.setReceiverPhone(receiverPhone);
    info.setReceiverAddress(receiverAddress);

    // Ghi chú + nội dung thiệp
    info.setNote(shopNote);          // ghi chú cho shop
    info.setCardMessage(cardMessage); // nội dung thiệp

    session.setAttribute("CHECKOUT_INFO", info);

    return "redirect:/home/payment";
}

    // ================== BƯỚC 2 - GET: XEM TRANG THANH TOÁN ==================

    /**
     * Thực chất xử lý chính vẫn ở đây, nhưng /home/payment sẽ "forward"
     * tới /checkout/payment (xem HomeController ở dưới).
     *
     * Trang này:
     *  - LUÔN cho phép vào nếu trong giỏ có sản phẩm (từ trang chủ, danh mục…)
     *  - Nếu CHƯA nhập thông tin nhận hàng -> chỉ cho xem tóm tắt + cảnh báo,
     *    không cho bấm "Đặt hàng".
     *  - Nếu ĐÃ nhập info (CHECKOUT_INFO != null) -> cho chọn phương thức thanh toán và đặt hàng.
     */
   @GetMapping("/payment")
public String showPaymentPage(HttpSession session,
                              Model model) {

    // Mega menu + combobox tìm kiếm
    List<Category> allCategories = homeCategoryDAO.findActiveCategories();
    model.addAttribute("allCategories", allCategories);
    List<Category> megaCategories = homeCategoryDAO.findCategoriesForHomeMenu();
    model.addAttribute("megaCategories", megaCategories);

    // Badge số lượng giỏ
    Object countObj = session.getAttribute("cartItemCount");
    int cartItemCount = (countObj instanceof Integer) ? (Integer) countObj : 0;
    model.addAttribute("cartItemCount", cartItemCount);

    // ===== LỊCH SỬ ĐƠN HÀNG CỦA KHÁCH =====
    User currentUser = (User) session.getAttribute("currentUser");
    if (currentUser != null) {
        List<Order> orders = customerOrderDAO.findOrdersByUserId(currentUser.getUserId());
        model.addAttribute("orders", orders);
    } else {
        model.addAttribute("orders", new ArrayList<Order>());
    }

    // ===== GIỎ HÀNG HIỆN TẠI =====
    List<CartItem> cart = getCartItems(session);
    if (cart.isEmpty()) {
        // Không có sản phẩm nào thì trả về trang payment nhưng danh sách rỗng
        model.addAttribute("selectedItems", new ArrayList<CartItem>());
        prepareSummary(new ArrayList<>(), model);
        model.addAttribute("hasCheckoutInfo", false);
        model.addAttribute("checkoutInfo", null);
        return "home/payment";
    }

    // Lấy những item đang được tick
    List<CartItem> selectedItems = cart.stream()
            .filter(CartItem::isSelected)
            .collect(Collectors.toList());

    // Nếu vì lý do gì đó tất cả đều không selected -> cho xem tất cả
    if (selectedItems.isEmpty()) {
        selectedItems = cart;
    }

    model.addAttribute("selectedItems", selectedItems);

    // Thông tin nhận hàng (nếu có)
    CheckoutInfo info = (CheckoutInfo) session.getAttribute("CHECKOUT_INFO");
    boolean hasCheckoutInfo = (info != null);

    model.addAttribute("checkoutInfo", info);
    model.addAttribute("hasCheckoutInfo", hasCheckoutInfo);

    // Tính tiền
    prepareSummary(selectedItems, model);

    // View: /WEB-INF/views/home/payment.jsp
    return "home/payment";
}


    // ================== BƯỚC 2 - POST: ĐẶT HÀNG ==================

    @PostMapping("/place-order")
    public String placeOrder(
            @RequestParam("paymentMethod") String paymentMethod, // COD | bank_transfer
            HttpSession session,
            RedirectAttributes redirectAttributes
    ) {
        // VẪN BẮT LOGIN Ở BƯỚC NÀY
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            redirectAttributes.addFlashAttribute("cartError",
                    "Bạn cần đăng nhập để xác nhận đặt hàng.");
            return "redirect:/auth/login";
        }
        Integer userId = currentUser.getUserId();

        CheckoutInfo info = (CheckoutInfo) session.getAttribute("CHECKOUT_INFO");
        if (info == null) {
            // Chưa nhập thông tin ở giỏ -> bắt quay lại giỏ hàng
            redirectAttributes.addFlashAttribute("cartError",
                    "Vui lòng nhập thông tin đặt hàng ở giỏ hàng trước khi xác nhận thanh toán.");
            return "redirect:/cart";
        }

        List<CartItem> cart = getCartItems(session);
        if (cart.isEmpty()) {
            redirectAttributes.addFlashAttribute("cartError",
                    "Giỏ hàng đang trống, không thể đặt hàng.");
            return "redirect:/cart";
        }

        List<CartItem> selectedItems = cart.stream()
                .filter(CartItem::isSelected)
                .collect(Collectors.toList());

        if (selectedItems.isEmpty()) {
            redirectAttributes.addFlashAttribute("cartError",
                    "Bạn chưa chọn sản phẩm nào để đặt hàng.");
            return "redirect:/cart";
        }

        // Tính lại tiền
        BigDecimal subtotal = BigDecimal.ZERO;
        for (CartItem item : selectedItems) {
            Product p = item.getProduct();
            if (p == null) continue;

            BigDecimal unitPrice =
                    (p.getDiscountPrice() != null
                            && p.getDiscountPrice().compareTo(BigDecimal.ZERO) > 0)
                            ? p.getDiscountPrice()
                            : p.getPrice();

            if (unitPrice == null) unitPrice = BigDecimal.ZERO;

            subtotal = subtotal.add(
                    unitPrice.multiply(BigDecimal.valueOf(item.getQuantity()))
            );
        }

        BigDecimal freeThreshold = new BigDecimal("500000");
        BigDecimal shippingFee = BigDecimal.ZERO;
        BigDecimal shippingUnder = new BigDecimal("60000");

        if (subtotal.compareTo(BigDecimal.ZERO) > 0 &&
                subtotal.compareTo(freeThreshold) < 0) {
            shippingFee = shippingUnder;
        }

        BigDecimal totalAmount = subtotal.add(shippingFee);

        // Dia chi don gian
        String fullAddress = info.getReceiverAddress();
        String ward = null;
        String district = "Không rõ quýên";
        String city = "Không rõ TP";

        System.out.println("=== CREATING ORDER ===");
        System.out.println("UserId: " + userId);
        System.out.println("PaymentMethod: " + paymentMethod);
        System.out.println("TotalAmount: " + totalAmount);
        
        OrderInfo orderInfo = customerOrderDAO.createOrder(
                userId,
                info.getReceiverName(),
                info.getReceiverPhone(),
                fullAddress,
                ward,
                district,
                city,
                subtotal,
                shippingFee,
                totalAmount,
                paymentMethod,
                info.getNote(),
                selectedItems
        );
        
        Long orderId = orderInfo.getOrderId();
        String orderCode = orderInfo.getOrderCode();
        
        System.out.println("=== ORDER CREATED ===");
        System.out.println("OrderId: " + orderId);
        System.out.println("OrderCode: " + orderCode);

        // ==== VNPAY FLOW ====
        if ("VNPAY".equals(paymentMethod) || "bank_transfer".equals(paymentMethod)) {
            // Store pending order info in session for post-payment processing
            session.setAttribute("PENDING_ORDER_ID", orderId);
            session.setAttribute("PENDING_ORDER_CODE", orderCode);
            session.setAttribute("PENDING_ORDER_AMOUNT", totalAmount.toString());
            // Don't remove cart items yet - will remove after successful payment
            
            // Redirect to VNPAY payment
            return "redirect:/checkout/vnpay-redirect?orderId=" + orderId + "&orderCode=" + orderCode + "&amount=" + totalAmount;
        }

        // ==== COD FLOW ====
        // Xoá các item đã đặt khỏi giỏ
        cart.removeIf(CartItem::isSelected);
        session.setAttribute("CART_ITEMS", cart);

        // Cập nhật lại số hiển thị trên icon giỏ hàng
        int itemCount = cart.stream()
                .mapToInt(CartItem::getQuantity)
                .sum();
        session.setAttribute("cartItemCount", itemCount);

        // Xoá info tạm
        session.removeAttribute("CHECKOUT_INFO");

        redirectAttributes.addFlashAttribute(
                "cartMessage",
                "Đặt hàng thành công! Mã đơn #" + orderId + "."
        );

        return "redirect:/cart";
    }
    @PostMapping("/orders/cancel")
public String cancelOrder(
        @RequestParam("orderId") Integer orderId,
        @RequestParam("cancelReason") String cancelReason,
        HttpSession session,
        RedirectAttributes redirectAttributes
) {
    User currentUser = (User) session.getAttribute("currentUser");
    if (currentUser == null) {
        redirectAttributes.addFlashAttribute("cartError",
                "Bạn cần đăng nhập để hủy đơn hàng.");
        return "redirect:/auth/login";
    }
    Integer userId = currentUser.getUserId();

    if (cancelReason == null || cancelReason.trim().isEmpty()) {
        cancelReason = "Khách hàng hủy đơn nhưng không ghi lý do.";
    }

    int updated = customerOrderDAO.cancelOrder(orderId, userId, cancelReason);
    if (updated > 0) {
        redirectAttributes.addFlashAttribute("cartMessage",
                "Hủy đơn hàng thành công.");
    } else {
        redirectAttributes.addFlashAttribute("cartError",
                "Không thể hủy đơn hàng. Có thể đơn đã được xử lý hoặc không thuộc về bạn.");
    }

    // Quay lại trang thanh toán (nơi hiển thị danh sách đơn)
    return "redirect:/home/payment";
}

    // ================== VNPAY REDIRECT ==================

    @GetMapping("/vnpay-redirect")
    public String redirectToVNPAY(
            @RequestParam("orderId") Long orderId,
            @RequestParam("orderCode") String orderCode,
            @RequestParam("amount") BigDecimal amount,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            redirectAttributes.addFlashAttribute("cartError",
                    "Ban can dang nhap de thanh toan.");
            return "redirect:/auth/login";
        }

        // Store order info for VNPAY callback
        session.setAttribute("VNPAY_ORDER_ID", orderId);
        session.setAttribute("VNPAY_ORDER_CODE", orderCode);

        // Redirect to VNPAY payment page
        return "redirect:/home/vnpay-payment?orderCode=" + orderCode + "&amount=" + amount.setScale(0, java.math.RoundingMode.DOWN).toPlainString();
    }

    // ================== VNPAY PAYMENT SUCCESS HANDLER ==================

    @GetMapping("/vnpay-success")
    public String handleVNPAYSuccess(
            @RequestParam(value = "orderCode", required = false) String orderCode,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        
        // Clear cart items that were pending
        List<CartItem> cart = getCartItems(session);
        cart.removeIf(CartItem::isSelected);
        session.setAttribute("CART_ITEMS", cart);

        // Update cart count
        int itemCount = cart.stream()
                .mapToInt(CartItem::getQuantity)
                .sum();
        session.setAttribute("cartItemCount", itemCount);

        // Clear checkout info
        session.removeAttribute("CHECKOUT_INFO");
        session.removeAttribute("PENDING_ORDER_ID");
        session.removeAttribute("PENDING_ORDER_CODE");
        session.removeAttribute("PENDING_ORDER_AMOUNT");
        session.removeAttribute("VNPAY_ORDER_ID");
        session.removeAttribute("VNPAY_ORDER_CODE");

        redirectAttributes.addFlashAttribute("cartMessage",
                "Thanh toán VNPAY thành công! Mã don " + orderCode);
        return "redirect:/cart";
    }

    // ================== VNPAY PAYMENT FAILURE HANDLER ==================

    @GetMapping("/vnpay-failed")
    public String handleVNPAYFailed(
            @RequestParam(value = "orderCode", required = false) String orderCode,
            @RequestParam(value = "error", required = false) String error,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        
        // Cart items are still there, user can retry or choose COD
        redirectAttributes.addFlashAttribute("cartError",
                "Thanh toán VNPAY thất bại: " + (error != null ? error : "Unknown error") + 
                ". Bạn có thể thử lại hoặc chọn thanh toán COD.");
        return "redirect:/home/payment";
    }

}
