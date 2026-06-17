package com.example.flowershop.dao;

import com.example.flowershop.model.Order;
import com.example.flowershop.model.OrderHistory;
import com.example.flowershop.model.OrderItem;

import java.util.List;

public interface OrderDAO {

    // ===== DANH SÁCH / CHI TIẾT ĐƠN HÀNG =====
    List<Order> search(String status, String keyword);

    Order findById(Integer id);

    List<OrderItem> findItemsByOrderId(Integer orderId);

    List<OrderHistory> findHistoryByOrderId(Integer orderId);

    // Lấy danh sách đơn hàng theo user (dùng cho trang Tài khoản khách)
    List<Order> findByUserId(Integer userId);


    // ===== API CHÍNH CÓ adminId (AdminOrderController đang dùng cái này) =====
    void updateStatus(Integer orderId, String status, String note, Integer adminId);

    void cancelOrder(Integer orderId, String reason, Integer adminId);

    // Cập nhật trạng thái thanh toán: pending / paid / failed
    void updatePaymentStatus(Integer orderId, String paymentStatus);


    // ===== API TIỆN LỢI CHO CODE CŨ (không có adminId) =====
    default void updateStatus(Integer orderId, String status, String note) {
        // chỗ nào trong project còn gọi 3 tham số sẽ chạy vào đây
        updateStatus(orderId, status, note, null);
    }

    default void cancelOrder(Integer orderId, String reason) {
        // chỗ nào trong project còn gọi 2 tham số sẽ chạy vào đây
        cancelOrder(orderId, reason, null);
    }
}
