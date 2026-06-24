<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh toán VNPAY - Flower Shop</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .vnpay-container {
            max-width: 600px;
            margin: 50px auto;
            padding: 30px;
            border: 1px solid #ddd;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .vnpay-logo {
            width: 150px;
            margin-bottom: 20px;
        }
        .loading-spinner {
            display: none;
            text-align: center;
            margin-top: 20px;
        }
        .order-info {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <%@ include file="_mega-menu.jsp" %>
    
    <div class="container">
        <div class="vnpay-container">
            <div class="text-center">
                <h2>Thanh toán VNPAY</h2>
                <p class="text-muted">Bạn đang chuyển đến cổng thanh toán VNPAY</p>
            </div>
            
            <div class="order-info">
                <div class="row">
                    <div class="col-6">
                        <strong>Mã đơn hàng:</strong>
                    </div>
                    <div class="col-6 text-end">
                        ${orderCode}
                    </div>
                </div>
                <div class="row mt-2">
                    <div class="col-6">
                        <strong>Số tiền:</strong>
                    </div>
                    <div class="col-6 text-end text-danger fw-bold">
                        <span id="amount-display"></span> VNĐ
                    </div>
                </div>
            </div>
            
            <div class="d-grid gap-2">
                <button id="btn-pay" class="btn btn-primary btn-lg" onclick="startPayment()">
                    Thanh toán ngay
                </button>
                <a href="${pageContext.request.contextPath}/home/payment" class="btn btn-outline-secondary">
                    Quay lại chọn phương thức khác
                </a>
            </div>
            
            <div class="loading-spinner" id="loading">
                <div class="spinner-border text-primary" role="status">
                    <span class="visually-hidden">Đang xử lý...</span>
                </div>
                <p class="mt-2 text-muted">Đang kết nối đến VNPAY...</p>
            </div>
            
            <div class="alert alert-danger mt-3" id="error-message" style="display: none;">
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        const orderCode = '${orderCode}';
        const amount = '${amount}';
        const ctx = '${pageContext.request.contextPath}';
        
        // Format amount for display
        document.getElementById('amount-display').textContent = 
            new Intl.NumberFormat('vi-VN').format(parseInt(amount));
        
        function startPayment() {
            document.getElementById('btn-pay').disabled = true;
            document.getElementById('loading').style.display = 'block';
            document.getElementById('error-message').style.display = 'none';
            
            // Call VNPAY API to create payment
            const formData = new FormData();
            formData.append('amount', amount);
            formData.append('orderInfo', 'Thanh toan don hang ' + orderCode);
            formData.append('orderCode', orderCode);
            
            fetch(ctx + '/vnpay/create_payment', {
                method: 'POST',
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                if (data.status === 'success' && data.paymentUrl) {
                    // Redirect to VNPAY
                    window.location.href = data.paymentUrl;
                } else {
                    showError(data.message || 'Không thể tạo thanh toán. Vui lòng thử lại.');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showError('Có lỗi xảy ra khi kết nối đến VNPAY. Vui lòng thử lại.');
            });
        }
        
        function showError(message) {
            document.getElementById('btn-pay').disabled = false;
            document.getElementById('loading').style.display = 'none';
            document.getElementById('error-message').textContent = message;
            document.getElementById('error-message').style.display = 'block';
        }
        
        // Auto-start payment on page load (optional - can be removed if user wants to click button)
        // window.onload = startPayment;
    </script>
</body>
</html>

