<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Quản lý banner</title>

    <style>
        body {
            margin:0;
            font-family:Arial, sans-serif;
            background:#f4f4f4;
        }

        .fs-main {
            margin-left: 210px;
            padding: 25px 30px 25px 60px;
        }

        .page-title {
            font-size: 26px;
            font-weight: bold;
            margin-bottom: 20px;
            color:#333;
        }

        .box {
            background:#fff;
            border-radius:10px;
            padding:20px;
            box-shadow:0 2px 8px rgba(0,0,0,0.08);
        }

        h3 {
            margin-top:0;
            margin-bottom:15px;
            font-size:20px;
        }

        table {
            width:100%;
            border-collapse:collapse;
            font-size:14px;
            background:white;
        }

        table tr:hover {
            background: #f7f7f7;
        }

        th, td {
            padding:10px;
            border-bottom:1px solid #eee;
            text-align:left;
        }

        th {
            background:#f0f0f0;
            font-weight:bold;
        }

        .thumb {
            width: 160px;
            height: 70px;
            object-fit: cover;
            border-radius:10px;
            background:#ddd;
        }

        .table-link {
            text-decoration:none;
            color:#333;
            font-weight:600;
            font-size:13px;
        }

        .table-link:hover {
            text-decoration:underline;
        }

        .table-link-danger {
            color:#d01a5a;
            font-weight:bold;
            text-decoration:none;
            font-size:13px;
        }

        .table-link-danger:hover {
            text-decoration:underline;
        }

        .btn-primary {
            padding:8px 14px;
            background:#4B6CB7;
            color:white;
            border-radius:6px;
            text-decoration:none;
            font-size:14px;
        }

        .btn-primary:hover {
            background:#3b58a0;
        }

        .msg-success {
            color:green;
            font-size:14px;
            margin-bottom:10px;
        }

        .msg-error {
            color:#d01a5a;
            font-size:14px;
            margin-bottom:10px;
        }
    </style>
</head>

<body>

<c:set var="activePage" value="banners"/>
<jsp:include page="/WEB-INF/views/admin/_sidebar.jsp"/>

<div class="fs-main">

    <div class="page-title">Quản lý banner</div>

    <c:if test="${not empty successMessage}">
        <div class="msg-success">${successMessage}</div>
    </c:if>
    <c:if test="${not empty errorMessage}">
        <div class="msg-error">${errorMessage}</div>
    </c:if>

    <div class="box">

        <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:15px;">
            <h3 style="margin:0;">Danh sách banner</h3>

            <a href="${pageContext.request.contextPath}/admin/banners/create"
               class="btn-primary">
                + Thêm banner
            </a>
        </div>

        <table>
            <tr>
                <th>ID</th>
                <th>Ảnh</th>
                <th>Tiêu đề</th>
                <th>Link</th>
                <th>Thứ tự</th>
                <th>Trạng thái</th>
                <th>Thời gian</th>
                <th></th>
            </tr>

            <c:choose>
                <c:when test="${not empty banners}">
                    <c:forEach var="b" items="${banners}">
                        <tr>
                            <td>${b.bannerId}</td>

                            <td>
                                <c:choose>
                                    <c:when test="${not empty b.imageUrl}">
                                        <img src="${pageContext.request.contextPath}/images/banners/${b.imageUrl}"
                                             class="thumb" alt="${b.title}">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="thumb"></div>
                                    </c:otherwise>
                                </c:choose>
                            </td>

                            <td>${b.title}</td>
                            <td style="max-width:200px; word-break:break-all;">${b.linkUrl}</td>
                            <td>${b.displayOrder}</td>
                            <td>${b.status}</td>

                            <td style="font-size:12px;">
                                <c:if test="${b.startDate != null}">
                                    Từ: ${b.startDate}
                                </c:if>
                                <br/>
                                <c:if test="${b.endDate != null}">
                                    Đến: ${b.endDate}
                                </c:if>
                            </td>

                            <td>
                                <a class="table-link"
                                   href="${pageContext.request.contextPath}/admin/banners/edit/${b.bannerId}">
                                    Sửa
                                </a>
                                &nbsp;|&nbsp;
                                <form action="${pageContext.request.contextPath}/admin/banners/delete"
                                      method="post"
                                      style="display:inline;"
                                      onsubmit="return confirm('Xóa banner này?');">
                                    <input type="hidden" name="id" value="${b.bannerId}">
                                    <button type="submit"
                                            style="background:none;border:none;padding:0;margin:0;cursor:pointer;"
                                            class="table-link-danger">
                                        Xóa
                                    </button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </c:when>

                <c:otherwise>
                    <tr>
                        <td colspan="8" style="text-align:center; padding:20px; color:#999;">
                            Chưa có banner nào.
                        </td>
                    </tr>
                </c:otherwise>
            </c:choose>

        </table>

    </div>
</div>

</body>
</html>


