package com.example.flowershop.controller.home;

import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

@ControllerAdvice
public class GlobalModelAttributes {

    @Autowired
    private CartService cartService;  // dùng CartService cùng package

    /**
     * Biến global cho tất cả view: số lượng sản phẩm trong giỏ.
     * JSP dùng: ${cartItemCount}
     */
    @ModelAttribute("cartItemCount")
    public int cartItemCount(HttpSession session) {
        return cartService.getTotalQuantity(session);
    }
}

