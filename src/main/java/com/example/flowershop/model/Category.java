package com.example.flowershop.model;

import jakarta.persistence.*;
import java.sql.Timestamp;

@Entity
@Table(name = "categories")
public class Category {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "category_id")
    private Integer id;

    @Column(name = "category_name", nullable = false, length = 100)
    private String name;

    @Column(columnDefinition = "TEXT")
    private String description;

    @Column(name = "image_url")
    private String imageUrl;

    @Column(name = "status", nullable = false)
    private String status = "active";

    @Column(name = "created_at")
    private Timestamp createdAt;

    public Category() {
    }

    // getter / setter
    public Integer getId() {
        return id;
    }
    public void setId(Integer id) {
        this.id = id;
    }
    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }
    public String getDescription() {
        return description;
    }
    public void setDescription(String description) {
        this.description = description;
    }
    public String getImageUrl() {
        return imageUrl;
    }
    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }
    public String getStatus() {
        return status;
    }
    public void setStatus(String status) {
        this.status = status;
    }
    public Timestamp getCreatedAt() {
        return createdAt;
    }
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
// Nếu chỗ khác gọi getCategoryId()
    public Integer getCategoryId() {
        return this.id;
    }

    public void setCategoryId(Integer categoryId) {
        this.id = categoryId;
    }

    // Nếu chỗ khác gọi getCategoryName()
    public String getCategoryName() {
        return this.name;
    }

    public void setCategoryName(String categoryName) {
        this.name = categoryName;
    }
}