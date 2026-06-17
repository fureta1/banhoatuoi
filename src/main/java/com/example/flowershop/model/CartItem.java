package com.example.flowershop.model;

import jakarta.persistence.Entity;

import java.math.BigDecimal;

/**
 * Đối tượng đại diện cho 1 dòng trong giỏ hàng (trên UI).
 * Không map trực tiếp với bảng CSDL, chỉ dùng để thao tác trong session / service.
 */
public class CartItem {

    // Sản phẩm
    private Product product;

    // Số lượng khách chọn
    private int quantity;

    // Có được chọn để thanh toán hay không (checkbox trên giao diện)
    private boolean selected = true; // mặc định là chọn

    // ========================================
    // Constructors
    // ========================================
    public CartItem() {
    }

    public CartItem(Product product, int quantity) {
        this.product = product;
        this.quantity = quantity;
        this.selected = true;
    }

    // ========================================
    // Getter & Setter
    // ========================================
    public Product getProduct() {
        return product;
    }

    public void setProduct(Product product) {
        this.product = product;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public boolean isSelected() {
        return selected;
    }

    public void setSelected(boolean selected) {
        this.selected = selected;
    }

    // ========================================
    // Helper methods (rất quan trọng cho JSP và Service)
    // ========================================

    /** Lấy ID sản phẩm – dùng trong form name="selectedIds" */
    public Integer getProductId() {
        return product != null ? product.getId() : null;
    }

    /**
     * Đơn giá thực tế áp dụng cho sản phẩm này
     * Ưu tiên discountPrice nếu có và > 0
     */
    public BigDecimal getUnitPrice() {
        if (product == null) return BigDecimal.ZERO;

        if (product.getDiscountPrice() != null
                && product.getDiscountPrice().compareTo(BigDecimal.ZERO) > 0) {
            return product.getDiscountPrice();
        }
        return product.getPrice() != null ? product.getPrice() : BigDecimal.ZERO;
    }

    /**
     * Thành tiền của dòng này = đơn giá thực tế × số lượng
     */
    public BigDecimal getLineTotal() {
        return getUnitPrice().multiply(BigDecimal.valueOf(quantity));
    }

    // ========================================
    // toString() để debug dễ hơn
    // ========================================
    @Override
    public String toString() {
        return "CartItem{" +
                "productId=" + (product != null ? product.getId() : "null") +
                ", name='" + (product != null ? product.getName() : "null") + '\'' +
                ", quantity=" + quantity +
                ", selected=" + selected +
                ", unitPrice=" + getUnitPrice() +
                ", lineTotal=" + getLineTotal() +
                '}';
    }
}
