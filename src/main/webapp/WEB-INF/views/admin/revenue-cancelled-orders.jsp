<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="activePage" value="revenue" />
<%@ include file="_sidebar.jsp" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đơn bị hủy ngày ${date}</title>
    <style>
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #f5f5f5;
        }

        .content-wrapper {
            margin-left: 280px;
            padding: 20px;
            min-height: 100vh;
            box-sizing: border-box;
        }

        .page-title {
            font-size: 22px;
            font-weight: bold;
            margin-bottom: 4px;
            color: #333;
        }

        .page-subtitle {
            font-size: 13px;
            color: #777;
            margin-bottom: 18px;
        }

        .btn {
            display: inline-block;
            padding: 6px 12px;
            font-size: 13px;
            border-radius: 4px;
            border: none;
            cursor: pointer;
            text-decoration: none;
        }

        .btn-back {
            background: #fff;
            border: 1px solid #ccc;
            color: #333;
            margin-bottom: 15px;
        }

        .btn-back:hover {
            background: #eee;
        }

        .btn-primary {
            background: #4A90E2;
            color: #fff;
        }

        .btn-primary:hover {
            background: #357ABD;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            background: #fff;
            border-radius: 8px;
            overflow: hidden;
            font-size: 13px;
        }

        th, td {
            padding: 8px 10px;
            border: 1px solid #e3e3e3;
            text-align: left;
        }

        th {
            background: #f3f6fb;
            color: #555;
            font-weight: 600;
        }

        tr:nth-child(even) {
            background: #fafafa;
        }

        .text-right { text-align: right; }
        .text-center { text-align: center; }

        .reason {
            max-width: 280px;
            white-space: pre-wrap;
            word-wrap: break-word;
        }
    </style>
</head>
<body>

<div class="content-wrapper">

    <a href="${pageContext.request.contextPath}/admin/revenue?fromDate=${fromDate}&toDate=${toDate}"
       class="btn btn-back">
        ← Quay lại thống kê doanh thu
    </a>

    <div class="page-title">
        Danh sách đơn bị hủy ngày ${date}
    </div>

    <div class="page-subtitle">
        Trạng thái: Đơn bị hủy
    </div>

    <table>
        <thead>
        <tr>
            <th>#</th>
            <th>Thời gian hủy</th>
            <th>Mã đơn</th>
            <th>Mã KH</th>
            <th>Khách hàng / Người nhận</th>
            <th>SĐT</th>
            <th>Địa chỉ</th>
            <th class="text-right">Tổng tiền (â‚«)</th>
            <th>Lý do hủy</th>
            <th class="text-center">Hành động</th>
        </tr>
        </thead>
        <tbody>
        <c:if test="${empty cancelledOrders}">
            <tr>
                <td colspan="10" class="text-center">
                    Không có đơn bị hủy trong ngày này.
                </td>
            </tr>
        </c:if>
        <c:forEach var="o" items="${cancelledOrders}" varStatus="st">
            <tr>
                <td>${st.index + 1}</td>
                <td>
                    <fmt:formatDate value="${o.updatedAt}" pattern="dd/MM/yyyy HH:mm" />
                </td>
                <td>${o.orderCode}</td>
                <td>${o.userId}</td>
                <td>${o.customerName}</td>
                <td>${o.phone}</td>
                <td>
                    <c:out value="${o.addressLine}"/>
                    <c:if test="${not empty o.ward}">, <c:out value="${o.ward}"/></c:if>
                    , <c:out value="${o.district}"/>, <c:out value="${o.city}"/>
                </td>
                <td class="text-right">
                    <fmt:formatNumber value="${o.totalAmount}" type="number"
                                      minFractionDigits="0" maxFractionDigits="0"/>
                </td>
                <td>
                    <div class="reason">
                        <c:out value="${o.cancelledReason}"/>
                    </div>
                </td>
                <td class="text-center">
                    <a class="btn btn-primary"
                       href="${pageContext.request.contextPath}/admin/revenue/order-detail?orderId=${o.orderId}&fromDate=${fromDate}&toDate=${toDate}">
                        Xem chi tiết
                    </a>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>

</div>

</body>
</html>

