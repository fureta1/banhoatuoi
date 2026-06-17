package com.example.flowershop.controller.admin;

import com.example.flowershop.dao.home.CustomerOrderDAO;
import com.example.flowershop.model.Order;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class AdminVNPAYDebugController {

    @Autowired
    private CustomerOrderDAO customerOrderDAO;

    @GetMapping("/admin/debug/vnpay-check")
    @ResponseBody
    public Map<String, Object> checkVNPAYOrder(@RequestParam(required = false) String orderCode) {
        Map<String, Object> result = new HashMap<>();
        
        try {
            List<Order> allOrders = customerOrderDAO.findOrdersByUserId(1); // Admin user
            result.put("totalOrders", allOrders.size());
            result.put("allOrders", allOrders);
            
            if (orderCode != null) {
                // Try to find order by code
                Order foundOrder = null;
                for (Order order : allOrders) {
                    if (order.getOrderCode() != null && order.getOrderCode().contains(orderCode)) {
                        foundOrder = order;
                        break;
                    }
                }
                
                if (foundOrder != null) {
                    result.put("foundOrder", foundOrder);
                    result.put("orderCode", foundOrder.getOrderCode());
                    result.put("paymentStatus", foundOrder.getPaymentStatus());
                    result.put("orderStatus", foundOrder.getOrderStatus());
                } else {
                    result.put("error", "Order not found with code: " + orderCode);
                }
            }
            
        } catch (Exception e) {
            result.put("error", e.getMessage());
            e.printStackTrace();
        }
        
        return result;
    }
}
