# VNPAY Payment Flow - Hướng dẫn sử dụng sau khi fix

## Tổng quan

Hệ thống đã được cập nhật để tích hợp VNPAY hoàn chỉnh với các tính năng:
- Tạo đơn hàng với trạng thái chờ thanh toán (pending)
- Thanh toán qua VNPAY sandbox
- Cập nhật tự động trạng thái đơn hàng sau thanh toán
- Xử lý giỏ hàng sau thanh toán thành công/thất bại

## Luồng thanh toán VNPAY

```
[User chọn thanh toán VNPAY]
    ↓
[CheckoutController.place-order]
    ↓
Tạo đơn hàng với payment_status='pending'
Lưu orderCode vào session
    ↓
Redirect → /checkout/vnpay-redirect
    ↓
Redirect → /home/vnpay-payment
    ↓
[Trang vnpay_payment.jsp hiển thị]
User click "Thanh toán ngay"
    ↓
Gọi API POST /vnpay/create_payment
    ↓
Redirect đến VNPAY sandbox
    ↓
[Nhập test card → Thanh toán]
    ↓
VNPAY redirect về /vnpay/return
    ↓
[VNPAYController.paymentReturn]
Validate signature
Cập nhật DB: payment_status='paid', order_status='confirmed'
    ↓
Redirect → /checkout/vnpay-success
    ↓
[Xóa giỏ hàng, hiển thị thông báo thành công]
```

## API Endpoints

### 1. Tạo thanh toán VNPAY
```
POST /vnpay/create_payment
Params:
  - amount: Số tiền (VND, không cần nhân 100)
  - orderInfo: Thông tin hiển thị (vd: "Thanh toan don hang DH001")
  - orderCode: Mã đơn hàng (dùng làm vnp_TxnRef để map lại)
Response:
  {
    "status": "success",
    "paymentUrl": "https://sandbox.vnpayment.vn/..."
  }
```

### 2. VNPAY Return (Callback từ VNPAY sau thanh toán)
```
GET /vnpay/return
- Tự động gọi bởi VNPAY sau khi user thanh toán
- Validate signature
- Cập nhật database
- Redirect đến trang success/failed phù hợp
```

### 3. VNPAY IPN (Instant Payment Notification)
```
POST /vnpay/ipn
- Webhook được VNPAY gọi server-to-server
- Cập nhật payment_status và order_status trong DB
- Trả về "OK" để xác nhận
```

## Các endpoint xử lý trong hệ thống

| Endpoint | Mô tả |
|----------|-------|
| `POST /checkout/place-order` | Tạo đơn hàng, phân luồng COD/VNPAY |
| `GET /checkout/vnpay-redirect` | Chuyển hướng đến trang thanh toán VNPAY |
| `GET /checkout/vnpay-success` | Xử lý sau thanh toán thành công (xóa giỏ) |
| `GET /checkout/vnpay-failed` | Xử lý sau thanh toán thất bại (giữ giỏ) |
| `GET /home/vnpay-payment` | Trang hiển thị thông tin và gọi API VNPAY |

## Database Schema - Orders

```sql
orders (
    order_id INT PK AUTO_INCREMENT,
    order_code VARCHAR(20) UNIQUE,  -- DH{timestamp}
    user_id INT FK,
    payment_method VARCHAR(20),     -- 'COD' | 'bank_transfer'
    payment_status VARCHAR(20),     -- 'pending' | 'paid' | 'failed'
    order_status VARCHAR(20),       -- 'pending' | 'confirmed' | 'preparing' | 'shipping' | 'delivered' | 'cancelled'
    total_amount DECIMAL(12,2),
    created_at TIMESTAMP
)
```

## Test Card VNPAY Sandbox

| Loại | Số thẻ | Hết hạn | CVV | Tên chủ thẻ |
|------|--------|---------|-----|-------------|
| Thành công | 4111111111111111 | 12/25 | 123 | NGUYEN VAN A |
| Thất bại | 4242424242424242 | 12/25 | 123 | NGUYEN VAN A |

## Cách test

### 1. Chuẩn bị data
```sql
-- Insert user test
INSERT INTO users (email, password, full_name, phone, role, status, created_at, updated_at) 
VALUES ('test@gmail.com', '$2a$10$hash', 'Nguyễn Văn Test', '0909123456', 'customer', 'active', NOW(), NOW());

-- Insert sản phẩm test
INSERT INTO products (category_id, product_name, price, stock_quantity, status) 
VALUES (1, 'Bó Hoa Test', 100000, 50, 'active');
```

### 2. Test flow
1. Đăng nhập với `test@gmail.com`
2. Thêm sản phẩm vào giỏ hàng
3. Vào giỏ hàng, chọn sản phẩm, nhập thông tin giao hàng
4. Chọn phương thức thanh toán VNPAY
5. Click "Đặt hàng"
6. Trang VNPAY hiện ra, click "Thanh toán ngay"
7. Nhập test card thành công (4111111111111111)
8. Hoàn tất thanh toán
9. Kiểm tra:
   - Đơn hàng trong DB có `payment_status='paid'`
   - Đơn hàng có `order_status='confirmed'`
   - Giỏ hàng đã được xóa
   - Hiển thị thông báo thành công

## Xử lý lỗi

| Tình huống | Xử lý |
|------------|-------|
| User hủy thanh toán VNPAY | Giữ giỏ hàng, cho phép chọn COD hoặc thử lại VNPAY |
| Thanh toán thất bại | Redirect về `/checkout/vnpay-failed`, hiển thị lỗi |
| IPN không nhận được | Return URL vẫn cập nhật DB khi user quay lại |
| OrderCode không tìm thấy | Log lỗi, user vẫn thấy thông báo thành công từ VNPAY |

## Các file đã sửa

| File | Thay đổi |
|------|----------|
| `VNPAYController.java` | Thêm CustomerOrderDAO, cập nhật DB trong IPN và return handler |
| `VNPAYService.java` | Hỗ trợ orderCode cho vnp_TxnRef |
| `CheckoutController.java` | Phân luồng COD/VNPAY, thêm success/failed handlers |
| `CustomerOrderDAO.java` | Thêm `findOrderByOrderCode`, `updatePaymentStatus`, `updateOrderStatus` |
| `HomeController.java` | Thêm `/home/vnpay-payment` endpoint |
| `vnpay_payment.jsp` | Trang hiển thị và gọi API VNPAY |

## Lưu ý quan trọng

1. **IPN URL** trong `application.properties` phải là public URL để VNPAY gọi được (localhost chỉ dùng cho test)
2. **Hash Secret** và **TmnCode** phải khớp với tài khoản VNPAY sandbox
3. Đơn hàng VNPAY được tạo với `payment_status='pending'`, chỉ chuyển sang `'paid'` sau khi thanh toán thành công
4. Giỏ hàng chỉ bị xóa sau khi thanh toán VNPAY thành công, nếu thất bại user có thể thử lại hoặc chọn COD
