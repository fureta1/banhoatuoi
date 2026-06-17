package com.example.flowershop.controller.home;

import com.example.flowershop.dao.home.AdviceProductDAO;
import com.example.flowershop.dao.home.HomeCategoryDAO;
import com.example.flowershop.model.Category;
import com.example.flowershop.model.Product;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.math.BigDecimal;
import java.util.List;

@Controller
public class AdviceController {

    @Autowired
    private HomeCategoryDAO homeCategoryDAO;

    @Autowired
    private AdviceProductDAO adviceProductDAO;

    @GetMapping("/tu-van-chon-hoa")
    public String showAdvice(
            @RequestParam(value = "categoryId", required = false) Long categoryId,
            @RequestParam(value = "priceRange", required = false) String priceRange,
            Model model
    ) {

        // 1. Danh mục cho combobox tìm kiếm
        List<Category> allCategories = homeCategoryDAO.findAllActive();
        model.addAttribute("allCategories", allCategories);

        // 2. Danh mục cho mega menu
        List<Category> megaCategories = homeCategoryDAO.findCategoriesForHomeMenu();
        model.addAttribute("megaCategories", megaCategories);

        if (categoryId != null) {
            model.addAttribute("activeCategoryId", categoryId.intValue());
        }

        // 3. Xử lý mức giá
        BigDecimal minPrice = null;
        BigDecimal maxPrice = null;
        String priceLabel = "Tất cả mức giá";

        if (priceRange != null && !priceRange.isEmpty()) {
            switch (priceRange) {
                case "UNDER_300":
                    maxPrice = new BigDecimal("300000");
                    priceLabel = "Dưới 300.000đ";
                    break;
                case "300_700":
                    minPrice = new BigDecimal("300000");
                    maxPrice = new BigDecimal("700000");
                    priceLabel = "300.000 – 700.000đ";
                    break;
                case "700_1000":
                    minPrice = new BigDecimal("700000");
                    maxPrice = new BigDecimal("1000000");
                    priceLabel = "700.000 – 1.000.000đ";
                    break;
                case "1000_2000":
                    minPrice = new BigDecimal("1000000");
                    maxPrice = new BigDecimal("2000000");
                    priceLabel = "1.000.000 – 2.000.000đ";
                    break;
                case "OVER_2000":
                    minPrice = new BigDecimal("2000000");
                    priceLabel = "Trên 2.000.000đ";
                    break;
            }
        }

        // 4. Label danh mục
        String categoryLabel = "Tất cả chủ đề";
        if (categoryId != null) {
            Category cat = homeCategoryDAO.findById(categoryId);
            if (cat != null) {
                categoryLabel = cat.getName();
            }
        }

        // 5. Lấy sản phẩm phù hợp
        List<Product> adviceProducts = adviceProductDAO.findAdviceProducts(categoryId, minPrice, maxPrice, 40);

        // 6. Gợi ý thêm
        List<Product> relatedProducts = adviceProductDAO.findRelatedProducts(categoryId, minPrice, maxPrice, 12);

        // 7. Đẩy dữ liệu xuống JSP
        model.addAttribute("selectedCategoryId", categoryId);
        model.addAttribute("selectedPriceRange", priceRange);
        model.addAttribute("displayCategoryLabel", categoryLabel);
        model.addAttribute("displayPriceLabel", priceLabel);
        model.addAttribute("adviceProducts", adviceProducts);
        model.addAttribute("relatedProducts", relatedProducts);

        return "home/tu-van-chon-hoa";
    }
}