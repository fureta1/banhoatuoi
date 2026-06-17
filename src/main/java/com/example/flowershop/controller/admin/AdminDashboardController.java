package com.example.flowershop.controller.admin;

import com.example.flowershop.dao.AdminDashboardDAO;
import com.example.flowershop.model.DashboardStats;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/admin")
public class AdminDashboardController {

    @Autowired
    private AdminDashboardDAO adminDashboardDAO;

    // /admin hoặc /admin/dashboard đều vào được dashboard
    @GetMapping({"/dashboard", ""})
    public String dashboard(Model model) {
        DashboardStats stats = adminDashboardDAO.getDashboardStats();
        model.addAttribute("stats", stats);
        return "admin/dashboard";
    }
}
