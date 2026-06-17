package com.example.flowershop.dao;

import com.example.flowershop.model.Contact;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@Repository
public class AdminContactDAO {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    // ========== MAPPER ==========
    private RowMapper<Contact> mapper = new RowMapper<Contact>() {
        @Override
        public Contact mapRow(ResultSet rs, int rowNum) throws SQLException {
            Contact c = new Contact();
            c.setContactId(rs.getInt("contact_id"));
            c.setUserId(rs.getObject("user_id") != null ? rs.getInt("user_id") : null);
            c.setFullName(rs.getString("full_name"));
            c.setEmail(rs.getString("email"));
            c.setPhone(rs.getString("phone"));
            c.setSubject(rs.getString("subject"));
            c.setMessage(rs.getString("message"));
            c.setStatus(rs.getString("status"));
            c.setAdminReply(rs.getString("admin_reply"));
            c.setCreatedAt(rs.getTimestamp("created_at"));
            c.setResolvedAt(rs.getTimestamp("resolved_at"));

            try {
                c.setRating(rs.getObject("rating") != null ? rs.getInt("rating") : null);
            } catch (SQLException ignore) {}

            return c;
        }
    };

    // ========== DANH SÁCH ==========
    public List<Contact> findAll() {
        String sql = """
            SELECT c.*
            FROM contacts c
            ORDER BY c.created_at DESC
        """;
        return jdbcTemplate.query(sql, mapper);
    }

    // ========== TÌM KIÉM ==========
    public List<Contact> search(String keyword, String status, Integer rating) {
        String sql = """
            SELECT c.*
            FROM contacts c
            WHERE 1=1
        """;

        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql += " AND (c.full_name LIKE ? OR c.email LIKE ? OR c.subject LIKE ? OR c.message LIKE ?)";
            String like = "%" + keyword + "%";
            params.add(like); params.add(like);
            params.add(like); params.add(like);
        }

        if (status != null && !status.isEmpty()) {
            sql += " AND c.status = ?";
            params.add(status);
        }

        // Remove rating filter for now - reviews table might not have data
        if (rating != null) {
            // Optional: Add rating filter from contacts.rating field if needed
            // sql += " AND c.rating = ?";
            // params.add(rating);
        }

        sql += " ORDER BY c.created_at DESC";

        return jdbcTemplate.query(sql, mapper, params.toArray());
    }

    // ========== CHI TIẾT ==========
    public Contact findById(int id) {
        String sql = """
            SELECT c.*
            FROM contacts c
            WHERE c.contact_id = ?
        """;

        return jdbcTemplate.queryForObject(sql, mapper, id);
    }

    // ========== THÊM CONTACT ==========
    public int create(Contact c) {
        String sql = """
            INSERT INTO contacts (user_id, full_name, email, phone, subject, message, status)
            VALUES (?,?,?,?,?,?, 'new')
        """;

        return jdbcTemplate.update(sql,
                c.getUserId(), c.getFullName(), c.getEmail(),
                c.getPhone(), c.getSubject(), c.getMessage());
    }

    // ========== CẬP NHẬT TRẠNG THÁI ==========
    public void updateStatus(int contactId, String status) {
        String sql = """
            UPDATE contacts
            SET status = ?,
                resolved_at = CASE WHEN ? = 'resolved' THEN NOW() ELSE resolved_at END
            WHERE contact_id = ?
        """;

        jdbcTemplate.update(sql, status, status, contactId);
    }

    // ========== THỐNG KÊ ==========
    public int countNewTickets() {
        String sql = "SELECT COUNT(*) FROM contacts WHERE status = 'new'";
        return jdbcTemplate.queryForObject(sql, Integer.class);
    }
}
