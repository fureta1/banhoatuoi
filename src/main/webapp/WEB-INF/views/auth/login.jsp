<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Đăng nhập - Hoa Tươi Đẹp</title>

    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Dancing+Script:wght@600&family=Poppins:wght@300;400;500&display=swap" rel="stylesheet">

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Poppins', sans-serif;
        }

        body {
            min-height: 100vh;
            background: linear-gradient(135deg, #fdf2f8 0%, #e6f7ff 100%);
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
            position: relative;
            overflow: hidden;
        }

        body::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0; bottom: 0;
            background: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="100" height="100" viewBox="0 0 100 100"><path fill="%23ffc0cb33" d="M50 10 Q65 25, 60 40 Q55 55, 40 55 Q25 55, 20 40 Q15 25, 30 10 Q40 0, 50 10 Z"/></svg>') repeat;
            opacity: 0.15;
            z-index: -1;
        }

        .login-container {
            background: rgba(255, 255, 255, 0.95);
            padding: 40px 35px;
            border-radius: 20px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 420px;
            text-align: center;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 182, 193, 0.3);
        }

        .logo {
            margin-bottom: 20px;
        }

        .logo h1 {
            font-family: 'Dancing Script', cursive;
            font-size: 42px;
            color: #d81b60;
            text-shadow: 0 2px 4px rgba(216, 27, 96, 0.2);
        }

        .logo p {
            color: #777;
            font-size: 14px;
            margin-top: 5px;
        }

        .form-group {
            margin-bottom: 20px;
            position: relative;
        }

        .form-group input {
            width: 100%;
            padding: 14px 16px;
            border: 2px solid #f8bbd0;
            border-radius: 12px;
            font-size: 16px;
            transition: all 0.3s ease;
            background: #fff;
            outline: none;
        }

        .form-group input:focus {
            border-color: #ec407a;
            box-shadow: 0 0 0 3px rgba(236, 64, 122, 0.15);
        }

        .form-group input::placeholder {
            color: #b0b0b0;
        }

        button {
            width: 100%;
            padding: 14px;
            background: linear-gradient(to right, #ec407a, #f06292);
            color: white;
            border: none;
            border-radius: 12px;
            font-size: 17px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-top: 10px;
        }

        button:hover {
            background: linear-gradient(to right, #e91e63, #ec407a);
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(236, 64, 122, 0.3);
        }

        .message {
            margin-top: 15px;
            padding: 10px;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 500;
        }

        .error {
            background: #ffebee;
            color: #c62828;
            border: 1px solid #ffcdd2;
        }

        .success {
            background: #e8f5e9;
            color: #2e7d32;
            border: 1px solid #c8e6c9;
        }

        .flower-icon {
            position: absolute;
            font-size: 20px;
            top: 14px;
            left: 12px;
            color: #ec407a;
        }

        .form-group input {
            padding-left: 45px;
        }

        /* Link đăng ký */
        .register-link {
            margin-top: 20px;
            font-size: 15px;
            color: #555;
        }

        .register-link a {
            color: #e91e63;
            font-weight: 500;
            text-decoration: none;
            transition: color 0.3s;
        }

        .register-link a:hover {
            color: #ad1457;
            text-decoration: underline;
        }
    </style>
</head>
<body>

<div class="login-container">
    <div class="logo">
        <h1>Hoa Tươi</h1>
        <p>Đem yêu thương đến mọi nhà</p>
    </div>

    <form action="${pageContext.request.contextPath}/auth/login" method="post">
        <div class="form-group">
            <span class="flower-icon">✉️</span>
            <input type="text" name="email" placeholder="Email" required />
        </div>

        <div class="form-group">
            <span class="flower-icon">🔒</span>
            <input type="password" name="password" placeholder="Mật khẩu (phải có @)" required pattern=".*@.*" />
        </div>

        <button type="submit">Đăng nhập</button>
    </form>

    <!-- Thông báo lỗi / logout / đăng ký -->
    <c:if test="${param.error != null}">
        <div class="message error">Sai email hoặc mật khẩu!</div>
    </c:if>

    <c:if test="${param.logout != null}">
        <div class="message success">Đã đăng xuất thành công!</div>
    </c:if>

    <c:if test="${param.registered != null}">
        <div class="message success">Đăng ký tài khoản thành công! Mời bạn đăng nhập.</div>
    </c:if>

    <!-- Link đăng ký -->
    <div class="register-link">
        Chưa có tài khoản?
        <a href="${pageContext.request.contextPath}/auth/register">Đăng ký ngay</a>
    </div>
</div>

</body>
</html>

