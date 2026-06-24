<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="activePage" value="contacts" />
<%@ include file="_sidebar.jsp" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>CSKH - Liên hệ #${contact.contactId}</title>
    <style>
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #f5f5f5;
        }

        .admin-content {
            margin-left: 250px; /* sidebar 230 + 20px */
            padding: 24px;
        }

        .page-title {
            font-size: 22px;
            font-weight: bold;
            margin-bottom: 4px;
            color: #333;
        }

        .page-subtitle {
            font-size: 13px;
            color: #777;
            margin-bottom: 12px;
        }

        .back-link {
            display: inline-block;
            margin-bottom: 8px;
            font-size: 13px;
            color: #4B6CB7;
            text-decoration: none;
        }
        .back-link:hover {
            text-decoration: underline;
        }

        .alert-success {
            margin-bottom: 12px;
            padding: 8px 12px;
            border-radius: 6px;
            background: #e5ffe9;
            color: #27ae60;
            font-size: 13px;
            border: 1px solid #b8f2c2;
        }

        .chat-wrapper {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 16px;
            align-items: flex-start;
        }

        .chat-card, .info-card {
            background: #fff;
            border-radius: 10px;
            border: 1px solid #ddd;
            box-shadow: 0 2px 6px rgba(0,0,0,0.04);
        }

        .chat-card {
            display: flex;
            flex-direction: column;
            height: 560px;
        }

        .chat-header {
            padding: 12px 16px;
            border-bottom: 1px solid #eee;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .chat-header-left {
            display: flex;
            flex-direction: column;
            gap: 2px;
        }

        .chat-customer-name {
            font-weight: 600;
            font-size: 15px;
            color: #333;
        }

        .chat-customer-email {
            font-size: 12px;
            color: #777;
        }

        .status-badge {
            padding: 4px 10px;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 600;
        }
        .badge-new      { background: #ffe5e5; color: #c0392b; }
        .badge-processing { background: #fff4e1; color: #d35400; }
        .badge-resolved { background: #e5ffe9; color: #27ae60; }

        .chat-body {
            flex: 1;
            padding: 12px 16px;
            overflow-y: auto;
            background: #f9fafc;
        }

        .chat-message {
            max-width: 70%;
            margin-bottom: 10px;
            display: flex;
            flex-direction: column;
        }

        .chat-message.user {
            align-items: flex-start;
        }

        .chat-message.admin {
            align-items: flex-end;
            margin-left: auto;
        }

        .chat-bubble {
            border-radius: 14px;
            padding: 8px 12px;
            font-size: 13px;
            line-height: 1.4;
            white-space: pre-line;
        }

        .chat-bubble.user {
            background: #ffffff;
            border: 1px solid #e0e0e0;
        }

        .chat-bubble.admin {
            background: #4B6CB7;
            color: #fff;
        }

        .chat-meta {
            margin-top: 2px;
            font-size: 11px;
            color: #999;
        }

        .chat-meta span {
            margin: 0 2px;
        }

        .chat-footer {
            padding: 10px 14px;
            border-top: 1px solid #eee;
            background: #fff;
        }

        .chat-form {
            display: flex;
            gap: 8px;
        }

        .chat-form textarea {
            flex: 1;
            min-height: 60px;
            max-height: 90px;
            resize: vertical;
            border-radius: 8px;
            border: 1px solid #ccc;
            padding: 8px 10px;
            font-size: 13px;
        }

        .btn-primary {
            padding: 8px 14px;
            border-radius: 8px;
            border: none;
            background: #4B6CB7;
            color: #fff;
            font-size: 13px;
            cursor: pointer;
            min-width: 80px;
            align-self: flex-end;
        }

        .btn-primary:hover {
            background: #3b58a0;
        }

        .info-card {
            padding: 14px 16px;
            font-size: 13px;
        }

        .info-title {
            font-weight: 600;
            margin-bottom: 10px;
            color: #333;
        }

        .info-row {
            margin-bottom: 6px;
        }

        .info-label {
            font-weight: 600;
            color: #555;
        }

        .info-value {
            color: #333;
        }

        .info-subject {
            background: #f7f9ff;
            border-radius: 8px;
            padding: 8px;
            border: 1px solid #e0e6ff;
            margin-bottom: 10px;
        }

        .info-note {
            font-size: 11px;
            color: #999;
        }

        .status-form {
            margin-top: 10px;
        }

        .status-form select {
            padding: 6px 8px;
            border-radius: 6px;
            border: 1px solid #ccc;
            font-size: 13px;
        }

        .btn-small {
            padding: 6px 10px;
            border-radius: 6px;
            border: none;
            background: #e0e0e0;
            font-size: 12px;
            cursor: pointer;
            margin-left: 6px;
        }

        .btn-small:hover {
            background: #d4d4d4;
        }
    </style>
</head>
<body>

<div class="admin-content">

    <a class="back-link" href="${pageContext.request.contextPath}/admin/contacts">
        ← Quay lại danh sách liên hệ
    </a>

    <div class="page-title">CSKH - Liên hệ #${contact.contactId}</div>
    <div class="page-subtitle">Trao đổi với khách hàng giống Shopee/Tiki CSKH.</div>

    <!-- Thông báo gửi thành công -->
    <c:if test="${param.sent == '1'}">
        <div class="alert-success">
            ✅ Gửi phản hồi cho khách hàng thành công.
        </div>
    </c:if>

    <div class="chat-wrapper">

        <!-- KHUNG CHAT CHÍNH -->
        <div class="chat-card">
            <div class="chat-header">
                <div class="chat-header-left">
                    <div class="chat-customer-name">${contact.fullName}</div>
                    <div class="chat-customer-email">${contact.email}</div>
                </div>
                <div>
                    <c:choose>
                        <c:when test="${contact.status == 'new'}">
                            <span class="status-badge badge-new">Mới</span>
                        </c:when>
                        <c:when test="${contact.status == 'processing'}">
                            <span class="status-badge badge-processing">Đang xử lý</span>
                        </c:when>
                        <c:otherwise>
                            <span class="status-badge badge-resolved">Đã xử lý</span>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <div class="chat-body" id="chatBody">
                <c:forEach var="m" items="${messages}">
                    <div class="chat-message ${m.senderType}">
                        <div class="chat-bubble ${m.senderType}">
                            ${m.messageText}
                        </div>
                        <div class="chat-meta">
                            <span>
                                <c:choose>
                                    <c:when test="${m.senderType == 'user'}">Khách hàng</c:when>
                                    <c:otherwise>Admin</c:otherwise>
                                </c:choose>
                            </span>
                            •
                            <span>${m.createdAt}</span>
                        </div>
                    </div>
                </c:forEach>

                <c:if test="${empty messages}">
                    <div style="text-align:center; color:#999; font-size:12px; margin-top:40px;">
                        Chưa có lịch sử trao đổi. Đây là nội dung liên hệ đầu tiên của khách.
                    </div>
                </c:if>
            </div>

            <div class="chat-footer">
                <form class="chat-form"
                      action="${pageContext.request.contextPath}/admin/contact-chat/send"
                      method="post">
                    <input type="hidden" name="contactId" value="${contact.contactId}"/>
                    <textarea name="messageText"
                              placeholder="Nhập nội dung phản hồi cho khách..."
                              required></textarea>
                    <button type="submit" class="btn-primary">Gửi</button>
                </form>
            </div>
        </div>

        <!-- THÔNG TIN LIÊN HỆ / TRẠNG THÁI -->
        <div class="info-card">
            <div class="info-title">Thông tin liên hệ</div>

            <div class="info-row">
                <span class="info-label">Họ tên: </span>
                <span class="info-value">${contact.fullName}</span>
            </div>
            <div class="info-row">
                <span class="info-label">Email: </span>
                <span class="info-value">${contact.email}</span>
            </div>
            <div class="info-row">
                <span class="info-label">Số điện thoại: </span>
                <span class="info-value">${contact.phone}</span>
            </div>
            <div class="info-row">
                <span class="info-label">Ngày gửi: </span>
                <span class="info-value">${contact.createdAt}</span>
            </div>

            <div class="info-row">
                <span class="info-label">Chủ đề: </span>
            </div>
            <div class="info-subject">
                ${contact.subject}
            </div>

            <div class="info-title" style="margin-top:14px;">Trạng thái ticket</div>
            <form class="status-form"
                  action="${pageContext.request.contextPath}/admin/contacts/updateStatus"
                  method="post">
                <input type="hidden" name="contactId" value="${contact.contactId}"/>

                <select name="status">
                    <option value="new" ${contact.status == 'new' ? 'selected' : ''}>Mới</option>
                    <option value="processing" ${contact.status == 'processing' ? 'selected' : ''}>Đang xử lý</option>
                    <option value="resolved" ${contact.status == 'resolved' ? 'selected' : ''}>Đã xử lý</option>
                </select>

                <button type="submit" class="btn-small">Lưu</button>
            </form>

            <div class="info-note" style="margin-top:8px;">
                Gợi ý: khi admin đã phản hồi đầy đủ cho khách và vấn đề đã xong, hãy chuyển sang "Đã xử lý".
            </div>
        </div>

    </div>
</div>

<script>
    // Tự cuộn xuống cuối khung chat
    const chatBody = document.getElementById('chatBody');
    if (chatBody) {
        chatBody.scrollTop = chatBody.scrollHeight;
    }
</script>

</body>
</html>

