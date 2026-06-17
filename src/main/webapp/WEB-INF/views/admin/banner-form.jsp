<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>${formTitle}</title>

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
            max-width: 650px;
        }

        h3 {
            margin-top:0;
            margin-bottom:15px;
            font-size:20px;
        }

        .form-group {
            margin-bottom:15px;
        }

        label {
            font-weight:bold;
            display:block;
            margin-bottom:4px;
        }

        input[type="text"],
        input[type="number"],
        input[type="date"],
        select,
        textarea {
            width:100%;
            padding:8px;
            border-radius:6px;
            border:1px solid #ccc;
            font-size:14px;
            box-sizing:border-box;
        }

        input[type="file"] {
            margin-top:5px;
        }

        .btn-primary {
            padding:10px 18px;
            border:none;
            background:#4B6CB7;
            color:white;
            border-radius:8px;
            font-size:15px;
            cursor:pointer;
            margin-top:10px;
        }

        .btn-primary:hover {
            background:#3b58a0;
        }

        .btn-back {
            padding:9px 16px;
            background:#777;
            color:white;
            border-radius:8px;
            font-size:14px;
            text-decoration:none;
            margin-left:8px;
        }

        img.preview {
            max-width:300px;
            max-height:120px;
            border-radius:10px;
            margin-top:8px;
            border:1px solid #ddd;
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

    <div class="page-title">${formTitle}</div>

    <c:if test="${not empty errorMessage}">
        <div class="msg-error">${errorMessage}</div>
    </c:if>

    <div class="box">
        <form action="${pageContext.request.contextPath}/admin/banners/save"
              method="post"
              enctype="multipart/form-data">

            <input type="hidden" name="bannerId" value="${banner.bannerId}"/>

            <div class="form-group">
                <label>Tiêu đề</label>
                <input type="text" name="title" value="${banner.title}" required/>
            </div>

            <div class="form-group">
                <label>Link URL (khi click vào banner)</label>
                <input type="text" name="linkUrl" value="${banner.linkUrl}"/>
            </div>

            <div class="form-group">
                <label>Thứ tự hiển thị</label>
                <input type="number" name="displayOrder" value="${banner.displayOrder}" min="0"/>
            </div>

            <div class="form-group">
                <label>Trạng thái</label>
                <select name="status">
                    <option value="active"   ${banner.status == 'active'   ? 'selected' : ''}>active</option>
                    <option value="inactive" ${banner.status == 'inactive' ? 'selected' : ''}>inactive</option>
                </select>
            </div>

            <div class="form-group">
                <label>Thời gian hiệu lực</label>
                <div style="display:flex; gap:10px;">
                    <div style="flex:1;">
                        <span style="font-size:13px;">Từ ngày:</span>
                        <input type="date" name="startDate"
                               value="${banner.startDate != null ? banner.startDate.toString().substring(0,10) : ''}"/>
                    </div>
                    <div style="flex:1;">
                        <span style="font-size:13px;">Đến ngày:</span>
                        <input type="date" name="endDate"
                               value="${banner.endDate != null ? banner.endDate.toString().substring(0,10) : ''}"/>
                    </div>
                </div>
            </div>

            <div class="form-group">
                <label>Ảnh banner</label>

                <c:if test="${not empty banner.imageUrl}">
                    <span style="font-size:13px;">Ảnh hiện tại:</span><br/>
                    <img class="preview"
                         src="${pageContext.request.contextPath}/images/banners/${banner.imageUrl}"
                         alt="${banner.title}"/>
                    <!-- giữ lại tên ảnh cũ nếu không upload mới -->
                    <input type="hidden" name="imageUrl" value="${banner.imageUrl}"/>
                </c:if>

                <input type="file" name="imageFile" accept="image/*"/>
                <div style="font-size:12px; color:#666; margin-top:4px;">
                    Nếu không chọn ảnh mới, hệ thống sẽ giữ nguyên ảnh hiện tại.
                </div>
            </div>

            <div style="margin-top:15px;">
                <button type="submit" class="btn-primary">Lưu</button>
                <a href="${pageContext.request.contextPath}/admin/banners" class="btn-back">
                    Quay lại danh sách
                </a>
            </div>

        </form>
    </div>
</div>

</body>
</html>

