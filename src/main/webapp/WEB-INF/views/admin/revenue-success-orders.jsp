<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="activePage" value="revenue" />
<%@ include file="_sidebar.jsp" %>

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
        font-size: 20px;
        font-weight: bold;
        color: #333;
        margin-bottom: 8px;
    }

    .page-subtitle {
        font-size: 13px;
        color: #777;
        margin-bottom: 15px;
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

    .btn-small {
        padding: 4px 8px;
        font-size: 12px;
        border-radius: 4px;
        text-decoration: none;
        cursor: pointer;
    }

    .btn-info {
        background: #00a8ff;
        color: #fff;
        border: none;
    }

    .btn-info:hover {
        background: #0080c3;
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

    .tag-status {
        font-size: 11px;
        padding: 2px 6px;
        border-radius: 10px;
        display: inline-block;
    }

    .tag-delivered {
        background: #e1f7e2;
        color: #27ae60;
    }

    .tag-cancelled {
        background: #fdeaea;
        color: #c0392b;
    }
</style>

<div class="content-wrapper">

    <a href="${pageContext.request.contextPath}/admin/revenue?fromDate=${fromDate}&toDate=${toDate}"
       class="btn btn-back">
        ← Quay lại thống kê doanh thu
    </a>

    <div class="page-title">
        Danh sách đơn hàng ngày ${date}
    </div>

    <div class="page-subtitle">
        Trạng thái:
        <c:choose>
            <c:when test="${status == 'delivered'}">Đơn thành công</c:when>
            <c:when test="${status == 'cancelled'}">Đơn bị hủy</c:when>
            <c:otherwise>${status}</c:otherwise>
        </c:choose>
    </div>

    <table>
        <thead>
        <tr>
            <th>Mã đơn</th>
            <th>Khách hàng / Người nhận</th>
            <th>SĐT</th>
            <th class="text-right">Tổng tiền (₫)</th>
            <th>Thanh toán</th>
            <th>Trạng thái</th>
            <th class="text-center">Chi tiết</th>
        </tr>
        </thead>
        <tbody>
        <c:if test="${empty orders}">
            <tr>
                <td colspan="7" class="text-center">
                    Không có đơn hàng nào.
                </td>
            </tr>
        </c:if>
        <c:forEach var="o" items="${orders}">
            <tr>
                <td>${o.orderCode}</td>
                <td>${o.recipientName}</td>
                <td>${o.phone}</td>
                <td class="text-right">
                    <fmt:formatNumber value="${o.totalAmount}" type="number"
                                      minFractionDigits="0" maxFractionDigits="0" />
                </td>
                <td>
                    <c:choose>
                        <c:when test="${o.paymentMethod == 'COD'}">Thanh toán khi nhận hàng</c:when>
                        <c:when test="${o.paymentMethod == 'bank_transfer'}">Chuyển khoản</c:when>
                        <c:otherwise>${o.paymentMethod}</c:otherwise>
                    </c:choose>
                    –
                    <c:choose>
                        <c:when test="${o.paymentStatus == 'paid'}">Đã thanh toán</c:when>
                        <c:when test="${o.paymentStatus == 'pending'}">Chưa thanh toán</c:when>
                        <c:when test="${o.paymentStatus == 'failed'}">Thanh toán thất bại</c:when>
                        <c:otherwise>${o.paymentStatus}</c:otherwise>
                    </c:choose>
                </td>
                <td>
                    <c:choose>
                        <c:when test="${o.orderStatus == 'delivered'}">
                            <span class="tag-status tag-delivered">Delivered</span>
                        </c:when>
                        <c:when test="${o.orderStatus == 'cancelled'}">
                            <span class="tag-status tag-cancelled">Cancelled</span>
                        </c:when>
                        <c:otherwise>${o.orderStatus}</c:otherwise>
                    </c:choose>
                </td>
                <td class="text-center">
                   <a class="btn-small btn-info"
   href="${pageContext.request.contextPath}/admin/revenue/order-detail?orderId=${o.orderId}&fromDate=${fromDate}&toDate=${toDate}">
    Xem chi tiết
</a>


                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>

</div>
