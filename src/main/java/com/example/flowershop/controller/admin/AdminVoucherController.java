package com.example.flowershop.controller.admin;

import com.example.flowershop.dao.VoucherDAO;
import com.example.flowershop.model.Voucher;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.List;

@Controller
public class AdminVoucherController {

    @Autowired
    private VoucherDAO voucherDAO;

    @GetMapping("/admin/vouchers")
    public String listVouchers(Model model) {
        List<Voucher> vouchers = voucherDAO.findAll();
        model.addAttribute("vouchers", vouchers);
        return "admin/voucher-list";
    }
}
