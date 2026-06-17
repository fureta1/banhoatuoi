<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="activePage" value="contacts" />
<%@ include file="_sidebar.jsp" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý phản hồi & liên hệ</title>
    <style>
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #f5f5f5;
        }

        /* Cách sidebar (230px) thêm 20px */
        .admin-content {
            margin-left: 250px;
            padding: 24px;
        }

        .page-title {
            font-size: 22px;
            font-weight: bold;
            margin-bottom: 6px;
            color: #333;
        }

        .page-subtitle {
            font-size: 13px;
            color: #777;
            margin-bottom: 18px;
        }

        .card {
            background: #fff;
            border-radius: 10px;
            border: 1px solid #ddd;
            padding: 16px 18px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.04);
        }

        .filter-bar {
            display: flex;
            gap: 10px;
            margin-bottom: 12px;
            align-items: center;
            flex-wrap: wrap;
        }

        .filter-bar input[type="text"],
        .filter-bar select {
            padding: 6px 8px;
            border-radius: 6px;
            border: 1px solid #ccc;
            font-size: 13px;
        }

        .filter-bar button {
            padding: 7px 12px;
            border-radius: 6px;
            border: none;
            background: #4B6CB7;
            color: #fff;
            font-size: 13px;
            cursor: pointer;
        }

        .filter-bar button:hover {
            background: #3b58a0;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            font-size: 13px;
            margin-top: 8px;
        }

        th, td {
            padding: 8px 10px;
            border-bottom: 1px solid #eee;
            text-align: left;
        }

        th {
            background: #f0f3ff;
            font-weight: 600;
            color: #333;
        }

        tr:hover td {
            background: #fafafa;
        }

        .status-badge {
            display: inline-block;
            padding: 3px 10px;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 600;
        }

        .badge-new {
            background: #ffe5e5;
            color: #c0392b;
        }

        .badge-processing {
            background: #fff4e1;
            color: #d35400;
        }

        .badge-resolved {
            background: #e5ffe9;
            color: #27ae60;
        }

        .btn-link {
            font-size: 13px;
            color: #4B6CB7;
            text-decoration: none;
        }

        .btn-link:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

<div class="admin-content">
    <div class="page-title">📩 Quản lý phản hồi & liên hệ</div>
    <div class="page-subtitle">Xem, tìm kiếm và xử lý các phản hồi/ liên hệ từ khách hàng.</div>

    <div class="card">

        <!-- FORM LỌC / TÌM KIẾM -->
        <form action="${pageContext.request.contextPath}/admin/contacts" method="get" class="filter-bar">

            <input type="text" name="keyword"
                   placeholder="Tìm theo tên, email, chủ đề..."
                   value="${keyword != null ? keyword : ''}" />

            <select name="status">
                <option value="">Tất cả trạng thái</option>
                <option value="new" ${status == 'new' ? 'selected' : ''}>Mới</option>
                <option value="processing" ${status == 'processing' ? 'selected' : ''}>Đang xử lý</option>
                <option value="resolved" ${status == 'resolved' ? 'selected' : ''}>Đã xử lý</option>
            </select>

            <select name="rating">
                <option value="">Tất cả số sao</option>
                <option value="1" ${rating == 1 ? 'selected' : ''}>1 sao</option>
                <option value="2" ${rating == 2 ? 'selected' : ''}>2 sao</option>
                <option value="3" ${rating == 3 ? 'selected' : ''}>3 sao</option>
                <option value="4" ${rating == 4 ? 'selected' : ''}>4 sao</option>
                <option value="5" ${rating == 5 ? 'selected' : ''}>5 sao</option>
            </select>

            <button type="submit">Lọc</button>
        </form>

        <!-- BẢNG DANH SÁCH -->
        <table>
            <thead>
            <tr>
                <th>Mã</th>
                <th>Khách hàng</th>
                <th>Email</th>
                <th>Chủ đề</th>
                <th>Số sao</th>
                <th>Trạng thái</th>
                <th>Ngày gửi</th>
                <th></th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="c" items="${contacts}">
                <tr>
                    <td>#${c.contactId}</td>
                    <td>${c.fullName}</td>
                    <td>${c.email}</td>
                    <td>${c.subject}</td>

                    <!-- CỘT SỐ SAO -->
                    <td>
                        <c:choose>
                            <c:when test="${c.rating == null}">
                                -
                            </c:when>
                            <c:otherwise>
                                ${c.rating} ⭐
                            </c:otherwise>
                        </c:choose>
                    </td>

                    <!-- CỘT TRẠNG THÁI -->
                    <td>
                        <c:choose>
                            <c:when test="${c.status == 'new'}">
                                <span class="status-badge badge-new">Mới</span>
                            </c:when>
                            <c:when test="${c.status == 'processing'}">
                                <span class="status-badge badge-processing">Đang xử lý</span>
                            </c:when>
                            <c:otherwise>
                                <span class="status-badge badge-resolved">Đã xử lý</span>
                            </c:otherwise>
                        </c:choose>
                    </td>

                    <td>${c.createdAt}</td>

                    <td>
                        <a class="btn-link"
                           href="${pageContext.request.contextPath}/admin/contacts/detail?id=${c.contactId}">
                            Xem chi tiết
                        </a>
                    </td>
                </tr>
            </c:forEach>

            <c:if test="${empty contacts}">
                <tr>
                    <td colspan="8" style="text-align: center; color: #999;">
                        Chưa có liên hệ nào.
                    </td>
                </tr>
            </c:if>
            </tbody>
        </table>
    </div>
</div>

</body>
</html>
