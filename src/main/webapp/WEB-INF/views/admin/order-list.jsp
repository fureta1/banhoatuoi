<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý đơn hàng</title>
    <style>
        body {
            margin: 0;
            background: #f5f7fa;
            font-family: "Segoe UI", Arial, sans-serif;
        }

        /* Dịch nội dung chính sang phải, cách sidebar 60px */
        .content {
            margin-left: 320px;        /* khoảng cách cố định với sidebar */
             /* trên - phải - dưới - trái */
            min-height: 100vh;
        }

        h1 {
            font-size: 24px;
            margin: 0 0 15px 0;
            color: #003366;
        }

        .message-success {
            padding: 8px 12px;
            background: #e6ffed;
            border: 1px solid #a5d6a7;
            color: #256029;
            border-radius: 6px;
            margin-bottom: 15px;
            display: inline-block;
        }

        .filter-card {
            background: #ffffff;
            padding: 10px 15px;
            border-radius: 8px;
            box-shadow: 0 1px 4px rgba(0,0,0,0.06);
            margin-bottom: 15px;
            font-size: 14px;
        }

        .filter-row {
            display: flex;
            flex-wrap: wrap;
            gap: 10px 15px;
            align-items: center;
        }

        .filter-row label {
            font-weight: 600;
            color: #374151;
        }

        select, input[type="text"] {
            padding: 6px 8px;
            border-radius: 6px;
            border: 1px solid #d1d5db;
            font-size: 14px;
            outline: none;
        }

        select:focus, input[type="text"]:focus {
            border-color: #4A90E2;
            box-shadow: 0 0 0 1px rgba(74,144,226,0.25);
        }

        button {
            padding: 7px 14px;
            background: #4A90E2;
            border: none;
            color: #ffffff;
            border-radius: 6px;
            cursor: pointer;
            font-size: 14px;
            transition: background 0.2s ease, transform 0.1s ease;
        }

        button:hover {
            background: #357ABD;
            transform: translateY(-1px);
        }

        .table-wrapper {
            margin-top: 10px;
        }

        .table {
            width: 100%;
            border-collapse: collapse;
            background: #ffffff;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 6px rgba(0,0,0,0.08);
            font-size: 13px;
        }

        th, td {
            padding: 8px 10px;
            border-bottom: 1px solid #eeeeee;
            text-align: left;
            vertical-align: middle;
        }

        th {
            background: #e6f2ff;
            color: #003366;
            font-weight: 600;
            white-space: nowrap;
        }

        tr:hover td {
            background: #f9fbff;
        }

        .text-center {
            text-align: center;
        }

        .badge-status {
            display: inline-block;
            padding: 2px 8px;
            border-radius: 999px;
            font-size: 11px;
            font-weight: 600;
            color: #ffffff;
            white-space: nowrap;
        }

        .status-pending { background: #f0ad4e; }
        .status-confirmed { background: #5bc0de; }
        .status-preparing { background: #5bc0de; }
        .status-shipping { background: #0275d8; }
        .status-delivered { background: #5cb85c; }
        .status-cancelled { background: #d9534f; }

        .badge-payment {
            display: inline-block;
            padding: 2px 8px;
            border-radius: 999px;
            font-size: 11px;
            font-weight: 600;
            white-space: nowrap;
        }

        .pay-pending { background: #fff3cd; color: #856404; }
        .pay-paid { background: #d4edda; color: #155724; }
        .pay-failed { background: #f8d7da; color: #721c24; }

        .link-detail {
            text-decoration: none;
            color: #2563eb;
            font-weight: 600;
        }

        .link-detail:hover {
            text-decoration: underline;
        }

        .no-data {
            text-align: center;
            padding: 15px;
            color: #6b7280;
        }

        /* Nếu sidebar của bạn có width cố định (ví dụ 250px), bạn có thể dùng giá trị lớn hơn */
        /* Ví dụ: margin-left: 250px; hoặc padding-left: 270px; tùy thiết kế sidebar */
    </style>
</head>
<body>

    <!-- SIDEBAR CHUNG -->
    <jsp:include page="_sidebar.jsp">
        <jsp:param name="activePage" value="orders"/>
    </jsp:include>

    <!-- NỘI DUNG CHÍNH - đã được dịch phải và cách sidebar 60px -->
    <div class="content">
        <h1>Quản lý đơn hàng</h1>

        <c:if test="${not empty msg}">
            <div class="message-success">${msg}</div>
        </c:if>

        <!-- BỘ LỌC TÌM KIẾM -->
        <div class="filter-card">
            <form method="get" action="${pageContext.request.contextPath}/admin/orders">
                <div class="filter-row">
                    <div>
                        <label>Trạng thái:&nbsp;</label>
                        <select name="status">
                            <option value="">Tất cả</option>
                            <option value="pending" ${status == 'pending' ? 'selected' : ''}>Chờ xác nhận</option>
                            <option value="confirmed" ${status == 'confirmed' ? 'selected' : ''}>Đã xác nhận</option>
                            <option value="preparing" ${status == 'preparing' ? 'selected' : ''}>Đang chuẩn bị</option>
                            <option value="shipping" ${status == 'shipping' ? 'selected' : ''}>Đang giao</option>
                            <option value="delivered" ${status == 'delivered' ? 'selected' : ''}>Đã giao</option>
                            <option value="cancelled" ${status == 'cancelled' ? 'selected' : ''}>Đã hủy</option>
                        </select>
                    </div>
                    <div>
                        <label>Tìm kiếm:&nbsp;</label>
                        <input type="text" name="keyword"
                               placeholder="Mã đơn, tên KH, email..."
                               value="${keyword != null ? keyword : ''}">
                    </div>
                    <div>
                        <button type="submit">Lọc</button>
                    </div>
                </div>
            </form>
        </div>

        <!-- BẢNG ĐƠN HÀNG -->
        <div class="table-wrapper">
            <table class="table">
                <thead>
                <tr>
                    <th>Mã đơn</th>
                    <th>Khách hàng</th>
                    <th>SĐT KH</th>
                    <th>Người nhận</th>
                    <th>SĐT nhận</th>
                    <th>Khu vực giao</th>
                    <th>Tổng thanh toán</th>
                    <th>Thanh toán</th>
                    <th>Trạng thái</th>
                    <th class="text-center">Chi tiết</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${orders}" var="o">
                    <tr>
                        <td>${o.orderCode}</td>
                        <td>${o.customerName}</td>
                        <td>${o.customerPhone}</td>
                        <td>${o.recipientName}</td>
                        <td>${o.phone}</td>
                        <td>${o.addressLine}</td>
                        <td>${o.totalAmount}</td>
                        <td>
                            <c:choose>
                                <c:when test="${o.paymentStatus == 'paid'}">
                                    <span class="badge-payment pay-paid">Đã thanh toán</span>
                                </c:when>
                                <c:when test="${o.paymentStatus == 'failed'}">
                                    <span class="badge-payment pay-failed">Lỗi thanh toán</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge-payment pay-pending">Chưa thanh toán</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <span class="badge-status status-${o.orderStatus}">
                                <c:choose>
                                    <c:when test="${o.orderStatus == 'pending'}">Chờ xác nhận</c:when>
                                    <c:when test="${o.orderStatus == 'confirmed'}">Đã xác nhận</c:when>
                                    <c:when test="${o.orderStatus == 'preparing'}">Đang chuẩn bị</c:when>
                                    <c:when test="${o.orderStatus == 'shipping'}">Đang giao</c:when>
                                    <c:when test="${o.orderStatus == 'delivered'}">Đã giao</c:when>
                                    <c:when test="${o.orderStatus == 'cancelled'}">Đã hủy</c:when>
                                    <c:otherwise>${o.orderStatus}</c:otherwise>
                                </c:choose>
                            </span>
                        </td>
                        
                        <td class="text-center">
                            <a class="link-detail"
                               href="${pageContext.request.contextPath}/admin/orders/${o.orderId}">
                                Xem
                            </a>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty orders}">
                    <tr>
                        <td colspan="10" class="no-data">
                            Chưa có đơn hàng phù hợp với bộ lọc.
                        </td>
                    </tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>
