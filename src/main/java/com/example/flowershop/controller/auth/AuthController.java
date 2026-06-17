package com.example.flowershop.controller.auth;

import com.example.flowershop.dao.UserDAO;
import com.example.flowershop.dao.home.CartDAO;
import com.example.flowershop.model.CartItem;
import com.example.flowershop.model.User;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;   // ✅ THÊM DÒNG NÀY
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
public class AuthController {

    @Autowired
    private UserDAO userDAO;

    @Autowired
    private CartDAO cartDAO;

    @GetMapping("/auth/login")
    public String loginPage() {
        return "auth/login";
    }

    @GetMapping("/auth/register")
    public String registerForm(Model model) {
        model.addAttribute("user", new User());
        return "auth/register";
    }

    @PostMapping("/auth/register")
    public String doRegister(@ModelAttribute("user") User user, Model model) {
        if (userDAO.findByEmail(user.getEmail()) != null) {
            model.addAttribute("error", "Email đã tồn tại, vui lòng chọn email khác.");
            return "auth/register";
        }

        // Kiểm tra mật khẩu có ký tự @
        if (!user.getPassword().contains("@")) {
            model.addAttribute("error", "Mật khẩu phải chứa ký tự '@'.");
            return "auth/register";
        }

        // Gán role và status
        user.setRole("customer");
        user.setStatus("active");

        userDAO.saveCustomer(user);

        // Sau khi đăng ký xong → redirect về trang login, kèm thông báo
        return "redirect:/auth/login?registered=true";
    }

    /**
     * Được gọi SAU KHI login thành công (do Spring Security redirect tới).
     * Mục đích: load lại giỏ hàng từ DB và nhét vào session.
     */
    @GetMapping("/auth/login-success")
    public String loginSuccess(HttpSession session, Authentication authentication) {
        // Lấy email đang login
        String email = authentication.getName();
        User user = userDAO.findByEmail(email);
        if (user != null) {
            // Lưu user vào session nếu bạn đang dùng currentUser
            session.setAttribute("currentUser", user);

            // === NẠP GIỎ TỪ DB ===
            List<CartItem> items = cartDAO.findCartItemsByUserId(user.getUserId());
            session.setAttribute("CART_ITEMS", items);

            int totalQty = 0;
            for (CartItem ci : items) {
                totalQty += ci.getQuantity();
            }
            session.setAttribute("cartItemCount", totalQty);
        }

        return "redirect:/home/index";
    }
}
