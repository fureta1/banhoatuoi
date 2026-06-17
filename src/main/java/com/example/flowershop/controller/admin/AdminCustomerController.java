package com.example.flowershop.controller.admin;

import com.example.flowershop.dao.AdminCustomerDAO;
import com.example.flowershop.model.User;
import com.example.flowershop.model.UserAddress;
import com.example.flowershop.model.OrderSummary;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
@RequestMapping("/admin/customers")
public class AdminCustomerController {

    @Autowired
    private AdminCustomerDAO adminCustomerDAO;

    // ====== DANH SÁCH + TÌM KIẾM ======
    @GetMapping
    public String list(@RequestParam(value = "keyword", required = false) String keyword,
                       Model model) {
        List<User> customers = (keyword != null && !keyword.trim().isEmpty())
                ? adminCustomerDAO.searchCustomers(keyword.trim())
                : adminCustomerDAO.findCustomers();

        model.addAttribute("customers", customers);
        model.addAttribute("keyword", keyword);
        return "admin/customers";
    }

    // ====== ĐỔI TRẠNG THÁI (active / inactive / blocked) ======
    @PostMapping("/{id}/status")
    public String updateStatus(@PathVariable int id,
                               @RequestParam String status,
                               RedirectAttributes ra) {
        adminCustomerDAO.updateStatus(id, status);
        ra.addFlashAttribute("message", "Cập nhật trạng thái thành công!");
        return "redirect:/admin/customers";
    }

    // ====== XEM CHI TIẾT: thông tin + địa chỉ + lịch sử đơn ======
    @GetMapping("/{id}")
    public String detail(@PathVariable int id,
                         Model model,
                         RedirectAttributes ra) {
        User customer = adminCustomerDAO.findById(id);
        if (customer == null) {
            ra.addFlashAttribute("error", "Không tìm thấy khách hàng!");
            return "redirect:/admin/customers";
        }

        List<UserAddress> addresses = adminCustomerDAO.findAddressesByUserId(id);
        List<OrderSummary> orders = adminCustomerDAO.findOrdersByUserId(id);

        model.addAttribute("customer", customer);
        model.addAttribute("addresses", addresses);
        model.addAttribute("orders", orders);

        return "admin/customer-detail"; // JSP chi tiết bạn đã/ sẽ tạo
    }
}
