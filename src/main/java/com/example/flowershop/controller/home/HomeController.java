package com.example.flowershop.controller.home;

import com.example.flowershop.dao.home.HomeBannerDAO;
import com.example.flowershop.dao.home.HomeCategoryDAO;
import com.example.flowershop.dao.home.HomeProductDAO;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class HomeController {

    @Autowired
    private HomeCategoryDAO homeCategoryDAO;

    @Autowired
    private HomeProductDAO homeProductDAO;

    @Autowired
    private HomeBannerDAO homeBannerDAO;

    /**
     * Trang chủ (public) – cả "/" và "/home/index" đều vào đây.
     * Hiển thị:
     *  - Mega menu ngang (5 danh mục chính)
     *  - Banner slider
     *  - Khối "Tư vấn chọn hoa"
     *  - 3 block danh mục + sản phẩm: Hoa Sinh Nhật, Hoa Khai Trương, Hoa Cưới
     */
    @GetMapping({"/", "/home/index"})
    public String home(Model model, HttpSession session) {

        // ========== DANH MỤC / BANNER / SẢN PHẨM ==========

        // Tất cả danh mục active – dùng cho combobox, tư vấn chọn hoa, v.v.
        model.addAttribute("allCategories", homeCategoryDAO.findActiveCategories());

        // 5 danh mục cho mega menu ngang
        model.addAttribute("megaCategories", homeCategoryDAO.findCategoriesForHomeMenu());

        // Banner slider
        model.addAttribute("banners", homeBannerDAO.findActiveBanners());

        // 3 danh mục ưu tiên + danh sách sản phẩm
        model.addAttribute("birthdayProducts",
                homeProductDAO.findTopProductsByCategoryName("Hoa Sinh Nhật", 8));

        model.addAttribute("openingProducts",
                homeProductDAO.findTopProductsByCategoryName("Hoa Khai Trương", 8));

        model.addAttribute("weddingProducts",
                homeProductDAO.findTopProductsByCategoryName("Hoa Cưới", 8));

        // ========== SỐ SẢN PHẨM TRONG GIỎ (BADGE ĐỎ) ==========
        Object countObj = session.getAttribute("cartItemCount");
        int cartItemCount = 0;
        if (countObj instanceof Integer) {
            cartItemCount = (Integer) countObj;
        }
        model.addAttribute("cartItemCount", cartItemCount);

        return "home/index";   // /WEB-INF/views/home/index.jsp
    }
    @GetMapping("/home/payment")
public String openPaymentFromAnywhere(HttpSession session, Model model) {
    // Không xử lý gì ở đây, chỉ forward sang /checkout/payment,
    // toàn bộ logic nằm ở CheckoutController.showPaymentPage(...)
    return "forward:/checkout/payment";
}

    /**
     * Trang thanh toán VNPAY - tạo thanh toán
     */
    @GetMapping("/home/vnpay-payment")
    public String vnpayPayment(
            @RequestParam("orderCode") String orderCode,
            @RequestParam("amount") String amount,
            Model model,
            HttpSession session) {
        
        model.addAttribute("orderCode", orderCode);
        model.addAttribute("amount", amount);
        model.addAttribute("megaCategories", homeCategoryDAO.findCategoriesForHomeMenu());
        
        Object countObj = session.getAttribute("cartItemCount");
        int cartItemCount = (countObj instanceof Integer) ? (Integer) countObj : 0;
        model.addAttribute("cartItemCount", cartItemCount);
        
        return "home/vnpay_payment";
    }
}
