<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tài khoản của tôi - FlowerShop</title>

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #fdfbfb 0%, #f8f3f0 100%);
            color: #333;
        }

        /* Top Bar */
        .top-bar {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 15px 0;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .top-bar-content {
            max-width: 1400px;
            margin: 0 auto;
            padding: 0 30px;
            display: flex;
            align-items: center;
            gap: 40px;
        }

        .logo {
            font-size: 28px;
            font-weight: 700;
            color: #fff;
            display: flex;
            align-items: center;
            gap: 10px;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.2);
        }

        .logo i {
            font-size: 32px;
        }

        .search-box {
            flex: 1;
            display: flex;
            background: white;
            border-radius: 50px;
            overflow: hidden;
            box-shadow: 0 4px 15px rgba(0,0,0,0.15);
        }

        .search-box input[type="text"] {
            flex: 1;
            padding: 14px 24px;
            border: none;
            font-size: 15px;
            outline: none;
        }

        .search-box input[type="text"]::placeholder {
            color: #999;
        }

        .search-box select {
            padding: 14px 20px;
            border: none;
            border-left: 1px solid #eee;
            background: white;
            cursor: pointer;
            outline: none;
            font-size: 14px;
        }

        .search-box button {
            padding: 14px 32px;
            border: none;
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            color: white;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
        }

        .search-box button:hover {
            background: linear-gradient(135deg, #f5576c 0%, #f093fb 100%);
        }

        .top-actions {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .logout-btn {
            padding: 10px 20px;
            border-radius: 25px;
            background: rgba(255,255,255,0.12);
            color: #fff;
            font-size: 14px;
            font-weight: 600;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 8px;
            border: 2px solid rgba(255,255,255,0.8);
            backdrop-filter: blur(4px);
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
            transition: all 0.3s;
        }

        .logout-btn i {
            font-size: 14px;
        }

        .logout-btn:hover {
            background: #fff;
            color: #764ba2;
        }

        /* Mega Menu */
        .mega-menu {
            background: white;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            position: sticky;
            top: 0;
            z-index: 100;
        }

        .mega-menu-content {
            max-width: 1400px;
            margin: 0 auto;
            padding: 0 30px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .mega-menu-left ul,
        .mega-menu-right ul {
            list-style: none;
            display: flex;
            gap: 0;
            justify-content: center;
        }

        .mega-menu-left li,
        .mega-menu-right li {
            position: relative;
        }

        .mega-menu a {
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 18px 24px;
            color: #333;
            text-decoration: none;
            font-weight: 600;
            font-size: 14px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            transition: all 0.3s;
            position: relative;
        }

        .mega-menu a::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 50%;
            width: 0;
            height: 3px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            transition: all 0.3s;
            transform: translateX(-50%);
        }

        .mega-menu a:hover {
            color: #667eea;
        }

        .mega-menu a:hover::after {
            width: 80%;
        }

        .mega-menu i {
            font-size: 16px;
        }

        .mega-menu a.active {
            color: #667eea;
            font-weight: 800;
        }

        .mega-menu-left a.active::after {
            width: 80%;
        }

        .mega-menu-right a {
            text-transform: none;
            font-size: 13px;
            padding: 12px 18px;
            border-radius: 999px;
            border: 1px solid #e2e8f0;
            margin-left: 8px;
        }

        .mega-menu-right a::after {
            display: none;
        }

        .mega-menu-right a:hover,
        .mega-menu-right a.active {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: #fff;
            border-color: transparent;
        }

        .cart-icon-wrapper {
            position: relative;
        }

        .cart-badge {
            position: absolute;
            top: 8px;
            right: 10px;
            min-width: 18px;
            height: 18px;
            padding: 0 5px;
            border-radius: 999px;
            background: #f5576c;
            color: #fff;
            font-size: 11px;
            font-weight: 700;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .mega-divider {
            width: 1px;
            height: 32px;
            background: #e2e8f0;
            margin: 0 12px;
        }

        /* Main Wrapper */
        .main-wrapper {
            max-width: 1400px;
            margin: 0 auto;
            padding: 40px 30px;
        }

        h1.page-title {
            font-size: 26px;
            margin-bottom: 8px;
        }

        .breadcrumb {
            font-size: 13px;
            color: #718096;
            margin-bottom: 20px;
        }

        .breadcrumb a {
            color: #667eea;
            text-decoration: none;
        }

        .back-link {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            font-size: 13px;
            color: #4a5568;
            text-decoration: none;
            margin-bottom: 10px;
        }

        .back-link i {
            font-size: 12px;
        }

        .back-link:hover {
            color: #2d3748;
        }

        .message {
            padding: 10px 12px;
            border-radius: 10px;
            font-size: 13px;
            margin-bottom: 12px;
        }
        .message.success {
            background: #e8f5e9;
            color: #2e7d32;
        }
        .message.error {
            background: #ffebee;
            color: #c62828;
        }

        /* ACCOUNT LAYOUT */
        .account-layout {
            display: grid;
            grid-template-columns: 280px 1fr;
            gap: 24px;
        }

        .account-card {
            background: #fff;
            border-radius: 20px;
            padding: 22px 24px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.08);
        }

        /* Sidebar */
        .account-sidebar {
            background: #fff;
            border-radius: 20px;
            padding: 22px 24px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.08);
        }

        .account-avatar {
            text-align: center;
            margin-bottom: 18px;
        }

        .account-avatar .circle {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            background: #ffe4ec;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 32px;
            color: #e91e63;
            margin: 0 auto 10px;
        }

        .account-name {
            font-weight: 600;
            margin-bottom: 4px;
        }

        .account-email {
            font-size: 13px;
            color: #888;
        }

        .account-phone {
            font-size: 13px;
            color: #888;
            margin-top: 4px;
        }

        .account-menu {
            margin-top: 18px;
            border-top: 1px solid #f0f0f0;
            padding-top: 15px;
        }

        .account-menu button {
            width: 100%;
            background: none;
            border: none;
            text-align: left;
            padding: 10px 8px;
            border-radius: 10px;
            cursor: pointer;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 8px;
            color: #555;
        }

        .account-menu button i {
            width: 18px;
        }

        .account-menu button.active,
        .account-menu button:hover {
            background: #ffe4ec;
            color: #e91e63;
        }

        /* Content */
        .section-title {
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 16px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .section-title i {
            color: #e91e63;
        }

        .form-group {
            margin-bottom: 12px;
        }

        .form-group label {
            display: block;
            margin-bottom: 4px;
            font-size: 13px;
            font-weight: 600;
        }

        .form-group input {
            width: 100%;
            padding: 8px 10px;
            border-radius: 8px;
            border: 1px solid #cbd5e0;
            font-size: 13px;
            outline: none;
        }

        .form-group input:focus {
            border-color: #e91e63;
            box-shadow: 0 0 0 2px rgba(233,30,99,0.15);
        }

        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
            border-radius: 999px;
            padding: 9px 18px;
            border: none;
            cursor: pointer;
            font-size: 14px;
            font-weight: 600;
        }

        .btn-primary {
            background: linear-gradient(135deg, #ff6a88 0%, #ff99ac 100%);
            color: #fff;
        }

        .btn-primary:hover {
            opacity: 0.9;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            font-size: 13px;
        }

        th, td {
            padding: 8px 10px;
            border-bottom: 1px solid #edf2f7;
            text-align: left;
            vertical-align: middle;
        }

        th {
            background: #f7fafc;
            font-weight: 600;
        }

        .badge {
            display: inline-block;
            padding: 3px 8px;
            border-radius: 999px;
            font-size: 11px;
        }
        .badge.status-pending    { background: #fff3cd; color: #856404; }
        .badge.status-confirmed  { background: #d1ecf1; color: #0c5460; }
        .badge.status-preparing  { background: #e2e3ff; color: #383d7c; }
        .badge.status-shipping   { background: #cce5ff; color: #004085; }
        .badge.status-delivered  { background: #d4edda; color: #155724; }
        .badge.status-cancelled  { background: #f8d7da; color: #721c24; }

        .text-muted {
            color: #718096;
            font-size: 13px;
        }

        /* Footer */
        .footer {
            background: linear-gradient(135deg, #2d3748 0%, #1a202c 100%);
            color: white;
            padding: 50px 0 30px;
            margin-top: 60px;
        }

        .footer-content {
            max-width: 1400px;
            margin: 0 auto;
            padding: 0 30px;
        }

        .footer h3 {
            font-size: 24px;
            margin-bottom: 20px;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .footer h3 i {
            color: #667eea;
        }

        .footer p {
            line-height: 1.8;
            color: #cbd5e0;
            margin-bottom: 25px;
            font-size: 15px;
        }

        .contact-line {
            display: flex;
            gap: 30px;
            font-size: 16px;
            padding: 25px;
            background: rgba(255,255,255,0.05);
            border-radius: 12px;
            border-left: 4px solid #667eea;
        }

        .contact-item {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .contact-item i {
            color: #667eea;
            font-size: 18px;
        }

        .contact-item strong {
            color: #667eea;
            margin-right: 8px;
        }

        @media (max-width: 992px) {
            .account-layout {
                grid-template-columns: 1fr;
            }
            .mega-menu-content {
                flex-wrap: wrap;
                justify-content: center;
            }
            .mega-divider {
                display: none;
            }
        }

        @media (max-width: 768px) {
            .top-bar-content {
                max-width: 1400px;
                margin: 0 auto;
                padding: 0 15px;
                display: flex;
                align-items: center;
                gap: 20px;
                flex-wrap: wrap;
            }

            .account-layout {
                gap: 18px;
            }

            .contact-line {
                flex-direction: column;
                gap: 15px;
            }

            .mega-menu-content {
                padding: 0 15px;
            }

            .mega-menu a {
                padding: 12px 14px;
                font-size: 13px;
            }

            .mega-menu-right a {
                padding: 10px 14px;
                margin-left: 4px;
            }
        }
    </style>
</head>

<body>

<!-- TOP BAR -->
<div class="top-bar">
    <div class="top-bar-content">
        <div class="logo">
            <i class="fas fa-spa"></i>
            FlowerShop
        </div>

        <form class="search-box" action="${ctx}/search" method="get">
            <input type="text" name="keyword"
                   placeholder="Tìm kiếm hoa tươi đẹp cho mọi dịp..."
                   value="${keyword != null ? keyword : ''}">
            <select name="categoryId">
                <option value="">Tất cả danh mục</option>
                <c:forEach var="cat" items="${allCategories}">
                    <option value="${cat.id}"
                        <c:if test="${categoryId != null && categoryId == cat.id}">selected</c:if>>
                        ${cat.name}
                    </option>
                </c:forEach>
            </select>
            <button type="submit">
                <i class="fas fa-search"></i> Tìm kiếm
            </button>
        </form>

        <div class="top-actions">
            <a href="${ctx}/auth/logout" class="logout-btn">
                <i class="fas fa-right-from-bracket"></i>
                Đăng xuất
            </a>
        </div>
    </div>
</div>

<!-- MEGA MENU -->
<jsp:include page="_mega-menu.jsp" />

<!-- MAIN CONTENT -->
<div class="main-wrapper">

    <!-- Nút quay lại trang chủ -->
    <a href="${ctx}/home/index" class="back-link">
        <i class="fas fa-arrow-left"></i> Quay lại trang chủ
    </a>

    <h1 class="page-title">Tài khoản của tôi</h1>

    <div class="breadcrumb">
        <a href="${ctx}/home/index">Trang chủ</a> &nbsp;/&nbsp;
        <span>Tài khoản</span>
    </div>

    <!-- Thông báo -->
    <c:if test="${not empty successMessage}">
        <div class="message success">${successMessage}</div>
    </c:if>
    <c:if test="${not empty errorMessage}">
        <div class="message error">${errorMessage}</div>
    </c:if>

    <!-- ACCOUNT LAYOUT -->
    <div class="account-layout">

        <!-- Sidebar -->
        <aside class="account-sidebar">
            <div class="account-avatar">
                <div class="circle">
                    <c:choose>
                        <c:when test="${not empty user && not empty user.fullName}">
                            <c:out value="${fn:substring(user.fullName,0,1)}" />
                        </c:when>
                        <c:otherwise>
                            <i class="fa-solid fa-user"></i>
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="account-name">${user.fullName}</div>
                <div class="account-email">${user.email}</div>
                <c:if test="${not empty user.phone}">
                    <div class="account-phone">
                        <i class="fa-solid fa-phone"></i> ${user.phone}
                    </div>
                </c:if>
            </div>

            <div class="account-menu">
                <button type="button" class="tab-btn active" data-target="#tab-profile">
                    <i class="fa-solid fa-user-pen"></i> Hồ sơ cá nhân
                </button>
                <button type="button" class="tab-btn" data-target="#tab-password">
                    <i class="fa-solid fa-key"></i> Đổi mật khẩu
                </button>
                <button type="button" class="tab-btn" data-target="#tab-orders">
                    <i class="fa-solid fa-receipt"></i> Lịch sử đơn hàng
                </button>
            </div>
        </aside>

        <!-- Content -->
        <section class="account-card">

            <!-- Hồ sơ -->
            <div id="tab-profile" class="tab-panel">
                <h2 class="section-title"><i class="fa-solid fa-user-pen"></i> Hồ sơ cá nhân</h2>

                <form action="${ctx}/account/update-profile" method="post">
                    <div class="form-group">
                        <label>Họ và tên</label>
                        <input type="text" name="fullName" value="${user.fullName}" required>
                    </div>
                    <div class="form-group">
                        <label>Số điện thoại</label>
                        <input type="text" name="phone" value="${user.phone}">
                    </div>
                    <div class="form-group">
                        <label>Email</label>
                        <input type="email" name="email" value="${user.email}" required>
                    </div>
                    <button class="btn btn-primary" type="submit">
                        <i class="fa-solid fa-floppy-disk"></i> Lưu thay đổi
                    </button>
                </form>
            </div>

            <!-- Đổi mật khẩu -->
            <div id="tab-password" class="tab-panel" style="display:none;">
                <h2 class="section-title"><i class="fa-solid fa-key"></i> Đổi mật khẩu</h2>

                <form action="${ctx}/account/change-password" method="post">
                    <div class="form-group">
                        <label>Mật khẩu hiện tại</label>
                        <input type="password" name="oldPassword" required>
                    </div>
                    <div class="form-group">
                        <label>Mật khẩu mới</label>
                        <input type="password" name="newPassword" required>
                    </div>
                    <div class="form-group">
                        <label>Nhập lại mật khẩu mới</label>
                        <input type="password" name="confirmPassword" required>
                    </div>
                    <button class="btn btn-primary" type="submit">
                        <i class="fa-solid fa-key"></i> Đổi mật khẩu
                    </button>
                </form>
            </div>

            <!-- Lịch sử đơn hàng -->
            <div id="tab-orders" class="tab-panel" style="display:none;">
                <h2 class="section-title"><i class="fa-solid fa-receipt"></i> Lịch sử đơn hàng</h2>

                <c:if test="${empty orders}">
                    <p class="text-muted">Bạn chưa có đơn hàng nào.</p>
                </c:if>

                <c:if test="${not empty orders}">
                    <table>
                        <thead>
                        <tr>
                            <th>Mã đơn</th>
                            <th>Ngày đặt</th>
                            <th>Tổng tiền</th>
                            <th>Trạng thái đơn</th>
                            <th>Thanh toán</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="o" items="${orders}">
                            <tr>
                                <td>#${o.orderCode}</td>
                                <td>
                                    <fmt:formatDate value="${o.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                                </td>
                                <td>
                                    <fmt:formatNumber value="${o.totalAmount}" type="number"
                                                      groupingUsed="true"
                                                      maxFractionDigits="0" /> VND
                                </td>
                                <td>
                                    <span class="badge status-${o.orderStatus}">
                                        ${o.orderStatus}
                                    </span>
                                </td>
                                <td>
                                    <span class="badge">
                                        ${o.paymentStatus}
                                    </span>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </c:if>
            </div>

        </section>
    </div>
</div>

<!-- FOOTER -->
<div class="footer">
    <div class="footer-content">
        <h3><i class="fas fa-spa"></i> Shop Hoa Tươi FlowerShop</h3>
        <p>
            FlowerShop là cửa hàng hoa tươi chuyên cung cấp các mẫu hoa sinh nhật, hoa cưới,
            hoa khai trương và thiết kế theo yêu cầu, giao nhanh trong ngày tại khu vực của bạn.
        </p>
        <div class="contact-line">
            <div class="contact-item">
                <i class="fas fa-phone-alt"></i>
                <strong>Hotline:</strong> 079 886 4360
            </div>
            <div class="contact-item">
                <i class="fab fa-facebook-messenger"></i>
                <strong>Zalo:</strong> Nhắn tin qua số trên
            </div>
        </div>
    </div>
</div>

<script>
    // tab switching
    document.addEventListener("DOMContentLoaded", function () {
        const buttons = document.querySelectorAll('.tab-btn');
        const panels  = document.querySelectorAll('.tab-panel');

        buttons.forEach(btn => {
            btn.addEventListener('click', () => {
                buttons.forEach(b => b.classList.remove('active'));
                panels.forEach(p => p.style.display = 'none');

                btn.classList.add('active');
                const target = document.querySelector(btn.dataset.target);
                if (target) target.style.display = 'block';
            });
        });
    });
</script>

</body>
</html>
