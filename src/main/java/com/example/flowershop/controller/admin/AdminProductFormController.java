package com.example.flowershop.controller.admin;

import com.example.flowershop.dao.CategoryDAO;
import com.example.flowershop.dao.ProductDAO;
import com.example.flowershop.model.Category;
import com.example.flowershop.model.Product;
import jakarta.servlet.ServletContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.UUID;

@Controller
public class AdminProductFormController {

    @Autowired
    private ProductDAO productDAO;

    @Autowired
    private CategoryDAO categoryDAO;

    @Autowired
    private ServletContext servletContext;

    // hiển thị form thêm
    @GetMapping("/admin/products/add")
    public String showAddForm(Model model) {
        List<Category> categories = categoryDAO.findAll();
        model.addAttribute("categories", categories);
        model.addAttribute("product", new Product());
        return "admin/product-detail";
    }

    // xử lý thêm
    @PostMapping("/admin/products/add")
    public String addProduct(@ModelAttribute("product") Product product,
                             @RequestParam("imageFile") MultipartFile imageFile) throws IOException {

        if (imageFile != null && !imageFile.isEmpty()) {
            String savedPath = saveProductImage(imageFile);
            product.setMainImage(savedPath);
        }

        productDAO.save(product);
        return "redirect:/admin/products";
    }

    // hiển thị form sửa
    @GetMapping("/admin/products/edit/{id}")
    public String showEditForm(@PathVariable("id") Integer id, Model model) {
        Product product = productDAO.findById(id).orElse(null);
        List<Category> categories = categoryDAO.findAll();
        model.addAttribute("product", product);
        model.addAttribute("categories", categories);
        return "admin/product-detail";
    }

    // xử lý sửa
    @PostMapping("/admin/products/edit")
    public String updateProduct(@ModelAttribute("product") Product product,
                                @RequestParam("imageFile") MultipartFile imageFile) throws IOException {

        Product old = productDAO.findById(product.getId()).orElse(null);
        if (old == null) {
            return "redirect:/admin/products";
        }

        if (imageFile != null && !imageFile.isEmpty()) {
            String savedPath = saveProductImage(imageFile);
            product.setMainImage(savedPath);
        } else {
            product.setMainImage(old.getMainImage());
        }

        productDAO.save(product);
        return "redirect:/admin/products";
    }

    // lưu ảnh vào Web Pages/images/products
    private String saveProductImage(MultipartFile file) throws IOException {
        String originalName = file.getOriginalFilename();
        String ext = "";
        if (originalName != null && originalName.contains(".")) {
            ext = originalName.substring(originalName.lastIndexOf("."));
        }
        String fileName = UUID.randomUUID().toString() + ext;

        // đúng thư mục bạn muốn
        String uploadDir = servletContext.getRealPath("/images/products");
        File dir = new File(uploadDir);
        if (!dir.exists()) {
            dir.mkdirs();
        }

        File dest = new File(dir, fileName);
        file.transferTo(dest);

        // để JSP hiển thị lại
        return "images/products/" + fileName;
    }
}
