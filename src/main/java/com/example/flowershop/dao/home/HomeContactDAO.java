package com.example.flowershop.dao.home;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Repository
public class HomeContactDAO {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    /** Lấy danh sách contact của 1 user */
    public List<Map<String, Object>> findContactsByUser(Integer userId) {
        String sql = """
                SELECT 
                    contact_id AS contactId,
                    subject,
                    status,
                    created_at AS createdAt
                FROM contacts
                WHERE user_id = ?
                ORDER BY created_at DESC
                """;
        
        return jdbcTemplate.query(sql, new RowMapper<Map<String, Object>>() {
            @Override
            public Map<String, Object> mapRow(ResultSet rs, int rowNum) throws SQLException {
                Map<String, Object> map = new java.util.HashMap<>();
                map.put("contactId", rs.getInt("contactId"));
                map.put("subject", rs.getString("subject"));
                map.put("status", rs.getString("status"));
                
                // Convert LocalDateTime to Timestamp for JSP compatibility
                LocalDateTime localDateTime = rs.getTimestamp("createdAt").toLocalDateTime();
                map.put("createdAt", Timestamp.valueOf(localDateTime));
                
                return map;
            }
        }, userId);
    }

    /** Lấy message trong 1 contact (chat), kiểm tra đúng user_id luôn */
    public List<Map<String, Object>> findMessagesByContact(Integer contactId, Integer userId) {
        String sql = """
                SELECT cm.message_id   AS messageId,
                       cm.sender_type  AS senderType,
                       cm.message_text AS messageText,
                       cm.created_at   AS createdAt
                FROM contact_messages cm
                JOIN contacts c ON cm.contact_id = c.contact_id
                WHERE cm.contact_id = ?
                  AND (c.user_id = ? OR c.user_id IS NULL)
                ORDER BY cm.created_at ASC
                """;
        
        return jdbcTemplate.query(sql, new RowMapper<Map<String, Object>>() {
            @Override
            public Map<String, Object> mapRow(ResultSet rs, int rowNum) throws SQLException {
                Map<String, Object> map = new java.util.HashMap<>();
                map.put("messageId", rs.getInt("messageId"));
                map.put("senderType", rs.getString("senderType"));
                map.put("messageText", rs.getString("messageText"));
                
                // Convert LocalDateTime to Timestamp for JSP compatibility
                LocalDateTime localDateTime = rs.getTimestamp("createdAt").toLocalDateTime();
                map.put("createdAt", Timestamp.valueOf(localDateTime));
                
                return map;
            }
        }, contactId, userId);
    }

    /**
     * Tạo contact mới + trả về contact_id
     */
    public Integer createContact(Integer userId,
                                 String fullName,
                                 String email,
                                 String phone,
                                 String subject,
                                 String messageText) {
        String sql = """
                INSERT INTO contacts (user_id, full_name, email, phone, subject, message, status)
                VALUES (?, ?, ?, ?, ?, ?, 'new')
                """;

        KeyHolder keyHolder = new GeneratedKeyHolder();

        jdbcTemplate.update(con -> {
            PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setObject(1, userId);
            ps.setString(2, fullName);
            ps.setString(3, email);
            ps.setString(4, phone);
            ps.setString(5, subject);
            ps.setString(6, messageText);
            return ps;
        }, keyHolder);

        return keyHolder.getKey() != null ? keyHolder.getKey().intValue() : null;
    }

    /** Thêm 1 tin nhán vào contact_messages */
    public void addMessage(Integer contactId, String senderType, String messageText) {
        String sql = """
                INSERT INTO contact_messages (contact_id, sender_type, message_text)
                VALUES (?, ?, ?)
                """;
        jdbcTemplate.update(sql, contactId, senderType, messageText);
    }
}
