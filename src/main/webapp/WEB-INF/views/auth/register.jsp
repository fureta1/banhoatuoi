<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký tài khoản - Shop Hoa Tươi</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #ffeef8 0%, #ffe4f1 50%, #ffd4e9 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }

        .container {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(255, 105, 180, 0.2);
            overflow: hidden;
            max-width: 900px;
            width: 100%;
            display: grid;
            grid-template-columns: 1fr 1fr;
        }

        .left-panel {
            background: linear-gradient(135deg, #ff69b4 0%, #ff1493 100%);
            padding: 50px 40px;
            color: white;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            text-align: center;
        }

        .left-panel i {
            font-size: 80px;
            margin-bottom: 30px;
            animation: float 3s ease-in-out infinite;
        }

        @keyframes float {
            0%, 100% { transform: translateY(0px); }
            50% { transform: translateY(-20px); }
        }

        .left-panel h2 {
            font-size: 32px;
            margin-bottom: 15px;
            font-weight: 600;
        }

        .left-panel p {
            font-size: 16px;
            line-height: 1.6;
            opacity: 0.95;
        }

        /* === PHẦN NỀN ẢNH HOA MỜ === */
        .right-panel {
            padding: 50px 40px;
            background-image: url('D:\Flower-Shop\flower-shop\src\main\webapp\images\anh1.jpg');
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            position: relative;
            z-index: 1;
        }

        .right-panel::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0; bottom: 0;
            background: rgba(255, 255, 255, 0.92);
            backdrop-filter: blur(3px);
            z-index: -1;
            border-radius: 0 20px 20px 0;
        }

        .form-header {
            text-align: center;
            margin-bottom: 35px;
            position: relative;
            z-index: 2;
        }

        .form-header h1 {
            color: #ff1493;
            font-size: 28px;
            margin-bottom: 10px;
        }

        .form-header p {
            color: #666;
            font-size: 14px;
        }

        .error-message {
            background: #ffe6e6;
            color: #d32f2f;
            padding: 12px 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            border-left: 4px solid #d32f2f;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 10px;
            position: relative;
            z-index: 2;
        }

        .form-group {
            margin-bottom: 25px;
            position: relative;
            z-index: 2;
        }

        .form-group label {
            display: block;
            color: #333;
            font-weight: 500;
            margin-bottom: 8px;
            font-size: 14px;
        }

        .form-group label i {
            color: #ff69b4;
            margin-right: 5px;
            width: 20px;
        }

        .input-wrapper {
            position: relative;
        }

        .form-group input {
            width: 100%;
            padding: 12px 15px 12px 45px;
            border: 2px solid #e0e0e0;
            border-radius: 10px;
            font-size: 15px;
            transition: all 0.3s ease;
            background: #f9f9f9;
        }

        .form-group input:focus {
            outline: none;
            border-color: #ff69b4;
            background: white;
            box-shadow: 0 0 0 4px rgba(255, 105, 180, 0.1);
        }

        .input-icon {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #ff69b4;
            font-size: 18px;
        }

        .password-toggle {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            cursor: pointer;
            color: #999;
            font-size: 16px;
        }

        .password-toggle:hover {
            color: #ff69b4;
        }

        .form-note {
            font-size: 12px;
            color: #666;
            margin-top: 5px;
            font-style: italic;
        }

        .submit-btn {
            width: 100%;
            padding: 14px;
            background: linear-gradient(135deg, #ff69b4 0%, #ff1493 100%);
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-top: 10px;
            position: relative;
            z-index: 2;
        }

        .submit-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(255, 20, 147, 0.3);
        }

        .submit-btn:active {
            transform: translateY(0);
        }

        .login-link {
            text-align: center;
            margin-top: 25px;
            font-size: 14px;
            color: #666;
            position: relative;
            z-index: 2;
        }

        .login-link a {
            color: #ff1493;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .login-link a:hover {
            color: #ff69b4;
            text-decoration: underline;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .container {
                grid-template-columns: 1fr;
            }
            .left-panel {
                padding: 30px 20px;
            }
            .left-panel i {
                font-size: 60px;
                margin-bottom: 20px;
            }
            .left-panel h2 {
                font-size: 24px;
            }
            .right-panel {
                padding: 30px 20px;
            }
            .right-panel::before {
                border-radius: 0 0 20px 20px;
            }
            .form-header h1 {
                font-size: 24px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- Left Panel -->
        <div class="left-panel">
            <i class="fas fa-flower"></i>
            <h2>Chào mừng đến với Shop Hoa Tươi</h2>
            <p>Đăng ký tài khoản để trải nghiệm dịch vụ đặt hoa tươi tốt nhất với hàng ngàn mẫu hoa đẹp và ưu đãi hấp dẫn.</p>
        </div>

        <!-- Right Panel - Form with Flower Background -->
        <div class="right-panel">
            <div class="form-header">
                <h1>Đăng ký tài khoản</h1>
                <p>Điền thông tin để tạo tài khoản mới</p>
            </div>

            <!-- Hiển thị lỗi nếu có -->
            <c:if test="${not empty error}">
                <div class="error-message">
                    <i class="fas fa-exclamation-circle"></i>
                    <span>${error}</span>
                </div>
            </c:if>

            <!-- Form đăng ký -->
            <form action="${pageContext.request.contextPath}/auth/register" method="post">
                <div class="form-group">
                    <label for="fullName">
                        <i class="fas fa-user"></i>Họ và tên
                    </label>
                    <div class="input-wrapper">
                        <i class="input-icon fas fa-user"></i>
                        <input type="text" id="fullName" name="fullName" placeholder="Nhập họ và tên" required />
                    </div>
                </div>

                <div class="form-group">
                    <label for="email">
                        <i class="fas fa-envelope"></i>Email
                    </label>
                    <div class="input-wrapper">
                        <i class="input-icon fas fa-envelope"></i>
                        <input type="email" id="email" name="email" placeholder="example@email.com" required />
                    </div>
                </div>

                <div class="form-group">
                    <label for="phone">
                        <i class="fas fa-phone"></i>Số điện thoại
                    </label>
                    <div class="input-wrapper">
                        <i class="input-icon fas fa-phone"></i>
                        <input type="text" id="phone" name="phone" placeholder="0123456789" />
                    </div>
                </div>

                <div class="form-group">
                    <label for="password">
                        <i class="fas fa-lock"></i>Mật khẩu
                    </label>
                    <div class="input-wrapper">
                        <i class="input-icon fas fa-lock"></i>
                        <input type="password" id="password" name="password" placeholder="Nhập mật khẩu" required />
                        <i class="password-toggle fas fa-eye" onclick="togglePassword()"></i>
                    </div>
                    <div class="form-note">* Mật khẩu phải chứa ký tự @</div>
                </div>

                <button type="submit" class="submit-btn">
                    <i class="fas fa-user-plus"></i> Đăng ký
                </button>

                <div class="login-link">
                    Đã có tài khoản? <a href="${pageContext.request.contextPath}/auth/login">Đăng nhập ngay</a>
                </div>
            </form>
        </div>
    </div>

    <!-- Script hiển thị/ẩn mật khẩu -->
    <script>
        function togglePassword() {
            const passwordInput = document.getElementById('password');
            const toggleIcon = document.querySelector('.password-toggle');
            if (passwordInput.type === 'password') {
                passwordInput.type = 'text';
                toggleIcon.classList.remove('fa-eye');
                toggleIcon.classList.add('fa-eye-slash');
            } else {
                passwordInput.type = 'password';
                toggleIcon.classList.remove('fa-eye-slash');
                toggleIcon.classList.add('fa-eye');
            }
        }
    </script>
</body>
</html>