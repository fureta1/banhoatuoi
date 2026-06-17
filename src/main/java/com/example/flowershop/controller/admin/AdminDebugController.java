package com.example.flowershop.controller.admin;

import com.example.flowershop.dao.OrderDAO;
import com.example.flowershop.model.Order;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class AdminDebugController {

    @Autowired
    private OrderDAO orderDAO;

    @GetMapping("/admin/debug/orders")
    @ResponseBody
    public Map<String, Object> debugOrders() {
        Map<String, Object> result = new HashMap<>();
        
        try {
            // Get all orders without filtering
            List<Order> allOrders = orderDAO.search(null, null);
            result.put("totalOrders", allOrders.size());
            result.put("orders", allOrders);
            
            // Get orders by status
            List<Order> pendingOrders = orderDAO.search("pending", null);
            List<Order> confirmedOrders = orderDAO.search("confirmed", null);
            List<Order> paidOrders = orderDAO.search(null, null); // All orders to check payment status
            
            result.put("pendingCount", pendingOrders.size());
            result.put("confirmedCount", confirmedOrders.size());
            
            // Count paid orders manually
            long paidCount = allOrders.stream()
                .filter(order -> "paid".equals(order.getPaymentStatus()))
                .count();
            result.put("paidCount", paidCount);
            
        } catch (Exception e) {
            result.put("error", e.getMessage());
            e.printStackTrace();
        }
        
        return result;
    }
}
