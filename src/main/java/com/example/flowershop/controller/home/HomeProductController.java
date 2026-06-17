package com.example.flowershop.controller.home;

import com.example.flowershop.dao.home.HomeCategoryDAO;
import com.example.flowershop.dao.home.HomeSearchDAO;
import com.example.flowershop.model.Category;
import com.example.flowershop.model.Product;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
public class HomeProductController {

    @Autowired
    private HomeSearchDAO homeSearchDAO;

    @Autowired
    private HomeCategoryDAO homeCategoryDAO;

    /**
     * Dữ liệu dùng chung cho header + mega menu:
     *  - allCategories: combobox tìm kiếm
     *  - megaCategories: 5 danh mục trên mega menu
     *  - cartItemCount: số sản phẩm hiển thị ở icon giỏ hàng
     */
    @ModelAttribute
    public void addCommonAttributes(Model model, HttpSession session) {
        // Tất cả danh mục active cho combobox search + tư vấn
        model.addAttribute("allCategories", homeCategoryDAO.findActiveCategories());

        // 5 danh mục cho mega menu ngang
        model.addAttribute("megaCategories", homeCategoryDAO.findCategoriesForHomeMenu());

        // Số sản phẩm trong giỏ (badge đỏ ở icon giỏ hàng)
        Object countObj = session.getAttribute("cartItemCount");
        int cartItemCount = 0;
        if (countObj instanceof Integer) {
            cartItemCount = (Integer) countObj;
        }
        model.addAttribute("cartItemCount", cartItemCount);
    }

    /**
     * Trang chi tiết sản phẩm
     * URL: /product/{id}
     */
    @GetMapping("/product/{id}")
    public String productDetail(@PathVariable("id") Integer id,
                                Model model,
                                HttpSession session,
                                RedirectAttributes redirectAttributes) {

        // 1. Lấy thông tin sản phẩm
        // CHÚ Ý: nếu HomeSearchDAO của bạn dùng tên khác (vd: getProductById),
        // hãy đổi lại cho khớp.
        Product product = homeSearchDAO.findProductById(id);
        if (product == null) {
            redirectAttributes.addFlashAttribute("cartError",
                    "Sản phẩm không tồn tại hoặc đã bị ẩn.");
            return "redirect:/";
        }

        // 2. Lấy danh mục chứa sản phẩm để:
        //    - hiển thị breadcrumb
        //    - set activeCategoryId cho mega menu (gạch dưới + màu tím)
        Category category = homeSearchDAO.findCategoryByProductId(id);
        if (category != null) {
            model.addAttribute("breadcrumbCategory", category.getName());
            model.addAttribute("activeCategoryId", category.getId());
        } else {
            model.addAttribute("breadcrumbCategory", "Danh mục khác");
        }

        // 3. Gợi ý sản phẩm liên quan
        List<Product> relatedProducts = homeSearchDAO.getRelatedProducts(id);

        // 4. Đẩy dữ liệu sang JSP
        model.addAttribute("product", product);
        model.addAttribute("category", category);
        model.addAttribute("relatedProducts", relatedProducts);

        return "home/product-detail"; // /WEB-INF/views/home/product-detail.jsp
    }
}
