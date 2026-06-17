package com.example.flowershop.controller.home;

import com.example.flowershop.dao.home.HomeSearchDAO;
import com.example.flowershop.model.Category;
import com.example.flowershop.model.Product;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Controller
public class HomeSearchController {

    @Autowired
    private HomeSearchDAO homeSearchDAO;

    @GetMapping("/search")
    public String search(
            @RequestParam(name = "keyword", required = false) String keyword,
            @RequestParam(name = "categoryId", required = false) Integer categoryId,
            Model model) {

        // Luôn giữ lại keyword để hiển thị trên giao diện
        model.addAttribute("keyword", keyword != null ? keyword.trim() : "");

        // =================================================================
        // 1. Trường hợp người dùng CLICK vào CHIP DANH MỤC (có categoryId)
        // =================================================================
        if (categoryId != null) {
            List<Product> categoryProducts = homeSearchDAO.getProductsByCategory(categoryId);
            Category selectedCategory = homeSearchDAO.findCategoryById(categoryId); // ← Bắt buộc phải có

            model.addAttribute("mode", "category");
            model.addAttribute("selectedCategory", selectedCategory);        // ← Hiển thị tên danh mục
            model.addAttribute("categoryProducts", categoryProducts);

            // Có thể gợi ý thêm các danh mục liên quan (tùy chọn)
            if (keyword != null && !keyword.trim().isEmpty()) {
                List<Category> relatedCategories = homeSearchDAO.searchCategories(keyword.trim());
                model.addAttribute("categories", relatedCategories);
            }

            return "home/search";
        }

        // =================================================================
        // 2. Không có keyword → về trang chủ
        // =================================================================
        if (keyword == null || keyword.trim().isEmpty()) {
            return "redirect:/home/index";
        }

        String kw = keyword.trim();

        // =================================================================
        // 3. Tìm kiếm theo từ khóa (cả danh mục và sản phẩm)
        // =================================================================
        List<Category> foundCategories = homeSearchDAO.searchCategories(kw);
        List<Product> foundProducts = homeSearchDAO.searchProducts(kw);

        model.addAttribute("categories", foundCategories);
        model.addAttribute("products", foundProducts);

        // =================================================================
        // 4. Xác định chế độ hiển thị (mode)
        // =================================================================
        if (!foundCategories.isEmpty()) {
            // Ưu tiên hiển thị theo danh mục nếu tìm thấy
            model.addAttribute("mode", "category");

            // Nếu chỉ có đúng 1 danh mục trùng → tự động hiển thị sản phẩm của danh mục đó
            if (foundCategories.size() == 1) {
                Category cat = foundCategories.get(0);
                List<Product> categoryProducts = homeSearchDAO.getProductsByCategory(cat.getId());

                model.addAttribute("selectedCategory", cat);           // ← Rất quan trọng!
                model.addAttribute("categoryProducts", categoryProducts);
            }
        }
        else if (!foundProducts.isEmpty()) {
            // Không có danh mục → hiển thị sản phẩm
            model.addAttribute("mode", "product");

            // Nếu chỉ có 1 sản phẩm khớp → làm sản phẩm nổi bật + gợi ý liên quan
            if (foundProducts.size() == 1) {
                Product mainProduct = foundProducts.get(0);
                List<Product> relatedProducts = homeSearchDAO.getRelatedProducts(mainProduct.getId());

                model.addAttribute("mainProduct", mainProduct);
                model.addAttribute("relatedProducts", relatedProducts);
            }
        }
        else {
            // Không tìm thấy gì
            model.addAttribute("mode", "none");
        }

        return "home/search";
    }
}