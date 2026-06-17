package com.example.flowershop.controller.home;

import com.example.flowershop.dao.home.CustomerOrderDAO;
import com.example.flowershop.service.VNPAYService;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/vnpay")
public class VNPAYController {
    
    @Autowired
    private VNPAYService vnpayService;
    
    @Autowired
    private CustomerOrderDAO customerOrderDAO;
    
    @PostMapping("/create_payment")
    @ResponseBody
    public ResponseEntity<Map<String, String>> createPayment(
            @RequestParam("amount") String amount,
            @RequestParam("orderInfo") String orderInfo,
            @RequestParam(value = "orderCode", required = false) String orderCode,
            HttpServletRequest request) {
        
        try {
            // Validate số tiền tối thiểu 5,000 VND cho VNPay
            long amountValue;
            try {
                amountValue = Long.parseLong(amount);
                if (amountValue < 50) { // 50 * 100 = 5000 VND
                    Map<String, String> errorResponse = new HashMap<>();
                    errorResponse.put("status", "error");
                    errorResponse.put("message", "Số tiền thanh toán tối thiểu là 5,000 VND. Vui lòng kiểm tra giỏ hàng.");
                    return ResponseEntity.badRequest().body(errorResponse);
                }
            } catch (NumberFormatException e) {
                Map<String, String> errorResponse = new HashMap<>();
                errorResponse.put("status", "error");
                errorResponse.put("message", "Số tiền không hợp lệ: " + amount);
                return ResponseEntity.badRequest().body(errorResponse);
            }
            
            Map<String, String> params = new HashMap<>();
            params.put("amount", amount);
            params.put("orderInfo", orderCode); // Use clean orderCode instead of orderInfo
            if (orderCode != null) {
                params.put("orderCode", orderCode);
            }
            params.put("ipAddr", getClientIpAddress(request));
            
            String paymentUrl = vnpayService.createPaymentUrl(params);
            
            Map<String, String> response = new HashMap<>();
            response.put("status", "success");
            response.put("paymentUrl", paymentUrl);
            
            return ResponseEntity.ok(response);
            
        } catch (Exception e) {
            Map<String, String> response = new HashMap<>();
            response.put("status", "error");
            response.put("message", e.getMessage());
            
            return ResponseEntity.badRequest().body(response);
        }
    }
    
    @GetMapping("/return")
    public String paymentReturn(HttpServletRequest request, Model model) {
        Map<String, String> responseParams = new HashMap<>();
        
        // Lấy tất cả tham số từ VNPAY
        request.getParameterMap().forEach((key, values) -> {
            responseParams.put(key, values[0]);
        });
        
        // Validate signature
        boolean isValid = vnpayService.validateResponse(responseParams);
        
        if (isValid && "00".equals(responseParams.get("vnp_TransactionStatus"))) {
            // Thanh toán thành công - updated database
            String vnpOrderInfo = responseParams.get("vnp_OrderInfo");
            System.out.println("VNPAY OrderInfo: " + vnpOrderInfo);
            
            // Extract numeric part from ORDER1775750679324
            String orderCode = null;
            if (vnpOrderInfo != null && vnpOrderInfo.startsWith("ORDER")) {
                String numericPart = vnpOrderInfo.substring(5); // Remove "ORDER" prefix
                // Try to find order with ORD prefix + numeric part
                orderCode = "ORD" + numericPart;
                System.out.println("Converted to orderCode: " + orderCode);
                
                // Test update
                int updated = customerOrderDAO.updatePaymentStatus(orderCode, "paid");
                System.out.println("Payment status updated: " + updated + " rows");
                
                if (updated > 0) {
                    customerOrderDAO.updateOrderStatus(orderCode, "confirmed");
                    System.out.println("Order status updated to confirmed");
                } else {
                    System.err.println("Order not found with code: " + orderCode);
                }
            }
            
            // Redirect to checkout success handler
            return "redirect:/checkout/vnpay-success?orderCode=" + (orderCode != null ? orderCode : vnpOrderInfo);
        } else {
            // Thanh toán thất bại
            String orderCode = responseParams.get("vnp_TxnRef");
            String errorCode = responseParams.get("vnp_TransactionStatus");
            return "redirect:/checkout/vnpay-failed?orderCode=" + orderCode + "&error=" + errorCode;
        }
    }
    
    @PostMapping("/ipn")
    @ResponseBody
    public ResponseEntity<String> paymentIpn(HttpServletRequest request) {
        Map<String, String> responseParams = new HashMap<>();
        
        // Lấy tất cả tham số từ VNPAY
        request.getParameterMap().forEach((key, values) -> {
            responseParams.put(key, values[0]);
        });
        
        // Validate signature
        boolean isValid = vnpayService.validateResponse(responseParams);
        
        if (!isValid) {
            return ResponseEntity.badRequest().body("Invalid signature");
        }
        
        // Xử lý trạng thái giao dịch
        String transactionStatus = responseParams.get("vnp_TransactionStatus");
        String vnpOrderInfo = responseParams.get("vnp_OrderInfo");
        String orderCode = null;
        
        if (vnpOrderInfo != null && vnpOrderInfo.startsWith("ORDER")) {
            String numericPart = vnpOrderInfo.substring(5); // Remove "ORDER" prefix
            orderCode = "ORD" + numericPart; // Convert to ORD prefix
        }
        
        if ("00".equals(transactionStatus)) {
            // Giao dịch thành công - cập nhật trạng thái đơn hàng
            int updated = customerOrderDAO.updatePaymentStatus(orderCode, "paid");
            if (updated > 0) {
                // Also update order status to confirmed
                customerOrderDAO.updateOrderStatus(orderCode, "confirmed");
                System.out.println("Payment successful - updated order: " + orderCode);
            } else {
                System.out.println("Payment successful but order not found: " + orderCode);
            }
            return ResponseEntity.ok("OK");
        } else {
            // Giao dịch thất bại
            customerOrderDAO.updatePaymentStatus(orderCode, "failed");
            System.out.println("Payment failed for order: " + orderCode + ", status: " + transactionStatus);
            return ResponseEntity.ok("OK");
        }
    }
    
    private String getClientIpAddress(HttpServletRequest request) {
        String xForwardedFor = request.getHeader("X-Forwarded-For");
        if (xForwardedFor != null && !xForwardedFor.isEmpty() && !"unknown".equalsIgnoreCase(xForwardedFor)) {
            return xForwardedFor.split(",")[0].trim();
        }
        
        String xRealIp = request.getHeader("X-Real-IP");
        if (xRealIp != null && !xRealIp.isEmpty() && !"unknown".equalsIgnoreCase(xRealIp)) {
            return xRealIp;
        }
        
        return request.getRemoteAddr();
    }
}
