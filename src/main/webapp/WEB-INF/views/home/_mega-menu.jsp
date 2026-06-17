<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="currentUri" value="${pageContext.request.requestURI}" />

<%-- Nếu controller chưa set activeCategoryId thì lấy từ param categoryId --%>
<c:if test="${empty activeCategoryId and not empty param.categoryId}">
    <c:set var="activeCategoryId" value="${param.categoryId}" />
</c:if>

<div class="mega-menu">
    <div class="mega-menu-content">
        <!-- Bên trái: danh mục chính -->
        <div class="mega-menu-left">
            <ul>
                <c:forEach var="cat" items="${megaCategories}">
                    <c:set var="isActiveCat"
                           value="${not empty activeCategoryId && activeCategoryId == cat.id}" />
                    <li>
                        <a href="${pageContext.request.contextPath}/category?categoryId=${cat.id}"
                           class="${isActiveCat ? 'active' : ''}">
                            <c:choose>
                                <c:when test="${cat.name == 'Hoa Sinh Nhật'}">
                                    <i class="fas fa-birthday-cake"></i>
                                </c:when>
                                <c:when test="${cat.name == 'Hoa Khai Trương'}">
                                    <i class="fas fa-store"></i>
                                </c:when>
                                <c:when test="${cat.name == 'Hoa Cưới'}">
                                    <i class="fas fa-ring"></i>
                                </c:when>
                                <c:when test="${cat.name == 'Hoa Tình Yêu'}">
                                    <i class="fas fa-heart"></i>
                                </c:when>
                                <c:when test="${cat.name == 'Hoa Chia Buồn'}">
                                    <i class="fas fa-dove"></i>
                                </c:when>
                                <c:otherwise>
                                    <i class="fas fa-leaf"></i>
                                </c:otherwise>
                            </c:choose>
                            ${cat.name}
                        </a>
                    </li>
                </c:forEach>
            </ul>
        </div>

        <!-- Gạch dọc ngăn giữa Hoa Chia Buồn và Tài khoản -->
        <div class="mega-divider"></div>

        <!-- Bên phải: Tài khoản, Giỏ hàng, Thanh toán, Liên hệ -->
        <div class="mega-menu-right">
            <ul>
                <li>
                    <a href="${pageContext.request.contextPath}/account"
                       class="${fn:contains(currentUri, '/account') ? 'active' : ''}">
                        <i class="fas fa-user-circle"></i> Tài khoản
                    </a>
                </li>
                <li class="cart-icon-wrapper">
                <a href="${pageContext.request.contextPath}/cart"
                    class="${fn:contains(currentUri, '/cart') ? 'active' : ''}">
                    <i class="fas fa-shopping-cart"></i>
                <span>Giỏ hàng</span>
                <c:if test="${cartItemCount > 0}">
                    <span class="cart-badge">${cartItemCount}</span>
                </c:if>
                </a>
                </li>
                <li>
    <a href="${pageContext.request.contextPath}/home/payment"
       class="${
           fn:contains(currentUri, '/home/payment') 
           or fn:contains(currentUri, '/checkout/payment')
           ? 'active' : ''
       }">
        <i class="fas fa-credit-card"></i> Thanh toán
    </a>
</li>

                <li>
                    <a href="${pageContext.request.contextPath}/contact"
                       class="${fn:contains(currentUri, '/contact') ? 'active' : ''}">
                        <i class="fas fa-headset"></i> Liên hệ
                    </a>
                </li>
            </ul>
        </div>
    </div>
</div>
