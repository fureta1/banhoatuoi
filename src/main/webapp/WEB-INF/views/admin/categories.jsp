<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
<title>Quản lý danh mục hoa</title>

<style>
    body {
        margin:0;
        font-family:Arial, sans-serif;
        background:#f4f4f4;
    }

    .fs-main {
        margin-left: 210px;
        padding: 25px 30px 25px 60px;  /* dịch phải 60px */
    }

    .page-title {
        font-size: 26px;
        font-weight: bold;
        margin-bottom: 20px;
        color:#333;
    }

    .content-grid {
        display: flex;
        gap: 25px;
        align-items:flex-start;
    }

    .box {
        background:#fff;
        border-radius:10px;
        padding:20px;
        box-shadow:0 2px 8px rgba(0,0,0,0.08);
    }

    .w40 { width: 38%; }
    .w60 { width: 60%; }

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
        width: 96px;
        height: 96px;
        object-fit: cover;
        border-radius:12px;
        background:#ddd;
    }

    .table-link {
        text-decoration:none;
        color:#333;
        font-weight:600;
    }

    .table-link:hover {
        text-decoration:underline;
    }

    .table-link-danger {
        color:#d01a5a;
        font-weight:bold;
        text-decoration:none;
    }

    .table-link-danger:hover {
        text-decoration:underline;
    }

    input[type="text"], textarea, select {
        width:100%;
        padding:8px;
        border-radius:6px;
        border:1px solid #ccc;
        font-size:14px;
        margin-top:5px;
    }

    button {
        padding:10px 18px;
        border:none;
        background:#4B6CB7;
        color:white;
        border-radius:8px;
        font-size:15px;
        cursor:pointer;
        margin-top:10px;
    }

    button:hover {
        background:#3b58a0;
    }

    /* Gợi ý tìm kiếm */
    .search-wrapper {
        position:relative;
        margin-bottom:12px;
    }

    .suggest-box {
        position:absolute;
        background:white;
        border:1px solid #ccc;
        width:90%;
        display:none;
        max-height:220px;
        overflow-y:auto;
        z-index:20;
    }

    .suggest-item {
        padding:8px;
        cursor:pointer;
    }

    .suggest-item:hover {
        background:#eee;
    }
</style>

</head>

<body>

<c:set var="activePage" value="categories"/>
<jsp:include page="/WEB-INF/views/admin/_sidebar.jsp"/>

<div class="fs-main">

    <div class="page-title">Quản lý danh mục hoa</div>

    <c:if test="${not empty message}">
        <div style="color:green; font-size:14px; margin-bottom:10px;">
            ${message}
        </div>
    </c:if>

    <div class="content-grid">

        <!-- ================= DANH SÁCH DANH MỤC ================= -->
        <div class="box w40">

            <div style="display:flex; justify-content:space-between; align-items:center;">
                <h3 style="margin:0;">Danh mục hiện có</h3>

                <a href="${pageContext.request.contextPath}/admin/categories"
                   style="padding:8px 14px; background:#4B6CB7; color:white;
                          border-radius:6px; text-decoration:none; font-size:14px;">
                    + Thêm danh mục
                </a>
            </div>

            <!-- Thanh tìm kiếm -->
            <div class="search-wrapper" style="margin-top:12px;">
                <form action="${pageContext.request.contextPath}/admin/categories"
                      method="get" style="display:flex; gap:8px;">

                    <input type="text" name="q" id="categorySearchInput"
                           value="${keyword}"
                           placeholder="Tìm danh mục..."
                           autocomplete="off"
                           style="flex:1;">

                    <button type="submit"
                            style="padding:10px 15px; background:#4B6CB7; border:none;
                                   color:white; border-radius:6px; cursor:pointer;">
                        Tìm
                    </button>
                </form>

                <div id="suggestBox" class="suggest-box"></div>
            </div>

            <!-- Bảng danh mục -->
            <table>
                <tr>
                    <th>ID</th>
                    <th>Ảnh</th>
                    <th>Tên</th>
                    <th>Trạng thái</th>
                    <th></th>
                </tr>

                <c:choose>

                    <c:when test="${not empty categories}">
                        <c:forEach var="c" items="${categories}">
                            <tr>
                                <td>${c.id}</td>

                                <td>
                                    <c:choose>
                                        <c:when test="${not empty c.imageUrl}">
                                            <img src="${pageContext.request.contextPath}/${c.imageUrl}" class="thumb">
                                        </c:when>
                                        <c:otherwise>
                                            <div class="thumb" style="background:#ccc;"></div>
                                        </c:otherwise>
                                    </c:choose>
                                </td>

                                <td>
                                    <a class="table-link"
                                       href="${pageContext.request.contextPath}/admin/categories?id=${c.id}">
                                        ${c.name}
                                    </a>
                                </td>

                                <td>${c.status}</td>

                                <td>
                                    <a class="table-link-danger"
                                       onclick="return confirm('Xóa danh mục này?')"
                                       href="${pageContext.request.contextPath}/admin/category/delete/${c.id}">
                                        Xóa
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>

                    <c:otherwise>
                        <tr>
                            <td colspan="5" style="text-align:center; padding:20px; color:#999;">
                                Không tìm thấy danh mục nào
                            </td>
                        </tr>
                    </c:otherwise>

                </c:choose>

            </table>

        </div>

        <!-- ============= FORM + DANH SÁCH SẢN PHẨM ============== -->
        <div class="box w60">

            <h3>
                <c:choose>
                    <c:when test="${category.id != null}">
                        Sửa danh mục: ${category.name}
                    </c:when>
                    <c:otherwise>Thêm danh mục mới</c:otherwise>
                </c:choose>
            </h3>

            <form action="${pageContext.request.contextPath}/admin/category/save"
                  method="post" enctype="multipart/form-data">

                <c:if test="${category.id != null}">
                    <input type="hidden" name="id" value="${category.id}"/>
                </c:if>

                <label>Tên danh mục:</label>
                <input type="text" name="name" value="${category.name}" required/>

                <label>Mô tả:</label>
                <textarea name="description" rows="3">${category.description}</textarea>

                <label>Ảnh danh mục:</label>
                <input type="file" name="imageFile" accept="image/*"/>

                <c:if test="${not empty category.imageUrl}">
                    <br>
                    <img src="${pageContext.request.contextPath}/${category.imageUrl}"
                         style="width:120px;height:120px;border-radius:12px;margin-top:8px;">
                </c:if>

                <label>Trạng thái:</label>
                <select name="status">
                    <option value="active" ${category.status=='active'?'selected':''}>active</option>
                    <option value="inactive" ${category.status=='inactive'?'selected':''}>inactive</option>
                </select>

                <button type="submit">Lưu</button>
            </form>

            <c:if test="${not empty productsInCategory}">
                <hr style="margin:25px 0;">
                <h3>Sản phẩm thuộc danh mục</h3>

                <table>
                    <tr>
                        <th>ID</th>
                        <th>Tên SP</th>
                        <th>Giá</th>
                        <th>Trạng thái</th>
                    </tr>

                    <c:forEach var="p" items="${productsInCategory}">
                        <tr>
                            <td>${p.id}</td>
                            <td>${p.name}</td>
                            <td>${p.price}</td>
                            <td>${p.status}</td>
                        </tr>
                    </c:forEach>
                </table>
            </c:if>

        </div>

    </div>
</div>

<script>
    const ctx = '${pageContext.request.contextPath}';
    const input = document.getElementById("categorySearchInput");
    const box = document.getElementById("suggestBox");

    input.addEventListener("keyup", function () {
        const t = this.value.trim();
        if (t.length < 1) { box.style.display = "none"; return; }

        fetch(ctx + "/admin/categories/suggest?term=" + encodeURIComponent(t))
            .then(r => r.json())
            .then(list => {
                if (!list || list.length === 0) { box.style.display = "none"; return; }

                box.innerHTML = "";
                list.forEach(item => {
                    const div = document.createElement("div");
                    div.className = "suggest-item";
                    div.textContent = item.name;
                    div.onclick = () => window.location = ctx + "/admin/categories?id=" + item.id;
                    box.appendChild(div);
                });
                box.style.display = "block";
            });
    });
</script>

</body>
</html>
