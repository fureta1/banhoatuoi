package com.example.flowershop.model;

import jakarta.persistence.Entity;

import java.math.BigDecimal;



public class BestSellingProduct {

    private int productId;
    private String productName;
    private String mainImage;
    private BigDecimal price;
    private long totalSold;
    private BigDecimal totalRevenue;

    // Thêm thuộc tính cho JSP dùng
    private String categoryName;

    // =============== GETTER / SETTER ===============

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getMainImage() {
        return mainImage;
    }

    public void setMainImage(String mainImage) {
        this.mainImage = mainImage;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public long getTotalSold() {
        return totalSold;
    }

    public void setTotalSold(long totalSold) {
        this.totalSold = totalSold;
    }

    public BigDecimal getTotalRevenue() {
        return totalRevenue;
    }

    public void setTotalRevenue(BigDecimal totalRevenue) {
        this.totalRevenue = totalRevenue;
    }

    // Getter / Setter cho categoryName
    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }
}
