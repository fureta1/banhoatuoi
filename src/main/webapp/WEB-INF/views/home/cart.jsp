<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Giỏ hàng - FlowerShop</title>

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

        /* Nút Đăng xuất trên top bar */
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

        /* ====== CART SPECIFIC ====== */

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

        .alert {
            padding: 10px 14px;
            border-radius: 6px;
            margin-bottom: 15px;
            font-size: 14px;
        }

        .alert-success { background: #c6f6d5; color: #22543d; }
        .alert-error   { background: #fed7d7; color: #742a2a; }

        .cart-layout {
            display: grid;
            grid-template-columns: 3fr 2fr;
            gap: 30px;
        }

        .cart-card {
            background: white;
            border-radius: 20px;
            padding: 24px 28px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.08);
        }

        .cart-card h2 {
            font-size: 20px;
            margin-bottom: 18px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .cart-card h2 i {
            color: #667eea;
        }

        table.cart-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 14px;
        }

        .cart-table th,
        .cart-table td {
            padding: 10px 8px;
            border-bottom: 1px solid #edf2f7;
            vertical-align: middle;
        }

        .cart-table th {
            background: #f7fafc;
            text-align: left;
        }

        .cart-product {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .cart-product img {
            width: 70px;
            height: 70px;
            object-fit: cover;
            border-radius: 10px;
        }

        .cart-product-name {
            font-weight: 600;
            margin-bottom: 4px;
        }

        .cart-product-meta {
            font-size: 12px;
            color: #718096;
        }

        .qty-input {
            width: 70px;
            padding: 4px 6px;
            border-radius: 6px;
            border: 1px solid #cbd5e0;
            text-align: center;
        }

        .btn-small {
            border: none;
            background: none;
            color: #e53e3e;
            cursor: pointer;
            font-size: 13px;
        }

        .btn-small i { margin-right: 2px; }

        .text-right { text-align: right; }
        .text-center { text-align: center; }

        .cart-summary-line {
            display: flex;
            justify-content: space-between;
            margin-bottom: 6px;
            font-size: 14px;
        }

        .cart-summary-total {
            font-size: 20px;
            font-weight: 700;
            margin-top: 10px;
        }

        .cart-summary-total span {
            color: #e53e3e;
        }

        .info-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px 20px;
            margin-top: 10px;
        }

        .form-group {
            margin-bottom: 8px;
        }

        .form-group label {
            font-size: 13px;
            font-weight: 600;
            margin-bottom: 4px;
            display: block;
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

        .form-group textarea {
            min-height: 60px;
            resize: vertical;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
            border-radius: 999px;
            padding: 10px 20px;
            border: none;
            cursor: pointer;
            font-size: 14px;
            font-weight: 600;
        }

        .btn-update {
            background: #e2e8f0;
            color: #2d3748;
        }

        .btn-update:hover {
            background: #cbd5e0;
        }

        .btn-checkout {
            width: 100%;
            margin-top: 10px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: #fff;
        }

        .btn-checkout:hover {
            background: linear-gradient(135deg, #764ba2 0%, #667eea 100%);
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

        /* Responsive */
        @media (max-width: 992px) {
            .cart-layout {
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

            .cart-layout {
                gap: 20px;
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

    <h1 class="page-title">Giỏ hàng của bạn</h1>

    <!-- Breadcrumb + nút quay lại trình duyệt -->
    <div class="breadcrumb">
        <a href="${ctx}/home/index">Trang chủ</a> &nbsp;/&nbsp;
        <span>Giỏ hàng</span>
        &nbsp;&nbsp;|&nbsp;&nbsp;
        <a href="javascript:history.back()" class="back-link">
            <i class="fas fa-arrow-left"></i> Quay lại trang trước
        </a>
    </div>

    <!-- Thông báo -->
    <c:if test="${not empty cartMessage}">
        <div class="alert alert-success">${cartMessage}</div>
    </c:if>
    <c:if test="${not empty cartError}">
        <div class="alert alert-error">${cartError}</div>
    </c:if>

    <c:choose>
        <c:when test="${empty cartItems}">
            <div class="cart-card">
                <h2><i class="fas fa-shopping-cart"></i> Giỏ hàng trống</h2>
                <p style="font-size:14px; margin-bottom:12px;">
                    Hiện tại bạn chưa có sản phẩm nào trong giỏ hàng.
                </p>
                <a href="${ctx}/home/index"
                   class="btn btn-checkout" style="width:auto; padding-inline:24px;">
                    <i class="fas fa-arrow-left"></i> Tiếp tục mua sắm
                </a>
            </div>
        </c:when>
        <c:otherwise>
            <div class="cart-layout">

                <!-- LEFT: product list -->
                <div class="cart-card">
                    <h2><i class="fas fa-box-open"></i> Sản phẩm trong giỏ</h2>

                    <form id="cart-form" action="${ctx}/cart/update" method="post">
                        <table class="cart-table">
                            <thead>
                            <tr>
                                <th style="width:40px;">Chọn</th>
                                <th>Sản phẩm</th>
                                <th style="width:90px;">Đơn giá</th>
                                <th style="width:90px;">Số lượng</th>
                                <th style="width:110px;">Thành tiền</th>
                                <th style="width:60px;"></th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="item" items="${cartItems}">
                                <c:set var="p" value="${item.product}" />
                                <tr>
                                    <td class="text-center">
                                        <input type="checkbox"
                                               class="select-item"
                                               name="selectedIds"
                                               value="${item.productId}"
                                            <c:if test="${item.selected}">checked="checked"</c:if> />
                                    </td>
                                    <td>
                                        <div class="cart-product">
                                            <img src="${ctx}/${p.mainImage}" alt="${p.name}">
                                            <div>
                                                <div class="cart-product-name">${p.name}</div>
                                                <div class="cart-product-meta">
                                                    <c:if test="${p.discountPrice != null && p.discountPrice > 0}">
                                                        <span style="text-decoration:line-through;">
                                                            <fmt:formatNumber value="${p.price}" type="number"
                                                                              groupingUsed="true"
                                                                              maxFractionDigits="0" /> VND
                                                        </span>
                                                        &nbsp;
                                                        <span style="color:#e53e3e; font-weight:600;">
                                                            <fmt:formatNumber value="${p.discountPrice}" type="number"
                                                                              groupingUsed="true"
                                                                              maxFractionDigits="0" /> VND
                                                        </span>
                                                    </c:if>
                                                    <c:if test="${p.discountPrice == null || p.discountPrice == 0}">
                                                        <span style="color:#2d3748; font-weight:600;">
                                                            <fmt:formatNumber value="${p.price}" type="number"
                                                                              groupingUsed="true"
                                                                              maxFractionDigits="0" /> VND
                                                        </span>
                                                    </c:if>
                                                    <br/>Còn lại: ${p.stockQuantity} sp
                                                </div>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <fmt:formatNumber value="${item.unitPrice}" type="number"
                                                          groupingUsed="true"
                                                          maxFractionDigits="0" /> VND
                                    </td>
                                    <td>
                                        <input type="number" class="qty-input"
                                               name="qty_${item.productId}"
                                               min="1"
                                               max="${p.stockQuantity}"
                                               value="${item.quantity}">
                                    </td>
                                    <td class="text-right">
                                        <fmt:formatNumber value="${item.lineTotal}" type="number"
                                                          groupingUsed="true"
                                                          maxFractionDigits="0" /> VND
                                    </td>
                                    <td class="text-right">
                                        <a href="${ctx}/cart/remove?productId=${item.productId}"
                                           class="btn-small" title="Xoá khỏi giỏ">
                                            <i class="fas fa-trash-alt"></i> Xoá
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>

                        <div style="margin-top:16px; display:flex; justify-content:space-between; align-items:center;">
                            <div style="font-size:13px; color:#718096;">
                                * Chọn/bỏ chọn hoặc đổi số lượng sẽ tự cập nhật giỏ hàng.<br>
                                * Số lượng tối thiểu là 1, tối đa bằng số lượng tồn kho.
                            </div>
                            <button type="submit" class="btn btn-update">
                                <i class="fas fa-sync-alt"></i> Cập nhật giỏ
                            </button>
                        </div>
                    </form>
                </div>

                <!-- RIGHT: summary + info -->
                <div class="cart-card">
                    <h2><i class="fas fa-receipt"></i> Thông tin đơn hàng</h2>

                    <c:set var="sub"   value="${subTotal}" />
                    <c:set var="ship"  value="${shippingFee}" />
                    <c:set var="total" value="${totalAmount}" />

                    <div class="cart-summary-line">
                        <span>Tạm tính (sản phẩm đã chọn)</span>
                        <span>
                            <fmt:formatNumber value="${sub}" type="number"
                                              groupingUsed="true"
                                              maxFractionDigits="0" /> VND
                        </span>
                    </div>
                    <div class="cart-summary-line">
                        <span>Phí vận chuyển</span>
                        <span>
                            <c:choose>
                                <c:when test="${sub >= 500000}">
                                    0 VND
                                </c:when>
                                <c:otherwise>
                                    <fmt:formatNumber value="${ship}" type="number"
                                                      groupingUsed="true"
                                                      maxFractionDigits="0" /> VND
                                </c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                    <div class="cart-summary-total">
                        Tổng thanh toán:
                        <span>
                            <fmt:formatNumber value="${total}" type="number"
                                              groupingUsed="true"
                                              maxFractionDigits="0" /> VND
                        </span>
                    </div>
                    <div style="font-size:12px; color:#38a169; margin-top:4px;">
                        Đơn từ 500,000 VND được miễn phí vận chuyển.
                        Đơn dưới 500,000 VND phí ship 60,000 VND.
                    </div>

                    <hr style="margin:16px 0; border:none; border-top:1px solid #e2e8f0;">

                    <form id="checkout-form"
                          action="${ctx}/checkout/info"
                          method="post"
                          onsubmit="return validateCheckout()">

                        <div class="info-grid">
                            <!-- Cột trái: người mua -->
                            <div>
                                <div class="form-group">
                                    <label>Họ tên người mua <span style="color:#e53e3e;">*</span></label>
                                    <input type="text" name="buyerName" required>
                                </div>
                                <div class="form-group">
                                    <label>Số điện thoại người mua <span style="color:#e53e3e;">*</span></label>
                                    <input type="tel" name="buyerPhone" required
                                           pattern="^[0-9]{10,11}$"
                                           title="Số điện thoại phải có 10-11 chữ số (0-9)">
                                </div>
                                <div class="form-group">
                                    <label>Email người mua</label>
                                    <input type="email" name="buyerEmail">
                                </div>
                            </div>

                            <!-- Cột phải: người nhận -->
                            <div>
                                <div class="form-group">
                                    <label>Họ tên người nhận <span style="color:#e53e3e;">*</span></label>
                                    <input type="text" name="receiverName" required>
                                </div>
                                <div class="form-group">
                                    <label>Số điện thoại người nhận <span style="color:#e53e3e;">*</span></label>
                                    <input type="tel" name="receiverPhone" required
                                           pattern="^[0-9]{10,11}$"
                                           title="Số điện thoại phải có 10-11 chữ số (0-9)">
                                </div>
                                <div class="form-group">
                                    <label>Địa chỉ nhận hàng <span style="color:#e53e3e;">*</span></label>
                                    <input type="text" name="receiverAddress" required>
                                </div>
                            </div>
                        </div>

                        <!-- Ghi chú / nội dung thiệp -->
                        <<div class="form-group" style="margin-top:8px;">
    <label>Ghi chú cho shop</label>
    <textarea name="shopNote"
              placeholder="VD: Giao giờ hành chính, không gọi trước..."></textarea>
</div>

<div class="form-group" style="margin-top:8px;">
    <label>Nội dung thiệp (nếu có)</label>
    <textarea name="cardMessage"
              placeholder="VD: Chúc mừng sinh nhật, chúc mừng khai trương..."></textarea>
</div>


                        <button type="submit" class="btn btn-checkout">
                            <i class="fas fa-arrow-right"></i> Tiếp tục thanh toán
                        </button>
                    </form>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
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

<script>
    document.addEventListener("DOMContentLoaded", function () {
        const cartForm = document.getElementById("cart-form");
        if (cartForm) {
            cartForm.querySelectorAll(".select-item").forEach(cb => {
                cb.addEventListener("change", () => cartForm.submit());
            });
            cartForm.querySelectorAll(".qty-input").forEach(input => {
                input.addEventListener("change", () => {
                    if (!input.value || parseInt(input.value) < 1) {
                        input.value = 1;
                    }
                    cartForm.submit();
                });
            });
        }
    });

    function validateCheckout() {
        const checked = document.querySelectorAll(".select-item:checked");
        if (checked.length === 0) {
            alert("Vui lòng chọn ít nhất một sản phẩm để thanh toán!");
            return false;
        }
        return true;
    }
</script>

</body>
</html>

