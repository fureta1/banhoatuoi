package com.example.flowershop.controller.admin;

import com.example.flowershop.dao.CategoryDAO;
import com.example.flowershop.dao.ProductDAO;
import com.example.flowershop.model.Category;
import com.example.flowershop.model.Product;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.util.List;

@Controller
public class AdminCategoryController {

    @Autowired
    private CategoryDAO categoryDAO;

    @Autowired
    private ProductDAO productDAO;

    // TRANG CHÍNH
    @GetMapping("/admin/categories")
    public String categories(Model model,
                             @RequestParam(value = "id", required = false) Integer id,
                             @RequestParam(value = "message", required = false) String message,
                             @RequestParam(value = "q", required = false) String keyword) {

        List<Category> categories =
                (keyword != null && !keyword.isEmpty())
                        ? categoryDAO.findByNameContainingIgnoreCase(keyword)
                        : categoryDAO.findAll();

        model.addAttribute("categories", categories);
        model.addAttribute("keyword", keyword);

        Category categoryForm;
        List<Product> productsInCategory;

        if (id != null) {
            categoryForm = categoryDAO.findById(id).orElse(new Category());
            productsInCategory = productDAO.findByCategory_Id(id);
        } else {
            categoryForm = new Category();
            categoryForm.setStatus("active");
            productsInCategory = List.of();
        }

        model.addAttribute("category", categoryForm);
        model.addAttribute("productsInCategory", productsInCategory);
        model.addAttribute("message", message);

        return "admin/categories";
    }

    // LƯU (ADD/EDIT)
    @PostMapping("/admin/category/save")
    public String save(@ModelAttribute("category") Category category,
                       @RequestParam(value = "imageFile", required = false) MultipartFile imageFile,
                       HttpServletRequest request) {

        try {
            if (imageFile != null && !imageFile.isEmpty()) {
                String uploadDir = request.getServletContext().getRealPath("/images/categories");
                File dir = new File(uploadDir);
                if (!dir.exists()) dir.mkdirs();

                String fileName = System.currentTimeMillis() + "_" + imageFile.getOriginalFilename();
                File dest = new File(dir, fileName);
                imageFile.transferTo(dest);

                category.setImageUrl("images/categories/" + fileName);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        categoryDAO.save(category);

        return "redirect:/admin/categories?id=" + category.getId() + "&message=Luu+thanh+cong";
    }

    // XOÁ
    @GetMapping("/admin/category/delete/{id}")
    public String delete(@PathVariable Integer id) {
        try {
            categoryDAO.deleteById(id);
            return "redirect:/admin/categories?message=Xoa+thanh+cong";

        } catch (Exception e) {
            return "redirect:/admin/categories?id=" + id + "&message=Danh+muc+co+san+pham+nen+khong+xoa+duoc";
        }
    }
}
