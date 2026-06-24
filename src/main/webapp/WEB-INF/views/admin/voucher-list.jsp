<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Quản lý mã giảm giá</title>
    <style>
        body { margin: 0; font-family: Arial, sans-serif; background: #f5f5f5; }
        .layout { display: flex; min-height: 100vh; }
        .sidebar { width: 220px; background: #1f2937; color: #fff; padding: 15px 0; }
        .sidebar h2 { margin: 0 15px 20px 15px; font-size: 18px; }
        .menu a { display: block; padding: 10px 15px; color: #e5e7eb; text-decoration: none; font-size: 14px; }
        .menu a:hover, .menu a.active { background: #111827; color: #fff; }

        .main { flex: 1; padding: 20px; }
        .page-title { font-size: 20px; margin-bottom: 15px; }

        table { border-collapse: collapse; width: 100%; background: #fff; font-size: 13px; border-radius: 6px; overflow: hidden; }
        th, td { border: 1px solid #ddd; padding: 6px 8px; text-align: left; }
        th { background: #f3f4f6; }
        .status-active { color: green; font-weight: bold; }
        .status-inactive { color: gray; font-weight: bold; }
        .actions a { text-decoration: none; color: #2563eb; margin-right: 8px; }
        .actions a:hover { text-decoration: underline; }
        button { background: #1f2937; color:white; border:none; border-radius:4px; padding:5px 10px; cursor:pointer; }
        button:hover { background:#374151; }
    </style>
</head>
<body>
<div class="layout">
    <div class="sidebar">
    <h2>Flower Admin</h2>
    <div class="menu">
        <a href="${pageContext.request.contextPath}/admin/dashboard"
           class="${pageContext.request.requestURI.endsWith('/dashboard') ? 'active' : ''}">
            Dashboard
        </a>

        <a href="${pageContext.request.contextPath}/admin/categories"
           class="${pageContext.request.requestURI.contains('/categories') ? 'active' : ''}">
            Danh mục hoa
        </a>

        <a href="${pageContext.request.contextPath}/admin/products"
           class="${pageContext.request.requestURI.contains('/products') ? 'active' : ''}">
            Sản phẩm
        </a>

        <a href="${pageContext.request.contextPath}/admin/orders"
           class="${pageContext.request.requestURI.contains('/orders') ? 'active' : ''}">
            Quản lý đơn hàng
        </a>

        <a href="${pageContext.request.contextPath}/admin/customers"
           class="${pageContext.request.requestURI.contains('/customers') ? 'active' : ''}">
            Khách hàng
        </a>

        <a href="${pageContext.request.contextPath}/admin/contacts"
           class="${pageContext.request.requestURI.contains('/contacts') ? 'active' : ''}">
            Phản hồi & Liên hệ
        </a>

        <a href="${pageContext.request.contextPath}/admin/vouchers"
           class="${pageContext.request.requestURI.contains('/vouchers') ? 'active' : ''}">
            Mã giảm giá
        </a>

        <a href="${pageContext.request.contextPath}/admin/reports"
           class="${pageContext.request.requestURI.contains('/reports') ? 'active' : ''}">
            Thống kê doanh thu
        </a>

        <a href="${pageContext.request.contextPath}/auth/logout">Đăng xuất</a>
    </div>
</div>


    <div class="main">
        <div class="page-title">Quản lý mã giảm giá</div>

        <table>
            <thead>
            <tr>
                <th>ID</th>
                <th>Mã</th>
                <th>Mô tả</th>
                <th>Loại</th>
                <th>Giá trị</th>
                <th>Đơn tối thiểu</th>
                <th>Tối đa</th>
                <th>Đã dùng</th>
                <th>Giới hạn</th>
                <th>Bắt đầu</th>
                <th>Kết thúc</th>
                <th>Trạng thái</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="v" items="${vouchers}">
                <tr>
                    <td>${v.voucherId}</td>
                    <td>${v.code}</td>
                    <td>${v.description}</td>
                    <td>
                        <c:choose>
                            <c:when test="${v.discountType == 'percentage'}">%</c:when>
                            <c:otherwise>VND</c:otherwise>
                        </c:choose>
                    </td>
                    <td>${v.discountValue}</td>
                    <td>${v.minOrderValue}</td>
                    <td>
                        <c:choose>
                            <c:when test="${empty v.maxDiscount}">–</c:when>
                            <c:otherwise>${v.maxDiscount}</c:otherwise>
                        </c:choose>
                    </td>
                    <td>${v.usedCount}</td>
                    <td>${v.usageLimit}</td>
                    <td>${v.startDate}</td>
                    <td>${v.endDate}</td>
                    <td>
                        <c:choose>
                            <c:when test="${v.status == 'active'}">
                                <span class="status-active">Kích hoạt</span>
                            </c:when>
                            <c:otherwise>
                                <span class="status-inactive">Ngừng</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty vouchers}">
                <tr><td colspan="12" style="text-align:center;">Không có mã giảm giá nào</td></tr>
            </c:if>
            </tbody>
        </table>
    </div>
</div>
</body>
</html>

