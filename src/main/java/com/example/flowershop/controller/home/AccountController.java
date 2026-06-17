package com.example.flowershop.controller.home;

import com.example.flowershop.dao.OrderDAO;
import com.example.flowershop.dao.UserDAO;
import com.example.flowershop.dao.home.HomeCategoryDAO;
import com.example.flowershop.model.Order;
import com.example.flowershop.model.User;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
public class AccountController {

    @Autowired
    private UserDAO userDAO;

    @Autowired
    private OrderDAO orderDAO;

    @Autowired
    private HomeCategoryDAO homeCategoryDAO;

    /**
     * Dữ liệu dùng chung cho header + mega menu:
     *  - allCategories: combobox tìm kiếm
     *  - megaCategories: 5 danh mục trên mega menu
     *  - cartItemCount: số sản phẩm hiển thị ở icon giỏ hàng
     */
    @ModelAttribute
    public void addCommonAttributes(Model model, HttpSession session) {
        // Tất cả danh mục active cho combobox search + tư vấn
        model.addAttribute("allCategories", homeCategoryDAO.findActiveCategories());

        // 5 danh mục cho mega menu ngang
        model.addAttribute("megaCategories", homeCategoryDAO.findCategoriesForHomeMenu());

        // Số sản phẩm trong giỏ (badge đỏ ở icon giỏ hàng)
        Object countObj = session.getAttribute("cartItemCount");
        int cartItemCount = 0;
        if (countObj instanceof Integer) {
            cartItemCount = (Integer) countObj;
        }
        model.addAttribute("cartItemCount", cartItemCount);
    }

    /**
     * Trang tài khoản: hồ sơ + đổi mật khẩu + lịch sử đơn hàng
     */
    @GetMapping("/account")
    public String accountPage(Model model,
                              HttpSession session,
                              RedirectAttributes ra) {

        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            ra.addFlashAttribute("errorMessage", "Bạn cần đăng nhập trước.");
            // Đổi lại path login cho đúng với project của bạn nếu khác
            return "redirect:/auth/login";
        }

        // Lấy user mới nhất từ DB
        User user = userDAO.findById(currentUser.getId());

        // Lịch sử đơn hàng theo user_id
        List<Order> orders = orderDAO.findByUserId(user.getId());

        model.addAttribute("user", user);
        model.addAttribute("orders", orders);

        return "home/account"; // /WEB-INF/views/home/account.jsp
    }

    /**
     * Cập nhật hồ sơ (tên, SĐT, email)
     */
    @PostMapping("/account/update-profile")
    public String updateProfile(@RequestParam("fullName") String fullName,
                                @RequestParam("phone") String phone,
                                @RequestParam("email") String email,
                                HttpSession session,
                                RedirectAttributes ra) {

        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            ra.addFlashAttribute("errorMessage", "Bạn cần đăng nhập trước.");
            return "redirect:/auth/login";
        }

        userDAO.updateProfile(currentUser.getId(), fullName, phone, email);

        // Cập nhật lại thông tin session nếu cần
        currentUser.setFullName(fullName);
        currentUser.setPhone(phone);
        currentUser.setEmail(email);
        session.setAttribute("currentUser", currentUser);

        ra.addFlashAttribute("successMessage", "Cập nhật hồ sơ thành công.");
        return "redirect:/account";
    }

    /**
     * Đổi mật khẩu
     */
    @PostMapping("/account/change-password")
    public String changePassword(@RequestParam("oldPassword") String oldPassword,
                                 @RequestParam("newPassword") String newPassword,
                                 @RequestParam("confirmPassword") String confirmPassword,
                                 HttpSession session,
                                 RedirectAttributes ra) {

        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            ra.addFlashAttribute("errorMessage", "Bạn cần đăng nhập trước.");
            return "redirect:/auth/login";
        }

        if (!newPassword.equals(confirmPassword)) {
            ra.addFlashAttribute("errorMessage", "Mật khẩu mới và xác nhận không khớp.");
            return "redirect:/account";
        }

        boolean ok = userDAO.changePassword(currentUser.getId(), oldPassword, newPassword);
        if (!ok) {
            ra.addFlashAttribute("errorMessage", "Mật khẩu hiện tại không chính xác.");
        } else {
            ra.addFlashAttribute("successMessage", "Đổi mật khẩu thành công.");
        }

        return "redirect:/account";
    }
}
