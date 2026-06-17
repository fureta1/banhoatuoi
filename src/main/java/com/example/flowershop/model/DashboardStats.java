package com.example.flowershop.model;

import jakarta.persistence.Entity;

import java.math.BigDecimal;
import java.util.List;


public class DashboardStats {

    // 4 ô trên cùng
    private BigDecimal monthlyRevenue;     // doanh thu tháng này
    private BigDecimal lastMonthRevenue;   // doanh thu tháng trước
    private double revenueChangePercent;   // % so với tháng trước

    private long todayOrders;              // đơn hôm nay
    private long yesterdayOrders;          // đơn hôm qua
    private double orderChangePercent;     // % so với hôm qua

    private long totalCustomers;           // tổng KH
    private long lastMonthNewCustomers;    // KH mới tháng trước
    private double customerChangePercent;  // % so với tháng trước

    private long totalProducts;            // tổng SP
    private long lastWeekNewProducts;      // SP mới tuần trước
    private double productChangePercent;   // % so với tuần trước

    // bảng đơn hàng gần đây
    private List<RecentOrderDTO> recentOrders;

    // ===== GETTER / SETTER =====

    public BigDecimal getMonthlyRevenue() {
        return monthlyRevenue;
    }

    public void setMonthlyRevenue(BigDecimal monthlyRevenue) {
        this.monthlyRevenue = monthlyRevenue;
    }

    public BigDecimal getLastMonthRevenue() {
        return lastMonthRevenue;
    }

    public void setLastMonthRevenue(BigDecimal lastMonthRevenue) {
        this.lastMonthRevenue = lastMonthRevenue;
    }

    public double getRevenueChangePercent() {
        return revenueChangePercent;
    }

    public void setRevenueChangePercent(double revenueChangePercent) {
        this.revenueChangePercent = revenueChangePercent;
    }

    public long getTodayOrders() {
        return todayOrders;
    }

    public void setTodayOrders(long todayOrders) {
        this.todayOrders = todayOrders;
    }

    public long getYesterdayOrders() {
        return yesterdayOrders;
    }

    public void setYesterdayOrders(long yesterdayOrders) {
        this.yesterdayOrders = yesterdayOrders;
    }

    public double getOrderChangePercent() {
        return orderChangePercent;
    }

    public void setOrderChangePercent(double orderChangePercent) {
        this.orderChangePercent = orderChangePercent;
    }

    public long getTotalCustomers() {
        return totalCustomers;
    }

    public void setTotalCustomers(long totalCustomers) {
        this.totalCustomers = totalCustomers;
    }

    public long getLastMonthNewCustomers() {
        return lastMonthNewCustomers;
    }

    public void setLastMonthNewCustomers(long lastMonthNewCustomers) {
        this.lastMonthNewCustomers = lastMonthNewCustomers;
    }

    public double getCustomerChangePercent() {
        return customerChangePercent;
    }

    public void setCustomerChangePercent(double customerChangePercent) {
        this.customerChangePercent = customerChangePercent;
    }

    public long getTotalProducts() {
        return totalProducts;
    }

    public void setTotalProducts(long totalProducts) {
        this.totalProducts = totalProducts;
    }

    public long getLastWeekNewProducts() {
        return lastWeekNewProducts;
    }

    public void setLastWeekNewProducts(long lastWeekNewProducts) {
        this.lastWeekNewProducts = lastWeekNewProducts;
    }

    public double getProductChangePercent() {
        return productChangePercent;
    }

    public void setProductChangePercent(double productChangePercent) {
        this.productChangePercent = productChangePercent;
    }

    public List<RecentOrderDTO> getRecentOrders() {
        return recentOrders;
    }

    public void setRecentOrders(List<RecentOrderDTO> recentOrders) {
        this.recentOrders = recentOrders;
    }
}

