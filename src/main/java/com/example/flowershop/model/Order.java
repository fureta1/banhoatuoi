package com.example.flowershop.model;

import jakarta.persistence.*;

import java.io.Serializable;
import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.List;


@Entity
@Table(name = "orders")
public class Order implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer orderId;
    private Integer userId;
    private String orderCode;
    private String recipientName;
    private String phone;
    private String addressLine;
    private String ward;
    private String district;
    private String city;
    private BigDecimal subtotal;
    private BigDecimal shippingFee;
    private BigDecimal discountAmount;
    private BigDecimal totalAmount;
    private String paymentMethod;   // COD, bank_transfer
    private String paymentStatus;   // pending, paid, failed
    private String orderStatus;     // pending, confirmed, preparing, shipping, delivered, cancelled
    private String note;
    private String cancelledReason;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    private String customerPhone;
    // để join thêm từ bảng users
    private String customerEmail;
    private String customerName;

    // để hiển thị chi tiết
    private List<OrderItem> items;
    private List<OrderHistory> histories;

    public Order() {
    }

    public Order(Integer orderId, Integer userId, String orderCode, String recipientName, String phone,
                 String addressLine, String ward, String district, String city,
                 BigDecimal subtotal, BigDecimal shippingFee, BigDecimal discountAmount, BigDecimal totalAmount,
                 String paymentMethod, String paymentStatus, String orderStatus,
                 String note, String cancelledReason, Timestamp createdAt, Timestamp updatedAt) {
        this.orderId = orderId;
        this.userId = userId;
        this.orderCode = orderCode;
        this.recipientName = recipientName;
        this.phone = phone;
        this.addressLine = addressLine;
        this.ward = ward;
        this.district = district;
        this.city = city;
        this.subtotal = subtotal;
        this.shippingFee = shippingFee;
        this.discountAmount = discountAmount;
        this.totalAmount = totalAmount;
        this.paymentMethod = paymentMethod;
        this.paymentStatus = paymentStatus;
        this.orderStatus = orderStatus;
        this.note = note;
        this.cancelledReason = cancelledReason;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    // getters & setters

    public Integer getOrderId() {
        return orderId;
    }

    public void setOrderId(Integer orderId) {
        this.orderId = orderId;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public String getOrderCode() {
        return orderCode;
    }

    public void setOrderCode(String orderCode) {
        this.orderCode = orderCode;
    }

    public String getRecipientName() {
        return recipientName;
    }

    public void setRecipientName(String recipientName) {
        this.recipientName = recipientName;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getAddressLine() {
        return addressLine;
    }

    public void setAddressLine(String addressLine) {
        this.addressLine = addressLine;
    }

    public String getWard() {
        return ward;
    }

    public void setWard(String ward) {
        this.ward = ward;
    }

    public String getDistrict() {
        return district;
    }

    public void setDistrict(String district) {
        this.district = district;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public BigDecimal getSubtotal() {
        return subtotal;
    }

    public void setSubtotal(BigDecimal subtotal) {
        this.subtotal = subtotal;
    }

    public BigDecimal getShippingFee() {
        return shippingFee;
    }

    public void setShippingFee(BigDecimal shippingFee) {
        this.shippingFee = shippingFee;
    }

    public BigDecimal getDiscountAmount() {
        return discountAmount;
    }

    public void setDiscountAmount(BigDecimal discountAmount) {
        this.discountAmount = discountAmount;
    }

    public BigDecimal getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public String getPaymentStatus() {
        return paymentStatus;
    }

    public void setPaymentStatus(String paymentStatus) {
        this.paymentStatus = paymentStatus;
    }

    public String getOrderStatus() {
        return orderStatus;
    }

    public void setOrderStatus(String orderStatus) {
        this.orderStatus = orderStatus;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public String getCancelledReason() {
        return cancelledReason;
    }

    public void setCancelledReason(String cancelledReason) {
        this.cancelledReason = cancelledReason;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    public String getCustomerEmail() {
        return customerEmail;
    }

    public void setCustomerEmail(String customerEmail) {
        this.customerEmail = customerEmail;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public List<OrderItem> getItems() {
        return items;
    }

    public void setItems(List<OrderItem> items) {
        this.items = items;
    }

    public List<OrderHistory> getHistories() {
        return histories;
    }

    public void setHistories(List<OrderHistory> histories) {
        this.histories = histories;
    }
    public String getCustomerPhone() {
        return customerPhone;
    }

    public void setCustomerPhone(String customerPhone) {
        this.customerPhone = customerPhone;
    }

    @Override
    public String toString() {
        return "Order{" +
                "orderId=" + orderId +
                ", userId=" + userId +
                ", orderCode='" + orderCode + '\'' +
                ", recipientName='" + recipientName + '\'' +
                ", phone='" + phone + '\'' +
                ", addressLine='" + addressLine + '\'' +
                ", ward='" + ward + '\'' +
                ", district='" + district + '\'' +
                ", city='" + city + '\'' +
                ", subtotal=" + subtotal +
                ", shippingFee=" + shippingFee +
                ", discountAmount=" + discountAmount +
                ", totalAmount=" + totalAmount +
                ", paymentMethod='" + paymentMethod + '\'' +
                ", paymentStatus='" + paymentStatus + '\'' +
                ", orderStatus='" + orderStatus + '\'' +
                ", note='" + note + '\'' +
                ", cancelledReason='" + cancelledReason + '\'' +
                ", createdAt=" + createdAt +
                ", updatedAt=" + updatedAt +
                ", customerEmail='" + customerEmail + '\'' +
                ", customerName='" + customerName + '\'' +
                '}';
    }
}

