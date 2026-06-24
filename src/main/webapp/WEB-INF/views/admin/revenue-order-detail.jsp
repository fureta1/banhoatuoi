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
        margin-bottom: 10px;
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

    .info-grid {
        display: grid;
        grid-template-columns: 1.2fr 1fr;
        gap: 15px;
        margin-bottom: 20px;
    }

    .card {
        background: #fff;
        border-radius: 8px;
        border: 1px solid #ddd;
        padding: 15px;
        font-size: 13px;
    }

    .card-title {
        font-size: 14px;
        font-weight: 600;
        color: #444;
        margin-bottom: 10px;
    }

    .info-row {
        margin-bottom: 4px;
    }

    .info-label {
        color: #777;
        min-width: 120px;
        display: inline-block;
    }

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
</style>

<div class="content-wrapper">

    <a href="javascript:history.back();" class="btn btn-back">
        ← Quay lại
    </a>

    <div class="page-title">
        Chi tiết đơn hàng: ${order.orderCode}
    </div>

    <div class="info-grid">
        <!-- Thông tin đơn + khách -->
        <div class="card">
            <div class="card-title">Thông tin đơn hàng</div>

            <div class="info-row">
                <span class="info-label">Mã đơn:</span>
                <span>${order.orderCode}</span>
            </div>
            <div class="info-row">
                <span class="info-label">Ngày tạo:</span>
                <span>
                    <fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                </span>
            </div>
            <div class="info-row">
                <span class="info-label">Trạng thái:</span>
                <span>
                    <c:choose>
                        <c:when test="${order.orderStatus == 'delivered'}">
                            <span class="tag-status tag-delivered">Delivered</span>
                        </c:when>
                        <c:when test="${order.orderStatus == 'cancelled'}">
                            <span class="tag-status tag-cancelled">Cancelled</span>
                        </c:when>
                        <c:otherwise>${order.orderStatus}</c:otherwise>
                    </c:choose>
                </span>
            </div>
            <div class="info-row">
                <span class="info-label">Thanh toán:</span>
                <span>
                    <c:choose>
                        <c:when test="${order.paymentMethod == 'COD'}">Thanh toán khi nhận hàng</c:when>
                        <c:when test="${order.paymentMethod == 'bank_transfer'}">Chuyển khoản</c:when>
                        <c:otherwise>${order.paymentMethod}</c:otherwise>
                    </c:choose>
                    –
                    <c:choose>
                        <c:when test="${order.paymentStatus == 'paid'}">Đã thanh toán</c:when>
                        <c:when test="${order.paymentStatus == 'pending'}">Chưa thanh toán</c:when>
                        <c:when test="${order.paymentStatus == 'failed'}">Thanh toán thất bại</c:when>
                        <c:otherwise>${order.paymentStatus}</c:otherwise>
                    </c:choose>
                </span>
            </div>

            <c:if test="${order.orderStatus == 'cancelled'}">
                <div class="info-row">
                    <span class="info-label">Ngày hủy:</span>
                    <span>
                        <fmt:formatDate value="${order.updatedAt}" pattern="dd/MM/yyyy HH:mm" />
                    </span>
                </div>
                <div class="info-row">
                    <span class="info-label">Lý do hủy:</span>
                    <span><c:out value="${order.cancelledReason}" /></span>
                </div>
            </c:if>
        </div>

        <!-- Thông tin người nhận -->
        <div class="card">
            <div class="card-title">Thông tin khách hàng / người nhận</div>

            <div class="info-row">
                <span class="info-label">Tên khách hàng:</span>
                <!-- Nếu bạn có tên khách trong Order thì dùng order.customerName, 
                     còn không có thì có thể dùng recipientName hoặc tự join User rồi đẩy attribute customerFullName -->
                <span>${order.recipientName}</span>
            </div>
            <div class="info-row">
                <span class="info-label">Mã khách hàng:</span>
                <span>${order.userId}</span>
            </div>
            <div class="info-row">
                <span class="info-label">Số điện thoại:</span>
                <span>${order.phone}</span>
            </div>
            <div class="info-row">
                <span class="info-label">Địa chỉ:</span>
                <span>
                    ${order.addressLine},
                    <c:if test="${not empty order.ward}">${order.ward}, </c:if>
                    ${order.district}, ${order.city}
                </span>
            </div>
        </div>
    </div>

    <!-- Bảng sản phẩm -->
    <div class="card" style="margin-bottom: 20px;">
        <div class="card-title">Sản phẩm trong đơn</div>

        <table>
            <thead>
            <tr>
                <th>#</th>
                <th>Sản phẩm</th>
                <th class="text-right">Đơn giá (â‚«)</th>
                <th class="text-right">Số lượng</th>
                <th class="text-right">Thành tiền (â‚«)</th>
            </tr>
            </thead>
            <tbody>
            <c:if test="${empty items}">
                <tr>
                    <td colspan="5" class="text-right">Không có sản phẩm.</td>
                </tr>
            </c:if>
            <c:forEach var="it" items="${items}" varStatus="st">
                <tr>
                    <td>${st.index + 1}</td>
                    <td>${it.productName}</td>
                    <td class="text-right">
                        <fmt:formatNumber value="${it.price}" type="number"
                                          minFractionDigits="0" maxFractionDigits="0" />
                    </td>
                    <td class="text-right">${it.quantity}</td>
                    <td class="text-right">
                        <fmt:formatNumber value="${it.subtotal}" type="number"
                                          minFractionDigits="0" maxFractionDigits="0" />
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>

    <!-- Tổng tiền -->
    <div class="card" style="max-width: 350px; margin-left: auto;">
        <div class="info-row">
            <span class="info-label">Tạm tính:</span>
            <span class="text-right">
                <fmt:formatNumber value="${order.subtotal}" type="number"
                                  minFractionDigits="0" maxFractionDigits="0" /> â‚«
            </span>
        </div>
        <div class="info-row">
            <span class="info-label">Phí vận chuyển:</span>
            <span class="text-right">
                <fmt:formatNumber value="${order.shippingFee}" type="number"
                                  minFractionDigits="0" maxFractionDigits="0" /> â‚«
            </span>
        </div>
        <div class="info-row">
            <span class="info-label">Giảm giá:</span>
            <span class="text-right">
                <fmt:formatNumber value="${order.discountAmount}" type="number"
                                  minFractionDigits="0" maxFractionDigits="0" /> â‚«
            </span>
        </div>
        <hr/>
        <div class="info-row">
            <span class="info-label"><b>Tổng thanh toán:</b></span>
            <span class="text-right">
                <b>
                    <fmt:formatNumber value="${order.totalAmount}" type="number"
                                      minFractionDigits="0" maxFractionDigits="0" /> â‚«
                </b>
            </span>
        </div>
    </div>
</div>


