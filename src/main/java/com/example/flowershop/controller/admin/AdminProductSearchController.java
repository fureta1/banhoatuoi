package com.example.flowershop.controller.admin;

import com.example.flowershop.dao.ProductDAO;
import com.example.flowershop.model.Product;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.ArrayList;
import java.util.List;

@Controller
public class AdminProductSearchController {

    @Autowired
    private ProductDAO productDAO;

    @GetMapping("/admin/products/search")
    public String searchProducts(@RequestParam("keyword") String keyword, Model model) {
        List<Product> result = new ArrayList<>();
        // tìm theo tên sản phẩm
        result = productDAO.findByNameContainingIgnoreCase(keyword);
        model.addAttribute("products", result);
        model.addAttribute("keyword", keyword);
        return "admin/product-search";
    }
}
