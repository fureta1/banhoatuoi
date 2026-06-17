package com.example.flowershop.dao;

import com.example.flowershop.model.Order;
import com.example.flowershop.model.OrderHistory;
import com.example.flowershop.model.OrderItem;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@Repository
public class OrderDAOImpl implements OrderDAO {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    /**
     * Map 1 dòng ResultSet -> Order
     * Lưu ý: các query sử dụng mapOrder() phải SELECT:
     *  - o.* từ orders
     *  - u.email
     *  - u.full_name AS customer_name
     *  - u.phone AS customer_phone
     */
    private Order mapOrder(ResultSet rs) throws SQLException {
        Order o = new Order();
        o.setOrderId(rs.getInt("order_id"));
        o.setUserId(rs.getInt("user_id"));
        o.setOrderCode(rs.getString("order_code"));
        o.setRecipientName(rs.getString("recipient_name"));
        o.setPhone(rs.getString("phone"));
        o.setAddressLine(rs.getString("address_line"));
        o.setWard(rs.getString("ward"));
        o.setDistrict(rs.getString("district"));
        o.setCity(rs.getString("city"));

        o.setSubtotal(rs.getBigDecimal("subtotal"));
        o.setShippingFee(rs.getBigDecimal("shipping_fee"));
        o.setDiscountAmount(rs.getBigDecimal("discount_amount"));
        o.setTotalAmount(rs.getBigDecimal("total_amount"));

        o.setPaymentMethod(rs.getString("payment_method"));
        o.setPaymentStatus(rs.getString("payment_status"));
        o.setOrderStatus(rs.getString("order_status"));

        o.setNote(rs.getString("note"));
        o.setCancelledReason(rs.getString("cancelled_reason"));
        o.setCreatedAt(rs.getTimestamp("created_at"));
        o.setUpdatedAt(rs.getTimestamp("updated_at"));

        // Thông tin khách hàng từ bảng users
        o.setCustomerEmail(rs.getString("email"));
        o.setCustomerName(rs.getString("customer_name"));
        o.setCustomerPhone(rs.getString("customer_phone"));  // cần field này trong Order.java

        return o;
    }

    // =========================================================
    // 1. DANH SÁCH / TÌM KIẾM ĐƠN HÀNG (ADMIN)
    // =========================================================

    @Override
    public List<Order> search(String status, String keyword) {
        StringBuilder sql = new StringBuilder(
                "SELECT o.*, u.email, u.full_name AS customer_name, u.phone AS customer_phone " +
                "FROM orders o " +
                "JOIN users u ON o.user_id = u.user_id " +
                "WHERE 1=1 "
        );

        List<Object> params = new ArrayList<>();

        if (status != null && !status.isEmpty()) {
            sql.append(" AND o.order_status = ? ");
            params.add(status);
        }

        if (keyword != null && !keyword.isEmpty()) {
            sql.append(" AND (o.order_code LIKE ? OR u.full_name LIKE ? OR u.email LIKE ?) ");
            String like = "%" + keyword + "%";
            params.add(like);
            params.add(like);
            params.add(like);
        }

        sql.append(" ORDER BY o.created_at DESC ");

        return jdbcTemplate.query(sql.toString(), params.toArray(), (rs, rowNum) -> mapOrder(rs));
    }

    @Override
    public Order findById(Integer id) {
        String sql =
                "SELECT o.*, u.email, u.full_name AS customer_name, u.phone AS customer_phone " +
                "FROM orders o " +
                "JOIN users u ON o.user_id = u.user_id " +
                "WHERE o.order_id = ?";

        return jdbcTemplate.queryForObject(sql, new Object[]{id}, (rs, rowNum) -> mapOrder(rs));
    }

    // =========================================================
    // 2. LỊCH SỬ ĐƠN HÀNG THEO USER (TRANG TÀI KHOẢN)
    // =========================================================

    @Override
    public List<Order> findByUserId(Integer userId) {
        String sql =
                "SELECT o.*, u.email, u.full_name AS customer_name, u.phone AS customer_phone " +
                "FROM orders o " +
                "JOIN users u ON o.user_id = u.user_id " +
                "WHERE o.user_id = ? " +
                "ORDER BY o.created_at DESC";

        return jdbcTemplate.query(sql, new Object[]{userId}, (rs, rowNum) -> mapOrder(rs));
    }

    // =========================================================
    // 3. CHI TIẾT ĐƠN HÀNG (ITEMS + HISTORY)
    // =========================================================

    @Override
    public List<OrderItem> findItemsByOrderId(Integer orderId) {
        String sql =
                "SELECT oi.*, p.main_image " +
                "FROM order_items oi " +
                "LEFT JOIN products p ON oi.product_id = p.product_id " +
                "WHERE oi.order_id = ?";

        return jdbcTemplate.query(sql, new Object[]{orderId}, (rs, rowNum) -> {
            OrderItem i = new OrderItem();
            i.setOrderItemId(rs.getInt("order_item_id"));
            i.setOrderId(rs.getInt("order_id"));
            i.setProductId(rs.getInt("product_id"));
            i.setProductName(rs.getString("product_name"));
            i.setPrice(rs.getBigDecimal("price"));
            i.setQuantity(rs.getInt("quantity"));
            i.setSubtotal(rs.getBigDecimal("subtotal"));
            i.setMainImage(rs.getString("main_image"));
            return i;
        });
    }

    @Override
    public List<OrderHistory> findHistoryByOrderId(Integer orderId) {
        String sql =
                "SELECT oh.*, u.full_name AS updated_by_name " +
                "FROM order_history oh " +
                "LEFT JOIN users u ON oh.updated_by = u.user_id " +
                "WHERE oh.order_id = ? " +
                "ORDER BY oh.created_at DESC";

        return jdbcTemplate.query(sql, new Object[]{orderId}, (rs, rowNum) -> {
            OrderHistory h = new OrderHistory();
            h.setHistoryId(rs.getInt("history_id"));
            h.setOrderId(rs.getInt("order_id"));
            h.setStatus(rs.getString("status"));
            h.setNote(rs.getString("note"));
            h.setUpdatedBy(rs.getInt("updated_by"));
            h.setUpdatedByName(rs.getString("updated_by_name"));
            h.setCreatedAt(rs.getTimestamp("created_at"));
            return h;
        });
    }

    // =========================================================
    // 4. CẬP NHẬT / HỦY ĐƠN (ADMIN)
    // =========================================================

    @Override
    public void updateStatus(Integer orderId, String status, String note, Integer adminId) {
        // Cập nhật bảng orders
        String sql = "UPDATE orders SET order_status = ?, updated_at = NOW() WHERE order_id = ?";
        jdbcTemplate.update(sql, status, orderId);

        // Ghi lịch sử vào order_history
        String sqlHistory =
                "INSERT INTO order_history (order_id, status, note, updated_by) " +
                "VALUES (?, ?, ?, ?)";

        jdbcTemplate.update(sqlHistory, orderId, status, note, adminId);
        // adminId phải là user_id tồn tại trong bảng users (role = admin)
    }

    @Override
    public void cancelOrder(Integer orderId, String reason, Integer adminId) {
        // Cập nhật trạng thái + lý do hủy trong orders
        String sql =
                "UPDATE orders " +
                "SET order_status = 'cancelled', cancelled_reason = ?, updated_at = NOW() " +
                "WHERE order_id = ?";
        jdbcTemplate.update(sql, reason, orderId);

        // Ghi lịch sử vào order_history
        String sqlHistory =
                "INSERT INTO order_history (order_id, status, note, updated_by) " +
                "VALUES (?, 'cancelled', ?, ?)";
        jdbcTemplate.update(sqlHistory, orderId, reason, adminId);
    }
        @Override
    public void updatePaymentStatus(Integer orderId, String paymentStatus) {
        String sql =
                "UPDATE orders " +
                "SET payment_status = ?, updated_at = NOW() " +
                "WHERE order_id = ?";
        jdbcTemplate.update(sql, paymentStatus, orderId);
    }

}
