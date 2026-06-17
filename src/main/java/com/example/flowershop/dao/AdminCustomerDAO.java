package com.example.flowershop.dao;

import com.example.flowershop.model.User;
import com.example.flowershop.model.UserAddress;
import com.example.flowershop.model.OrderSummary;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

@Repository
public class AdminCustomerDAO {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    // ========================= USERS =========================

    public List<User> findCustomers() {
        String sql = """
            SELECT user_id, email, password, full_name, phone, role, status, created_at, updated_at
            FROM users
            WHERE role = 'customer'
            ORDER BY created_at DESC
            """;
        return jdbcTemplate.query(sql, userRowMapper);
    }

    public List<User> searchCustomers(String keyword) {
        String like = "%" + keyword + "%";
        String sql = """
            SELECT user_id, email, password, full_name, phone, role, status, created_at, updated_at
            FROM users
            WHERE role = 'customer'
              AND (full_name LIKE ? OR email LIKE ? OR phone LIKE ?)
            ORDER BY created_at DESC
            """;
        return jdbcTemplate.query(sql, new Object[]{like, like, like}, userRowMapper);
    }

    public User findById(int id) {
        String sql = """
            SELECT user_id, email, password, full_name, phone, role, status, created_at, updated_at
            FROM users
            WHERE user_id = ?
            """;
        List<User> list = jdbcTemplate.query(sql, new Object[]{id}, userRowMapper);
        return list.isEmpty() ? null : list.get(0);
    }

    public void updateStatus(int userId, String status) {
        String sql = "UPDATE users SET status = ? WHERE user_id = ?";
        jdbcTemplate.update(sql, status, userId);
    }

    // ========================= ADDRESSES =========================

    public List<UserAddress> findAddressesByUserId(int userId) {
        String sql = """
            SELECT address_id, user_id, recipient_name, phone, 
                   address_line, ward, district, city, is_default, created_at
            FROM user_addresses
            WHERE user_id = ?
            ORDER BY is_default DESC, created_at DESC
            """;
        return jdbcTemplate.query(sql, new Object[]{userId}, addressRowMapper);
    }

    // ========================= ORDERS =========================

    public List<OrderSummary> findOrdersByUserId(int userId) {
        String sql = """
            SELECT order_id, order_code, total_amount,
                   payment_method, payment_status, order_status, created_at
            FROM orders
            WHERE user_id = ?
            ORDER BY created_at DESC
            """;
        return jdbcTemplate.query(sql, new Object[]{userId}, orderRowMapper);
    }

    // ========================= ROW MAPPERS =========================

    private final RowMapper<User> userRowMapper = new RowMapper<User>() {
        @Override
        public User mapRow(ResultSet rs, int rowNum) throws SQLException {
            User u = new User();
            u.setId(rs.getInt("user_id"));
            u.setEmail(rs.getString("email"));
            u.setPassword(rs.getString("password"));
            u.setFullName(rs.getString("full_name"));
            u.setPhone(rs.getString("phone"));
            u.setRole(rs.getString("role"));
            u.setStatus(rs.getString("status"));
            u.setCreatedAt(rs.getTimestamp("created_at"));
            u.setUpdatedAt(rs.getTimestamp("updated_at"));
            return u;
        }
    };

    private final RowMapper<UserAddress> addressRowMapper = new RowMapper<UserAddress>() {
        @Override
        public UserAddress mapRow(ResultSet rs, int rowNum) throws SQLException {
            UserAddress addr = new UserAddress();
            addr.setAddressId(rs.getInt("address_id"));
            addr.setUserId(rs.getInt("user_id"));
            addr.setRecipientName(rs.getString("recipient_name"));
            addr.setPhone(rs.getString("phone"));
            addr.setAddressLine(rs.getString("address_line"));
            addr.setWard(rs.getString("ward"));
            addr.setDistrict(rs.getString("district"));
            addr.setCity(rs.getString("city"));

            // Quan trọng nhất — khớp với JSP ${a.defaultAddress}
            addr.setDefaultAddress(rs.getBoolean("is_default"));

            addr.setCreatedAt(rs.getTimestamp("created_at"));
            return addr;
        }
    };

    private final RowMapper<OrderSummary> orderRowMapper = new RowMapper<OrderSummary>() {
        @Override
        public OrderSummary mapRow(ResultSet rs, int rowNum) throws SQLException {
            OrderSummary o = new OrderSummary();
            o.setOrderId(rs.getInt("order_id"));
            o.setOrderCode(rs.getString("order_code"));
            o.setTotalAmount(rs.getBigDecimal("total_amount"));
            o.setPaymentMethod(rs.getString("payment_method"));
            o.setPaymentStatus(rs.getString("payment_status"));
            o.setOrderStatus(rs.getString("order_status"));
            o.setCreatedAt(rs.getTimestamp("created_at"));
            return o;
        }
    };
}
