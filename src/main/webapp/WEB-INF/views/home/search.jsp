<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kết quả tìm kiếm - FlowerShop</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
    
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', 'Segoe UI', sans-serif;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
            padding: 20px 0;
        }

        .page-wrapper {
            max-width: 1280px;
            margin: 0 auto;
            padding: 0 24px;
        }

        /* Header Section */
        .search-header {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            padding: 32px 40px;
            margin-bottom: 32px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.08);
            border: 1px solid rgba(255, 255, 255, 0.8);
            position: relative;
            overflow: hidden;
        }

        .search-header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #667eea 0%, #764ba2 50%, #f093fb 100%);
        }

        .header-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 20px;
        }

        .search-title {
            display: flex;
            align-items: center;
            gap: 16px;
        }

        .search-icon {
            width: 56px;
            height: 56px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 16px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 24px;
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);
        }

        .title-text h1 {
            font-size: 28px;
            font-weight: 700;
            color: #1a202c;
            margin-bottom: 4px;
        }

        .keyword {
            color: #667eea;
            font-weight: 700;
        }

        .search-subtitle {
            font-size: 14px;
            color: #718096;
        }

        .back-link {
            text-decoration: none;
            padding: 12px 24px;
            background: white;
            color: #4a5568;
            border-radius: 12px;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            font-weight: 500;
            border: 2px solid #e2e8f0;
            transition: all 0.3s ease;
        }

        .back-link:hover {
            background: #667eea;
            color: white;
            border-color: #667eea;
            transform: translateX(-4px);
        }

        /* Section Styles */
        .section {
            margin-bottom: 40px;
        }

        .section-header {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 24px;
            padding: 16px 24px;
            background: white;
            border-radius: 16px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
        }

        .section-icon {
            width: 40px;
            height: 40px;
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 18px;
        }

        .section-title {
            font-size: 20px;
            font-weight: 700;
            color: #2d3748;
        }

        /* Category Chips */
        .category-list {
            display: flex;
            flex-wrap: wrap;
            gap: 12px;
        }

        .category-chip {
            padding: 12px 20px;
            border-radius: 50px;
            background: white;
            color: #2d3748;
            font-size: 14px;
            font-weight: 600;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            border: 2px solid #e2e8f0;
            transition: all 0.3s ease;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
        }

        .category-chip i {
            font-size: 16px;
            color: #f56565;
        }

        .category-chip:hover {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-color: transparent;
            transform: translateY(-2px);
            box-shadow: 0 8px 16px rgba(102, 126, 234, 0.3);
        }

        .category-chip:hover i {
            color: white;
        }

        /* Product Grid */
        .product-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 24px;
        }

        .product-card {
            background: white;
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 4px 16px rgba(0, 0, 0, 0.08);
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            position: relative;
        }

        .product-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(135deg, rgba(102, 126, 234, 0.1) 0%, rgba(118, 75, 162, 0.1) 100%);
            opacity: 0;
            transition: opacity 0.3s ease;
            z-index: 1;
            pointer-events: none;
        }

        .product-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 12px 32px rgba(0, 0, 0, 0.15);
        }

        .product-card:hover::before {
            opacity: 1;
        }

        .product-image-wrapper {
            position: relative;
            overflow: hidden;
            height: 260px;
        }

        .product-card img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.5s ease;
        }

        .product-card:hover img {
            transform: scale(1.1);
        }

        .product-badge {
            position: absolute;
            top: 12px;
            right: 12px;
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            color: white;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 700;
            z-index: 2;
            box-shadow: 0 4px 12px rgba(245, 87, 108, 0.3);
        }

        .product-body {
            padding: 20px;
            position: relative;
            z-index: 2;
        }

        .product-name {
            font-size: 16px;
            font-weight: 700;
            color: #2d3748;
            margin-bottom: 12px;
            min-height: 48px;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
            line-height: 1.5;
        }

        .product-price-section {
            margin-bottom: 16px;
            display: flex;
            align-items: baseline;
            gap: 8px;
        }

        .product-price {
            font-size: 20px;
            font-weight: 800;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .product-price-old {
            font-size: 14px;
            text-decoration: line-through;
            color: #a0aec0;
        }

        .product-actions {
            display: flex;
            gap: 8px;
        }

        .btn {
            border: none;
            border-radius: 12px;
            padding: 12px 16px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            text-decoration: none;
            transition: all 0.3s ease;
        }

        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            flex: 1;
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(102, 126, 234, 0.4);
        }

        .btn-outline {
            background: transparent;
            color: #667eea;
            border: 2px solid #667eea;
        }

        .btn-outline:hover {
            background: #667eea;
            color: white;
        }

        /* Highlight Product */
        .highlight-product {
            background: white;
            border-radius: 24px;
            overflow: hidden;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.12);
            display: grid;
            grid-template-columns: 400px 1fr;
            gap: 32px;
            padding: 32px;
            position: relative;
        }

        .highlight-product::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 5px;
            background: linear-gradient(90deg, #667eea 0%, #764ba2 50%, #f093fb 100%);
        }

        .highlight-image {
            position: relative;
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.1);
        }

        .highlight-product img {
            width: 100%;
            height: 360px;
            object-fit: cover;
        }

        .highlight-info {
            display: flex;
            flex-direction: column;
            justify-content: center;
            gap: 16px;
        }

        .highlight-info h2 {
            font-size: 28px;
            font-weight: 800;
            color: #1a202c;
            margin-bottom: 8px;
        }

        .highlight-info p {
            font-size: 15px;
            color: #4a5568;
            line-height: 1.7;
            margin-bottom: 8px;
        }

        .highlight-actions {
            display: flex;
            gap: 12px;
            margin-top: 8px;
        }

        /* Empty State */
        .empty-message {
            background: white;
            padding: 48px;
            border-radius: 20px;
            text-align: center;
            box-shadow: 0 4px 16px rgba(0, 0, 0, 0.08);
        }

        .empty-icon {
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, #fbd38d 0%, #f6ad55 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            font-size: 36px;
            color: white;
        }

        .empty-message p {
            font-size: 16px;
            color: #4a5568;
            line-height: 1.6;
        }

        .empty-message strong {
            color: #667eea;
            font-weight: 700;
        }

        /* Responsive */
        @media (max-width: 1024px) {
            .highlight-product {
                grid-template-columns: 1fr;
            }
            
            .product-grid {
                grid-template-columns: repeat(auto-fill, minmax(240px, 1fr));
            }
        }

        @media (max-width: 768px) {
            .search-header {
                padding: 24px;
            }

            .header-content {
                flex-direction: column;
                align-items: flex-start;
            }

            .search-title {
                flex-direction: column;
                align-items: flex-start;
            }

            .title-text h1 {
                font-size: 24px;
            }

            .product-grid {
                grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
                gap: 16px;
            }

            .highlight-product {
                padding: 20px;
                gap: 20px;
            }
        }

        /* Animation */
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .product-card {
            animation: fadeInUp 0.5s ease forwards;
        }

        .product-card:nth-child(1) { animation-delay: 0.1s; }
        .product-card:nth-child(2) { animation-delay: 0.2s; }
        .product-card:nth-child(3) { animation-delay: 0.3s; }
        .product-card:nth-child(4) { animation-delay: 0.4s; }
    </style>
</head>
<body>

<div class="page-wrapper">
    <!-- Header -->
    <div class="search-header">
        <div class="header-content">
            <div class="search-title">
                <div class="search-icon">
                    <i class="fas fa-search"></i>
                </div>
                <div class="title-text">
                    <h1>
                        Kết quả tìm kiếm
                        <c:if test="${not empty keyword}">
                            cho "<span class="keyword">${keyword}</span>"
                        </c:if>
                    </h1>
                    <div class="search-subtitle">Khám phá những sản phẩm phù hợp với bạn</div>
                </div>
            </div>
            <a href="${pageContext.request.contextPath}/home/index" class="back-link">
                <i class="fas fa-arrow-left"></i> Về trang chủ
            </a>
        </div>
    </div>

    <!-- Category Mode -->
    <c:if test="${mode == 'category'}">
        <c:if test="${not empty categories}">
            <div class="section">
                <div class="section-header">
                    <div class="section-icon">
                        <i class="fas fa-layer-group"></i>
                    </div>
                    <div class="section-title">Danh mục phù hợp</div>
                </div>
                <div class="category-list">
                    <c:forEach var="cat" items="${categories}">
                        <a class="category-chip" href="${pageContext.request.contextPath}/search?categoryId=${cat.id}">
                            <i class="fas fa-spa"></i> ${cat.name}
                        </a>
                    </c:forEach>
                </div>
            </div>
        </c:if>

        <c:if test="${not empty categoryProducts}">
            <div class="section">
                <div class="section-header">
                    <div class="section-icon">
                        <i class="fas fa-box-open"></i>
                    </div>
                    <div class="section-title">
                        <c:choose>
                            <c:when test="${not empty selectedCategory}">
                                Sản phẩm trong "${selectedCategory.name}"
                            </c:when>
                            <c:otherwise>
                                Sản phẩm trong danh mục
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <div class="product-grid">
                    <c:forEach var="p" items="${categoryProducts}">
                        <div class="product-card">
                            <div class="product-image-wrapper">
                                <a href="${pageContext.request.contextPath}/product/${p.id}">
                                    <img src="${pageContext.request.contextPath}/${p.mainImage}" alt="${p.name}">
                                </a>
                                <c:if test="${p.discountPrice != null}">
                                    <div class="product-badge">SALE</div>
                                </c:if>
                            </div>
                            <div class="product-body">
                                <div class="product-name">${p.name}</div>
                                <div class="product-price-section">
                                    <c:if test="${p.discountPrice != null}">
                                        <span class="product-price-old">
                                            <fmt:formatNumber value="${p.price}" type="number"/>đ
                                        </span>
                                    </c:if>
                                    <div class="product-price">
                                        <fmt:formatNumber value="${p.discountPrice != null ? p.discountPrice : p.price}" type="number"/>đ
                                    </div>
                                </div>
                                <div class="product-actions">
                                    <form action="${pageContext.request.contextPath}/cart/add" method="post" style="flex: 1;">
                                        <input type="hidden" name="productId" value="${p.id}">
                                        <input type="hidden" name="quantity" value="1">
                                        <button type="submit" class="btn btn-primary" style="width: 100%;">
                                            <i class="fas fa-cart-plus"></i> Thêm giỏ hàng
                                        </button>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </c:if>
    </c:if>

    <!-- Product Mode -->
    <c:if test="${mode == 'product'}">
        <c:if test="${not empty mainProduct}">
            <div class="section">
                <div class="section-header">
                    <div class="section-icon">
                        <i class="fas fa-star"></i>
                    </div>
                    <div class="section-title">Sản phẩm nổi bật</div>
                </div>
                <div class="highlight-product">
                    <div class="highlight-image">
                        <a href="${pageContext.request.contextPath}/product/${mainProduct.id}">
                            <img src="${pageContext.request.contextPath}/${mainProduct.mainImage}" alt="${mainProduct.name}">
                        </a>
                    </div>
                    <div class="highlight-info">
                        <h2>${mainProduct.name}</h2>
                        <p>${mainProduct.description}</p>
                        <div class="product-price-section">
                            <c:if test="${mainProduct.discountPrice != null}">
                                <span class="product-price-old">
                                    <fmt:formatNumber value="${mainProduct.price}" type="number"/>đ
                                </span>
                            </c:if>
                            <div class="product-price">
                                <fmt:formatNumber value="${mainProduct.discountPrice != null ? mainProduct.discountPrice : mainProduct.price}" type="number"/>đ
                            </div>
                        </div>
                        <div class="highlight-actions">
                            <form action="${pageContext.request.contextPath}/cart/add" method="post">
                                <input type="hidden" name="productId" value="${mainProduct.id}">
                                <input type="hidden" name="quantity" value="1">
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-cart-plus"></i> Thêm giỏ hàng
                                </button>
                            </form>
                            <a href="${pageContext.request.contextPath}/product/${mainProduct.id}" class="btn btn-outline">
                                <i class="fas fa-eye"></i> Xem chi tiết
                            </a>
                        </div>
                    </div>
                </div>
            </div>

            <c:if test="${not empty relatedProducts}">
                <div class="section">
                    <div class="section-header">
                        <div class="section-icon">
                            <i class="fas fa-heart"></i>
                        </div>
                        <div class="section-title">Sản phẩm liên quan</div>
                    </div>
                    <div class="product-grid">
                        <c:forEach var="p" items="${relatedProducts}">
                            <div class="product-card">
                                <div class="product-image-wrapper">
                                    <a href="${pageContext.request.contextPath}/product/${p.id}">
                                        <img src="${pageContext.request.contextPath}/${p.mainImage}" alt="${p.name}">
                                    </a>
                                    <c:if test="${p.discountPrice != null}">
                                        <div class="product-badge">SALE</div>
                                    </c:if>
                                </div>
                                <div class="product-body">
                                    <div class="product-name">${p.name}</div>
                                    <div class="product-price-section">
                                        <c:if test="${p.discountPrice != null}">
                                            <span class="product-price-old">
                                                <fmt:formatNumber value="${p.price}" type="number"/>đ
                                            </span>
                                        </c:if>
                                        <div class="product-price">
                                            <fmt:formatNumber value="${p.discountPrice != null ? p.discountPrice : p.price}" type="number"/>đ
                                        </div>
                                    </div>
                                    <div class="product-actions">
                                        <form action="${pageContext.request.contextPath}/cart/add" method="post" style="flex: 1;">
                                            <input type="hidden" name="productId" value="${p.id}">
                                            <input type="hidden" name="quantity" value="1">
                                            <button type="submit" class="btn btn-primary" style="width: 100%;">
                                                <i class="fas fa-cart-plus"></i> Thêm giỏ hàng
                                            </button>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </c:if>
        </c:if>

        <c:if test="${empty mainProduct and not empty products}">
            <div class="section">
                <div class="section-header">
                    <div class="section-icon">
                        <i class="fas fa-box-open"></i>
                    </div>
                    <div class="section-title">Sản phẩm phù hợp</div>
                </div>
                <div class="product-grid">
                    <c:forEach var="p" items="${products}">
                        <div class="product-card">
                            <div class="product-image-wrapper">
                                <a href="${pageContext.request.contextPath}/product/${p.id}">
                                    <img src="${pageContext.request.contextPath}/${p.mainImage}" alt="${p.name}">
                                </a>
                                <c:if test="${p.discountPrice != null}">
                                    <div class="product-badge">SALE</div>
                                </c:if>
                            </div>
                            <div class="product-body">
                                <div class="product-name">${p.name}</div>
                                <div class="product-price-section">
                                    <c:if test="${p.discountPrice != null}">
                                        <span class="product-price-old">
                                            <fmt:formatNumber value="${p.price}" type="number"/>đ
                                        </span>
                                    </c:if>
                                    <div class="product-price">
                                        <fmt:formatNumber value="${p.discountPrice != null ? p.discountPrice : p.price}" type="number"/>đ
                                    </div>
                                </div>
                                <div class="product-actions">
                                    <form action="${pageContext.request.contextPath}/cart/add" method="post" style="flex: 1;">
                                        <input type="hidden" name="productId" value="${p.id}">
                                        <input type="hidden" name="quantity" value="1">
                                        <button type="submit" class="btn btn-primary" style="width: 100%;">
                                            <i class="fas fa-cart-plus"></i> Thêm giỏ hàng
                                        </button>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </c:if>
    </c:if>

    <!-- Empty State -->
    <c:if test="${mode == 'none' || (empty categories and empty products and empty categoryProducts)}">
        <div class="section">
            <div class="empty-message">
                <div class="empty-icon">
                    <i class="fas fa-search"></i>
                </div>
                <p>
                    Không tìm thấy kết quả phù hợp
                    <c:if test="${not empty keyword}">
                        với từ khóa "<strong>${keyword}</strong>"
                    </c:if>
                    <br>
                    Vui lòng thử lại với từ khóa khác hoặc khám phá các danh mục sản phẩm của chúng tôi.
                </p>
            </div>
        </div>
    </c:if>
</div>

</body>
</html>