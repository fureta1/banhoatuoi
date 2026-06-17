<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý sản phẩm</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; padding: 0; }

        /* Dịch nội dung sang phải thêm 20px (220 → 240) */
        .admin-content { margin-left: 260px; padding: 20px; }

        h1 { color: #333; margin-bottom: 20px; }
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 10px; border: 1px solid #ddd; text-align: left; }
        th { background-color: #f2f2f2; }
        tr:nth-child(even) { background-color: #fafafa; }
        .success { color: green; }
        .error { color: red; }
        .search-box input { padding: 6px; width: 250px; }
        .search-box button, .btn { padding: 6px 10px; }
        .thumb { width: 48px; height: 48px; object-fit: cover; border-radius: 6px; background:#eee; }
        .inline-form { display: inline-flex; gap: 6px; align-items: center; }
        .inline-form input[type="number"] { width: 80px; padding: 6px; }
        .actions a { margin-right: 8px; }
        .toolbar { margin: 12px 0 18px; display: flex; gap: 10px; align-items: center; }
        .pill { background:#4caf50; color:#fff; text-decoration:none; padding:7px 10px; border-radius:4px; }
        .status-available { color: green; font-weight: 600; }
        .status-out { color: #d00000; font-weight: 600; }
        .status-discontinued { color: #666; font-weight: 600; }
    </style>
</head>
<body>

<jsp:include page="_sidebar.jsp"/>

<div class="admin-content">
    <h1>Quản lý sản phẩm</h1>

    <c:if test="${not empty message}">
        <p class="success">${message}</p>
    </c:if>
    <c:if test="${not empty error}">
        <p class="error">${error}</p>
    </c:if>

    <div class="toolbar">
        <form class="search-box" method="get" action="${pageContext.request.contextPath}/admin/products">
            <input type="text" name="keyword" value="${keyword}" placeholder="Tìm theo tên, danh mục...">
            <button type="submit">Tìm kiếm</button>
            <c:if test="${not empty keyword}">
                <a href="${pageContext.request.contextPath}/admin/products">Xóa lọc</a>
            </c:if>
        </form>
        <a class="pill" href="${pageContext.request.contextPath}/admin/products/add">+ Thêm sản phẩm</a>
    </div>

    <table>
        <thead>
        <tr>
            <th>ID</th>
            <th>Ảnh</th>
            <th>Tên sản phẩm</th>
            <th>Danh mục</th>
            <th>Giá</th>
            <th>Tồn kho</th>
            <th>Trạng thái</th>
            <th>Thao tác</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="p" items="${products}">
            <tr>
                <td>${p.id}</td>
                <td>
                    <c:choose>
                        <c:when test="${not empty p.mainImage}">
                            <img class="thumb" src="${pageContext.request.contextPath}/${p.mainImage}" alt="${p.name}">
                        </c:when>
                        <c:otherwise>
                            <div class="thumb"></div>
                        </c:otherwise>
                    </c:choose>
                </td>
                <td>${p.name}</td>
                <td><c:out value="${p.category != null ? p.category.name : '—'}"/></td>
                <td>
                    <c:choose>
                        <c:when test="${p.discountPrice != null}">
                            <del>${p.price}</del> <b>${p.discountPrice}</b>
                        </c:when>
                        <c:otherwise>${p.price}</c:otherwise>
                    </c:choose>
                </td>
                <td>
                    <form class="inline-form" method="post"
                          action="${pageContext.request.contextPath}/admin/products/${p.id}/stock">
                        <input type="number" min="0" name="stockQuantity" value="${p.stockQuantity}">
                        <button type="submit" class="btn">Lưu</button>
                    </form>
                </td>
                <td>
                    <c:choose>
                        <c:when test="${p.status == 'available'}"><span class="status-available">Đang bán</span></c:when>
                        <c:when test="${p.status == 'out_of_stock'}"><span class="status-out">Hết hàng</span></c:when>
                        <c:otherwise><span class="status-discontinued">Ngừng bán</span></c:otherwise>
                    </c:choose>
                </td>
                <td class="actions">
                    <a href="${pageContext.request.contextPath}/admin/products/edit/${p.id}">Sửa</a>
                    <a href="${pageContext.request.contextPath}/admin/products/delete/${p.id}"
                       onclick="return confirm('Xóa sản phẩm này?');">Xóa</a>
                </td>
            </tr>
        </c:forEach>

        <c:if test="${empty products}">
            <tr>
                <td colspan="8" style="text-align:center;">Không có sản phẩm.</td>
            </tr>
        </c:if>
        </tbody>
    </table>
</div>

</body>
</html>
