package com.example.flowershop.controller.home;

import com.example.flowershop.dao.UserDAO;
import com.example.flowershop.dao.home.HomeCategoryDAO;
import com.example.flowershop.dao.home.HomeContactDAO;
import com.example.flowershop.dao.home.HomeReviewDAO;
import com.example.flowershop.model.User;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
public class ContactController {

    @Autowired
    private HomeCategoryDAO homeCategoryDAO;

    @Autowired
    private HomeReviewDAO homeReviewDAO;

    @Autowired
    private HomeContactDAO homeContactDAO;

    @Autowired
    private UserDAO userDAO;

    /** Dùng chung header + mega menu + badge giỏ hàng */
    @ModelAttribute
    public void addCommonAttributes(Model model, HttpSession session) {
        model.addAttribute("allCategories", homeCategoryDAO.findActiveCategories());
        model.addAttribute("megaCategories", homeCategoryDAO.findCategoriesForHomeMenu());

        Object countObj = session.getAttribute("cartItemCount");
        int cartItemCount = (countObj instanceof Integer) ? (Integer) countObj : 0;
        model.addAttribute("cartItemCount", cartItemCount);
    }

    /** GET /contact – trang liên hệ + đánh giá */
    @GetMapping("/contact")
    public String contactPage(@RequestParam(value = "contactId", required = false) String contactIdStr,
                              Model model,
                              HttpSession session,
                              RedirectAttributes ra) {

        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            ra.addFlashAttribute("errorMessage", "Bạn cần đăng nhập trước.");
            return "redirect:/auth/login";
        }

        Integer userId = currentUser.getId();

        // 1. Danh sách sản phẩm đã giao để đánh giá
        List<Map<String, Object>> ratingItems = homeReviewDAO.findDeliveredItemsForRating(userId);
        model.addAttribute("ratingItems", ratingItems);

        // 2. Danh sách contact của user
        List<Map<String, Object>> contacts = homeContactDAO.findContactsByUser(userId);
        model.addAttribute("contacts", contacts);

        // 3. Neu co contactId, load messages
        Integer contactId = null;
        if (contactIdStr != null && !contactIdStr.equals("null") && !contactIdStr.isEmpty()) {
            try {
                contactId = Integer.parseInt(contactIdStr);
            } catch (NumberFormatException e) {
                System.out.println("Invalid contactId format: " + contactIdStr);
            }
        }
        
        if (contactId != null) {
            List<Map<String, Object>> messages = homeContactDAO.findMessagesByContact(contactId, userId);
            model.addAttribute("currentContactId", contactId);
            model.addAttribute("messages", messages);
        }

        // Thông tin user (họ tên, email, phone)
        User freshUser = userDAO.findById(userId);
        model.addAttribute("user", freshUser);

        return "home/contact";
    }

    /** POST đánh giá sản phẩm (sao + comment) */
    @PostMapping("/contact/rate")
    public String rateProduct(@RequestParam("orderId") Integer orderId,
                              @RequestParam("productId") Integer productId,
                              @RequestParam("rating") Integer rating,
                              @RequestParam(value = "comment", required = false) String comment,
                              HttpSession session,
                              RedirectAttributes ra) {

        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            ra.addFlashAttribute("errorMessage", "Bạn cần đăng nhập trước.");
            return "redirect:/auth/login";
        }

        if (rating == null || rating < 1 || rating > 5) {
            ra.addFlashAttribute("errorMessage", "Số sao không hợp lệ.");
            return "redirect:/contact";
        }

        homeReviewDAO.saveOrUpdateReview(currentUser.getId(),
                orderId, productId, rating, comment);

        ra.addFlashAttribute("successMessage", "Cảm ơn bạn đã đánh giá sản phẩm!");
        return "redirect:/contact";
    }

    /** POST tạo contact mới + gửi tin nhắn đầu tiên */
    @PostMapping("/contact/new")
    public String createContact(@RequestParam("subject") String subject,
                                @RequestParam("message") String messageText,
                                HttpSession session,
                                RedirectAttributes ra) {

        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            ra.addFlashAttribute("errorMessage", "Bạn cần đăng nhập trước.");
            return "redirect:/auth/login";
        }

        Integer userId = currentUser.getId();
        System.out.println("Current user ID: " + userId);
        System.out.println("Current user: " + currentUser.getFullName());
        
        if (userId == null) {
            ra.addFlashAttribute("errorMessage", "Lỗi xác minh user ID.");
            return "redirect:/contact";
        }
        
        // dùng thông tin user làm full_name, email, phone
        String fullName = currentUser.getFullName();
        String email = currentUser.getEmail();
        String phone = currentUser.getPhone();

        Integer contactId = homeContactDAO.createContact(
                userId, fullName, email, phone, subject, messageText
        );

        if (contactId != null) {
            // lưu luôn bản ghi message đầu tiên
            homeContactDAO.addMessage(contactId, "user", messageText);
        }

        ra.addFlashAttribute("successMessage", "Đã gửi phản hồi đến shop. Chúng tôi sẽ trả lời sớm nhất.");
        return "redirect:/contact?contactId=" + contactId;
    }

    /** POST gửi tin nhắn trong 1 cuộc hội thoại đã có */
    @PostMapping("/contact/send-message")
    public String sendMessage(@RequestParam("contactId") Integer contactId,
                              @RequestParam("message") String messageText,
                              HttpSession session,
                              RedirectAttributes ra) {

        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            ra.addFlashAttribute("errorMessage", "Bạn cần đăng nhập trước.");
            return "redirect:/auth/login";
        }

        if (messageText == null || messageText.trim().isEmpty()) {
            ra.addFlashAttribute("errorMessage", "Nội dung tin nhắn không được để trống.");
            return "redirect:/contact?contactId=" + contactId;
        }

        homeContactDAO.addMessage(contactId, "user", messageText);

        return "redirect:/contact?contactId=" + contactId;
    }
}

