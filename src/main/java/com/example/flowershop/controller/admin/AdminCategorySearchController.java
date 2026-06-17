package com.example.flowershop.controller.admin;

import com.example.flowershop.dao.CategoryDAO;
import com.example.flowershop.model.Category;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
public class AdminCategorySearchController {

    @Autowired
    private CategoryDAO categoryDAO;

    // tìm kiếm và render lại TRANG categories.jsp (tích hợp)
    @GetMapping("/admin/categories/search")
    public String search(@RequestParam("q") String keyword, Model model) {
        List<Category> categories = categoryDAO.findByNameContainingIgnoreCase(keyword);
        model.addAttribute("categories", categories);
        model.addAttribute("keyword", keyword);

        // khi chỉ search thì form bên phải nên là form thêm mới
        Category empty = new Category();
        empty.setStatus("active");
        model.addAttribute("category", empty);
        model.addAttribute("productsInCategory", null);
        model.addAttribute("message", "Tìm thấy " + categories.size() + " danh mục");

        return "admin/categories";
    }

    // gợi ý khi gõ (trả về JSON)
    @GetMapping(value = "/admin/categories/suggest", produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public List<Category> suggest(@RequestParam("term") String term) {
        // trả tối đa 10 gợi ý
        List<Category> list = categoryDAO.findByNameContainingIgnoreCase(term);
        if (list.size() > 10) {
            return list.subList(0, 10);
        }
        return list;
    }
}
