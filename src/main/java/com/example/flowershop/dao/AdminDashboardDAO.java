package com.example.flowershop.dao;

import com.example.flowershop.model.DashboardStats;
import com.example.flowershop.model.RecentOrderDTO;
import java.sql.Timestamp;
import java.math.BigDecimal;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

@Repository
public class AdminDashboardDAO {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    // Lấy 4 số liệu thô bằng SQL query trực tiếp
    public DashboardStats getBaseStats() {
        DashboardStats stats = new DashboardStats();
        
        // Tổng số khách hàng
        String customersSql = "SELECT COUNT(*) FROM users WHERE role = 'customer'";
        Long totalCustomers = jdbcTemplate.queryForObject(customersSql, Long.class);
        stats.setTotalCustomers(totalCustomers != null ? totalCustomers : 0L);
        
        // Tổng số sản phẩm
        String productsSql = "SELECT COUNT(*) FROM products WHERE status = 'active'";
        Long totalProducts = jdbcTemplate.queryForObject(productsSql, Long.class);
        stats.setTotalProducts(totalProducts != null ? totalProducts : 0L);
        
        // Đơn hàng hôm nay
        String todayOrdersSql = "SELECT COUNT(*) FROM orders WHERE DATE(created_at) = CURDATE()";
        Long todayOrders = jdbcTemplate.queryForObject(todayOrdersSql, Long.class);
        stats.setTodayOrders(todayOrders != null ? todayOrders : 0L);
        
        // Doanh thu tháng này
        String monthlyRevenueSql = """
            SELECT COALESCE(SUM(total_amount), 0) 
            FROM orders 
            WHERE MONTH(created_at) = MONTH(CURDATE()) 
              AND YEAR(created_at) = YEAR(CURDATE())
              AND order_status = 'delivered'
              AND payment_status = 'paid'
            """;
        BigDecimal monthlyRevenue = jdbcTemplate.queryForObject(monthlyRevenueSql, BigDecimal.class);
        stats.setMonthlyRevenue(monthlyRevenue != null ? monthlyRevenue : BigDecimal.ZERO);
        
        return stats;
    }

    public BigDecimal getLastMonthRevenue() {
        String sql =
                "SELECT COALESCE(SUM(total_amount),0) " +
                "FROM orders " +
                "WHERE order_status = 'delivered' " +
                "  AND payment_status = 'paid' " +
                "  AND MONTH(created_at) = MONTH(DATE_SUB(CURDATE(), INTERVAL 1 MONTH)) " +
                "  AND YEAR(created_at) = YEAR(DATE_SUB(CURDATE(), INTERVAL 1 MONTH))";
        return jdbcTemplate.queryForObject(sql, BigDecimal.class);
    }

    public long getYesterdayOrders() {
        String sql =
                "SELECT COUNT(*) FROM orders " +
                "WHERE DATE(created_at) = DATE_SUB(CURDATE(), INTERVAL 1 DAY)";
        return jdbcTemplate.queryForObject(sql, Long.class);
    }

    // KH mới trong tháng trước
    public long getLastMonthNewCustomers() {
        String sql =
                "SELECT COUNT(*) FROM users " +
                "WHERE role = 'customer' " +
                "  AND MONTH(created_at) = MONTH(DATE_SUB(CURDATE(), INTERVAL 1 MONTH)) " +
                "  AND YEAR(created_at) = YEAR(DATE_SUB(CURDATE(), INTERVAL 1 MONTH))";
        return jdbcTemplate.queryForObject(sql, Long.class);
    }

    // SP được thêm mới trong tuần trước
    public long getLastWeekNewProducts() {
        String sql =
                "SELECT COUNT(*) FROM products " +
                "WHERE DATE(created_at) >= DATE_SUB(CURDATE(), INTERVAL 14 DAY) " +
                "  AND DATE(created_at) < DATE_SUB(CURDATE(), INTERVAL 7 DAY)";
        return jdbcTemplate.queryForObject(sql, Long.class);
    }

    // Bảng đơn hàng gần đây
    public List<RecentOrderDTO> getRecentOrders(int limit) {
        String sql = """
                SELECT 
                    o.order_code,
                    u.full_name       AS customer_name,
                    MIN(oi.product_name) AS product_summary,
                    o.total_amount,
                    o.order_status,
                    o.created_at
                FROM orders o
                JOIN users u ON o.user_id = u.user_id
                LEFT JOIN order_items oi ON o.order_id = oi.order_id
                GROUP BY o.order_id, o.order_code, u.full_name, o.total_amount, o.order_status, o.created_at
                ORDER BY o.created_at DESC
                LIMIT ?
                """;

        RowMapper<RecentOrderDTO> mapper = (rs, rowNum) -> {
            RecentOrderDTO dto = new RecentOrderDTO();
            dto.setOrderCode(rs.getString("order_code"));
            dto.setCustomerName(rs.getString("customer_name"));
            dto.setProductSummary(rs.getString("product_summary"));
            dto.setTotalAmount(rs.getBigDecimal("total_amount"));
            dto.setOrderStatus(rs.getString("order_status"));
            Timestamp timestamp = rs.getTimestamp("created_at");
            if (timestamp != null) {
                dto.setCreatedAt(timestamp.toLocalDateTime());
            }
            return dto;
        };

        return jdbcTemplate.query(sql, mapper, limit);
    }

    // Tính phần trăm thay đổi an toàn
    public double calcPercent(Number current, Number previous) {
        double cur = current.doubleValue();
        double prev = previous.doubleValue();
        if (prev == 0) {
            return cur > 0 ? 100.0 : 0.0;
        }
        return (cur - prev) * 100.0 / prev;
    }

    // Hàm tổng hợp: build đầy đủ DashboardStats
    public DashboardStats getDashboardStats() {
        DashboardStats stats = getBaseStats();

        BigDecimal lastMonthRevenue = getLastMonthRevenue();
        long yesterdayOrders = getYesterdayOrders();
        long lastMonthCustomers = getLastMonthNewCustomers();
        long lastWeekProducts = getLastWeekNewProducts();
        List<RecentOrderDTO> recentOrders = getRecentOrders(5);

        stats.setLastMonthRevenue(lastMonthRevenue);
        stats.setYesterdayOrders(yesterdayOrders);
        stats.setLastMonthNewCustomers(lastMonthCustomers);
        stats.setLastWeekNewProducts(lastWeekProducts);
        stats.setRecentOrders(recentOrders);

        // Tính % thay đổi
        stats.setRevenueChangePercent(
                calcPercent(stats.getMonthlyRevenue(), lastMonthRevenue)
        );
        stats.setOrderChangePercent(
                calcPercent(stats.getTodayOrders(), yesterdayOrders)
        );
        stats.setCustomerChangePercent(
                calcPercent(stats.getTotalCustomers(), lastMonthCustomers)
        );
        stats.setProductChangePercent(
                calcPercent(stats.getTotalProducts(), lastWeekProducts)
        );

        return stats;
    }
}

