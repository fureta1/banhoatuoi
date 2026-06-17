package com.example.flowershop.controller.admin;

import com.example.flowershop.dao.AdminRevenueDAO;
import com.example.flowershop.export.RevenueExcelExporter;
import com.example.flowershop.model.BestSellingProduct;
import com.example.flowershop.model.Order;
import com.example.flowershop.model.OrderItem;
import com.example.flowershop.model.RevenueStat;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.io.IOException;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.util.List;

@Controller
@RequestMapping("/admin/revenue")
public class AdminRevenueController {

    @Autowired
    private AdminRevenueDAO revenueDAO;

    /**
     * ============= TRANG TỔNG QUAN DOANH THU =============
     */
    @GetMapping
    public String viewRevenue(
            @RequestParam(name = "fromDate", required = false)
            @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate fromDate,

            @RequestParam(name = "toDate", required = false)
            @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate toDate,

            Model model
    ) {

        // Default 7 ngày gần nhất
        if (toDate == null) toDate = LocalDate.now();
        if (fromDate == null) fromDate = toDate.minusDays(6);

        // Thống kê theo ngày
        List<RevenueStat> stats = revenueDAO.getRevenueByDateRange(fromDate, toDate);

        // Summary tổng quan
        RevenueStat summary = revenueDAO.getSummary(fromDate, toDate);
        BigDecimal totalRevenue = summary.getRevenue() == null
                ? BigDecimal.ZERO
                : summary.getRevenue();

        // Doanh thu tháng / năm (dựa theo toDate hiện tại)
        int year = toDate.getYear();
        int month = toDate.getMonthValue();
        BigDecimal monthlyRevenue = revenueDAO.getMonthlyRevenue(year, month);
        BigDecimal yearlyRevenue = revenueDAO.getYearlyRevenue(year);

        // Top 5 sản phẩm bán chạy
        List<BestSellingProduct> topProducts =
                revenueDAO.getTopBestSellingProducts(fromDate, toDate, 5);

        // Đẩy dữ liệu sang view
        model.addAttribute("fromDate", fromDate);
        model.addAttribute("toDate", toDate);
        model.addAttribute("stats", stats);
        model.addAttribute("summary", summary);
        model.addAttribute("totalRevenue", totalRevenue);
        model.addAttribute("monthlyRevenue", monthlyRevenue);
        model.addAttribute("yearlyRevenue", yearlyRevenue);
        model.addAttribute("topProducts", topProducts);

        // để _sidebar.jsp highlight đúng menu
        model.addAttribute("activePage", "revenue");

        return "admin/revenue";
    }

    /**
     * ============= XUẤT BÁO CÁO EXCEL =============
     * Nếu không có đơn trong khoảng ngày thì redirect lại kèm ?noData=1
     */
    @GetMapping("/export")
    public void exportToExcel(
            @RequestParam(name = "fromDate", required = false)
            @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate fromDate,

            @RequestParam(name = "toDate", required = false)
            @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate toDate,

            HttpServletRequest request,
            HttpServletResponse response
    ) throws IOException {

        if (toDate == null) toDate = LocalDate.now();
        if (fromDate == null) fromDate = toDate.minusDays(6);

        // Lấy thống kê theo ngày
        List<RevenueStat> stats = revenueDAO.getRevenueByDateRange(fromDate, toDate);

        // Nếu không có dòng nào => không có đơn trong khoảng ngày này
        if (stats == null || stats.isEmpty()) {
            String ctx = request.getContextPath();
            String redirectUrl = ctx + "/admin/revenue?fromDate=" + fromDate
                    + "&toDate=" + toDate
                    + "&noData=1";
            response.sendRedirect(redirectUrl);
            return;
        }

        // Có dữ liệu thì mới xuất
        RevenueStat summary = revenueDAO.getSummary(fromDate, toDate);

        RevenueExcelExporter exporter =
                new RevenueExcelExporter(stats, summary, fromDate, toDate);

        // Thiết lập header file tải xuống
        response.setContentType(
                "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
        );

        String fileName = "bao_cao_doanh_thu_" + fromDate + "_den_" + toDate + ".xlsx";
        String encoded = URLEncoder.encode(fileName, StandardCharsets.UTF_8)
                .replaceAll("\\+", "%20");

        response.setHeader("Content-Disposition",
                "attachment; filename*=UTF-8''" + encoded);

        exporter.export(response);
    }

    /**
     * ============= TRANG ĐƠN THÀNH CÔNG THEO NGÀY =============
     */
    @GetMapping("/success-orders")
    public String viewSuccessOrders(
            @RequestParam("date")
            @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate date,

            @RequestParam(name = "fromDate", required = false)
            @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate fromDate,

            @RequestParam(name = "toDate", required = false)
            @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate toDate,

            Model model
    ) {
        List<Order> orders = revenueDAO.getSuccessOrdersByDate(date);

        model.addAttribute("date", date);
        model.addAttribute("orders", orders);
        model.addAttribute("status", "delivered");

        // để nút Quay lại giữ được khoảng lọc
        model.addAttribute("fromDate", fromDate);
        model.addAttribute("toDate", toDate);
        model.addAttribute("activePage", "revenue");

        return "admin/revenue-success-orders";
    }

    /**
     * ============= TRANG ĐƠN HỦY THEO NGÀY =============
     */
    @GetMapping("/cancelled-orders")
    public String viewCancelledOrders(
            @RequestParam("date")
            @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate date,

            @RequestParam(name = "fromDate", required = false)
            @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate fromDate,

            @RequestParam(name = "toDate", required = false)
            @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate toDate,

            Model model
    ) {
        List<Order> cancelledOrders = revenueDAO.getCancelledOrdersByDate(date);

        model.addAttribute("date", date);
        model.addAttribute("cancelledOrders", cancelledOrders);
        model.addAttribute("status", "cancelled");

        model.addAttribute("fromDate", fromDate);
        model.addAttribute("toDate", toDate);
        model.addAttribute("activePage", "revenue");

        return "admin/revenue-cancelled-orders";
    }

    /**
     * ============= TRANG CHI TIẾT ĐƠN TỪ TRANG THỐNG KÊ =============
     */
    @GetMapping("/order-detail")
    public String viewOrderDetail(
            @RequestParam("orderId") int orderId,

            @RequestParam(name = "fromDate", required = false)
            @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate fromDate,

            @RequestParam(name = "toDate", required = false)
            @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate toDate,

            Model model
    ) {
        Order order = revenueDAO.getOrderDetail(orderId);
        if (order == null) {
            return "redirect:/admin/revenue";
        }

        // Lấy sản phẩm trong đơn
        List<OrderItem> items = revenueDAO.getOrderItems(orderId);

        model.addAttribute("order", order);
        model.addAttribute("items", items);

        // để nút Quay lại giữ được khoảng lọc
        model.addAttribute("fromDate", fromDate);
        model.addAttribute("toDate", toDate);
        model.addAttribute("activePage", "revenue");

        return "admin/revenue-order-detail";
    }
}
