package com.example.flowershop.controller.admin;

import com.example.flowershop.dao.OrderDAO;
import com.example.flowershop.model.Order;
import com.example.flowershop.model.OrderHistory;
import com.example.flowershop.model.OrderItem;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
@RequestMapping("/admin/orders")
public class AdminOrderController {

    @Autowired
    private OrderDAO orderDAO;

    /**
     * Danh sách đơn hàng + lọc theo trạng thái / từ khóa
     */
    @GetMapping
    public String listOrders(@RequestParam(value = "status", required = false) String status,
                             @RequestParam(value = "keyword", required = false) String keyword,
                             Model model) {

        List<Order> orders = orderDAO.search(status, keyword);
        model.addAttribute("orders", orders);
        model.addAttribute("status", status);
        model.addAttribute("keyword", keyword);

        // để _sidebar.jsp biết đang ở mục nào
        model.addAttribute("activePage", "orders");

        // JSP: /WEB-INF/views/admin/order-list.jsp
        return "admin/order-list";
    }

    /**
     * Xem chi tiết 1 đơn
     */
    @GetMapping("/{id}")
    public String viewOrder(@PathVariable("id") Integer id,
                            Model model,
                            RedirectAttributes ra) {
        try {
            Order order = orderDAO.findById(id);
            List<OrderItem> items = orderDAO.findItemsByOrderId(id);
            List<OrderHistory> histories = orderDAO.findHistoryByOrderId(id);

            order.setItems(items);
            order.setHistories(histories);

            model.addAttribute("order", order);
            model.addAttribute("activePage", "orders");
            return "admin/order-detail";
        } catch (Exception e) {
            ra.addFlashAttribute("msg", "Không tìm thấy đơn hàng!");
            return "redirect:/admin/orders";
        }
    }

    /**
     * Cập nhật trạng thái đơn hàng
     * POST /admin/orders/{id}/status
     */
    @PostMapping("/{id}/status")
    public String updateStatus(@PathVariable("id") Integer id,
                               @RequestParam("status") String status,
                               @RequestParam(value = "note", required = false) String note,
                               RedirectAttributes ra) {

        orderDAO.updateStatus(id, status, note);
        ra.addFlashAttribute("msg", "Cập nhật trạng thái thành công!");
        return "redirect:/admin/orders/" + id;
    }

        /**
     * Cập nhật trạng thái thanh toán
     * POST /admin/orders/{id}/payment
     */
    @PostMapping("/{id}/payment")
    public String updatePaymentStatus(@PathVariable("id") Integer id,
                                      @RequestParam("paymentStatus") String paymentStatus,
                                      RedirectAttributes ra) {

        orderDAO.updatePaymentStatus(id, paymentStatus);
        ra.addFlashAttribute("msg", "Cập nhật trạng thái thanh toán thành công!");
        return "redirect:/admin/orders/" + id;
    }

    /**
     * Hủy đơn hàng
     * POST /admin/orders/{id}/cancel
     */
    @PostMapping("/{id}/cancel")
    public String cancelOrder(@PathVariable("id") Integer id,
                              @RequestParam("reason") String reason,
                              RedirectAttributes ra) {

        orderDAO.cancelOrder(id, reason);
        ra.addFlashAttribute("msg", "Đã hủy đơn hàng!");
        return "redirect:/admin/orders/" + id;
    }

    /**
     * Gửi thông báo cho khách (để sẵn endpoint)
     */
    @PostMapping("/{id}/notify")
    public String notifyCustomer(@PathVariable("id") Integer id,
                                 @RequestParam("message") String message,
                                 RedirectAttributes ra) {
        // Sau này gắn service gửi mail / thông báo ở đây
        // notificationService.sendToOrder(id, message);

        ra.addFlashAttribute("msg", "Đã gửi thông báo cho khách.");
        return "redirect:/admin/orders/" + id;
    }
}
