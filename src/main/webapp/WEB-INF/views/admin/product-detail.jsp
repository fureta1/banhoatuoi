<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>
        <c:choose>
            <c:when test="${product != null && product.id != null}">Sửa sản phẩm</c:when>
            <c:otherwise>Thêm sản phẩm</c:otherwise>
        </c:choose>
    </title>
    <style>
        body { font-family: Arial, sans-serif; margin:0; padding:0; }

        /* DỊCH NỘI DUNG SANG PHẢI 260px */
        .admin-content { margin-left: 260px; padding: 20px; }

        h1 { color: #333; margin-bottom: 20px; }
        .form { background:#fff; border:1px solid #ddd; padding:16px; max-width: 920px; }
        .row { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; }
        .row-1 { display: grid; grid-template-columns: 1fr; gap: 12px; }
        label { font-weight: 600; }
        input[type="text"], input[type="number"], input[type="file"], textarea, select {
            width: 100%; padding: 8px; border: 1px solid #ccc; border-radius: 4px;
        }
        textarea { min-height: 110px; resize: vertical; }
        .actions { margin-top: 14px; display: flex; gap: 10px; }
        .btn { padding: 8px 12px; }
        .thumb { width: 70px; height: 70px; object-fit: cover; border-radius: 6px; border: 1px solid #ddd; background:#eee; }
        .hint { color:#666; font-size: 12px; }
    </style>
</head>
<body>

<jsp:include page="_sidebar.jsp"/>

<div class="admin-content">
    <h1>
        <c:choose>
            <c:when test="${product != null && product.id != null}">Sửa sản phẩm: ${product.name}</c:when>
            <c:otherwise>Thêm sản phẩm</c:otherwise>
        </c:choose>
    </h1>

    <div class="form">
        <form method="post"
              action="<c:choose><c:when test='${product != null && product.id != null}'>${pageContext.request.contextPath}/admin/products/edit</c:when><c:otherwise>${pageContext.request.contextPath}/admin/products/add</c:otherwise></c:choose>"
              enctype="multipart/form-data">

            <c:if test="${product != null && product.id != null}">
                <input type="hidden" name="id" value="${product.id}">
            </c:if>

            <div class="row">
                <div>
                    <label>Tên sản phẩm</label>
                    <input type="text" name="name" value="${product.name}" required>
                </div>

                <div>
                    <label>Danh mục</label>
                    <select name="category.id" required>
                        <option value="">-- Chọn danh mục --</option>
                        <c:forEach var="c" items="${categories}">
                            <option value="${c.id}" <c:if test="${product.category != null && product.category.id == c.id}">selected</c:if>>
                                ${c.name}
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <div class="row-1">
                    <label>Mô tả</label>
                    <textarea name="description">${product.description}</textarea>
                </div>

                <div>
                    <label>Giá</label>
                    <input type="number" name="price" step="0.01" min="0" value="${product.price}" required>
                </div>

                <div>
                    <label>Giá khuyến mãi</label>
                    <input type="number" name="discountPrice" step="0.01" min="0" value="${product.discountPrice}">
                    <div class="hint">Để trống nếu không có khuyến mãi</div>
                </div>

                <div>
                    <label>Tồn kho</label>
                    <input type="number" name="stockQuantity" min="0"
                           value="${product.stockQuantity != null ? product.stockQuantity : 0}">
                </div>

                <div>
                    <label>Trạng thái</label>
                    <select name="status">
                        <option value="available" ${product.status == 'available' ? 'selected' : ''}>Đang bán</option>
                        <option value="out_of_stock" ${product.status == 'out_of_stock' ? 'selected' : ''}>Hết hàng</option>
                        <option value="discontinued" ${product.status == 'discontinued' ? 'selected' : ''}>Ngừng bán</option>
                    </select>
                </div>

                <div class="row-1">
                    <label>Ảnh đại diện</label>
                    <input type="file" name="imageFile" accept="image/*">
                    <div class="hint">Ảnh sẽ lưu vào thư mục <code>/images/products</code> trong dự án.</div>
                    <c:if test="${not empty product.mainImage}">
                        <div style="margin-top:8px; display:flex; align-items:center; gap:8px;">
                            <img class="thumb" src="${pageContext.request.contextPath}/${product.mainImage}" alt="${product.name}">
                            <span class="hint">${product.mainImage}</span>
                        </div>
                    </c:if>
                </div>
            </div>

            <div class="actions">
                <button class="btn" type="submit">Lưu</button>
                <a class="btn" href="${pageContext.request.contextPath}/admin/products">Hủy</a>
            </div>
        </form>
    </div>
</div>
</body>
</html>
