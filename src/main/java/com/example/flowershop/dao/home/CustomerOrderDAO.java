package com.example.flowershop.dao.home;

import com.example.flowershop.model.CartItem;
import com.example.flowershop.model.Product;
import com.example.flowershop.model.Order;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.sql.PreparedStatement;
import java.sql.Statement;
import java.util.List;

@Repository
public class CustomerOrderDAO {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    // Dùng cho các truy vấn lấy danh sách đơn hàng
    private final RowMapper<Order> orderRowMapper =
            new BeanPropertyRowMapper<>(Order.class);

    /**
     * Tạo đơn hàng + chi tiết đơn hàng từ giỏ hàng đã chọn.
     * Trả về order_id vừa tạo.
     *
     * Lưu ý:
     *  - order_code sẽ được trigger before_order_insert tự sinh.
     *  - payment_status, order_status dùng default 'pending'.
     */
    @Transactional
    public OrderInfo createOrder(
            Integer userId,
            String recipientName,
            String phone,
            String addressLine,
            String ward,
            String district,
            String city,
            BigDecimal subtotal,
            BigDecimal shippingFee,
            BigDecimal totalAmount,
            String paymentMethod,
            String note,
            List<CartItem> items
    ) {

        // Generate order code
        String orderCode = "ORD" + System.currentTimeMillis();
        System.out.println("=== CUSTOMER ORDER DAO ===");
        System.out.println("Generated orderCode: " + orderCode);
        System.out.println("UserId: " + userId);
        System.out.println("PaymentMethod: " + paymentMethod);

        // 1) Insert vào bảng orders
        String sqlOrder = """
            INSERT INTO orders (
                order_code,
                user_id,
                recipient_name, phone,
                address_line, ward, district, city,
                subtotal, shipping_fee, discount_amount, total_amount,
                payment_method, payment_status, order_status, note,
                created_at, updated_at
            )
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 0, ?, ?, 'pending', 'pending', ?, NOW(), NOW())
            """;

        KeyHolder keyHolder = new GeneratedKeyHolder();

        jdbcTemplate.update(con -> {
            PreparedStatement ps = con.prepareStatement(sqlOrder, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, orderCode);
            ps.setInt(2, userId);
            ps.setString(3, recipientName);
            ps.setString(4, phone);
            ps.setString(5, addressLine);
            ps.setString(6, ward);
            ps.setString(7, district);
            ps.setString(8, city);
            ps.setBigDecimal(9, subtotal);
            ps.setBigDecimal(10, shippingFee);
            ps.setBigDecimal(11, totalAmount);
            ps.setString(12, paymentMethod);
            ps.setString(13, note);
            return ps;
        }, keyHolder);

        Number key = keyHolder.getKey();
        if (key == null) {
            throw new IllegalStateException("Không lấy được order_id sau khi insert orders");
        }
        Long orderId = key.longValue();
        
        System.out.println("=== ORDER INSERTED ===");
        System.out.println("Generated orderId: " + orderId);
        System.out.println("Final orderCode: " + orderCode);

        // 2) Insert chi tiết từng sản phẩm vào order_items
        String sqlItem = """
            INSERT INTO order_items (
                order_id, product_id, product_name,
                price, quantity, subtotal
            )
            VALUES (?, ?, ?, ?, ?, ?)
            """;

        for (CartItem item : items) {
            Product p = item.getProduct();
            if (p == null) continue;

            BigDecimal unitPrice =
                    p.getDiscountPrice() != null && p.getDiscountPrice().compareTo(BigDecimal.ZERO) > 0
                            ? p.getDiscountPrice()
                            : p.getPrice();

            BigDecimal lineSubtotal = unitPrice.multiply(BigDecimal.valueOf(item.getQuantity()));

            jdbcTemplate.update(
                    sqlItem,
                    orderId,
                    p.getId(),              // Product có getter getId()
                    p.getName(),
                    unitPrice,
                    item.getQuantity(),
                    lineSubtotal
            );
        }

        // Trigger after_order_item_insert sẽ tự update stock_quantity, sold_quantity.
        return new OrderInfo(orderId, orderCode);
    }

    /**
     * Lấy danh sách tất cả đơn hàng của 1 khách (user).
     * Dùng để hiển thị ở trang thanh toán / lịch sử đơn hàng.
     */
    public List<Order> findOrdersByUserId(Integer userId) {
        String sql = """
                SELECT 
                    order_id,
                    order_code,
                    user_id,
                    recipient_name,
                    phone,
                    address_line,
                    ward,
                    district,
                    city,
                    subtotal,
                    shipping_fee,
                    discount_amount,
                    total_amount,
                    payment_method,
                    payment_status,
                    order_status,
                    note,
                    cancelled_reason,
                    created_at,
                    updated_at
                FROM orders
                WHERE user_id = ?
                ORDER BY created_at DESC
                """;

        return jdbcTemplate.query(sql, orderRowMapper, userId);
    }

    /**
     * Hủy đơn hàng của khách:
     *  - Chỉ cho phép hủy khi đơn đang ở các trạng thái: pending, confirmed, preparing.
     *  - Ghi lại lý do hủy vào cột cancelled_reason.
     *
     * @return số dòng bị ảnh hưởng (0 = không hủy được, >0 = thành công)
     */
    public int cancelOrder(Integer orderId, Integer userId, String cancelReason) {
        String sql = """
                UPDATE orders
                SET order_status = 'cancelled',
                    cancelled_reason = ?,
                    updated_at = NOW()
                WHERE order_id = ?
                  AND user_id = ?
                  AND order_status IN ('pending', 'confirmed', 'preparing')
                """;

        return jdbcTemplate.update(sql, cancelReason, orderId, userId);
    }

    /**
     * (Tuỳ chọn) Lấy chi tiết 1 đơn hàng cụ thể của 1 user.
     * Có thể dùng để xem chi tiết đơn hàng nếu sau này bạn cần.
     */
    public Order findOrderByIdAndUser(Integer orderId, Integer userId) {
        String sql = """
                SELECT 
                    order_id,
                    order_code,
                    user_id,
                    recipient_name,
                    phone,
                    address_line,
                    ward,
                    district,
                    city,
                    subtotal,
                    shipping_fee,
                    discount_amount,
                    total_amount,
                    payment_method,
                    payment_status,
                    order_status,
                    note,
                    cancelled_reason,
                    created_at,
                    updated_at
                FROM orders
                WHERE order_id = ?
                  AND user_id = ?
                """;

        List<Order> list = jdbcTemplate.query(sql, orderRowMapper, orderId, userId);
        return list.isEmpty() ? null : list.get(0);
    }

    /**
     * Tìm đơn hàng theo order_code (dùng cho VNPAY callback).
     */
    public Order findOrderByOrderCode(String orderCode) {
        String sql = """
                SELECT 
                    order_id,
                    order_code,
                    user_id,
                    recipient_name,
                    phone,
                    address_line,
                    ward,
                    district,
                    city,
                    subtotal,
                    shipping_fee,
                    discount_amount,
                    total_amount,
                    payment_method,
                    payment_status,
                    order_status,
                    note,
                    cancelled_reason,
                    created_at,
                    updated_at
                FROM orders
                WHERE order_code = ?
                """;

        List<Order> list = jdbcTemplate.query(sql, orderRowMapper, orderCode);
        return list.isEmpty() ? null : list.get(0);
    }

    /**
     * Cập nhật trạng thái thanh toán đơn hàng (dùng cho VNPAY IPN).
     * @return số dòng bị ảnh hưởng
     */
    public int updatePaymentStatus(String orderCode, String paymentStatus) {
        String sql = """
                UPDATE orders
                SET payment_status = ?,
                    updated_at = NOW()
                WHERE order_code = ?
                """;

        return jdbcTemplate.update(sql, paymentStatus, orderCode);
    }

    /**
     * Cập nhật trạng thái đơn hàng (dùng cho VNPAY sau khi thanh toán thành công).
     * @return số dòng bị ảnh hưởng
     */
    public int updateOrderStatus(String orderCode, String orderStatus) {
        String sql = """
                UPDATE orders
                SET order_status = ?,
                    updated_at = NOW()
                WHERE order_code = ?
                """;

        return jdbcTemplate.update(sql, orderStatus, orderCode);
    }
}
