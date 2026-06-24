<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thống kê doanh thu</title>

    <!-- Chart.js CDN -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <style>
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #f5f5f5;
        }

        .admin-content {
            margin-left: 250px;
            padding: 20px;
            min-height: 100vh;
            box-sizing: border-box;
        }

        h1 {
            margin-top: 0;
            color: #333;
            margin-bottom: 20px;
        }

        .filter-box {
            background: #fff;
            padding: 15px;
            border-radius: 8px;
            border: 1px solid #ddd;
            margin-bottom: 20px;
        }

        .filter-box form {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            align-items: center;
        }

        .filter-box label {
            font-size: 14px;
        }

        .filter-box input[type="date"] {
            padding: 5px 8px;
            border-radius: 4px;
            border: 1px solid #ccc;
            font-size: 14px;
        }

        .btn {
            display: inline-block;
            padding: 6px 12px;
            font-size: 14px;
            border-radius: 4px;
            border: none;
            cursor: pointer;
            text-decoration: none;
        }

        .btn-primary {
            background: #4A90E2;
            color: #fff;
        }

        .btn-primary:hover {
            background: #357ABD;
        }

        .btn-outline {
            background: #fff;
            border: 1px solid #4A90E2;
            color: #4A90E2;
        }

        .btn-outline:hover {
            background: #4A90E2;
            color: #fff;
        }

        .cards {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            margin-bottom: 20px;
        }

        .card {
            background: #fff;
            border-radius: 8px;
            border: 1px solid #ddd;
            padding: 15px;
            flex: 1;
            min-width: 220px;
        }

        .card-title {
            font-size: 13px;
            text-transform: uppercase;
            color: #777;
            margin-bottom: 5px;
        }

        .card-value {
            font-size: 20px;
            font-weight: bold;
            color: #333;
        }

        .card-sub {
            font-size: 12px;
            color: #999;
        }

        .section-title {
            margin: 25px 0 10px;
            font-size: 18px;
            font-weight: bold;
            color: #333;
        }

        .flex-row {
            display: flex;
            gap: 20px;
            flex-wrap: wrap;
        }

        .flex-2 {
            flex: 2;
            min-width: 380px;
        }

        .flex-1 {
            flex: 1;
            min-width: 260px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            background: #fff;
            border-radius: 8px;
            overflow: hidden;
        }

        th, td {
            border: 1px solid #ddd;
            padding: 8px 10px;
            font-size: 13px;
            text-align: left;
        }

        th {
            background: #f0f0f0;
        }

        tr:nth-child(even) {
            background: #fafafa;
        }

        .text-right {
            text-align: right;
        }

        .badge {
            display: inline-block;
            padding: 3px 8px;
            border-radius: 12px;
            font-size: 11px;
            color: #fff;
        }

        .badge-success { background: #27ae60; }
        .badge-danger { background: #e74c3c; }

        .actions-col a {
            margin-right: 5px;
        }

        .alert {
            padding: 10px 14px;
            border-radius: 4px;
            margin-bottom: 15px;
            font-size: 13px;
        }

        .alert-warning {
            background: #FFF7E6;
            border: 1px solid #F6C453;
            color: #8A6D3B;
        }

    </style>
</head>
<body>

<c:set var="activePage" value="revenue" />
<%@ include file="_sidebar.jsp" %>

<div class="admin-content">
    <h1>Thống kê doanh thu</h1>

    <c:if test="${not empty param.noData}">
        <div class="alert alert-warning">
            Không có đơn hàng nào trong khoảng ngày đã chọn, không thể xuất Excel. Vui lòng chọn lại.
        </div>
    </c:if>

    <!-- Bộ lọc ngày + nút Export -->
    <div class="filter-box">
        <form method="get" action="${pageContext.request.contextPath}/admin/revenue">
            <label for="fromDate">Từ ngày:</label>
            <input type="date" id="fromDate" name="fromDate" value="${fromDate}"/>

            <label for="toDate">Đến ngày:</label>
            <input type="date" id="toDate" name="toDate" value="${toDate}"/>

            <button type="submit" class="btn btn-primary">Lọc</button>

            <a class="btn btn-outline"
               href="${pageContext.request.contextPath}/admin/revenue/export?fromDate=${fromDate}&toDate=${toDate}">
                Xuất Excel
            </a>
        </form>
    </div>

    <!-- Cards tổng quan -->
    <div class="cards">
        <div class="card">
            <div class="card-title">Doanh thu trong khoảng</div>
            <div class="card-value">
                <fmt:formatNumber value="${totalRevenue}" type="number" minFractionDigits="0" maxFractionDigits="0"/> â‚«
            </div>
            <div class="card-sub">
                Từ ${fromDate} đến ${toDate}
            </div>
        </div>
        <div class="card">
            <div class="card-title">Tổng doanh thu tháng</div>
            <div class="card-value">
                <fmt:formatNumber value="${monthlyRevenue}" type="number" minFractionDigits="0" maxFractionDigits="0"/> â‚«
            </div>
            <div class="card-sub">
                Tháng ${toDate.monthValue} / ${toDate.year}
            </div>
        </div>
        <div class="card">
            <div class="card-title">Tổng doanh thu năm</div>
            <div class="card-value">
                <fmt:formatNumber value="${yearlyRevenue}" type="number" minFractionDigits="0" maxFractionDigits="0"/> â‚«
            </div>
            <div class="card-sub">
                Năm ${toDate.year}
            </div>
        </div>
        <div class="card">
            <div class="card-title">Số đơn trong khoảng</div>
            <div class="card-value">${summary.totalOrders}</div>
            <div class="card-sub">
                Thành công: <span class="badge badge-success">${summary.successOrders}</span>
                &nbsp; Hủy: <span class="badge badge-danger">${summary.cancelledOrders}</span>
            </div>
        </div>
    </div>

    <!-- Biểu đồ + Top sản phẩm -->
    <div class="flex-row">
        <!-- Biểu đồ -->
        <div class="flex-2">
            <div class="section-title">Biểu đồ doanh thu theo ngày</div>
            <div style="background:#fff; border-radius:8px; border:1px solid #ddd; padding:15px;">
                <canvas id="revenueChart" height="120"></canvas>
            </div>
        </div>

        <!-- Top 5 sản phẩm bán chạy -->
        <div class="flex-1">
            <div class="section-title">🔥 Top 5 sản phẩm bán chạy</div>
            <table>
                <thead>
                <tr>
                    <th>#</th>
                    <th>Sản phẩm</th>
                    <th class="text-right">SL bán</th>
                    <th class="text-right">Doanh thu</th>
                </tr>
                </thead>
                <tbody>
                <c:if test="${empty topProducts}">
                    <tr>
                        <td colspan="4">Chưa có dữ liệu.</td>
                    </tr>
                </c:if>
                <c:forEach var="p" items="${topProducts}" varStatus="loop">
                    <tr>
                        <td>${loop.index + 1}</td>
                        <td>
                            <c:out value="${p.productName}"/>
                            <br/>
                            <small><c:out value="${p.categoryName}"/></small>
                        </td>
                        <td class="text-right">${p.totalSold}</td>
                        <td class="text-right">
                            <fmt:formatNumber value="${p.totalRevenue}" type="number" minFractionDigits="0" maxFractionDigits="0"/> â‚«
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Bảng chi tiết theo ngày -->
    <div class="section-title">Chi tiết doanh thu theo ngày</div>
    <table>
        <thead>
        <tr>
            <th>Ngày</th>
            <th class="text-right">Doanh thu (â‚«)</th>
            <th class="text-right">Số đơn</th>
            <th class="text-right">Đơn thành công</th>
            <th class="text-right">Đơn hủy</th>
            <th>Hành động</th>
        </tr>
        </thead>
        <tbody>
        <c:if test="${empty stats}">
            <tr>
                <td colspan="6">Không có dữ liệu trong khoảng thời gian này.</td>
            </tr>
        </c:if>
        <c:forEach var="s" items="${stats}">
            <tr>
                <!-- LocalDate in ra dạng chuỗi, không dùng fmt:formatDate -->
                <td>${s.date}</td>
                <td class="text-right">
                    <fmt:formatNumber value="${s.revenue}" type="number" minFractionDigits="0" maxFractionDigits="0"/>
                </td>
                <td class="text-right">${s.totalOrders}</td>
                <td class="text-right">${s.successOrders}</td>
                <td class="text-right">${s.cancelledOrders}</td>
                <td class="actions-col">
                    <a class="btn btn-outline"
                       href="${pageContext.request.contextPath}/admin/revenue/success-orders?date=${s.date}&fromDate=${fromDate}&toDate=${toDate}">
                        Đơn thành công
                    </a>
                    <a class="btn btn-outline"
                       href="${pageContext.request.contextPath}/admin/revenue/cancelled-orders?date=${s.date}&fromDate=${fromDate}&toDate=${toDate}">
                        Đơn hủy
                    </a>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>

<!-- Script vẽ Chart.js -->
<script>
    (function () {
        const ctx = document.getElementById('revenueChart');
        if (!ctx) return;

        const labels = [
            <c:forEach var="s" items="${stats}" varStatus="loop">
            '${s.date}'<c:if test="${!loop.last}">,</c:if>
            </c:forEach>
        ];

        const dataRevenue = [
            <c:forEach var="s" items="${stats}" varStatus="loop">
            ${s.revenue}<c:if test="${!loop.last}">,</c:if>
            </c:forEach>
        ];

        new Chart(ctx, {
            type: 'line',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Doanh thu (â‚«)',
                    data: dataRevenue,
                    fill: false,
                    tension: 0.2
                }]
            },
            options: {
                responsive: true,
                interaction: {
                    mode: 'index',
                    intersect: false
                },
                scales: {
                    y: {
                        beginAtZero: true
                    }
                }
            }
        });
    })();
</script>

</body>
</html>

