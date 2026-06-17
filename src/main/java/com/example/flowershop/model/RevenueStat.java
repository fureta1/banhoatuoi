package com.example.flowershop.model;

import jakarta.persistence.Entity;

import java.math.BigDecimal;
import java.time.LocalDate;


public class RevenueStat {

    // Ngày thống kê (theo ngày)
    private LocalDate date;

    // Doanh thu trong ngày
    private BigDecimal revenue;

    // Tổng số đơn trong ngày
    private int totalOrders;

    // Số đơn thành công (delivered / completed)
    private int successOrders;

    // Số đơn bị hủy (cancelled)
    private int cancelledOrders;

    // ===== GETTER / SETTER =====

    public LocalDate getDate() {
        return date;
    }

    public void setDate(LocalDate date) {
        this.date = date;
    }

    public BigDecimal getRevenue() {
        return revenue;
    }

    public void setRevenue(BigDecimal revenue) {
        this.revenue = revenue;
    }

    public int getTotalOrders() {
        return totalOrders;
    }

    public void setTotalOrders(int totalOrders) {
        this.totalOrders = totalOrders;
    }

    public int getSuccessOrders() {
        return successOrders;
    }

    public void setSuccessOrders(int successOrders) {
        this.successOrders = successOrders;
    }

    public int getCancelledOrders() {
        return cancelledOrders;
    }

    public void setCancelledOrders(int cancelledOrders) {
        this.cancelledOrders = cancelledOrders;
    }
}
