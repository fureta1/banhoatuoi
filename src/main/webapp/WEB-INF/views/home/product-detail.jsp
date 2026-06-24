<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${product.name} - FlowerShop</title>

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

        /* ============ TOP BAR ============ */
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

        .logout-btn:hover {
            background: #fff;
            color: #764ba2;
        }

        /* ============ MEGA MENU ============ */
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

        .mega-divider {
            width: 1px;
            height: 32px;
            background: #e2e8f0;
            margin: 0 12px;
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

        /* ============ MAIN ============ */
        .main-wrapper {
            max-width: 1400px;
            margin: 0 auto;
            padding: 30px;
        }

        .breadcrumb {
            font-size: 13px;
            color: #718096;
            margin-bottom: 15px;
        }

        .breadcrumb a {
            color: #667eea;
            text-decoration: none;
            font-weight: 500;
        }

        .breadcrumb a:hover {
            text-decoration: underline;
        }

        .breadcrumb span {
            margin: 0 4px;
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

        .product-detail-layout {
            display: grid;
            grid-template-columns: 1.1fr 1.2fr;
            gap: 40px;
        }

        .product-detail-image-wrapper {
            background: #fff;
            border-radius: 20px;
            padding: 18px;
            box-shadow: 0 8px 30px rgba(0,0,0,0.08);
        }

        .product-detail-image-wrapper img {
            width: 100%;
            max-height: 500px;
            object-fit: cover;
            border-radius: 16px;
        }

        .product-detail-info {
            background: #fff;
            border-radius: 20px;
            padding: 24px 26px;
            box-shadow: 0 8px 30px rgba(0,0,0,0.08);
        }

        .product-detail-title {
            font-size: 26px;
            font-weight: 700;
            margin-bottom: 8px;
        }

        .product-detail-category {
            font-size: 13px;
            color: #718096;
            margin-bottom: 18px;
        }

        .product-detail-category a {
            color: #3182ce;
            text-decoration: none;
        }

        .product-detail-category a:hover {
            text-decoration: underline;
        }

        .product-detail-price {
            margin-bottom: 20px;
        }

        .product-detail-price-main {
            font-size: 24px;
            font-weight: 800;
            color: #f5576c;
        }

        .product-detail-price-old {
            font-size: 16px;
            text-decoration: line-through;
            color: #a0aec0;
            margin-right: 8px;
            font-weight: 400;
        }

        .product-detail-status {
            font-size: 14px;
            margin-bottom: 15px;
        }

        .status-in-stock {
            color: #38a169;
            font-weight: 600;
        }

        .status-out-stock {
            color: #e53e3e;
            font-weight: 600;
        }

        .product-detail-short-desc {
            font-size: 14px;
            color: #4a5568;
            line-height: 1.7;
            margin-bottom: 18px;
        }

        .product-detail-meta {
            font-size: 14px;
            margin-bottom: 22px;
        }

        .product-detail-meta span {
            display: inline-block;
            margin-right: 18px;
            color: #4a5568;
        }

        .product-detail-meta i {
            margin-right: 6px;
            color: #667eea;
        }

        .product-detail-cart-form {
            margin-top: 10px;
        }

        .product-detail-qty {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 18px;
        }

        .product-detail-qty label {
            font-size: 14px;
            font-weight: 600;
        }

        .product-detail-qty input[type="number"] {
            width: 80px;
            padding: 6px 10px;
            border-radius: 10px;
            border: 1px solid #cbd5e0;
            font-size: 14px;
            text-align: center;
        }

        .btn-main {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            padding: 12px 22px;
            border-radius: 999px;
            border: none;
            font-size: 14px;
            font-weight: 700;
            cursor: pointer;
            text-transform: uppercase;
            letter-spacing: 0.7px;
        }

        .btn-add-cart {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: #fff;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
        }

        .btn-add-cart:hover {
            background: linear-gradient(135deg, #764ba2 0%, #667eea 100%);
        }

        .product-detail-note {
            margin-top: 12px;
            font-size: 12px;
            color: #718096;
        }

        .product-detail-note i {
            margin-right: 4px;
        }

        .product-detail-description-block {
            margin-top: 28px;
            padding-top: 18px;
            border-top: 1px dashed #e2e8f0;
        }

        .product-detail-description-block h3 {
            font-size: 18px;
            margin-bottom: 10px;
        }

        .product-detail-description-block p {
            font-size: 14px;
            color: #4a5568;
            line-height: 1.7;
            white-space: pre-line;
        }

        /* ============ RELATED PRODUCTS ============ */
        .home-section {
            margin-top: 50px;
            margin-bottom: 20px;
        }

        .home-section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 24px;
            padding-bottom: 12px;
            border-bottom: 3px solid transparent;
            border-image: linear-gradient(90deg, #667eea 0%, #764ba2 100%);
            border-image-slice: 1;
        }

        .home-section-header h2 {
            font-size: 22px;
            color: #333;
            text-transform: uppercase;
            font-weight: 700;
            letter-spacing: 1px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .home-section-header h2::before {
            content: '';
            width: 6px;
            height: 26px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 3px;
        }

        .product-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
            gap: 26px;
        }

        .product-card {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 5px 20px rgba(0,0,0,0.08);
            transition: all 0.3s;
            position: relative;
        }

        .product-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 15px 40px rgba(0,0,0,0.15);
        }

        .product-card a {
            display: block;
            overflow: hidden;
        }

        .product-card img {
            width: 100%;
            height: 260px;
            object-fit: cover;
            transition: all 0.5s;
        }

        .product-card:hover img {
            transform: scale(1.06);
        }

        .product-info {
            padding: 16px 18px 18px;
        }

        .product-name {
            font-size: 15px;
            font-weight: 600;
            color: #333;
            margin-bottom: 10px;
            height: 44px;
            overflow: hidden;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
        }

        .product-price {
            font-size: 18px;
            font-weight: 700;
            color: #f5576c;
            margin-bottom: 12px;
        }

        .product-price-old {
            font-size: 14px;
            text-decoration: line-through;
            color: #999;
            margin-right: 8px;
            font-weight: 400;
        }

        .product-card button {
            width: 100%;
            padding: 10px;
            border: none;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            font-weight: 600;
            font-size: 13px;
            cursor: pointer;
            border-radius: 8px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            transition: all 0.3s;
        }

        .product-card button:hover {
            background: linear-gradient(135deg, #764ba2 0%, #667eea 100%);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
        }

        .empty-related {
            font-size: 14px;
            color: #718096;
        }

        /* ============ FOOTER ============ */
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
            .product-detail-layout {
                grid-template-columns: 1fr;
            }

            .main-wrapper {
                padding: 20px 15px;
            }
        }

        @media (max-width: 768px) {
            .top-bar-content {
                padding: 0 15px;
                gap: 20px;
                flex-wrap: wrap;
            }

            .mega-menu-content {
                padding: 0 15px;
                flex-wrap: wrap;
                justify-content: center;
            }

            .mega-menu a {
                padding: 12px 14px;
                font-size: 13px;
            }

            .contact-line {
                flex-direction: column;
                gap: 15px;
            }

            .product-detail-title {
                font-size: 22px;
            }

            .product-detail-image-wrapper img {
                max-height: 380px;
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

<!-- MEGA MENU DÙNG CHUNG -->
<jsp:include page="_mega-menu.jsp" />

<!-- MAIN CONTENT -->
<div class="main-wrapper">

    <a href="${ctx}/home/index" class="back-link">
        <i class="fas fa-arrow-left"></i> Quay lại trang chủ
    </a>

    <div class="breadcrumb">
        <a href="${ctx}/home/index">Trang chủ</a>
        <c:if test="${not empty category}">
            <span>›</span>
            <a href="${ctx}/category?categoryId=${category.id}">
                ${category.name}
            </a>
        </c:if>
        <span>›</span>
        <span>${product.name}</span>
    </div>

    <!-- LAYOUT CHI TIẾT -->
    <div class="product-detail-layout">
        <!-- HÌNH ẢNH -->
        <div class="product-detail-image-wrapper">
            <img src="${ctx}/${product.mainImage}" alt="${product.name}">
        </div>

        <!-- THÔNG TIN CHI TIẾT -->
        <div class="product-detail-info">
            <h1 class="product-detail-title">${product.name}</h1>

            <div class="product-detail-category">
                <i class="fas fa-tags"></i>
                <c:choose>
                    <c:when test="${not empty category}">
                        Thuộc danh mục:
                        <a href="${ctx}/category?categoryId=${category.id}">
                            ${category.name}
                        </a>
                    </c:when>
                    <c:otherwise>
                        Thuộc danh mục: <em>Khác</em>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- GIÁ -->
            <div class="product-detail-price">
                <c:choose>
                    <c:when test="${product.discountPrice != null}">
                        <span class="product-detail-price-old">
                            <fmt:formatNumber value="${product.price}"
                                              type="number"
                                              groupingUsed="true"
                                              maxFractionDigits="0"/> VND
                        </span>
                        <span class="product-detail-price-main">
                            <fmt:formatNumber value="${product.discountPrice}"
                                              type="number"
                                              groupingUsed="true"
                                              maxFractionDigits="0"/> VND
                        </span>
                    </c:when>
                    <c:otherwise>
                        <span class="product-detail-price-main">
                            <fmt:formatNumber value="${product.price}"
                                              type="number"
                                              groupingUsed="true"
                                              maxFractionDigits="0"/> VND
                        </span>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- TÌNH TRẠNG -->
            <div class="product-detail-status">
                <c:choose>
                    <c:when test="${product.stockQuantity != null && product.stockQuantity > 0}">
                        <span class="status-in-stock">
                            <i class="fas fa-check-circle"></i> Còn hàng (${product.stockQuantity} sản phẩm)
                        </span>
                    </c:when>
                    <c:otherwise>
                        <span class="status-out-stock">
                            <i class="fas fa-times-circle"></i> Hết hàng
                        </span>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- MÔ TẢ NGẮN (KHÔNG DÙNG shortDescription NỮA) -->
            <div class="product-detail-short-desc">
                <c:choose>
                    <c:when test="${not empty product.description}">
                        ${product.description}
                    </c:when>
                    <c:otherwise>
                        Thiết kế bó hoa/bình hoa tinh tế, phù hợp nhiều dịp tặng: sinh nhật, kỷ niệm, chúc mừng,
                        khai trương hay gửi lời cảm ơn. FlowerShop sử dụng hoa tươi loại 1, được tuyển chọn kỹ
                        và cắm trong ngày để đảm bảo độ tươi lâu nhất cho khách hàng.
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- META -->
            <div class="product-detail-meta">
                <span><i class="fas fa-gift"></i> Phù hợp cho nhiều dịp tặng</span>
                <span><i class="fas fa-truck"></i> Giao nhanh trong ngày</span>
            </div>

            <!-- FORM THÊM VÀO GIỎ (GIỮ NGUYÊN CHỨC NĂNG) -->
            <form action="${ctx}/cart/add" method="post" class="product-detail-cart-form">
                <input type="hidden" name="productId" value="${product.id}"/>

                <div class="product-detail-qty">
                    <label for="qty">Số lượng:</label>
                    <input id="qty" type="number" name="quantity"
                           min="1"
                           value="1"
                        <c:if test="${product.stockQuantity != null && product.stockQuantity > 0}">
                            max="${product.stockQuantity}"
                        </c:if>>
                </div>

                <c:choose>
                    <c:when test="${product.stockQuantity != null && product.stockQuantity > 0}">
                        <button type="submit" class="btn-main btn-add-cart">
                            <i class="fas fa-shopping-cart"></i> Thêm vào giỏ
                        </button>
                    </c:when>
                    <c:otherwise>
                        <button type="button" class="btn-main btn-add-cart" disabled
                                style="opacity:0.6; cursor:not-allowed;">
                            <i class="fas fa-ban"></i> Tạm hết hàng
                        </button>
                    </c:otherwise>
                </c:choose>
            </form>

            <div class="product-detail-note">
                <i class="fas fa-info-circle"></i>
                Hình ảnh mang tính minh họa, màu sắc & kiểu dáng có thể thay đổi nhẹ tùy theo mùa hoa,
                nhưng FlowerShop luôn giữ đúng giá trị & kích thước sản phẩm.
            </div>

            <!-- MÔ TẢ CHI TIẾT (DÙNG CHUNG description) -->
            <div class="product-detail-description-block">
                <h3>Mô tả chi tiết</h3>
                <c:choose>
                    <c:when test="${not empty product.description}">
                        <p>${product.description}</p>
                    </c:when>
                    <c:otherwise>
                        <p>
                            Sản phẩm được cắm từ hoa tươi tuyển chọn, phối màu hài hòa, phù hợp nhiều dịp:
                            sinh nhật, chúc mừng, khai trương, kỷ niệm... Đội ngũ FlowerShop sẽ tư vấn thêm nếu
                            bạn cần điều chỉnh mẫu hoặc thay đổi tông màu cho phù hợp người nhận.
                        </p>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <!-- SẢN PHẨM LIÊN QUAN / GỢI Ý – GIỮ LẠI ĐẦY ĐỦ -->
    <div class="home-section">
        <div class="home-section-header">
            <h2>Sản phẩm liên quan</h2>
        </div>

        <c:choose>
            <c:when test="${empty relatedProducts}">
                <p class="empty-related">
                    Hiện chưa có sản phẩm gợi ý. Bạn có thể xem thêm các mẫu hoa khác ở trang chủ.
                </p>
            </c:when>
            <c:otherwise>
                <div class="product-grid">
                    <c:forEach var="p" items="${relatedProducts}">
                        <div class="product-card">
                            <a href="${ctx}/product/${p.id}">
                                <img src="${ctx}/${p.mainImage}" alt="${p.name}">
                            </a>
                            <div class="product-info">
                                <div class="product-name">${p.name}</div>
                                <div class="product-price">
                                    <c:if test="${p.discountPrice != null}">
                                        <span class="product-price-old">
                                            <fmt:formatNumber value="${p.price}"
                                                              type="number"
                                                              groupingUsed="true"
                                                              maxFractionDigits="0" /> VND
                                        </span>
                                        <fmt:formatNumber value="${p.discountPrice}"
                                                          type="number"
                                                          groupingUsed="true"
                                                          maxFractionDigits="0" /> VND
                                    </c:if>
                                    <c:if test="${p.discountPrice == null}">
                                        <fmt:formatNumber value="${p.price}"
                                                          type="number"
                                                          groupingUsed="true"
                                                          maxFractionDigits="0" /> VND
                                    </c:if>
                                </div>
                                <form action="${ctx}/cart/add" method="post">
                                    <input type="hidden" name="productId" value="${p.id}">
                                    <input type="hidden" name="quantity" value="1">
                                    <button type="submit">
                                        <i class="fas fa-shopping-cart"></i> Thêm vào giỏ
                                    </button>
                                </form>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
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

