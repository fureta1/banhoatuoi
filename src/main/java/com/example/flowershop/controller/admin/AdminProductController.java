package com.example.flowershop.controller.admin;

import com.example.flowershop.dao.ProductDAO;
import com.example.flowershop.model.Product;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
public class AdminProductController {

    @Autowired
    private ProductDAO productDAO;

    // Hiển thị danh sách sản phẩm + tìm kiếm
    @GetMapping("/admin/products")
    public String listProducts(@RequestParam(value = "keyword", required = false) String keyword,
                               Model model) {
        List<Product> products;

        if (keyword != null && !keyword.trim().isEmpty()) {
            products = productDAO.findByNameContainingIgnoreCase(keyword.trim());
            model.addAttribute("keyword", keyword);
        } else {
            products = productDAO.findAll();
        }

        model.addAttribute("products", products);
        return "admin/product-list";
    }

    // Cập nhật tồn kho
    @PostMapping("/admin/products/{id}/stock")
    public String updateStock(@PathVariable("id") Integer id,
                              @RequestParam("stockQuantity") Integer stockQuantity,
                              Model model) {

        Product product = productDAO.findById(id).orElse(null);
        if (product == null) {
            model.addAttribute("message", "Không tìm thấy sản phẩm ID: " + id);
            return "redirect:/admin/products";
        }

        // đảm bảo không bị âm
        if (stockQuantity == null || stockQuantity < 0) stockQuantity = 0;
        product.setStockQuantity(stockQuantity);

        // tự động cập nhật trạng thái
        if (stockQuantity == 0) {
            product.setStatus("out_of_stock"); // Enum tiếng Anh trong DB
        } else if (!"discontinued".equalsIgnoreCase(product.getStatus())) {
            product.setStatus("available");
        }

        productDAO.save(product);

        return "redirect:/admin/products";
    }

    // Xóa sản phẩm
    @GetMapping("/admin/products/delete/{id}")
    public String deleteProduct(@PathVariable("id") Integer id) {
        productDAO.deleteById(id);
        return "redirect:/admin/products";
    }
}
