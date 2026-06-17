package com.example.flowershop.model;

import jakarta.persistence.Entity;

import java.sql.Timestamp;


public class ContactMessage {
    private int messageId;
    private int contactId;
    private String senderType;
    private String messageText;
    private Timestamp createdAt;

    public int getMessageId() { return messageId; }
    public void setMessageId(int messageId) { this.messageId = messageId; }

    public int getContactId() { return contactId; }
    public void setContactId(int contactId) { this.contactId = contactId; }

    public String getSenderType() { return senderType; }
    public void setSenderType(String senderType) { this.senderType = senderType; }

    public String getMessageText() { return messageText; }
    public void setMessageText(String messageText) { this.messageText = messageText; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}

