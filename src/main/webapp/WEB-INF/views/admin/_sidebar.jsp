<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<link rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"
      crossorigin="anonymous" referrerpolicy="no-referrer" />

<style>
    .sidebar {
        position: fixed;
        top: 0;
        left: 0;
        width: 230px;             /* sidebar nhỏ lại */
        height: 100vh;
        background: linear-gradient(180deg, #4B6CB7 0%, #8E54E9 100%);
        padding: 22px 18px;
        box-shadow: 3px 0 12px rgba(0,0,0,0.25);
        color: white;
        font-family: "Segoe UI", Arial, sans-serif;
        z-index: 999;
    }

    .sidebar-title {
        font-size: 22px;
        font-weight: 700;
        margin-bottom: 6px;
    }

    .sidebar-subtitle {
        font-size: 14px;
        opacity: 0.9;
        margin-bottom: 20px;
    }

    .menu {
        display: flex;
        flex-direction: column;
        gap: 10px;
    }

    .menu a {
        display: flex;
        align-items: center;
        gap: 12px;
        padding: 10px 12px;
        border-radius: 10px;
        text-decoration: none;
        font-size: 16px; /* chữ to hơn */
        color: white;
        transition: 0.25s;
    }

    .menu a:hover {
        background: rgba(255,255,255,0.25);
        padding-left: 18px;
    }

    .menu a.active {
        background: rgba(255,255,255,0.45);
        color: #1b2550;
        font-weight: 700;
    }

    /* logout */
    .menu a.logout {
        margin-top: 20px;
        background: #ff4d4d;
        text-align: center;
        font-weight: bold;
    }

    .menu a.logout:hover {
        background: #ff2020;
    }
</style>

<div class="sidebar">
    <div class="sidebar-title">Flower Shop</div>
    <div class="sidebar-subtitle">Quản trị hệ thống</div>

    <div class="menu">

        <a href="${pageContext.request.contextPath}/admin/dashboard"
           class="${activePage == 'dashboard' ? 'active' : ''}">
            <i class="fa-solid fa-gauge"></i> Tổng quan
        </a>

        <a href="${pageContext.request.contextPath}/admin/categories"
           class="${activePage == 'categories' ? 'active' : ''}">
            <i class="fa-solid fa-list"></i> Danh mục hoa
        </a>

        <a href="${pageContext.request.contextPath}/admin/products"
           class="${activePage == 'products' ? 'active' : ''}">
            <i class="fa-solid fa-box"></i> Sản phẩm
        </a>

        <!-- MỤC MỚI: Quản lý banner -->
        <a href="${pageContext.request.contextPath}/admin/banners"
           class="${activePage == 'banners' ? 'active' : ''}">
            <i class="fa-solid fa-image"></i> Banner
        </a>

        <a href="${pageContext.request.contextPath}/admin/orders"
           class="${activePage == 'orders' ? 'active' : ''}">
            <i class="fa-solid fa-cart-shopping"></i> Đơn hàng
        </a>

        <a href="${pageContext.request.contextPath}/admin/customers"
           class="${activePage == 'customers' ? 'active' : ''}">
            <i class="fa-solid fa-users"></i> Khách hàng
        </a>

        <a href="${pageContext.request.contextPath}/admin/contacts"
           class="${activePage == 'contacts' ? 'active' : ''}">
            <i class="fa-solid fa-comments"></i> Phản hồi
        </a>

        <a href="${pageContext.request.contextPath}/admin/revenue"
           class="${activePage == 'revenue' ? 'active' : ''}">
            <i class="fa-solid fa-chart-line"></i> Doanh thu
        </a>

        <a href="${pageContext.request.contextPath}/auth/logout" class="logout">
            <i class="fa-solid fa-right-from-bracket"></i> Đăng xuất
        </a>
    </div>
</div>
