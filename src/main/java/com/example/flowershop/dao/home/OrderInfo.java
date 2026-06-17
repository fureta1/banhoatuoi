package com.example.flowershop.dao.home;

public class OrderInfo {
    private Long orderId;
    private String orderCode;
    
    public OrderInfo(Long orderId, String orderCode) {
        this.orderId = orderId;
        this.orderCode = orderCode;
    }
    
    public Long getOrderId() {
        return orderId;
    }
    
    public void setOrderId(Long orderId) {
        this.orderId = orderId;
    }
    
    public String getOrderCode() {
        return orderCode;
    }
    
    public void setOrderCode(String orderCode) {
        this.orderCode = orderCode;
    }
}
