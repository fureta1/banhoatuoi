package com.example.flowershop.controller.home;

import com.example.flowershop.dao.home.HomeCategoryDAO;
import com.example.flowershop.dao.home.HomeProductDAO;
import com.example.flowershop.model.Category;
import com.example.flowershop.model.Product;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Controller
public class CategoryController {

    @Autowired
    private HomeCategoryDAO homeCategoryDAO;

    @Autowired
    private HomeProductDAO homeProductDAO;

    /**
     * Trang danh mục chung: /category
     * Hỗ trợ:
     *   - /category?categoryId=1
     *   - /category?categoryName=Hoa Sinh Nhật
     */
    @GetMapping("/category")
    public String viewCategory(
            @RequestParam(value = "categoryId", required = false) Long categoryId,
            @RequestParam(value = "categoryName", required = false) String categoryName,
            Model model
    ) {
        // 1) Xác định danh mục đang xem
        Category category = null;

        if (categoryId != null) {
            category = homeCategoryDAO.findById(categoryId);
        } else if (categoryName != null && !categoryName.isBlank()) {
            category = homeCategoryDAO.findByName(categoryName.trim());
        }

        // Không tìm thấy danh mục -> về trang chủ
        if (category == null) {
            return "redirect:/home/index";
        }

        // 2) Dữ liệu cho top-bar
        List<Category> allCategories = homeCategoryDAO.findAllActive();
        model.addAttribute("allCategories", allCategories);

        // 3) Dữ liệu cho mega-menu
        List<Category> megaCategories = homeCategoryDAO.findCategoriesForHomeMenu();
        model.addAttribute("megaCategories", megaCategories);
        model.addAttribute("activeCategoryId", category.getId()); // để _mega-menu.jsp tô active

        // 4) Lấy hết sản phẩm trong danh mục này
        List<Product> categoryProducts =
                homeProductDAO.findProductsByCategory((long) category.getId());

        // 5) Đẩy xuống view
        model.addAttribute("category", category);
        model.addAttribute("categoryProducts", categoryProducts);

        return "home/category";  // => /WEB-INF/views/home/category.jsp
    }
}

