package com.example.flowershop.controller.admin;

import com.example.flowershop.dao.ContactMessageDAO;
import com.example.flowershop.dao.AdminContactDAO;
import com.example.flowershop.model.ContactMessage;
import com.example.flowershop.model.Contact;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/admin/contact-chat")
public class AdminContactChatController {

    @Autowired
    private ContactMessageDAO messageDAO;

    @Autowired
    private AdminContactDAO contactDAO;

    // ADMIN GỬI TIN NHẮN CHO KHÁCH
    @PostMapping("/send")
    public String sendMessage(
            @RequestParam("contactId") int contactId,
            @RequestParam("messageText") String messageText
    ) {
        // Lưu tin nhắn vào bảng contact_messages
        ContactMessage msg = new ContactMessage();
        msg.setContactId(contactId);
        msg.setSenderType("admin");
        msg.setMessageText(messageText);
        messageDAO.saveMessage(msg);

        // Nếu ticket đang ở trạng thái "new" thì tự chuyển sang "processing"
        Contact c = contactDAO.findById(contactId);
        if ("new".equals(c.getStatus())) {
            contactDAO.updateStatus(contactId, "processing");
        }

        // Redirect về lại trang chi tiết + gắn flag success để hiển thị thông báo
        return "redirect:/admin/contacts/detail?id=" + contactId + "&sent=1";
    }
}
