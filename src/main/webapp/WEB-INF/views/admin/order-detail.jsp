<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi tiết đơn hàng</title>
    <style>
        body {
            margin: 0;
            background: #f5f7fa;
            font-family: "Segoe UI", Arial, sans-serif;
        }

        /* Sidebar vẫn giữ nguyên 260px */
        .main {
            margin-left: 260px; /* khớp với width của _sidebar.jsp */
            padding: 20px;
        }

        /* Nội dung chính dịch sang phải thêm 60px so với sidebar */
        .content {
            margin-left: 60px;      /* cách sidebar 60px */
            padding: 20px;
            position: relative;
        }

        h1 {
            font-size: 24px;
            margin: 0 0 15px 0;
            color: #003366;
        }

        .top-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
        }

        .btn-back {
            padding: 7px 12px;
            font-size: 13px;
            border-radius: 6px;
            border: 1px solid #d1d5db;
            background: #ffffff;
            color: #374151;
            cursor: pointer;
            transition: background 0.2s ease, transform 0.1s ease;
        }

        .btn-back:hover {
            background: #e5e7eb;
            transform: translateY(-1px);
        }

        h3 {
            margin-top: 25px;
            margin-bottom: 10px;
            color: #004a80;
            font-size: 18px;
        }

        .message-success {
            padding: 8px 12px;
            background: #e6ffed;
            border: 1px solid #a5d6a7;
            color: #256029;
            border-radius: 6px;
            margin-bottom: 15px;
            display: inline-block;
        }

        .section-card {
            background: #ffffff;
            border-radius: 8px;
            padding: 12px 15px;
            margin-bottom: 15px;
            box-shadow: 0 1px 4px rgba(0,0,0,0.06);
        }

        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
            gap: 6px 20px;
            font-size: 14px;
        }

        .info-grid p {
            margin: 2px 0;
        }

        .label {
            font-weight: 600;
            color: #003366;
        }

        .table {
            width: 100%;
            border-collapse: collapse;
            background: #ffffff;
            margin-top: 10px;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 6px rgba(0,0,0,0.08);
        }

        th, td {
            padding: 10px;
            border-bottom: 1px solid #eeeeee;
            font-size: 14px;
        }

        th {
            background: #e6f2ff;
            color: #003366;
            font-weight: 600;
        }

        tr:hover td {
            background: #f9fbff;
        }

        .total-row {
            font-weight: 600;
        }

        input, select, textarea {
            padding: 7px 9px;
            font-size: 14px;
            border: 1px solid #d1d5db;
            border-radius: 6px;
            outline: none;
            box-sizing: border-box;
        }

        input:focus, select:focus, textarea:focus {
            border-color: #4A90E2;
            box-shadow: 0 0 0 1px rgba(74,144,226,0.25);
        }

        textarea {
            width: 100%;
            max-width: 500px;
            resize: vertical;
        }

        .form-inline {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            align-items: center;
            margin-top: 5px;
        }

        button {
            padding: 8px 14px;
            margin-top: 10px;
            background: #4A90E2;
            color: #ffffff;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 14px;
            transition: background 0.2s ease, transform 0.1s ease;
        }

        button:hover {
            background: #357ABD;
            transform: translateY(-1px);
        }

        .cancel-btn {
            background: #d9534f;
        }

        .cancel-btn:hover {
            background: #c9302c;
        }

        .badge-status {
            display: inline-block;
            padding: 3px 8px;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 600;
            color: #ffffff;
        }

        .status-pending { background: #f0ad4e; }
        .status-confirmed { background: #5bc0de; }
        .status-preparing { background: #5bc0de; }
        .status-shipping { background: #0275d8; }
        .status-delivered { background: #5cb85c; }
        .status-cancelled { background: #d9534f; }

        .subtitle {
            font-size: 13px;
            color: #6b7280;
            margin-top: -3px;
            margin-bottom: 8px;
        }
    </style>
</head>
<body>

<!-- SIDEBAR CHUNG -->
<jsp:include page="_sidebar.jsp">
    <jsp:param name="activePage" value="orders"/>
</jsp:include>

<!-- NỘI DUNG CHÍNH - CÁCH SIDEBAR 60PX -->
<div class="main">
    <div class="content">

        <div class="top-bar">
            <h1>Chi tiết đơn hàng: ${order.orderCode}</h1>
            
            <button type="button"
        class="back-link"
        onclick="window.location='${pageContext.request.contextPath}/admin/orders'">
    ← Quay lại danh sách đơn
        </button>

        </div>

        <c:if test="${not empty msg}">
            <div class="message-success">${msg}</div>
        </c:if>

        <!-- THÔNG TIN KHÁCH / GIAO HÀNG -->
        <div class="section-card">
            <h3>Thông tin khách / giao hàng</h3>
            <div class="info-grid">
                <p>
                    <span class="label">Khách hàng:</span>
                    ${order.customerName} (${order.customerEmail})
                </p>
                <p>
                    <span class="label">Người nhận:</span>
                    ${order.recipientName} - ${order.phone}
                </p>
                <!-- Khu vực giao = address_line -->
                <p>
                    <span class="label">Khu vực giao:</span>
                    ${order.addressLine}
                </p>
                <!-- Địa chỉ giao đầy đủ -->
                <p>
                    <span class="label">Địa chỉ giao đầy đủ:</span>
                    ${order.addressLine}, ${order.ward}, ${order.district}, ${order.city}
                </p>
                <p>
                    <span class="label">Trạng thái đơn:</span>
                    <span class="badge-status status-${order.orderStatus}">
                        <c:choose>
                            <c:when test="${order.orderStatus == 'pending'}">Chờ xác nhận</c:when>
                            <c:when test="${order.orderStatus == 'confirmed'}">Đã xác nhận</c:when>
                            <c:when test="${order.orderStatus == 'preparing'}">Đang chuẩn bị</c:when>
                            <c:when test="${order.orderStatus == 'shipping'}">Đang giao</c:when>
                            <c:when test="${order.orderStatus == 'delivered'}">Đã giao</c:when>
                            <c:when test="${order.orderStatus == 'cancelled'}">Đã hủy</c:when>
                            <c:otherwise>${order.orderStatus}</c:otherwise>
                        </c:choose>
                    </span>
                </p>
            </div>
        </div>

        <!-- CHI TIẾT SẢN PHẨM -->
        <div class="section-card">
            <h3>Chi tiết sản phẩm</h3>
            <table class="table">
                <thead>
                <tr>
                    <th>Sản phẩm</th>
                    <th style="width:130px;">Đơn giá</th>
                    <th style="width:60px;">SL</th>
                    <th style="width:150px;">Thành tiền</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${order.items}" var="it">
                    <tr>
                        <td>${it.productName}</td>
                        <td>${it.price}</td>
                        <td>${it.quantity}</td>
                        <td>${it.subtotal}</td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>

        <!-- TỔNG TIỀN & THANH TOÁN -->
        <div class="section-card">
            <h3>Thanh toán</h3>
            <div class="info-grid">
                <p><span class="label">Tạm tính:</span> ${order.subtotal}</p>
                <p><span class="label">Phí vận chuyển:</span> ${order.shippingFee}</p>
                <p><span class="label">Giảm giá:</span> ${order.discountAmount}</p>
                <p class="total-row"><span class="label">Tổng thanh toán:</span> ${order.totalAmount}</p>
                <p>
                    <span class="label">Hình thức thanh toán:</span>
                    <c:choose>
                        <c:when test="${order.paymentMethod == 'COD'}">
                            Thanh toán khi nhận hàng (COD)
                        </c:when>
                        <c:when test="${order.paymentMethod == 'bank_transfer'}">
                            Chuyển khoản ngân hàng
                        </c:when>
                        <c:otherwise>${order.paymentMethod}</c:otherwise>
                    </c:choose>
                </p>
                <p>
                    <span class="label">Trạng thái thanh toán:</span>
                    <c:choose>
                        <c:when test="${order.paymentStatus == 'pending'}">Chưa thanh toán</c:when>
                        <c:when test="${order.paymentStatus == 'paid'}">Đã thanh toán</c:when>
                        <c:when test="${order.paymentStatus == 'failed'}">Thanh toán thất bại</c:when>
                        <c:otherwise>${order.paymentStatus}</c:otherwise>
                    </c:choose>
                </p>
            </div>

            <p class="subtitle"><b>Ghi chú khách:</b> ${order.note}</p>
            <c:if test="${order.orderStatus == 'cancelled'}">
                <p class="subtitle"><b>Lý do khách hủy:</b> ${order.cancelledReason}</p>
            </c:if>
        </div>

        <!-- CẬP NHẬT TRẠNG THÁI -->
        <div class="section-card">
            <h3>Cập nhật trạng thái đơn hàng</h3>
            <form method="post" action="${pageContext.request.contextPath}/admin/orders/${order.orderId}/status">
                <div class="form-inline">
                    <select name="status">
                        <option value="pending"   ${order.orderStatus=='pending'   ? 'selected' : ''}>Chờ xác nhận</option>
                        <option value="confirmed" ${order.orderStatus=='confirmed' ? 'selected' : ''}>Đã xác nhận</option>
                        <option value="preparing" ${order.orderStatus=='preparing' ? 'selected' : ''}>Đang chuẩn bị</option>
                        <option value="shipping"  ${order.orderStatus=='shipping'  ? 'selected' : ''}>Đang giao</option>
                        <option value="delivered" ${order.orderStatus=='delivered' ? 'selected' : ''}>Đã giao</option>
                    </select>
                    <input type="text" name="note"
                           placeholder="Ghi chú cập nhật (ví dụ: Đã bàn giao cho shipper)...">
                    <button type="submit">Lưu trạng thái</button>
                </div>
            </form>
        </div>
        
           <!-- CẬP NHẬT TRẠNG THÁI THANH TOÁN -->
        <div class="section-card">
            <h3>Cập nhật trạng thái thanh toán</h3>
            <p class="subtitle">
                Trạng thái hiện tại:
                <c:choose>
                    <c:when test="${order.paymentStatus == 'pending'}">Chưa thanh toán</c:when>
                    <c:when test="${order.paymentStatus == 'paid'}">Đã thanh toán</c:when>
                    <c:when test="${order.paymentStatus == 'failed'}">Thanh toán thất bại</c:when>
                    <c:otherwise>${order.paymentStatus}</c:otherwise>
                </c:choose>
            </p>

            <form method="post" action="${pageContext.request.contextPath}/admin/orders/${order.orderId}/payment">
                <div class="form-inline">
                    <button type="submit" name="paymentStatus" value="paid">
                        Xác nhận ĐÃ thanh toán
                    </button>
                    <button type="submit" name="paymentStatus" value="pending">
                        Đánh dấu CHƯA thanh toán
                    </button>
                </div>
            </form>
        </div>


                <c:if test="${order.orderStatus != 'delivered' || order.paymentStatus != 'paid'}">
            <!-- HỦY ĐƠN HÀNG -->
            <div class="section-card danger">
                <h3>Hủy đơn hàng</h3>
                <form method="post" action="${pageContext.request.contextPath}/admin/orders/${order.orderId}/cancel">
                    <!-- lý do hủy, nút submit... -->
                </form>
            </div>
        </c:if>


        <!-- GỬI THÔNG BÁO CHO KHÁCH -->
        <div class="section-card">
            <h3>Gửi thông báo cho khách</h3>
            <p class="subtitle">Dùng khi cần báo trạng thái, nhắc thanh toán, báo trễ giờ giao,...</p>
            <form method="post" action="${pageContext.request.contextPath}/admin/orders/${order.orderId}/notify">
                <textarea name="message" rows="3" placeholder="Nội dung gửi khách..."></textarea>
                <br>
                <button type="submit">Gửi thông báo</button>
            </form>
        </div>

        <!-- LỊCH SỬ TRẠNG THÁI -->
        <div class="section-card">
            <h3>Lịch sử trạng thái</h3>
            <table class="table">
                <thead>
                <tr>
                    <th>Thời gian</th>
                    <th>Trạng thái</th>
                    <th>Ghi chú</th>
                    <th>Người cập nhật</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${order.histories}" var="h">
                    <tr>
                        <td>${h.createdAt}</td>
                        <td>
                            <c:choose>
                                <c:when test="${h.status == 'pending'}">Chờ xác nhận</c:when>
                                <c:when test="${h.status == 'confirmed'}">Đã xác nhận</c:when>
                                <c:when test="${h.status == 'preparing'}">Đang chuẩn bị</c:when>
                                <c:when test="${h.status == 'shipping'}">Đang giao</c:when>
                                <c:when test="${h.status == 'delivered'}">Đã giao</c:when>
                                <c:when test="${h.status == 'cancelled'}">Đã hủy</c:when>
                                <c:otherwise>${h.status}</c:otherwise>
                            </c:choose>
                        </td>
                        <td>${h.note}</td>
                        <td>${h.updatedByName}</td>
                    </tr>
                </c:forEach>
                <c:if test="${empty order.histories}">
                    <tr>
                        <td colspan="4" style="text-align:center;color:#6b7280;">
                            Chưa có lịch sử thay đổi trạng thái.
                        </td>
                    </tr>
                </c:if>
                </tbody>
            </table>
        </div>

    </div>
</div>

</body>
</html>
