package com.example.flowershop.controller.admin;

import com.example.flowershop.dao.home.CustomerOrderDAO;
import com.example.flowershop.dao.home.OrderInfo;
import com.example.flowershop.model.CartItem;
import com.example.flowershop.model.Product;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class AdminTestController {

    @Autowired
    private CustomerOrderDAO customerOrderDAO;

    @GetMapping("/admin/debug/create-test-order")
    @ResponseBody
    public Map<String, Object> createTestOrder() {
        Map<String, Object> result = new HashMap<>();
        
        try {
            // Create a test product
            Product testProduct = new Product();
            testProduct.setId(1);
            testProduct.setName("Hoa Rose Test");
            testProduct.setPrice(new BigDecimal("150000"));
            testProduct.setDiscountPrice(null);
            
            // Create test cart item
            CartItem testItem = new CartItem();
            testItem.setProduct(testProduct);
            testItem.setQuantity(2);
            testItem.setSelected(true);
            
            List<CartItem> items = new ArrayList<>();
            items.add(testItem);
            
            // Create test order
            OrderInfo orderInfo = customerOrderDAO.createOrder(
                1, // user_id = 1 (admin user)
                "Test Customer",
                "0123456789",
                "Test Address",
                "Test Ward",
                "Test District",
                "Test City",
                new BigDecimal("300000"), // subtotal
                new BigDecimal("0"), // shipping fee
                new BigDecimal("300000"), // total
                "bank_transfer", // payment method
                "Test order created via debug endpoint",
                items
            );
            
            Long orderId = orderInfo.getOrderId();
            String orderCode = orderInfo.getOrderCode();
            
            result.put("success", true);
            result.put("orderId", orderId);
            result.put("orderCode", orderCode);
            result.put("message", "Test order created successfully");
            
            // Update payment status to paid
            int updated = customerOrderDAO.updatePaymentStatus(orderCode, "paid");
            customerOrderDAO.updateOrderStatus(orderCode, "confirmed");
            result.put("paymentUpdated", updated > 0);
            
        } catch (Exception e) {
            result.put("success", false);
            result.put("error", e.getMessage());
            e.printStackTrace();
        }
        
        return result;
    }
}
