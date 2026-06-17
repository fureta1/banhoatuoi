<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý khách hàng</title>
    <style>
        body { 
            font-family: Arial, sans-serif; 
            margin: 0; 
            padding: 0; 
        }

        /* Dịch nội dung sang phải thêm 20px (220 → 240) */
        .admin-content { 
            margin-left: 260px; 
            padding: 20px; 
        }

        h1 { 
            color: #333; 
            margin-bottom: 20px; 
        }

        table { 
            width: 100%; 
            border-collapse: collapse; 
        }

        /* Ô trong bảng để to vừa đủ trang (padding bình thường) */
        th, td { 
            padding: 10px; 
            border: 1px solid #ddd; 
            text-align: left; 
        }

        th { 
            background-color: #f2f2f2; 
        }

        tr:nth-child(even) { 
            background-color: #fafafa; 
        }

        .success { color: green; }
        .error { color: red; }

        select { padding: 3px; }

        .search-box input { 
            padding: 6px; 
            width: 250px; 
        }

        .search-box button { 
            padding: 6px 10px; 
        }
    </style>
</head>
<body>

<jsp:include page="_sidebar.jsp"/>

<div class="admin-content">
    <h1>Quản lý khách hàng</h1>

    <c:if test="${not empty message}">
        <p class="success">${message}</p>
    </c:if>
    <c:if test="${not empty error}">
        <p class="error">${error}</p>
    </c:if>

    <form class="search-box" method="get" action="${pageContext.request.contextPath}/admin/customers">
        <input type="text" name="keyword" value="${keyword}" placeholder="Tìm theo tên, email hoặc SĐT...">
        <button type="submit">Tìm kiếm</button>
        <c:if test="${not empty keyword}">
            <a href="${pageContext.request.contextPath}/admin/customers">Xóa lọc</a>
        </c:if>
    </form>

    <table>
        <thead>
        <tr>
            <th>ID</th>
            <th>Họ tên</th>
            <th>Email</th>
            <th>SĐT</th>
            <th>Vai trò</th>
            <th>Trạng thái</th>
            <th>Ngày tạo</th>
            <th>Thao tác</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="u" items="${customers}">
            <tr>
                <td>${u.id}</td>
                <td>${u.fullName}</td>
                <td>${u.email}</td>
                <td>${u.phone}</td>
                <td>${u.role}</td>
                <td>
                    <c:choose>
                        <c:when test="${u.status == 'active'}">
                            <span style="color:green;">${u.status}</span>
                        </c:when>
                        <c:when test="${u.status == 'blocked'}">
                            <span style="color:red;">${u.status}</span>
                        </c:when>
                        <c:otherwise>${u.status}</c:otherwise>
                    </c:choose>
                </td>
                <td>${u.createdAt}</td>
                <td>
                    <a href="${pageContext.request.contextPath}/admin/customers/${u.id}">Xem</a>
                    <form action="${pageContext.request.contextPath}/admin/customers/${u.id}/status"
                          method="post" style="display:inline;">
                        <select name="status" onchange="this.form.submit()">
                            <option value="active" ${u.status == 'active' ? 'selected' : ''}>active</option>
                            <option value="inactive" ${u.status == 'inactive' ? 'selected' : ''}>inactive</option>
                            <option value="blocked" ${u.status == 'blocked' ? 'selected' : ''}>blocked</option>
                        </select>
                    </form>
                </td>
            </tr>
        </c:forEach>

        <c:if test="${empty customers}">
            <tr>
                <td colspan="8" style="text-align:center;">Không có khách hàng.</td>
            </tr>
        </c:if>
        </tbody>
    </table>
</div>

</body>
</html>
