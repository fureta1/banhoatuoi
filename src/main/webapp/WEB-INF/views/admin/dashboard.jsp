<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Dashboard - Flower Shop Admin</title>
    <style>
        body {
            margin: 0;
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Arial, sans-serif;
            background: #f5f7fb;
        }

        .admin-content {
            margin-left: 250px; 
            padding: 24px 32px;
        }

        .page-title {
            font-size: 26px;
            font-weight: 600;
            margin-bottom: 20px;
            color: #1f2933;
        }

        .cards-row {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .card {
            background: #ffffff;
            border-radius: 16px;
            padding: 18px 20px;
            box-shadow: 0 10px 25px rgba(15, 23, 42, 0.06);
            border: 1px solid #edf0f6;
        }

        .card-title {
            font-size: 13px;
            text-transform: uppercase;
            letter-spacing: .08em;
            color: #6b7280;
            margin-bottom: 8px;
        }

        .card-value {
            font-size: 26px;
            font-weight: 700;
            color: #111827;
            margin-bottom: 6px;
        }

        .card-sub {
            font-size: 12px;
            color: #10b981;
        }

        .card-sub.down {
            color: #ef4444;
        }

        .recent-box {
            background: #ffffff;
            border-radius: 16px;
            padding: 18px 20px;
            box-shadow: 0 10px 25px rgba(15, 23, 42, 0.06);
            border: 1px solid #edf0f6;
        }

        .recent-title {
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 16px;
            color: #111827;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            font-size: 13px;
        }

        thead tr {
            background: #f3f4f6;
        }

        th, td {
            padding: 10px 12px;
            text-align: left;
        }

        th {
            font-weight: 600;
            color: #4b5563;
        }

        tbody tr:nth-child(even) {
            background: #fafbff;
        }

        tbody tr:hover {
            background: #eef2ff;
        }

        .text-right {
            text-align: right;
        }

        .status-badge {
            display: inline-block;
            padding: 4px 10px;
            font-size: 11px;
            border-radius: 999px;
            font-weight: 500;
        }

        .status-pending {
            background: #fef3c7;
            color: #92400e;
        }

        .status-confirmed, .status-preparing, .status-shipping {
            background: #dbeafe;
            color: #1d4ed8;
        }

        .status-delivered {
            background: #dcfce7;
            color: #166534;
        }

        .status-cancelled {
            background: #fee2e2;
            color: #b91c1c;
        }
    </style>
</head>
<body>

<jsp:include page="_sidebar.jsp"/>

<div class="admin-content">
    <div class="page-title">Xin chào, Quản trị viên!</div>

    <!-- 4 ô thống kê -->
    <div class="cards-row">
        <!-- Tổng doanh thu -->
        <div class="card">
            <div class="card-title">Tổng doanh thu (tháng này)</div>
            <div class="card-value">
                <fmt:formatNumber value="${stats.monthlyRevenue}" type="currency" currencySymbol="" /> VND
            </div>
            <c:set var="revChange" value="${stats.revenueChangePercent}" />
            <div class="card-sub ${revChange < 0 ? 'down' : ''}">
                <c:if test="${revChange >= 0}">↑</c:if>
                <c:if test="${revChange < 0}">↓</c:if>
                <fmt:formatNumber value="${revChange}" maxFractionDigits="1"/>% so với tháng trước
            </div>
        </div>

        <!-- Đơn hàng mới -->
        <div class="card">
            <div class="card-title">Đơn hàng hôm nay</div>
            <div class="card-value">
                ${stats.todayOrders}
            </div>
            <c:set var="orderChange" value="${stats.orderChangePercent}" />
            <div class="card-sub ${orderChange < 0 ? 'down' : ''}">
                <c:if test="${orderChange >= 0}">↑</c:if>
                <c:if test="${orderChange < 0}">↓</c:if>
                <fmt:formatNumber value="${orderChange}" maxFractionDigits="1"/>% so với hôm qua
            </div>
        </div>

        <!-- Khách hàng -->
        <div class="card">
            <div class="card-title">Khách hàng</div>
            <div class="card-value">
                <fmt:formatNumber value="${stats.totalCustomers}" groupingUsed="true"/>
            </div>
            <c:set var="cusChange" value="${stats.customerChangePercent}" />
            <div class="card-sub ${cusChange < 0 ? 'down' : ''}">
                <c:if test="${cusChange >= 0}">↑</c:if>
                <c:if test="${cusChange < 0}">↓</c:if>
                <fmt:formatNumber value="${cusChange}" maxFractionDigits="1"/>% so với tháng trước
            </div>
        </div>

        <!-- Sản phẩm -->
        <div class="card">
            <div class="card-title">Sản phẩm</div>
            <div class="card-value">
                <fmt:formatNumber value="${stats.totalProducts}" groupingUsed="true"/>
            </div>
            <c:set var="prodChange" value="${stats.productChangePercent}" />
            <div class="card-sub ${prodChange < 0 ? 'down' : ''}">
                <c:if test="${prodChange >= 0}">↑</c:if>
                <c:if test="${prodChange < 0}">↓</c:if>
                <fmt:formatNumber value="${prodChange}" maxFractionDigits="1"/>% so với tuần trước
            </div>
        </div>
    </div>

    <!-- Bảng đơn hàng gần đây -->
    <div class="recent-box">
        <div class="recent-title">Đơn hàng gần đây</div>
        <table>
            <thead>
            <tr>
                <th>Mã đơn</th>
                <th>Khách hàng</th>
                <th>Sản phẩm</th>
                <th class="text-right">Số tiền</th>
                <th>Trạng thái</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="o" items="${stats.recentOrders}">
                <tr>
                    <td>${o.orderCode}</td>
                    <td>${o.customerName}</td>
                    <td>${o.productSummary}</td>
                    <td class="text-right">
                        <fmt:formatNumber value="${o.totalAmount}" type="currency" currencySymbol="" /> VND
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${o.orderStatus == 'pending'}">
                                <span class="status-badge status-pending">Chờ xử lý</span>
                            </c:when>
                            <c:when test="${o.orderStatus == 'confirmed' || o.orderStatus == 'preparing' || o.orderStatus == 'shipping'}">
                                <span class="status-badge status-confirmed">Đang xử lý</span>
                            </c:when>
                            <c:when test="${o.orderStatus == 'delivered'}">
                                <span class="status-badge status-delivered">Đã giao</span>
                            </c:when>
                            <c:when test="${o.orderStatus == 'cancelled'}">
                                <span class="status-badge status-cancelled">Đã hủy</span>
                            </c:when>
                            <c:otherwise>
                                <span class="status-badge">${o.orderStatus}</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                </tr>
            </c:forEach>

            <c:if test="${empty stats.recentOrders}">
                <tr>
                    <td colspan="5">Chưa có đơn hàng nào.</td>
                </tr>
            </c:if>
            </tbody>
        </table>
    </div>

</div>

</body>
</html>

