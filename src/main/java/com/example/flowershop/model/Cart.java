package com.example.flowershop.model;

import jakarta.persistence.*;
import java.sql.Timestamp;

@Entity
@Table(name = "carts", 
       uniqueConstraints = @UniqueConstraint(columnNames = {"user_id", "product_id"}))
public class Cart {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne
    @JoinColumn(name = "product_id", nullable = false)
    private Product product;

    @Column(nullable = false)
    private Integer quantity = 1;

    @Column(name = "added_at", nullable = false,
            columnDefinition = "TIMESTAMP DEFAULT CURRENT_TIMESTAMP")
    private Timestamp addedAt;

    @PrePersist
    protected void onCreate() {
        if (addedAt == null) {
            addedAt = new Timestamp(System.currentTimeMillis());
        }
    }

    // ===== Constructors =====
    public Cart() {}

    public Cart(User user, Product product, Integer quantity) {
        this.user = user;
        this.product = product;
        this.quantity = quantity;
        this.addedAt = new Timestamp(System.currentTimeMillis());
    }

    // ===== Getters & Setters =====
    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public Product getProduct() {
        return product;
    }

    public void setProduct(Product product) {
        this.product = product;
    }

    public Integer getQuantity() {
        return quantity;
    }

    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }

    public Timestamp getAddedAt() {
        return addedAt;
    }

    public void setAddedAt(Timestamp addedAt) {
        this.addedAt = addedAt;
    }

    // ===== Alias methods for compatibility =====
    public Integer getUserId() {
        return user != null ? user.getId() : null;
    }

    public void setUserId(Integer userId) {
        if (user == null) {
            user = new User();
        }
        user.setId(userId);
    }

    public Integer getProductId() {
        return product != null ? product.getId() : null;
    }

    public void setProductId(Integer productId) {
        if (product == null) {
            product = new Product();
        }
        product.setId(productId);
    }
}
