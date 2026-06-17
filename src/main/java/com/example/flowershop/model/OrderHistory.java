package com.example.flowershop.model;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;

import java.io.Serializable;
import java.sql.Timestamp;


@Entity
public class OrderHistory implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer historyId;
    private Integer orderId;
    private String status;
    private String note;
    private Integer updatedBy;       // user_id
    private String updatedByName;    // để join hiển thị
    private Timestamp createdAt;

    public OrderHistory() {
    }

    public OrderHistory(Integer historyId, Integer orderId, String status,
                        String note, Integer updatedBy, String updatedByName,
                        Timestamp createdAt) {
        this.historyId = historyId;
        this.orderId = orderId;
        this.status = status;
        this.note = note;
        this.updatedBy = updatedBy;
        this.updatedByName = updatedByName;
        this.createdAt = createdAt;
    }

    public Integer getHistoryId() {
        return historyId;
    }

    public void setHistoryId(Integer historyId) {
        this.historyId = historyId;
    }

    public Integer getOrderId() {
        return orderId;
    }

    public void setOrderId(Integer orderId) {
        this.orderId = orderId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public Integer getUpdatedBy() {
        return updatedBy;
    }

    public void setUpdatedBy(Integer updatedBy) {
        this.updatedBy = updatedBy;
    }

    public String getUpdatedByName() {
        return updatedByName;
    }

    public void setUpdatedByName(String updatedByName) {
        this.updatedByName = updatedByName;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "OrderHistory{" +
                "historyId=" + historyId +
                ", orderId=" + orderId +
                ", status='" + status + '\'' +
                ", note='" + note + '\'' +
                ", updatedBy=" + updatedBy +
                ", updatedByName='" + updatedByName + '\'' +
                ", createdAt=" + createdAt +
                '}';
    }
}
