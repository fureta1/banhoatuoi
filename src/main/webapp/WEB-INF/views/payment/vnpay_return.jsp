<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kết quả thanh toán VNPAY</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header text-center">
                        <h4>Kết quả thanh toán VNPAY</h4>
                    </div>
                    <div class="card-body text-center">
                        <c:choose>
                            <c:when test="${status == 'success'}">
                                <div class="alert alert-success">
                                    <i class="fas fa-check-circle fa-3x mb-3"></i>
                                    <h5>${message}</h5>
                                </div>
                                
                                <div class="row mt-4">
                                    <div class="col-6">
                                        <strong>Mã đơn hàng:</strong>
                                    </div>
                                    <div class="col-6">
                                        ${orderInfo}
                                    </div>
                                </div>
                                
                                <div class="row mt-2">
                                    <div class="col-6">
                                        <strong>Số tiền:</strong>
                                    </div>
                                    <div class="col-6">
                                        <c:if test="${not empty amount}">
                                            ${amount / 100} VNĐ
                                        </c:if>
                                    </div>
                                </div>
                                
                                <div class="row mt-2">
                                    <div class="col-6">
                                        <strong>Mã giao dịch:</strong>
                                    </div>
                                    <div class="col-6">
                                        ${transactionId}
                                    </div>
                                </div>
                                
                                <div class="mt-4">
                                    <a href="${pageContext.request.contextPath}/" class="btn btn-primary">
                                        <i class="fas fa-home"></i> Về trang chủ
                                    </a>
                                    <a href="${pageContext.request.contextPath}/account/orders" class="btn btn-outline-primary">
                                        <i class="fas fa-list"></i> Xem đơn hàng
                                    </a>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="alert alert-danger">
                                    <i class="fas fa-times-circle fa-3x mb-3"></i>
                                    <h5>${message}</h5>
                                    <c:if test="${not empty errorCode}">
                                        <p class="mb-0">Mã lỗi: ${errorCode}</p>
                                    </c:if>
                                </div>
                                
                                <div class="mt-4">
                                    <a href="${pageContext.request.contextPath}/checkout" class="btn btn-warning">
                                        <i class="fas fa-redo"></i> Thử lại
                                    </a>
                                    <a href="${pageContext.request.contextPath}/" class="btn btn-outline-secondary">
                                        <i class="fas fa-home"></i> Về trang chủ
                                    </a>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

