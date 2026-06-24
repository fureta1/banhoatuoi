<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FlowerShop - Hoa Tươi Cao Cấp</title>

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

        /* Active (trang đang đứng) */
        .mega-menu a.active {
            color: #667eea;
            font-weight: 800;
        }

        .mega-menu-left a.active::after {
            width: 80%;
        }

        /* Bên phải: dạng button + active */
        .mega-menu-right a {
            text-transform: none;
            font-size: 13px;
            padding: 12px 18px;
            border-radius: 999px;
            border: 1px solid #e2e8f0;
            margin-left: 8px;
        }

        .mega-menu-right a::after {
            display: none; /* không cần gạch dưới */
        }

        .mega-menu-right a:hover {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: #fff;
            border-color: transparent;
        }

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


        /* Gạch dọc ngăn giữa Hoa Chia Buồn và Tài khoản */
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

        /* Top Section */
        .top-section {
            display: grid;
            grid-template-columns: 1fr 420px;
            gap: 30px;
            margin-bottom: 50px;
        }

        /* Banner Slider */
        .banner-slider {
            position: relative;
            overflow: hidden;
            border-radius: 20px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.15);
            height: 450px;
        }

        .banner-slide {
            display: none;
            animation: fadeIn 0.5s;
        }

        .banner-slide.active {
            display: block;
        }

        .banner-slide img {
            width: 100%;
            height: 450px;
            object-fit: cover;
        }

        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        /* Advice Box */
        .advice-box {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 35px;
            border-radius: 20px;
            color: white;
            box-shadow: 0 10px 40px rgba(102, 126, 234, 0.3);
        }

        .advice-box h3 {
            font-size: 24px;
            margin-bottom: 25px;
            text-align: center;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .advice-box label {
            display: block;
            margin-top: 20px;
            font-weight: 600;
            font-size: 14px;
            margin-bottom: 8px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .advice-box select {
            width: 100%;
            padding: 14px;
            border: none;
            border-radius: 10px;
            font-size: 14px;
            outline: none;
            cursor: pointer;
            background: white;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        .advice-box button {
            width: 100%;
            margin-top: 25px;
            padding: 16px;
            border: none;
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            color: white;
            font-weight: 700;
            font-size: 16px;
            cursor: pointer;
            border-radius: 10px;
            text-transform: uppercase;
            letter-spacing: 1px;
            box-shadow: 0 4px 15px rgba(245, 87, 108, 0.4);
            transition: all 0.3s;
        }

        .advice-box button:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(245, 87, 108, 0.5);
        }

        .advice-box p {
            margin-top: 20px;
            font-size: 13px;
            line-height: 1.6;
            opacity: 0.95;
            text-align: center;
        }

        /* Home Section */
        .home-section {
            margin-bottom: 60px;
        }

        .home-section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 15px;
            border-bottom: 3px solid transparent;
            border-image: linear-gradient(90deg, #667eea 0%, #764ba2 100%);
            border-image-slice: 1;
        }

        .home-section-header h2 {
            font-size: 28px;
            color: #333;
            text-transform: uppercase;
            font-weight: 700;
            letter-spacing: 1px;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .home-section-header h2::before {
            content: '';
            width: 6px;
            height: 32px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 3px;
        }

        .home-section-header a {
            color: #667eea;
            text-decoration: none;
            font-weight: 600;
            font-size: 15px;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s;
        }

        .home-section-header a:hover {
            gap: 12px;
            color: #764ba2;
        }

        /* Product Grid */
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

        /* Responsive */
        @media (max-width: 1200px) {
            .product-grid {
                grid-template-columns: repeat(3, 1fr);
            }
        }

        @media (max-width: 992px) {
            .top-section {
                grid-template-columns: 1fr;
            }

            .advice-box {
                max-width: 500px;
                margin: 0 auto;
            }

            .product-grid {
                grid-template-columns: repeat(2, 1fr);
            }

            .mega-menu-content {
                flex-wrap: wrap;
                justify-content: center;
            }

            .mega-divider {
                display: none; /* Mobile cho gọn, nếu muốn vẫn để cũng được */
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

            .logo {
                font-size: 24px;
            }

            .product-grid {
                grid-template-columns: 1fr;
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

        <form class="search-box" action="${pageContext.request.contextPath}/search" method="get">
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
            <a href="${pageContext.request.contextPath}/auth/logout" class="logout-btn">
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
    <!-- TOP SECTION -->
    <div class="top-section">
        <!-- Banner Slider -->
        <div class="banner-slider">
            <c:choose>
                <c:when test="${not empty banners}">
                    <c:forEach var="b" items="${banners}" varStatus="st">
                        <div class="banner-slide ${st.index == 0 ? 'active' : ''}">
                            <img src="${pageContext.request.contextPath}/images/banners/${b.imageUrl}"
                                 alt="${b.title}">
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="banner-slide active">
                        <img src="${pageContext.request.contextPath}/images/banners/1764081327303_banner1.jpg"
                             alt="FlowerShop banner">
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Advice Box -->
        <div class="advice-box">
            <h3><i class="fas fa-lightbulb"></i> Tư vấn chọn hoa</h3>
            <form action="${pageContext.request.contextPath}/tu-van-chon-hoa" method="get">
                <label><i class="fas fa-tag"></i> Chủ đề</label>
<select name="categoryId">
    <option value="">Chọn danh mục thể loại</option>
    <c:forEach var="cat" items="${allCategories}">
        <option value="${cat.id}"
            <c:if test="${selectedCategoryId != null && selectedCategoryId == cat.id}">selected</c:if>>
            ${cat.name}
        </option>
    </c:forEach>
</select>


                <label><i class="fas fa-dollar-sign"></i> Mức giá</label>
<select name="priceRange">
    <option value="">Tất cả mức giá</option>
    <option value="UNDER_300">Dưới 300.000đ</option>
    <option value="300_700">300.000 – 700.000đ</option>
    <option value="700_1000">700.000 – 1.000.000đ</option>
    <option value="1000_2000">1.000.000 – 2.000.000đ</option>
    <option value="OVER_2000">Trên 2.000.000đ</option>
</select>


                <button type="submit">
                    <i class="fas fa-magic"></i> Chọn Tư vấn
                </button>

                <p>
                    <i class="fas fa-phone-alt"></i> Hoặc gọi nhanh cho chúng tôi để được tư vấn thiết kế riêng
                </p>
            </form>
        </div>
    </div>

    <!-- SECTION 1: Hoa Sinh Nhật -->
    <div class="home-section">
        <div class="home-section-header">
            <h2>Hoa Sinh Nhật</h2>
            <a href="${pageContext.request.contextPath}/category?categoryName=Hoa Sinh Nhật">
                Xem tất cả <i class="fas fa-arrow-right"></i>
            </a>
        </div>

        <div class="product-grid">
            <c:forEach var="p" items="${birthdayProducts}">
                <div class="product-card">
                    <a href="${pageContext.request.contextPath}/product/${p.id}">
                        <img src="${pageContext.request.contextPath}/${p.mainImage}"
                             alt="${p.name}">
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

                        <form action="${pageContext.request.contextPath}/cart/add" method="post">
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
    </div>

    <!-- SECTION 2: Hoa Khai Trương -->
    <div class="home-section">
        <div class="home-section-header">
            <h2>Hoa Khai Trương</h2>
            <a href="${pageContext.request.contextPath}/category?categoryName=Hoa Khai Trương">
                Xem tất cả <i class="fas fa-arrow-right"></i>
            </a>
        </div>

        <div class="product-grid">
            <c:forEach var="p" items="${openingProducts}">
                <div class="product-card">
                    <a href="${pageContext.request.contextPath}/product/${p.id}">
                        <img src="${pageContext.request.contextPath}/${p.mainImage}"
                             alt="${p.name}">
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


                        <form action="${pageContext.request.contextPath}/cart/add" method="post">
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
    </div>

    <!-- SECTION 3: Hoa Cưới -->
    <div class="home-section">
        <div class="home-section-header">
            <h2>Hoa Cưới</h2>
            <a href="${pageContext.request.contextPath}/category?categoryName=Hoa Cưới">
                Xem tất cả <i class="fas fa-arrow-right"></i>
            </a>
        </div>

        <div class="product-grid">
            <c:forEach var="p" items="${weddingProducts}">
                <div class="product-card">
                    <a href="${pageContext.request.contextPath}/product/${p.id}">
                        <img src="${pageContext.request.contextPath}/${p.mainImage}"
                             alt="${p.name}">
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


                        <form action="${pageContext.request.contextPath}/cart/add" method="post">
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

<script>
    document.addEventListener("DOMContentLoaded", function () {
        const slides = document.querySelectorAll(".banner-slide");
        if (!slides || slides.length === 0) return;

        let current = 0;
        slides.forEach((s, i) => {
            if (i === 0) s.classList.add("active");
            else s.classList.remove("active");
        });

        setInterval(function () {
            slides[current].classList.remove("active");
            current = (current + 1) % slides.length;
            slides[current].classList.add("active");
        }, 3000);
    });
</script>

</body>
</html>

