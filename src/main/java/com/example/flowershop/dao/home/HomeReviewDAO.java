package com.example.flowershop.dao.home;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

@Repository
public class HomeReviewDAO {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    /**
     * Lấy danh sách sản phẩm đã giao để đánh giá
     */
    public List<Map<String, Object>> findDeliveredItemsForRating(Integer userId) {
        String sql = """
                SELECT
                    o.order_id       AS orderId,
                    o.order_code     AS orderCode,
                    o.created_at     AS orderDate,
                    oi.product_id    AS productId,
                    oi.product_name  AS productName,
                    p.main_image     AS mainImage,
                    r.review_id      AS reviewId,
                    r.rating         AS rating,
                    r.comment        AS comment
                FROM order_items oi
                JOIN orders o   ON oi.order_id = o.order_id
                JOIN products p ON oi.product_id = p.product_id
                LEFT JOIN reviews r
                       ON r.order_id   = o.order_id
                      AND r.product_id = oi.product_id
                      AND r.user_id    = o.user_id
                WHERE o.user_id = ?
                  AND o.order_status = 'delivered'
                ORDER BY o.created_at DESC, oi.order_item_id DESC
                """;

        return jdbcTemplate.query(sql, new RowMapper<Map<String, Object>>() {
            @Override
            public Map<String, Object> mapRow(ResultSet rs, int rowNum) throws SQLException {
                Map<String, Object> map = new java.util.HashMap<>();
                map.put("orderId", rs.getInt("orderId"));
                map.put("orderCode", rs.getString("orderCode"));
                map.put("productId", rs.getInt("productId"));
                map.put("productName", rs.getString("productName"));
                map.put("mainImage", rs.getString("mainImage"));
                map.put("reviewId", rs.getObject("reviewId"));
                map.put("rating", rs.getObject("rating"));
                map.put("comment", rs.getString("comment"));
                
                // Convert LocalDateTime to Timestamp for JSP compatibility
                LocalDateTime localDateTime = rs.getTimestamp("orderDate").toLocalDateTime();
                map.put("orderDate", Timestamp.valueOf(localDateTime));
                
                return map;
            }
        }, userId);
    }

    /**
     * Táo moi hoac cap nhat danh gia cho 1 san pham trong 1 don cua user.
     */
    public void saveOrUpdateReview(Integer userId,
                                   Integer orderId,
                                   Integer productId,
                                   int rating,
                                   String comment) {
        // kiem tra ton tai
        String sqlCheck = """
                SELECT review_id
                FROM reviews
                WHERE user_id = ? AND order_id = ? AND product_id = ?
                """;
        List<Map<String, Object>> list =
                jdbcTemplate.queryForList(sqlCheck, userId, orderId, productId);

        if (list.isEmpty()) {
            // insert
            String sqlInsert = """
                    INSERT INTO reviews
                        (user_id, product_id, order_id, rating, comment, status)
                    VALUES
                        (?, ?, ?, ?, ?, 'pending')
                    """;
            jdbcTemplate.update(sqlInsert,
                    userId, productId, orderId, rating, comment);
        } else {
            // update
            String sqlUpdate = """
                    UPDATE reviews
                    SET rating = ?, comment = ?, status = 'pending'
                    WHERE user_id = ? AND order_id = ? AND product_id = ?
                    """;
            jdbcTemplate.update(sqlUpdate,
                    rating, comment, userId, orderId, productId);
        }
    }
}
