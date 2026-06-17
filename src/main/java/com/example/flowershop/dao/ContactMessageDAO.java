package com.example.flowershop.dao;

import com.example.flowershop.model.ContactMessage;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

@Repository
public class ContactMessageDAO {

    @Autowired
    private JdbcTemplate jdbc;

    private RowMapper<ContactMessage> mapper = new RowMapper<ContactMessage>() {
        @Override
        public ContactMessage mapRow(ResultSet rs, int rowNum) throws SQLException {
            ContactMessage m = new ContactMessage();
            m.setMessageId(rs.getInt("message_id"));
            m.setContactId(rs.getInt("contact_id"));
            m.setSenderType(rs.getString("sender_type"));
            m.setMessageText(rs.getString("message_text"));
            m.setCreatedAt(rs.getTimestamp("created_at"));
            return m;
        }
    };

    public List<ContactMessage> findByContactId(int contactId) {
        String sql = "SELECT * FROM contact_messages WHERE contact_id = ? ORDER BY created_at ASC";
        return jdbc.query(sql, mapper, contactId);
    }

    public void saveMessage(ContactMessage msg) {
        String sql = """
            INSERT INTO contact_messages (contact_id, sender_type, message_text)
            VALUES (?, ?, ?)
        """;
        jdbc.update(sql, msg.getContactId(), msg.getSenderType(), msg.getMessageText());
    }
}

