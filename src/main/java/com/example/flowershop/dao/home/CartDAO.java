package com.example.flowershop.dao.home;

import com.example.flowershop.model.CartItem;
import com.example.flowershop.model.Product;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

/**
 * DAO thao tác với bảng carts (giỏ hàng lưu trong DB).
 */

@Repository
public class CartDAO {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    // Map 1 row (JOIN carts + products) => CartItem
    private final RowMapper<CartItem> cartItemRowMapper = new RowMapper<CartItem>() {
        @Override
        public CartItem mapRow(ResultSet rs, int rowNum) throws SQLException {
            Product p = new Product();
            p.setId(rs.getInt("product_id"));
            p.setCategoryId(rs.getInt("category_id"));
            p.setName(rs.getString("product_name"));
            p.setDescription(rs.getString("description"));
            p.setPrice(rs.getBigDecimal("price"));
            p.setDiscountPrice(rs.getBigDecimal("discount_price"));
            p.setStockQuantity(rs.getInt("stock_quantity"));
            p.setSoldQuantity(rs.getInt("sold_quantity"));
            p.setMainImage(rs.getString("main_image"));
            p.setStatus(rs.getString("status"));
            p.setCreatedAt(rs.getTimestamp("created_at"));
            p.setUpdatedAt(rs.getTimestamp("updated_at"));

            CartItem item = new CartItem();
            item.setProduct(p);
            item.setQuantity(rs.getInt("quantity")); // quantity trong CartItem là int
            // selected mặc định là true trong CartItem()
            return item;
        }
    };

    /** Lấy toàn bộ cart items của 1 user từ DB */
    public List<CartItem> findCartItemsByUserId(Integer userId) {
        String sql = """
            SELECT 
                c.quantity,
                p.product_id,
                p.category_id,
                p.product_name,
                p.description,
                p.price,
                p.discount_price,
                p.stock_quantity,
                p.sold_quantity,
                p.main_image,
                p.status,
                p.created_at,
                p.updated_at
            FROM carts c
            JOIN products p ON c.product_id = p.product_id
            WHERE c.user_id = ?
            ORDER BY c.added_at DESC
            """;
        return jdbcTemplate.query(sql, cartItemRowMapper, userId);
    }

    /** Thêm mới hoặc cộng dồn số lượng */
    public void addOrUpdateItem(Integer userId, Integer productId, int quantityToAdd) {
        String sql = """
            INSERT INTO carts (user_id, product_id, quantity)
            VALUES (?, ?, ?)
            ON DUPLICATE KEY UPDATE quantity = quantity + VALUES(quantity)
            """;
        jdbcTemplate.update(sql, userId, productId, quantityToAdd);
    }

    /** Cập nhật số lượng tuyệt đối (dùng khi update giỏ) */
    public void updateQuantity(Integer userId, Integer productId, int quantity) {
        String sql = "UPDATE carts SET quantity = ? WHERE user_id = ? AND product_id = ?";
        jdbcTemplate.update(sql, quantity, userId, productId);
    }

    /** Xoá 1 sản phẩm khỏi giỏ */
    public void deleteItem(Integer userId, Integer productId) {
        String sql = "DELETE FROM carts WHERE user_id = ? AND product_id = ?";
        jdbcTemplate.update(sql, userId, productId);
    }

    /** Xoá toàn bộ giỏ sau khi đặt hàng xong (nếu cần) */
    public void clearCart(Integer userId) {
        String sql = "DELETE FROM carts WHERE user_id = ?";
        jdbcTemplate.update(sql, userId);
    }
}
