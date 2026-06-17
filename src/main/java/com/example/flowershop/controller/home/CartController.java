package com.example.flowershop.controller.home;

import com.example.flowershop.dao.ProductDAO;
import com.example.flowershop.dao.home.CartDAO;
import com.example.flowershop.dao.home.HomeCategoryDAO;
import com.example.flowershop.model.Cart;
import com.example.flowershop.model.CartItem;
import com.example.flowershop.model.Product;
import com.example.flowershop.model.User;
import com.example.flowershop.service.CartService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Controller
@RequestMapping("/cart")
public class CartController {

    @Autowired
    private HomeCategoryDAO homeCategoryDAO;   // dùng cho mega menu + combobox search

    @Autowired
    private ProductDAO productDAO;             // JPA repository để lấy Product theo id

    @Autowired
    private CartDAO cartDAO;                  // DAO thao tác bảng carts (lưu DB)

    @Autowired
    @Qualifier("cartDatabaseService")
    private CartService cartService; // JPA entity service

    // ================== HÀM TIỆN ÍCH ==================

    @SuppressWarnings("unchecked")
    private List<CartItem> getCartFromSession(HttpSession session) {
        List<CartItem> items = (List<CartItem>) session.getAttribute("CART_ITEMS");
        if (items == null) {
            items = new ArrayList<>();
            session.setAttribute("CART_ITEMS", items);
        }
        return items;
    }

    /**
     * Cập nhật tổng số lượng sản phẩm trong giỏ và lưu vào session ("cartItemCount").
     * Dùng cho badge đỏ trên icon giỏ hàng.
     */
    private void updateCartItemCountInSession(HttpSession session) {
        List<CartItem> items = getCartFromSession(session);
        int totalQty = 0;
        for (CartItem ci : items) {
            totalQty += ci.getQuantity();
        }
        session.setAttribute("cartItemCount", totalQty);
    }

    /**
     * Đọc "cartItemCount" từ session và nhét vào model để JSP dùng.
     */
    private void addCartCountToModel(HttpSession session, Model model) {
        Object countObj = session.getAttribute("cartItemCount");
        int cartItemCount = 0;
        if (countObj instanceof Integer) {
            cartItemCount = (Integer) countObj;
        }
        model.addAttribute("cartItemCount", cartItemCount);
    }

    /**
     * Đồng bộ giỏ hàng từ session sang database khi user đăng nhập
     */
    public void syncCartFromSessionToDatabase(User user, HttpSession session) {
        if (user != null) {
            List<CartItem> sessionItems = getCartFromSession(session);
            if (!sessionItems.isEmpty()) {
                cartService.syncCartFromSession(user, sessionItems);
                // Xóa giỏ hàng session sau khi đã sync
                session.removeAttribute("CART_ITEMS");
                updateCartItemCountInSession(session);
            }
        }
    }

    // ================== HIỂN THỊ GIỎ HÀNG ==================

    // GET /cart
    @GetMapping
    public String showCart(Model model, HttpSession session) {
        // Mega menu + combobox tìm kiếm giống trang index
        model.addAttribute("megaCategories", homeCategoryDAO.findCategoriesForHomeMenu());
        model.addAttribute("allCategories", homeCategoryDAO.findActiveCategories());

        List<CartItem> items;
        User currentUser = (User) session.getAttribute("currentUser");
        
        if (currentUser != null) {
            // User đã đăng nhập - lấy từ database
            items = cartService.getCartItems(currentUser);
        } else {
            // User chưa đăng nhập - lấy từ session
            items = getCartFromSession(session);
        }
        
        model.addAttribute("cartItems", items);

        // Tính tạm tính cho các item đang được chọn
        long subTotal = 0L;
        for (CartItem ci : items) {
            if (ci.isSelected()) {
                subTotal += ci.getLineTotal().longValue();
            }
        }

        long shippingFee = 0L;
        if (subTotal > 0 && subTotal < 500_000L) {
            shippingFee = 60_000L;
        }

        long total = subTotal + shippingFee;

        model.addAttribute("subTotal", subTotal);
        model.addAttribute("shippingFee", shippingFee);
        model.addAttribute("totalAmount", total);

        // Cập nhật lại cartItemCount trong session và đưa vào model
        if (currentUser != null) {
            // User đã đăng nhập - lấy tổng số lượng từ database
            int totalQuantity = cartService.getTotalQuantity(currentUser);
            session.setAttribute("cartItemCount", totalQuantity);
            model.addAttribute("cartItemCount", totalQuantity);
        } else {
            // User chưa đăng nhập - tính từ session
            updateCartItemCountInSession(session);
            addCartCountToModel(session, model);
        }

        return "home/cart";  // /WEB-INF/views/home/cart.jsp
    }

    // ================== THÊM VÀO GIỎ ==================

    // POST /cart/add  (form ở trang chủ & product-detail đang dùng)
    @PostMapping("/add")
    public String addToCart(@RequestParam("productId") Integer productId,
                            @RequestParam(value = "quantity", defaultValue = "1") Integer quantity,
                            HttpSession session) {

        try {
            if (quantity == null || quantity < 1) {
                quantity = 1;
            }

            // Lấy sản phẩm (Spring Data JPA trả Optional<Product>)
            Optional<Product> opt = productDAO.findById(productId);
            if (opt.isEmpty()) {
                // không thấy sản phẩm, quay về trang chủ
                return "redirect:/home/index";
            }
            Product p = opt.get();

            // ====== 1. LƯU TRONG SESSION (để hiển thị lên JSP) ======
            List<CartItem> items = getCartFromSession(session);
            CartItem existed = null;
            for (CartItem ci : items) {
                if (ci.getProduct() != null && ci.getProduct().getId().equals(productId)) {
                    existed = ci;
                    break;
                }
            }
            if (existed != null) {
                existed.setQuantity(existed.getQuantity() + quantity);
            } else {
                items.add(new CartItem(p, quantity));
            }

            // ====== 2. NẾU ĐÃ LOGIN -> LƯU DB (dùng JPA entity service) ======
            User currentUser = (User) session.getAttribute("currentUser");
            if (currentUser != null) {
                // Sử dụng JPA entity service cho user đã đăng nhập
                Cart savedCart = cartService.addToCart(currentUser, p, quantity);
                if (savedCart == null) {
                    // Nếu lưu vào DB thất bại, vẫn tiếp tục với session
                    System.err.println("Failed to save cart to database, using session only");
                }
            }
            // User chưa đăng nhập chỉ lưu trong session, không lưu vào database

            // Cập nhật số lượng icon giỏ
            updateCartItemCountInSession(session);

            // quay về trang giỏ
            return "redirect:/cart";
        } catch (Exception e) {
            // Log error và redirect về trang chủ với thông báo lỗi
            System.err.println("Error in addToCart: " + e.getMessage());
            e.printStackTrace();
            return "redirect:/home/index";
        }
    }

    // ================== CẬP NHẬT GIỎ HÀNG ==================

    // POST /cart/update  (form id="cart-form" trong cart.jsp đang dùng)
    @PostMapping("/update")
    public String updateCart(
            @RequestParam(required = false, name = "selectedIds") List<Integer> selectedIds,
            @RequestParam Map<String, String> allParams,
            HttpSession session) {

        List<CartItem> items = getCartFromSession(session);

        // Cập nhật trạng thái selected (checkbox)
        for (CartItem ci : items) {
            Integer pid = ci.getProductId();
            boolean isSelected = selectedIds != null && selectedIds.contains(pid);
            ci.setSelected(isSelected);
        }

        // Cập nhật số lượng: input name="qty_{productId}"
        for (CartItem ci : items) {
            Integer pid = ci.getProductId();
            String key = "qty_" + pid;
            if (allParams.containsKey(key)) {
                try {
                    int q = Integer.parseInt(allParams.get(key));
                    if (q < 1) q = 1;
                    ci.setQuantity(q);
                } catch (NumberFormatException ignore) {
                }
            }
        }

        // Nếu đã login thì sync số lượng xuống DB (dùng entity service)
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser != null) {
            for (CartItem ci : items) {
                Integer pid = ci.getProductId();
                Product product = productDAO.findById(pid).orElse(null);
                if (product != null) {
                    cartService.updateQuantity(currentUser, product, ci.getQuantity());
                }
            }
        }

        updateCartItemCountInSession(session);
        return "redirect:/cart";
    }

    // ================== XOÁ 1 DÒNG GIỎ HÀNG ==================

    // GET /cart/remove?productId=...
    @GetMapping("/remove")
    public String removeItem(@RequestParam("productId") Integer productId,
                             HttpSession session) {
        List<CartItem> items = getCartFromSession(session);
        items.removeIf(ci -> ci.getProduct() != null
                && ci.getProduct().getId().equals(productId));

        // Nếu đã login thì xoá luôn dưới DB (dùng entity service)
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser != null) {
            Product product = productDAO.findById(productId).orElse(null);
            if (product != null) {
                cartService.removeFromCart(currentUser, product);
            }
        }

        updateCartItemCountInSession(session);
        return "redirect:/cart";
    }
}
