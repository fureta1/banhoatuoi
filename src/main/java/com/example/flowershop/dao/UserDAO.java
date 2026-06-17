package com.example.flowershop.dao;

import com.example.flowershop.model.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

@Repository
public class UserDAO {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    // =========================================================
    // 1. HÀM DÙNG CHO LOGIN / ĐĂNG KÝ
    // =========================================================

    /**
     * Lấy user theo email (dùng cho login, kiểm tra tồn tại)
     */
    public User findByEmail(String email) {
        String sql = """
            SELECT user_id, email, password, full_name, phone, role, status
            FROM users
            WHERE email = ?
            """;
        List<User> list = jdbcTemplate.query(sql, new Object[]{email}, new UserRowMapper());
        return list.isEmpty() ? null : list.get(0);
    }

    /**
     * Lưu khách hàng mới đăng ký
     * role = customer, status = active
     */
    public int saveCustomer(User u) {
        String sql = """
            INSERT INTO users (email, password, full_name, phone, role, status)
            VALUES (?, ?, ?, ?, 'customer', 'active')
            """;
        return jdbcTemplate.update(sql,
                u.getEmail(),
                u.getPassword(),   // hiện tại đang để plain text
                u.getFullName(),
                u.getPhone()
        );
    }

    // =========================================================
    // 2. HÀM DÙNG CHUNG – TRA CỨU USER
    // =========================================================

    /**
     * Lấy user theo ID
     */
    public User findById(Integer id) {
        String sql = """
            SELECT user_id, email, password, full_name, phone, role, status
            FROM users
            WHERE user_id = ?
            """;
        List<User> list = jdbcTemplate.query(sql, new Object[]{id}, new UserRowMapper());
        return list.isEmpty() ? null : list.get(0);
    }

    // =========================================================
    // 3. HÀM CHO TRANG TÀI KHOẢN (MY ACCOUNT)
    // =========================================================

    /**
     * Cập nhật hồ sơ: họ tên, SĐT, email
     */
    public void updateProfile(Integer userId, String fullName, String phone, String email) {
        String sql = """
                UPDATE users
                SET full_name = ?, phone = ?, email = ?
                WHERE user_id = ?
                """;
        jdbcTemplate.update(sql, fullName, phone, email, userId);
    }

    /**
     * Đổi mật khẩu – trả về true nếu mật khẩu cũ đúng
     */
    public boolean changePassword(Integer userId, String oldPassword, String newPassword) {
        // kiểm tra mật khẩu cũ
        String sqlCheck = "SELECT COUNT(*) FROM users WHERE user_id = ? AND password = ?";
        Integer count = jdbcTemplate.queryForObject(sqlCheck, Integer.class, userId, oldPassword);

        if (count == null || count == 0) {
            return false; // sai mật khẩu cũ
        }

        // cập nhật mật khẩu mới
        String sqlUpdate = "UPDATE users SET password = ? WHERE user_id = ?";
        jdbcTemplate.update(sqlUpdate, newPassword, userId);
        return true;
    }

    // =========================================================
    // 4. ROW MAPPER – MAP DỮ LIỆU DB -> User
    // =========================================================

    private static class UserRowMapper implements RowMapper<User> {
        @Override
        public User mapRow(ResultSet rs, int rowNum) throws SQLException {
            User u = new User();
            // khớp với field 'id' trong User.java
            u.setId(rs.getInt("user_id"));
            u.setEmail(rs.getString("email"));
            u.setPassword(rs.getString("password"));
            u.setFullName(rs.getString("full_name"));
            u.setPhone(rs.getString("phone"));
            u.setRole(rs.getString("role"));
            u.setStatus(rs.getString("status"));

            // nếu trong User.java có createdAt / updatedAt thì bỏ comment 2 dòng dưới:
            // u.setCreatedAt(rs.getTimestamp("created_at"));
            // u.setUpdatedAt(rs.getTimestamp("updated_at"));

            return u;
        }
    }
}
