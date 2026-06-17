package com.example.flowershop.dao;

import com.example.flowershop.model.BestSellingProduct;
import com.example.flowershop.model.MonthlyRevenueStat;
import com.example.flowershop.model.Order;
import com.example.flowershop.model.OrderItem;
import com.example.flowershop.model.RevenueStat;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.sql.Date;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Repository
public class AdminRevenueDAO {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    // ================== 1. THỐNG KÊ THEO NGÀY ==================

    /**
     * Lấy danh sách thống kê doanh thu theo ngày trong khoảng [fromDate, toDate]
     */
    public List<RevenueStat> getRevenueByDateRange(LocalDate fromDate, LocalDate toDate) {
        LocalDateTime start = fromDate.atStartOfDay();
        LocalDateTime end = toDate.plusDays(1).atStartOfDay();

        String sql = """
                SELECT 
                    DATE(created_at) AS day,
                    SUM(total_amount) AS revenue,
                    COUNT(*) AS total_orders,
                    SUM(CASE WHEN order_status = 'delivered' 
                              AND payment_status = 'paid' THEN 1 ELSE 0 END) AS success_orders,
                    SUM(CASE WHEN order_status = 'cancelled' THEN 1 ELSE 0 END) AS cancelled_orders
                FROM orders
                WHERE created_at >= ? AND created_at < ?
                GROUP BY DATE(created_at)
                ORDER BY day ASC
                """;

        return jdbcTemplate.query(sql, revenueStatRowMapper, start, end);
    }

    /**
     * Summary trong khoảng [fromDate, toDate]:
     * - Tổng doanh thu
     * - Tổng số đơn
     * - Đơn thành công
     * - Đơn hủy
     */
    public RevenueStat getSummary(LocalDate fromDate, LocalDate toDate) {
        LocalDateTime start = fromDate.atStartOfDay();
        LocalDateTime end = toDate.plusDays(1).atStartOfDay();

        String sql = """
                SELECT 
                    SUM(total_amount) AS revenue,
                    COUNT(*) AS total_orders,
                    SUM(CASE WHEN order_status = 'delivered' 
                              AND payment_status = 'paid' THEN 1 ELSE 0 END) AS success_orders,
                    SUM(CASE WHEN order_status = 'cancelled' THEN 1 ELSE 0 END) AS cancelled_orders
                FROM orders
                WHERE created_at >= ? AND created_at < ?
                """;

        return jdbcTemplate.queryForObject(sql, (rs, rowNum) -> {
            RevenueStat s = new RevenueStat();
            BigDecimal revenue = rs.getBigDecimal("revenue");
            s.setRevenue(revenue != null ? revenue : BigDecimal.ZERO);
            s.setTotalOrders(rs.getInt("total_orders"));
            s.setSuccessOrders(rs.getInt("success_orders"));
            s.setCancelledOrders(rs.getInt("cancelled_orders"));
            s.setDate(null); // không dùng ngày cho summary
            return s;
        }, start, end);
    }

    private final RowMapper<RevenueStat> revenueStatRowMapper = new RowMapper<>() {
        @Override
        public RevenueStat mapRow(ResultSet rs, int rowNum) throws SQLException {
            RevenueStat s = new RevenueStat();
            Date d = rs.getDate("day");
            s.setDate(d != null ? d.toLocalDate() : null);
            s.setRevenue(rs.getBigDecimal("revenue"));
            s.setTotalOrders(rs.getInt("total_orders"));
            s.setSuccessOrders(rs.getInt("success_orders"));
            s.setCancelledOrders(rs.getInt("cancelled_orders"));
            return s;
        }
    };

    // ================== 2. DOANH THU THÁNG / NĂM ==================

    /**
     * Tổng doanh thu của 1 tháng (chỉ tính đơn giao thành công + đã thanh toán)
     */
    public BigDecimal getMonthlyRevenue(int year, int month) {
        String sql = """
                SELECT COALESCE(SUM(total_amount), 0) AS revenue
                FROM orders
                WHERE order_status = 'delivered'
                  AND payment_status = 'paid'
                  AND YEAR(created_at) = ?
                  AND MONTH(created_at) = ?
                """;
        return jdbcTemplate.queryForObject(
                sql,
                BigDecimal.class,
                year, month
        );
    }

    /**
     * Tổng doanh thu của 1 năm
     */
    public BigDecimal getYearlyRevenue(int year) {
        String sql = """
                SELECT COALESCE(SUM(total_amount), 0) AS revenue
                FROM orders
                WHERE order_status = 'delivered'
                  AND payment_status = 'paid'
                  AND YEAR(created_at) = ?
                """;
        return jdbcTemplate.queryForObject(
                sql,
                BigDecimal.class,
                year
        );
    }

    /**
     * (Tùy chọn) Lấy doanh thu từng tháng trong 1 năm – dùng vẽ chart cột theo tháng
     */
    public List<MonthlyRevenueStat> getMonthlyRevenueStatsInYear(int year) {
        String sql = """
                SELECT 
                    YEAR(created_at) AS y,
                    MONTH(created_at) AS m,
                    COALESCE(SUM(total_amount), 0) AS revenue,
                    COUNT(*) AS total_orders
                FROM orders
                WHERE order_status = 'delivered'
                  AND payment_status = 'paid'
                  AND YEAR(created_at) = ?
                GROUP BY YEAR(created_at), MONTH(created_at)
                ORDER BY m ASC
                """;

        return jdbcTemplate.query(sql, (rs, rowNum) -> {
            MonthlyRevenueStat s = new MonthlyRevenueStat();
            s.setYear(rs.getInt("y"));
            s.setMonth(rs.getInt("m"));
            s.setRevenue(rs.getBigDecimal("revenue"));
            s.setTotalOrders(rs.getInt("total_orders"));
            return s;
        }, year);
    }

    // ================== 3. TOP SẢN PHẨM BÁN CHẠY ==================

    /**
     * Top N sản phẩm bán chạy trong khoảng ngày
     */
    public List<BestSellingProduct> getTopBestSellingProducts(LocalDate fromDate,
                                                              LocalDate toDate,
                                                              int limit) {
        LocalDateTime start = fromDate.atStartOfDay();
        LocalDateTime end = toDate.plusDays(1).atStartOfDay();

        String sql = """
                SELECT 
                    p.product_id,
                    p.product_name,
                    p.main_image,
                    p.price,
                    SUM(oi.quantity) AS total_sold,
                    SUM(oi.subtotal) AS total_revenue
                FROM order_items oi
                JOIN orders o ON oi.order_id = o.order_id
                JOIN products p ON oi.product_id = p.product_id
                WHERE o.created_at >= ? AND o.created_at < ?
                  AND o.order_status = 'delivered'
                  AND o.payment_status = 'paid'
                GROUP BY p.product_id, p.product_name, p.main_image, p.price
                ORDER BY total_sold DESC
                LIMIT ?
                """;

        return jdbcTemplate.query(
                sql,
                (rs, rowNum) -> {
                    BestSellingProduct p = new BestSellingProduct();
                    p.setProductId(rs.getInt("product_id"));
                    p.setProductName(rs.getString("product_name"));
                    p.setMainImage(rs.getString("main_image"));
                    p.setPrice(rs.getBigDecimal("price"));
                    p.setTotalSold(rs.getInt("total_sold"));
                    p.setTotalRevenue(rs.getBigDecimal("total_revenue"));
                    return p;
                },
                start, end, limit
        );
    }

    // ================== 4. DANH SÁCH ĐƠN THEO NGÀY ==================

    /**
     * Đơn giao thành công (delivered + paid) trong 1 ngày
     */
    public List<Order> getSuccessOrdersByDate(LocalDate date) {
        LocalDateTime start = date.atStartOfDay();
        LocalDateTime end = date.plusDays(1).atStartOfDay();

        String sql = """
                SELECT *
                FROM orders
                WHERE created_at >= ? AND created_at < ?
                  AND order_status = 'delivered'
                  AND payment_status = 'paid'
                ORDER BY created_at DESC
                """;

        return jdbcTemplate.query(
                sql,
                new BeanPropertyRowMapper<>(Order.class),
                start, end
        );
    }

    /**
     * Đơn bị hủy trong 1 ngày
     */
    public List<Order> getCancelledOrdersByDate(LocalDate date) {
        LocalDateTime start = date.atStartOfDay();
        LocalDateTime end = date.plusDays(1).atStartOfDay();

        String sql = """
                SELECT *
                FROM orders
                WHERE created_at >= ? AND created_at < ?
                  AND order_status = 'cancelled'
                ORDER BY created_at DESC
                """;

        return jdbcTemplate.query(
                sql,
                new BeanPropertyRowMapper<>(Order.class),
                start, end
        );
    }

    // ================== 5. CHI TIẾT ĐƠN HÀNG ==================

    /**
     * Lấy thông tin đơn hàng (để hiển thị chi tiết)
     */
    public Order getOrderDetail(int orderId) {
        String sql = "SELECT * FROM orders WHERE order_id = ?";
        return jdbcTemplate.queryForObject(
                sql,
                new BeanPropertyRowMapper<>(Order.class),
                orderId
        );
    }

    /**
     * Danh sách sản phẩm trong đơn
     */
    public List<OrderItem> getOrderItems(int orderId) {
        String sql = "SELECT * FROM order_items WHERE order_id = ?";
        return jdbcTemplate.query(
                sql,
                new BeanPropertyRowMapper<>(OrderItem.class),
                orderId
        );
    }
}
