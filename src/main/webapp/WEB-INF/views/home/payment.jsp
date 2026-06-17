<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thanh toán - FlowerShop</title>

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #fdfbfb 0%, #f8f3f0 100%);
            color: #333;
        }

        /* =========== TOP BAR =========== */
        .top-bar {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 15px 0;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .top-bar-content {
            max-width: 1400px;
            margin: 0 auto;
            padding: 0 30px;
            display: flex;
            align-items: center;
            gap: 40px;
        }

        .logo {
            font-size: 28px;
            font-weight: 700;
            color: #fff;
            display: flex;
            align-items: center;
            gap: 10px;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.2);
        }

        .logo i {
            font-size: 32px;
        }

        .search-box {
            flex: 1;
            display: flex;
            background: white;
            border-radius: 50px;
            overflow: hidden;
            box-shadow: 0 4px 15px rgba(0,0,0,0.15);
        }

        .search-box input[type="text"] {
            flex: 1;
            padding: 14px 24px;
            border: none;
            font-size: 15px;
            outline: none;
        }

        .search-box input[type="text"]::placeholder {
            color: #999;
        }

        .search-box select {
            padding: 14px 20px;
            border: none;
            border-left: 1px solid #eee;
            background: white;
            cursor: pointer;
            outline: none;
            font-size: 14px;
        }

        .search-box button {
            padding: 14px 32px;
            border: none;
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            color: white;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
        }

        .search-box button:hover {
            background: linear-gradient(135deg, #f5576c 0%, #f093fb 100%);
        }

        .top-actions {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .logout-btn {
            padding: 10px 20px;
            border-radius: 25px;
            background: rgba(255,255,255,0.12);
            color: #fff;
            font-size: 14px;
            font-weight: 600;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 8px;
            border: 2px solid rgba(255,255,255,0.8);
            backdrop-filter: blur(4px);
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
            transition: all 0.3s;
        }

        .logout-btn:hover {
            background: #fff;
            color: #764ba2;
        }

        /* =========== MEGA MENU =========== */
        .mega-menu {
            background: white;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            position: sticky;
            top: 0;
            z-index: 100;
        }

        .mega-menu-content {
            max-width: 1400px;
            margin: 0 auto;
            padding: 0 30px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .mega-menu-left ul,
        .mega-menu-right ul {
            list-style: none;
            display: flex;
            gap: 0;
            justify-content: center;
        }

        .mega-menu a {
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 18px 24px;
            color: #333;
            text-decoration: none;
            font-weight: 600;
            font-size: 14px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            transition: all 0.3s;
            position: relative;
        }

        .mega-menu a::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 50%;
            width: 0;
            height: 3px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            transition: all 0.3s;
            transform: translateX(-50%);
        }

        .mega-menu a:hover {
            color: #667eea;
        }

        .mega-menu a:hover::after {
            width: 80%;
        }

        .mega-menu a.active {
            color: #667eea;
            font-weight: 800;
        }

        .mega-menu-left a.active::after {
            width: 80%;
        }

        .mega-menu-right a {
            text-transform: none;
            font-size: 13px;
            padding: 12px 18px;
            border-radius: 999px;
            border: 1px solid #e2e8f0;
            margin-left: 8px;
        }

        .mega-menu-right a::after {
            display: none;
        }

        .mega-menu-right a:hover,
        .mega-menu-right a.active {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: #fff;
            border-color: transparent;
        }

        .mega-divider {
            width: 1px;
            height: 32px;
            background: #e2e8f0;
            margin: 0 12px;
        }

        /* =========== BREADCRUMB =========== */
        .breadcrumb-wrapper {
            max-width: 1400px;
            margin: 0 auto;
            padding: 15px 30px 0;
        }

        .breadcrumb {
            font-size: 14px;
            color: #4a5568;
            display: flex;
            align-items: center;
            flex-wrap: wrap;
            gap: 6px;
        }

        .breadcrumb a {
            color: #3182ce;
            text-decoration: none;
            font-weight: 500;
        }

        .breadcrumb a:hover {
            text-decoration: underline;
        }

        .breadcrumb-separator {
            color: #a0aec0;
        }

        .breadcrumb-current {
            font-weight: 500;
            color: #2d3748;
        }

        /* =========== MAIN WRAPPER =========== */
        .main-wrapper {
            max-width: 1400px;
            margin: 0 auto;
            padding: 20px 30px 40px;
        }

        /* HEADER CHECKOUT */
        .category-header {
            background: white;
            border-radius: 18px;
            padding: 24px 28px;
            box-shadow: 0 6px 20px rgba(0,0,0,0.08);
            margin-bottom: 30px;
        }

        .category-header h1 {
            font-size: 26px;
            margin-bottom: 8px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .category-header h1 i {
            color: #ed8936;
        }

        .category-header p {
            color: #4a5568;
            font-size: 15px;
        }

        /* CHECKOUT LAYOUT */
        .checkout-layout {
            display: grid;
            grid-template-columns: 2fr 1.3fr;
            gap: 30px;
        }

        .checkout-card {
            background: #fff;
            border-radius: 18px;
            padding: 24px 28px;
            box-shadow: 0 6px 20px rgba(0,0,0,0.08);
        }

        .checkout-card h2 {
            font-size: 20px;
            margin-bottom: 16px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .checkout-card h2 i {
            color: #667eea;
        }

        table.summary-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 14px;
        }

        .summary-table th,
        .summary-table td {
            padding: 10px 8px;
            border-bottom: 1px solid #edf2f7;
        }

        .summary-table th {
            background: #f7fafc;
            text-align: left;
        }

        .info-block {
            font-size: 14px;
            line-height: 1.6;
            margin-top: 16px;
        }

        .info-block p {
            margin-bottom: 4px;
        }

        .info-block strong {
            display: inline-block;
            min-width: 140px;
            color: #4a5568;
        }

        .summary-line {
            display: flex;
            justify-content: space-between;
            margin-bottom: 8px;
            font-size: 14px;
        }

        .summary-total-row {
            display: flex;
            justify-content: space-between;
            margin-top: 10px;
            font-size: 18px;
            font-weight: 700;
        }

        .summary-total-row span:last-child {
            color: #e53e3e;
        }

        .free-ship-label {
            font-size: 13px;
            color: #38a169;
            margin-top: 6px;
        }

        .form-group {
            margin-top: 16px;
            margin-bottom: 12px;
            font-size: 14px;
        }

        .form-group label {
            font-weight: 600;
            margin-bottom: 4px;
            display: block;
        }

        .payment-options label {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 6px;
            font-size: 14px;
        }

        .btn-place {
            width: 100%;
            margin-top: 16px;
            padding: 12px 18px;
            border-radius: 999px;
            border: none;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: #fff;
            font-size: 15px;
            font-weight: 700;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            transition: all 0.3s;
        }

        .btn-place:hover {
            transform: translateY(-1px);
            box-shadow: 0 8px 20px rgba(102,126,234,0.5);
        }

        /* FOOTER */
        .footer {
            background: linear-gradient(135deg, #2d3748 0%, #1a202c 100%);
            color: white;
            padding: 50px 0 30px;
            margin-top: 60px;
        }

        .footer-content {
            max-width: 1400px;
            margin: 0 auto;
            padding: 0 30px;
        }

        .footer h3 {
            font-size: 24px;
            margin-bottom: 20px;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .footer h3 i {
            color: #667eea;
        }

        .footer p {
            line-height: 1.8;
            color: #cbd5e0;
            margin-bottom: 25px;
            font-size: 15px;
        }

        .contact-line {
            display: flex;
            gap: 30px;
            font-size: 16px;
            padding: 25px;
            background: rgba(255,255,255,0.05);
            border-radius: 12px;
            border-left: 4px solid #667eea;
        }

        .contact-item {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .contact-item i {
            color: #667eea;
            font-size: 18px;
        }

        .contact-item strong {
            color: #667eea;
            margin-right: 8px;
        }

        @media (max-width: 992px) {
            .checkout-layout {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 768px) {
            .top-bar-content {
                padding: 0 15px;
                gap: 20px;
                flex-wrap: wrap;
            }
            .main-wrapper {
                padding: 20px 15px 40px;
            }
        }

        /* NÚT QUAY LẠI */
        .back-link {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            font-size: 13px;
            color: #4a5568;
            text-decoration: none;
            margin-bottom: 10px;
        }

        .back-link i {
            font-size: 12px;
        }

        .back-link:hover {
            color: #2d3748;
        }
        /* =========== ORDER HISTORY =========== */

.order-history {
    max-width: 1400px;
    margin: 20px auto 40px;
    padding: 0 30px;
}

.order-history-card {
    background: #fff;
    border-radius: 18px;
    padding: 24px 28px;
    box-shadow: 0 6px 20px rgba(0,0,0,0.08);
}

.order-history-card h2 {
    font-size: 20px;
    margin-bottom: 16px;
    display: flex;
    align-items: center;
    gap: 8px;
}

.order-history-card h2 i {
    color: #667eea;
}

.order-status-legend {
    display: flex;
    flex-wrap: wrap;
    gap: 12px 20px;
    font-size: 13px;
    color: #4a5568;
    margin-bottom: 12px;
}

.order-status-legend span {
    display: inline-flex;
    align-items: center;
    gap: 6px;
}

.status-badge {
    display: inline-block;
    width: 10px;
    height: 10px;
    border-radius: 999px;
}

/* màu cho ô chú thích trạng thái */
.status-pending { background: #ecc94b; }
.status-confirmed { background: #4299e1; }
.status-preparing { background: #ed8936; }
.status-shipping { background: #805ad5; }
.status-delivered { background: #38a169; }
.status-cancelled { background: #e53e3e; }

/* pill trạng thái trong bảng */
.status-pill {
    display: inline-flex;
    align-items: center;
    padding: 3px 10px;
    border-radius: 999px;
    font-size: 12px;
    font-weight: 600;
}

/* Dùng cùng màu nền nhạt + chữ đậm hơn */
.status-pending.status-pill {
    background: #fefcbf;
    color: #744210;
}

.status-confirmed.status-pill {
    background: #bee3f8;
    color: #2b6cb0;
}

.status-preparing.status-pill {
    background: #feebc8;
    color: #9c4221;
}

.status-shipping.status-pill {
    background: #e9d8fd;
    color: #553c9a;
}

.status-delivered.status-pill {
    background: #c6f6d5;
    color: #276749;
}

.status-cancelled.status-pill {
    background: #fed7d7;
    color: #c53030;
}

.order-table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 10px;
    font-size: 14px;
}

.order-table th,
.order-table td {
    padding: 10px 8px;
    border-bottom: 1px solid #e2e8f0;
    text-align: left;
    vertical-align: top;
}

.order-table th {
    background: #f7fafc;
    font-weight: 600;
}

/* form hủy đơn */
.cancel-form {
    display: flex;
    flex-direction: column;
    gap: 6px;
}

.cancel-form textarea {
    width: 100%;
    min-height: 60px;
    resize: vertical;
    padding: 6px 8px;
    font-size: 13px;
}

.cancel-form button {
    align-self: flex-start;
    padding: 6px 12px;
    border: none;
    border-radius: 999px;
    background: linear-gradient(135deg, #f56565 0%, #e53e3e 100%);
    color: #fff;
    font-size: 13px;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.2s;
}

.cancel-form button:hover {
    transform: translateY(-1px);
    box-shadow: 0 4px 10px rgba(229,62,62,0.4);
}

/* alert message */
.alert {
    padding: 8px 10px;
    border-radius: 6px;
    margin-bottom: 10px;
    font-size: 13px;
}

.alert-success {
    background: #e6fffa;
    color: #2c7a7b;
    border-left: 3px solid #2c7a7b;
}

.alert-error {
    background: #fff5f5;
    color: #c53030;
    border-left: 3px solid #c53030;
}
/* =========== BANK TRANSFER QR =========== */
.bank-transfer-info {
    max-width: 1400px;
    margin: 20px auto 0;
    padding: 0 30px;
}

.bank-transfer-card {
    background: #fff;
    border-radius: 18px;
    padding: 24px 28px;
    box-shadow: 0 6px 20px rgba(0,0,0,0.08);
    display: flex;
    gap: 24px;
    align-items: flex-start;
}

.bank-qr img {
    width: 180px;
    height: auto;
    border-radius: 12px;
    box-shadow: 0 4px 12px rgba(0,0,0,0.12);
}

.bank-details h2 {
    font-size: 18px;
    margin-bottom: 8px;
    display: flex;
    align-items: center;
    gap: 8px;
}

.bank-details h2 i {
    color: #667eea;
}

.bank-details p {
    font-size: 14px;
    margin-bottom: 4px;
}


    </style>
</head>
<body>

<!-- TOP BAR -->
<div class="top-bar">
    <div class="top-bar-content">
        <div class="logo">
            <i class="fas fa-spa"></i>
            FlowerShop
        </div>

        <form class="search-box" action="${ctx}/search" method="get">
            <input type="text" name="keyword"
                   placeholder="Tìm kiếm hoa tươi đẹp cho mọi dịp..."
                   value="${keyword != null ? keyword : ''}">
            <select name="categoryId">
                <option value="">Tất cả danh mục</option>
                <c:forEach var="cat" items="${allCategories}">
                    <option value="${cat.id}">${cat.name}</option>
                </c:forEach>
            </select>
            <button type="submit">
                <i class="fas fa-search"></i> Tìm kiếm
            </button>
        </form>

        <div class="top-actions">
            <a href="${ctx}/auth/logout" class="logout-btn">
                <i class="fas fa-right-from-bracket"></i>
                Đăng xuất
            </a>
        </div>
    </div>
</div>

<!-- MEGA MENU -->
<jsp:include page="_mega-menu.jsp" />

<!-- BREADCRUMB -->
<div class="breadcrumb-wrapper">
    <div class="breadcrumb">
        <a href="${ctx}/home/index">Trang chủ</a>
        <span class="breadcrumb-separator">›</span>
        <a href="${ctx}/cart">Giỏ hàng</a>
        <span class="breadcrumb-separator">›</span>
        <span class="breadcrumb-current">Thanh toán</span>
    </div>
</div>

<!-- MAIN CONTENT -->
<div class="main-wrapper">

    <!-- NÚT QUAY LẠI TRANG TRƯỚC -->
    <a href="javascript:history.back()" class="back-link">
        <i class="fas fa-arrow-left"></i>
        Quay lại trang trước
    </a>

    <div class="category-header">
        <h1>
            <i class="fas fa-wallet"></i>
            Thanh toán
        </h1>
        <p>
    Vui lòng kiểm tra lại thông tin đơn hàng và chọn phương thức thanh toán phù hợp.
    Đơn từ <strong>500,000 VND</strong> được miễn phí vận chuyển. Đơn dưới
    <strong>500,000 VND</strong> phí ship <strong>60,000 VND</strong>.
    <br/>
    <strong>Đơn sẽ giao từ 3–5 ngày sau ngày đặt.</strong>
</p>

    </div>

    <div class="checkout-layout">

        <!-- BÊN TRÁI: SẢN PHẨM & THÔNG TIN -->
        <div class="checkout-card">
            <h2><i class="fas fa-box-open"></i> Sản phẩm & thông tin nhận hàng</h2>

            <table class="summary-table">
                <thead>
                <tr>
                    <th>Sản phẩm</th>
                    <th>SL</th>
                    <th>Đơn giá</th>
                    <th>Thành tiền</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="item" items="${selectedItems}">
                    <c:set var="p" value="${item.product}" />
                    <c:set var="unitPrice" value="${p.discountPrice != null && p.discountPrice > 0 ? p.discountPrice : p.price}" />
                    <tr>
                        <td>${p.name}</td>
                        <td>${item.quantity}</td>
                        <td>
                            <fmt:formatNumber value="${unitPrice}"
                                              type="number" groupingUsed="true" maxFractionDigits="0" /> VND
                        </td>
                        <td>
                            <fmt:formatNumber value="${unitPrice * item.quantity}"
                                              type="number" groupingUsed="true" maxFractionDigits="0" /> VND
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>

            <div class="info-block">
    <p><strong>Người mua:</strong> ${checkoutInfo.buyerName}</p>
    <p><strong>Điện thoại:</strong> ${checkoutInfo.buyerPhone}</p>
    <c:if test="${not empty checkoutInfo.buyerEmail}">
        <p><strong>Email:</strong> ${checkoutInfo.buyerEmail}</p>
    </c:if>
    <br>
    <p><strong>Người nhận:</strong> ${checkoutInfo.receiverName}</p>
    <p><strong>Điện thoại:</strong> ${checkoutInfo.receiverPhone}</p>
    <p><strong>Địa chỉ nhận hàng:</strong> ${checkoutInfo.receiverAddress}</p>

    <c:if test="${not empty checkoutInfo.note}">
        <br>
        <p><strong>Ghi chú cho shop:</strong> ${checkoutInfo.note}</p>
    </c:if>

    <c:if test="${not empty checkoutInfo.cardMessage}">
        <p><strong>Nội dung thiệp:</strong> ${checkoutInfo.cardMessage}</p>
    </c:if>
</div>


        </div>

        <!-- BÊN PHẢI: TỔNG TIỀN & PHƯƠNG THỨC THANH TOÁN -->
        <div class="checkout-card">
            <h2><i class="fas fa-credit-card"></i> Phương thức thanh toán</h2>

            <div class="summary-line">
                <span>Tạm tính</span>
                <span>
                    <fmt:formatNumber value="${checkoutSubtotal}"
                                      type="number" groupingUsed="true" maxFractionDigits="0" /> VND
                </span>
            </div>
            <div class="summary-line">
                <span>Phí vận chuyển</span>
                <span>
                    <fmt:formatNumber value="${checkoutShipping}"
                                      type="number" groupingUsed="true" maxFractionDigits="0" /> VND
                </span>
            </div>
            <div class="summary-total-row">
                <span>Tổng thanh toán</span>
                <span class="total-amount">
                    <fmt:formatNumber value="${checkoutTotal}"
                                      type="number" groupingUsed="true" maxFractionDigits="0" /> VND
                </span>
            </div>

            <c:if test="${freeShipping}">
                <div class="free-ship-label">
                    <i class="fas fa-truck"></i> Đơn hàng của bạn được <strong>MIỄN PHÍ VẬN CHUYỂN</strong>.
                </div>
            </c:if>

            <form action="${ctx}/checkout/place-order" method="post">
                <div class="form-group">
                    <label>Chọn phương thức thanh toán</label>
                    <div class="payment-options">
                        <label>
                            <input type="radio" name="paymentMethod" value="COD" checked>
                            Thanh toán khi nhận hàng (COD)
                        </label>
                        <label>
                            <input type="radio" name="paymentMethod" value="bank_transfer">
                            Chuyển khoản ngân hàng
                        </label>
                        <label>
                            <input type="radio" name="paymentMethod" value="VNPAY">
                            <i class="fas fa-mobile-alt"></i> Thanh toán qua VNPAY
                        </label>
                    </div>
                </div>

                <button type="submit" class="btn-place" id="submitBtn">
                    <i class="fas fa-check-circle"></i>
                    Xác nhận đặt hàng
                </button>
            </form>
        </div>
    </div>
</div>
                <!-- THÔNG TIN CHUYỂN KHOẢN NGÂN HÀNG (hiện khi chọn chuyển khoản) -->
<div id="bankTransferInfo" class="bank-transfer-info" style="display:none;">
    <div class="bank-transfer-card">
        <div class="bank-qr">
            <img src="${ctx}/images/bank/bank-qr.jpg"
                 alt="Mã QR chuyển khoản ngân hàng">
        </div>
        <div class="bank-details">
            <h2><i class="fas fa-qrcode"></i> Thanh toán chuyển khoản ngân hàng</h2>
            <p><strong>Ngân hàng:</strong> BIDV (Ngân hàng Đầu tư và Phát Triển Việt Nam</p>
            <p><strong>Chủ tài khoản:</strong> Hà Thành Tuân </p>
            <p><strong>Số tài khoản:</strong> 2601644044 </p>
            <p><strong>Nội dung chuyển khoản:</strong> Họ tên + SĐT người nhận</p>
            <p style="margin-top:8px;">
                Sau khi bạn chuyển khoản thành công, đơn hàng sẽ được ghi nhận
                vào danh sách <strong>Đơn hàng đã đặt</strong> với trạng thái
                <strong>chờ xác nhận</strong>.
            </p>
        </div>
    </div>
</div>
<!-- =================== DANH SÁCH ĐƠN HÀNG ĐÃ ĐẶT =================== -->
<div class="order-history">
    <div class="order-history-card">
        <h2><i class="fas fa-list"></i> Đơn hàng đã đặt</h2>

        <c:if test="${not empty cartMessage}">
            <div class="alert alert-success">${cartMessage}</div>
        </c:if>
        <c:if test="${not empty cartError}">
            <div class="alert alert-error">${cartError}</div>
        </c:if>

        <c:if test="${empty orders}">
            <p>Bạn chưa có đơn hàng nào.</p>
        </c:if>

        <c:if test="${not empty orders}">
            <!-- Ô hiển thị chú thích trạng thái -->
            <div class="order-status-legend">
                <span><span class="status-badge status-pending"></span> Chờ xác nhận</span>
                <span><span class="status-badge status-confirmed"></span> Đã xác nhận</span>
                <span><span class="status-badge status-preparing"></span> Đang chuẩn bị</span>
                <span><span class="status-badge status-shipping"></span> Đang giao</span>
                <span><span class="status-badge status-delivered"></span> Đã giao</span>
                <span><span class="status-badge status-cancelled"></span> Đã hủy</span>
            </div>

            <table class="order-table">
                <thead>
                <tr>
                    <th>Mã đơn</th>
                    <th>Ngày đặt</th>
                    <th>Tổng tiền</th>
                    <th>Trạng thái đơn</th>
                    <th>Thanh toán</th>
                    <th>Lý do hủy</th>
                    <th>Hành động</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="o" items="${orders}">
                    <tr>
                        <td>${o.orderCode}</td>
                        <td>
                            <fmt:formatDate value="${o.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                        </td>
                        <td>
                            <fmt:formatNumber value="${o.totalAmount}" type="number" maxFractionDigits="0"/>
                            VND
                        </td>
                        <td>
                            <span class="status-pill status-${o.orderStatus}">
                                <c:choose>
                                    <c:when test="${o.orderStatus == 'pending'}">Chờ xác nhận</c:when>
                                    <c:when test="${o.orderStatus == 'confirmed'}">Đã xác nhận</c:when>
                                    <c:when test="${o.orderStatus == 'preparing'}">Đang chuẩn bị</c:when>
                                    <c:when test="${o.orderStatus == 'shipping'}">Đang giao</c:when>
                                    <c:when test="${o.orderStatus == 'delivered'}">Đã giao</c:when>
                                    <c:when test="${o.orderStatus == 'cancelled'}">Đã hủy</c:when>
                                    <c:otherwise>${o.orderStatus}</c:otherwise>
                                </c:choose>
                            </span>
                        </td>
                        <td>${o.paymentMethod}</td>
                        <td>
                            <c:choose>
                                <c:when test="${o.orderStatus == 'cancelled'}">
                                    <c:out value="${o.cancelledReason}"/>
                                </c:when>
                                <c:otherwise>-</c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <!-- Chỉ cho hủy khi đơn còn đang xử lý -->
                            <c:choose>
                                <c:when test="${o.orderStatus == 'pending'
                                               || o.orderStatus == 'confirmed'
                                               || o.orderStatus == 'preparing'}">

                                    <form action="${ctx}/checkout/orders/cancel"
                                          method="post" class="cancel-form">
                                        <input type="hidden" name="orderId" value="${o.orderId}"/>

                                        <textarea name="cancelReason"
                                                  placeholder="Lý do hủy đơn"
                                                  required></textarea>

                                        <button type="submit"
                                                onclick="return confirm('Bạn chắc chắn muốn hủy đơn này?');">
                                            Hủy đơn
                                        </button>
                                    </form>
                                </c:when>
                                <c:otherwise>
                                    -
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </c:if>
    </div>
</div>


<!-- FOOTER -->
<div class="footer">
    <div class="footer-content">
        <h3><i class="fas fa-spa"></i> Shop Hoa Tươi FlowerShop</h3>
        <p>
            FlowerShop là cửa hàng hoa tươi chuyên cung cấp các mẫu hoa sinh nhật, hoa cưới,
            hoa khai trương và thiết kế theo yêu cầu, giao nhanh trong ngày tại khu vực của bạn.
        </p>
        <div class="contact-line">
            <div class="contact-item">
                <i class="fas fa-phone-alt"></i>
                <strong>Hotline:</strong> 079 886 4360
            </div>
            <div class="contact-item">
                <i class="fab fa-facebook-messenger"></i>
                <strong>Zalo:</strong> Nhắn tin qua số trên
            </div>
        </div>
    </div>
</div>
<script>
    document.addEventListener('DOMContentLoaded', function () {
        const codRadio = document.querySelector('input[name="paymentMethod"][value="COD"]');
        const bankRadio = document.querySelector('input[name="paymentMethod"][value="bank_transfer"]');
        const vnpayRadio = document.querySelector('input[name="paymentMethod"][value="VNPAY"]');
        const bankInfo = document.getElementById('bankTransferInfo');
        const submitBtn = document.getElementById('submitBtn');
        const form = document.querySelector('form[action*="place-order"]');

        function updateBankInfo() {
            if (!bankInfo || !bankRadio) return;
            bankInfo.style.display = bankRadio.checked ? 'block' : 'none';
        }

        function handlePaymentMethodChange() {
            updateBankInfo();
            
            if (!submitBtn) return;
            
            if (vnpayRadio && vnpayRadio.checked) {
                submitBtn.innerHTML = '<i class="fas fa-mobile-alt"></i> Thanh toán qua VNPAY';
                submitBtn.style.background = 'linear-gradient(135deg, #0072bc 0%, #005a9e 100%)';
            } else {
                submitBtn.innerHTML = '<i class="fas fa-check-circle"></i> Xác nhận đặt hàng';
                submitBtn.style.background = 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)';
            }
        }

        function handleFormSubmit(e) {
            // Allow form to submit normally - let backend handle VNPAY flow
            // This will create order first, then redirect to VNPAY
        }

        // Event listeners
        if (codRadio) codRadio.addEventListener('change', handlePaymentMethodChange);
        if (bankRadio) bankRadio.addEventListener('change', handlePaymentMethodChange);
        if (vnpayRadio) vnpayRadio.addEventListener('change', handlePaymentMethodChange);
        if (form) form.addEventListener('submit', handleFormSubmit);

        // Gọi lần đầu để set trạng thái đúng khi load trang
        handlePaymentMethodChange();
    });
</script>
</body>
</html>
</html>
