
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Liên hệ & Đánh giá sản phẩm - FlowerShop</title>

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

        /* LAYOUT CHUNG 2 CỘT (tái dùng của account) */
        .account-layout {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 24px;
        }

        .account-card {
            background: #fff;
            border-radius: 20px;
            padding: 22px 24px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.08);
        }

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

        .form-group input,
        .form-group textarea {
            width: 100%;
            padding: 8px 10px;
            border-radius: 8px;
            border: 1px solid #cbd5e0;
            font-size: 13px;
            outline: none;
        }

        .form-group input:focus,
        .form-group textarea:focus {
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

    <a href="${ctx}/home/index" class="back-link">
        <i class="fas fa-arrow-left"></i> Quay lại trang chủ
    </a>

    <h1 class="page-title">Liên hệ & Đánh giá sản phẩm</h1>

    <div class="breadcrumb">
        <a href="${ctx}/home/index">Trang chủ</a> &nbsp;/&nbsp;
        <span>Liên hệ</span>
    </div>

    <!-- Thông báo -->
    <c:if test="${not empty successMessage}">
        <div class="message success">${successMessage}</div>
    </c:if>
    <c:if test="${not empty errorMessage}">
        <div class="message error">${errorMessage}</div>
    </c:if>

    <!-- 2 CỘT: TRÁI ĐÁNH GIÁ – PHẢI LIÊN HỆ/CHAT -->
    <div class="account-layout">

        <!-- CỘT TRÁI: ĐÁNH GIÁ SẢN PHẨM -->
        <section class="account-card">
            <h2 class="section-title">
                <i class="fa-solid fa-star-half-stroke"></i> Đánh giá sản phẩm đã mua
            </h2>

            <c:if test="${empty ratingItems}">
                <p class="text-muted">Bạn chưa có sản phẩm nào trong đơn đã giao để đánh giá.</p>
            </c:if>

            <c:if test="${not empty ratingItems}">
                <table>
                    <thead>
                    <tr>
                        <th>Sản phẩm</th>
                        <th>Đơn hàng</th>
                        <th style="width:120px;">Số sao</th>
                        <th>Nhận xét</th>
                        <th style="width:80px;"></th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="row" items="${ratingItems}">
                        <tr>
                            <td>
                                <div style="display:flex; align-items:center; gap:8px;">
                                    <img src="${ctx}/${row.mainImage}" alt="${row.productName}"
                                         style="width:50px; height:50px; border-radius:8px; object-fit:cover;">
                                    <div>
                                        <div style="font-weight:600;">${row.productName}</div>
                                        <div class="text-muted">
                                            Mã đơn: #${row.orderCode}<br>
                                            Ngày: <fmt:formatDate value="${row.orderDate}" pattern="dd/MM/yyyy" />
                                        </div>
                                    </div>
                                </div>
                            </td>
                            <td>#${row.orderCode}</td>
                            <td>
                                <form action="${ctx}/contact/rate" method="post">
                                    <input type="hidden" name="orderId"   value="${row.orderId}">
                                    <input type="hidden" name="productId" value="${row.productId}">
                                    <select name="rating" style="padding:4px 6px; border-radius:6px;">
                                        <c:forEach var="star" begin="1" end="5">
                                            <option value="${star}"
                                                <c:if test="${row.rating != null && row.rating == star}">selected</c:if>>
                                                ${star} sao
                                            </option>
                                        </c:forEach>
                                    </select>
                            </td>
                            <td>
                                    <textarea name="comment"
                                              style="width:100%; min-height:60px; font-size:12px; padding:5px 7px; border-radius:6px; border:1px solid #cbd5e0;">${row.comment}</textarea>
                            </td>
                            <td>
                                    <button type="submit" class="btn btn-primary" style="font-size:12px;">
                                        Lưu
                                    </button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </c:if>
        </section>

        <!-- CỘT PHẢI: LIÊN HỆ / CHAT VỚI ADMIN -->
        <section class="account-card">
            <h2 class="section-title">
                <i class="fa-solid fa-comments"></i> Liên hệ với shop
            </h2>

            <!-- Form tạo phản hồi mới -->
            <div style="margin-bottom:18px; border-bottom:1px solid #edf2f7; padding-bottom:14px;">
                <form action="${ctx}/contact/new" method="post">
                    <div class="form-group">
                        <label>Chủ đề</label>
                        <input type="text" name="subject" placeholder="VD: Phản hồi về chất lượng hoa..." required>
                    </div>
                    <div class="form-group">
                        <label>Nội dung</label>
                        <textarea name="message" required
                                  style="width:100%; min-height:70px; padding:8px 10px; border-radius:8px; border:1px solid #cbd5e0;"></textarea>
                    </div>
                    <button type="submit" class="btn btn-primary">
                        <i class="fa-solid fa-paper-plane"></i> Gửi phản hồi mới
                    </button>
                </form>
            </div>

            <div style="display:grid; grid-template-columns: 220px 1fr; gap:16px;">

                <!-- DANH SÁCH PHIẾU PHẢN HỒI -->
                <div style="border-right:1px solid #edf2f7; padding-right:10px; max-height:280px; overflow:auto;">
                    <div class="text-muted" style="margin-bottom:6px;">Phiếu phản hồi của bạn</div>
                    <c:if test="${empty contacts}">
                        <p class="text-muted">Bạn chưa tạo phản hồi nào.</p>
                    </c:if>
                    <c:forEach var="cItem" items="${contacts}">
                        <a href="${ctx}/contact?contactId=${cItem.contactId}"
                           style="display:block; padding:8px 6px; border-radius:8px; text-decoration:none; font-size:13px; margin-bottom:4px;
                                  background:${cItem.contactId == currentContactId ? '#ffe4ec' : 'transparent'};
                                  color:#2d3748;">
                            <div style="font-weight:600;">${cItem.subject}</div>
                            <div class="text-muted">
                                <fmt:formatDate value="${cItem.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                                &nbsp;-&nbsp; ${cItem.status}
                            </div>
                        </a>
                    </c:forEach>
                </div>

                <!-- VÙNG CHAT -->
                <div style="display:flex; flex-direction:column; height:280px;">
                    <div class="text-muted" style="margin-bottom:6px;">Trao đổi với shop</div>

                    <div style="flex:1; border:1px solid #edf2f7; border-radius:10px; padding:8px; overflow-y:auto; background:#f9fafb;">
                        <c:if test="${empty currentContactId}">
                            <p class="text-muted" style="font-size:13px;">
                                Hãy chọn 1 phiếu phản hồi bên trái hoặc tạo phản hồi mới.
                            </p>
                        </c:if>
                        <c:if test="${not empty currentContactId}">
                            <c:forEach var="m" items="${messages}">
                                <div style="margin-bottom:8px; text-align:${m.senderType == 'user' ? 'right' : 'left'};">
                                    <div style="
                                        display:inline-block;
                                        padding:6px 10px;
                                        border-radius:10px;
                                        font-size:13px;
                                        max-width:80%;
                                        text-align:left;
                                        background:${m.senderType == 'user' ? '#ffeff5' : '#e3f2fd'};">
                                        <strong>${m.senderType == 'user' ? 'Bạn' : 'Shop'}:</strong>
                                        <br>${m.messageText}
                                        <div class="text-muted" style="font-size:11px; margin-top:2px;">
                                            <fmt:formatDate value="${m.createdAt}" pattern="dd/MM HH:mm" />
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:if>
                    </div>

                    <c:if test="${not empty currentContactId}">
                        <form action="${ctx}/contact/send-message" method="post"
                              style="margin-top:8px; display:flex; gap:6px;">
                            <input type="hidden" name="contactId" value="${currentContactId}">
                            <input type="text" name="message"
                                   placeholder="Nhập tin nhắn..."
                                   style="flex:1; padding:8px 10px; border-radius:999px; border:1px solid #cbd5e0;">
                            <button type="submit" class="btn btn-primary" style="border-radius:999px;">
                                <i class="fa-solid fa-paper-plane"></i>
                            </button>
                        </form>
                    </c:if>
                </div>
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
                <strong>Hotline:</strong> 0335422157
            </div>
            <div class="contact-item">
                <i class="fab fa-facebook-messenger"></i>
                <strong>Zalo:</strong> Nhắn tin qua số trên
            </div>
        </div>
    </div>
</div>

</body>
</html>

