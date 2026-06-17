<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>${category.name} - FlowerShop</title>

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

        /* =========== TOP BAR =========== */
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

        /* =========== MEGA MENU (đã dùng chung _mega-menu.jsp) =========== */
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

        /* =========== BREADCRUMB CHỈ DÙNG CHO TRANG DANH MỤC =========== */
        .breadcrumb-wrapper {
            max-width: 1400px;
            margin: 0 auto;
            padding: 15px 30px 0;
        }

        .breadcrumb {
            font-size: 14px;
            color: #4a5568;
            display: flex;
            align-items: center;
            flex-wrap: wrap;
            gap: 6px;
        }

        .breadcrumb a {
            color: #3182ce;
            text-decoration: none;
            font-weight: 500;
        }

        .breadcrumb a:hover {
            text-decoration: underline;
        }

        .breadcrumb-separator {
            color: #a0aec0;
        }

        .breadcrumb-current {
            font-weight: 500;
            color: #2d3748;
        }

        /* =========== MAIN WRAPPER =========== */
        .main-wrapper {
            max-width: 1400px;
            margin: 0 auto;
            padding: 20px 30px 40px;
        }

        /* HEADER DANH MỤC */
        .category-header {
            background: white;
            border-radius: 18px;
            padding: 24px 28px;
            box-shadow: 0 6px 20px rgba(0,0,0,0.08);
            margin-bottom: 30px;
        }

        .category-header h1 {
            font-size: 26px;
            margin-bottom: 8px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .category-header h1 i {
            color: #f6ad55;
        }

        .category-header p {
            color: #4a5568;
            font-size: 15px;
        }

        /* SECTION HEADER */
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

        .home-section-header span {
            font-size: 13px;
            color: #718096;
            margin-left: 6px;
        }

        /* GRID SẢN PHẨM */
        .product-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 30px;
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
            transform: translateY(-10px);
            box-shadow: 0 15px 40px rgba(0,0,0,0.15);
        }

        .product-card a {
            display: block;
            overflow: hidden;
        }

        .product-card img {
            width: 100%;
            height: 280px;
            object-fit: cover;
            transition: all 0.5s;
        }

        .product-card:hover img {
            transform: scale(1.1);
        }

        .product-info {
            padding: 20px;
        }

        .product-name {
            font-size: 16px;
            font-weight: 600;
            color: #333;
            margin-bottom: 12px;
            height: 48px;
            overflow: hidden;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
        }

        .product-price {
            font-size: 20px;
            font-weight: 700;
            color: #f5576c;
            margin-bottom: 15px;
        }

        .product-price-old {
            font-size: 15px;
            text-decoration: line-through;
            color: #999;
            margin-right: 8px;
            font-weight: 400;
        }

        .product-card button {
            width: 100%;
            padding: 12px;
            border: none;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            font-weight: 600;
            font-size: 14px;
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

        .empty-result {
            padding: 30px;
            background: #fff;
            border-radius: 16px;
            box-shadow: 0 6px 20px rgba(0,0,0,0.06);
            text-align: center;
            color: #4a5568;
        }

        .empty-result i {
            font-size: 40px;
            color: #a0aec0;
            margin-bottom: 10px;
        }

        /* FOOTER */
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

        /* Responsive nhẹ */
        @media (max-width: 768px) {
            .top-bar-content {
                padding: 0 15px;
                gap: 20px;
                flex-wrap: wrap;
            }
            .main-wrapper {
                padding: 20px 15px 40px;
            }
            .product-grid {
                grid-template-columns: 1fr;
            }
            .contact-line {
                flex-direction: column;
                gap: 15px;
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
                    <option value="${cat.id}">${cat.name}</option>
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

<!-- BREADCRUMB CHO TRANG DANH MỤC -->
<div class="breadcrumb-wrapper">
    <div class="breadcrumb">
        <a href="${ctx}/home/index">Trang chủ</a>
        <span class="breadcrumb-separator">›</span>
        <span class="breadcrumb-current">${category.name}</span>
    </div>
</div>

<!-- MAIN CONTENT -->
<div class="main-wrapper">

    <!-- HEADER DANH MỤC -->
    <div class="category-header">
        <h1>
            <i class="fas fa-birthday-cake"></i>
            ${category.name}
        </h1>
        <p>
            <c:choose>
                <c:when test="${not empty category.description}">
                    ${category.description}
                </c:when>
                <c:otherwise>
                    Các mẫu hoa thuộc danh mục ${category.name} được thiết kế tỉ mỉ, phù hợp nhiều nhu cầu tặng quà.
                </c:otherwise>
            </c:choose>
        </p>
    </div>

    <!-- DANH SÁCH SẢN PHẨM TRONG DANH MỤC -->
    <div class="home-section">
        <div class="home-section-header">
            <h2>
                Sản phẩm trong danh mục
                <c:if test="${not empty categoryProducts}">
                    <span>(${fn:length(categoryProducts)} sản phẩm)</span>
                </c:if>
            </h2>
        </div>

        <c:choose>
            <c:when test="${empty categoryProducts}">
                <div class="empty-result">
                    <i class="fas fa-box-open"></i>
                    <h3>Hiện chưa có sản phẩm nào trong danh mục này.</h3>
                    <p>Vui lòng quay lại sau hoặc chọn danh mục khác.</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="product-grid">
                    <c:forEach var="p" items="${categoryProducts}">
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
                <strong>Hotline:</strong> 079 886 4360
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
