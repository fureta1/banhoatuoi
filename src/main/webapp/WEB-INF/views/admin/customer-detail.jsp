<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/WEB-INF/views/admin/_sidebar.jsp"/>

<style>
    /* ===== LAYOUT CONTENT ===== */
    .content-wrapper {
        margin-left: 260px; /* trừ phần sidebar */
        padding: 25px;
        font-family: "Segoe UI", sans-serif;
        background: #f5f7fa;
        min-height: 100vh;
    }

    /* ===== PAGE TITLE ===== */
    .page-title {
        font-size: 26px;
        font-weight: 700;
        color: #333;
        margin-bottom: 20px;
    }

    /* ===== CARD ===== */
    .card {
        background: #fff;
        padding: 18px 22px;
        border-radius: 12px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.06);
        margin-bottom: 25px;
    }

    .card h3 {
        margin-top: 0;
        font-size: 20px;
        border-left: 4px solid #4A90E2;
        padding-left: 10px;
        color: #333;
        margin-bottom: 15px;
    }

    .info-list li {
        list-style: none;
        padding: 6px 0;
        font-size: 15px;
        color: #444;
    }

    /* ===== TABLE ===== */
    table.custom-table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 10px;
        font-size: 15px;
    }

    table.custom-table th {
        background: #4A90E2;
        color: white;
        padding: 10px;
        text-align: left;
        font-weight: 600;
    }

    table.custom-table td {
        padding: 10px;
        background: white;
        border-bottom: 1px solid #e5e5e5;
        color: #333;
    }

    table.custom-table tr:hover td {
        background: #f0f7ff;
    }

    /* DEFAULT BADGE */
    .badge-default {
        background: #28a745;
        color: white;
        padding: 4px 8px;
        border-radius: 6px;
        font-size: 12px;
        font-weight: bold;
    }

    .badge-none {
        color: #aaa;
    }
</style>

<div class="content-wrapper">

    <div class="page-title">Chi tiết khách hàng</div>

    <!-- ==== THÔNG TIN CÁ NHN ==== -->
    <div class="card">
        <h3>Thông tin cá nhân</h3>
        <ul class="info-list">
            <li><strong>ID: </strong> ${customer.id}</li>
            <li><strong>Email: </strong> ${customer.email}</li>
            <li><strong>Họ tên: </strong> ${customer.fullName}</li>
            <li><strong>Số điện thoại: </strong> ${customer.phone}</li>
            <li><strong>Trạng thái: </strong> ${customer.status}</li>
        </ul>
    </div>

    <!-- ==== DANH SÁCH ĐỊA CHỈ ==== -->
    <div class="card">
        <h3>Địa chỉ giao hàng</h3>

        <table class="custom-table">
            <tr>
                <th>Người nhận</th>
                <th>Số điện thoại</th>
                <th>Địa chỉ</th>
                <th>Mặc định</th>
            </tr>

            <c:forEach var="a" items="${addresses}">
                <tr>
                    <td>${a.recipientName}</td>
                    <td>${a.phone}</td>
                    <td>${a.addressLine}, ${a.ward}, ${a.district}, ${a.city}</td>
                    <td>
                    <c:choose>
                    <c:when test="${a.defaultAddress}">
                        <span class="badge-default">Mặc định</span>
                        </c:when>
                        <c:otherwise>
                        <span class="badge-none">-</span>
                    </c:otherwise>
                    </c:choose>
                    </td>
                </tr>
            </c:forEach>
        </table>
    </div>

    <!-- ==== LỊCH SỬ ĐƠN HÀNG ==== -->
    <div class="card">
        <h3>Lịch sử đơn hàng</h3>

        <table class="custom-table">
            <tr>
                <th>Mã đơn</th>
                <th>Ngày đặt</th>
                <th>Thành tiền</th>
                <th>Trạng thái</th>
            </tr>

            <c:forEach var="o" items="${orders}">
                <tr>
                    <td>${o.orderCode}</td>
                    <td>${o.createdAt}</td>
                    <td>${o.totalAmount}</td>
                    <td>${o.orderStatus}</td>
                </tr>
            </c:forEach>
        </table>
    </div>

</div>

