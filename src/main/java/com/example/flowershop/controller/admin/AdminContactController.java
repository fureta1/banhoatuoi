package com.example.flowershop.controller.admin;

import com.example.flowershop.dao.AdminContactDAO;
import com.example.flowershop.dao.ContactMessageDAO;
import com.example.flowershop.model.Contact;
import com.example.flowershop.model.ContactMessage;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;

@Controller
@RequestMapping("/admin/contacts")
public class AdminContactController {

    @Autowired
    private AdminContactDAO contactDAO;

    @Autowired
    private ContactMessageDAO messageDAO;


    // ========== DANH SÁCH ==========
    @GetMapping
    public String list(
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String status,
            @RequestParam(required = false) Integer rating,
            Model model
    ) {
        List<Contact> contacts = contactDAO.search(keyword, status, rating);

        model.addAttribute("contacts", contacts);
        model.addAttribute("keyword", keyword);
        model.addAttribute("status", status);
        model.addAttribute("rating", rating);

        return "admin/contact-list";
    }


    // ========== CHI TIẾT TICKET ==========
    @GetMapping("/detail")
    public String detail(@RequestParam("id") int id, Model model) {
        Contact contact = contactDAO.findById(id);
        List<ContactMessage> messages = messageDAO.findByContactId(id);

        model.addAttribute("contact", contact);
        model.addAttribute("messages", messages);

        return "admin/contact-detail";
    }


    // ========== CẬP NHẬT TRẠNG THÁI ==========
    @PostMapping("/updateStatus")
    public String updateStatus(
            @RequestParam("contactId") int contactId,
            @RequestParam("status") String status
    ) {
        contactDAO.updateStatus(contactId, status);
        return "redirect:/admin/contacts/detail?id=" + contactId;
    }
}
