# Test VNPAY Payment Flow

## Data mẫu cần insert

```sql
-- 1. User test (password: 123456)
INSERT INTO users (email, password, full_name, phone, role, status, created_at, updated_at) 
VALUES ('test@gmail.com', '$2a$10$N9qoBuGJs/sxSlplZgZv8.nmRXTBhDdU3C0NTlvHK9Q0E9L8V1kZu', 'Nguyễn Văn Test', '0909123456', 'customer', 'active', NOW(), NOW());

-- 2. Danh mục
INSERT INTO categories (category_name, description, status, created_at) 
VALUES ('Hoa Test', 'Danh mục test', 'active', NOW());

-- 3. Sản phẩm
INSERT INTO products (category_id, product_name, description, price, stock_quantity, status, created_at, updated_at) 
VALUES (1, 'Bó Hoa Test', 'Hoa test thanh toán', 100000, 50, 'active', NOW(), NOW());
```

## Các cách test

### Cách 1: Test qua UI (Khuyến nghị)

1. Đăng nhập: http://localhost:8081/auth/login
   - Email: test@gmail.com
   - Password: 123456

2. Thêm sản phẩm vào giỏ

3. Vào giỏ hàng → Nhập thông tin giao hàng → Chọn "Thanh toán VNPAY"

4. Click "Đặt hàng" → Click "Thanh toán ngay"

5. Nhập test card: **4111111111111111** | 12/25 | 123 | NGUYEN VAN A

6. Kiểm tra kết quả trong DB:
```sql
SELECT order_code, payment_status, order_status 
FROM orders WHERE user_id = 1 ORDER BY created_at DESC LIMIT 1;
-- Kết quả mong đợi: payment_status='paid', order_status='confirmed'
```

---

### Cách 2: Test API bằng curl

#### Bước 1: Tạo đơn hàng qua API (hoặc tạo trực tiếp trong DB)

```sql
-- Insert đơn hàng test trực tiếp
INSERT INTO orders (
    user_id, order_code, recipient_name, phone, address_line, ward, district, city,
    subtotal, shipping_fee, discount_amount, total_amount,
    payment_method, payment_status, order_status, note, created_at, updated_at
) VALUES (
    1, 'DH999001', 'Test User', '0909123456', '123 Test Street', 'Ward 1', 'District 1', 'HCM',
    100000, 0, 0, 100000,
    'bank_transfer', 'pending', 'pending', 'Test VNPAY', NOW(), NOW()
);
```

#### Bước 2: Gọi API tạo URL thanh toán VNPAY

```bash
curl -X POST http://localhost:8081/vnpay/create_payment \
  -d "amount=100000" \
  -d "orderInfo=Thanh toan don hang DH999001" \
  -d "orderCode=DH999001"
```

**Response mong đợi:**
```json
{
  "status": "success",
  "paymentUrl": "https://sandbox.vnpayment.vn/paymentv2/vpcpay.html?vnp_Amount=10000000&..."
}
```

#### Bước 3: Mở paymentUrl trong browser và thanh toán

- Nhập test card: 4111111111111111
- Sau thanh toán, VNPAY redirect về: http://localhost:8081/vnpay/return?...

#### Bước 4: Kiểm tra DB

```sql
-- Kiểm tra trạng thái đơn hàng
SELECT order_code, payment_status, order_status, updated_at 
FROM orders WHERE order_code = 'DH999001';

-- Kết quả mong đợi:
-- order_code: DH999001
-- payment_status: paid
-- order_status: confirmed
```

---

### Cách 3: Test IPN webhook (Server-to-server)

Sau khi thanh toán thành công, VNPAY gọi IPN:

```bash
curl -X POST http://localhost:8081/vnpay/ipn \
  -d "vnp_TxnRef=DH999001" \
  -d "vnp_TransactionStatus=00" \
  -d "vnp_SecureHash=valid_hash_here"
```

**Response mong đợi:** `OK`

---

## Kiểm tra các trường hợp

### 1. Thanh toán thành công
```sql
-- Trước khi thanh toán
SELECT payment_status, order_status FROM orders WHERE order_code = 'DH999001';
-- Result: pending, pending

-- Sau khi thanh toán
SELECT payment_status, order_status FROM orders WHERE order_code = 'DH999001';
-- Result: paid, confirmed
```

### 2. Thanh toán thất bại
- Dùng test card: 4242424242424242
- Kiểm tra: payment_status = 'failed'

### 3. User hủy thanh toán
- Đóng trang VNPAY
- Giỏ hàng vẫn còn, có thể thử lại hoặc chọn COD

---

## Test Script tự động (Bash)

```bash
#!/bin/bash

BASE_URL="http://localhost:8081"
ORDER_CODE="DH$(date +%s)"

echo "=== Test VNPAY Payment ==="
echo "Order Code: $ORDER_CODE"

# 1. Create order in DB first (manual or via API)
# ... insert SQL ...

# 2. Create payment URL
echo "Creating payment URL..."
RESPONSE=$(curl -s -X POST "$BASE_URL/vnpay/create_payment" \
  -d "amount=100000" \
  -d "orderInfo=Test order $ORDER_CODE" \
  -d "orderCode=$ORDER_CODE")

echo "Response: $RESPONSE"

# 3. Extract paymentUrl
PAYMENT_URL=$(echo $RESPONSE | grep -o '"paymentUrl":"[^"]*"' | cut -d'"' -f4)

if [ -n "$PAYMENT_URL" ]; then
    echo ""
    echo "Open this URL in browser to test:"
    echo "$PAYMENT_URL"
else
    echo "Failed to create payment URL"
fi
```

---

## Checklist kiểm tra sau khi fix

- [ ] Tạo đơn hàng với payment_method='bank_transfer' có payment_status='pending'
- [ ] Gọi `/vnpay/create_payment` trả về URL hợp lệ
- [ ] Thanh toán thành công → DB cập nhật payment_status='paid'
- [ ] Thanh toán thành công → DB cập nhật order_status='confirmed'
- [ ] IPN nhận được và trả về "OK"
- [ ] Return URL redirect đến `/checkout/vnpay-success`
- [ ] Giỏ hàng được xóa sau thanh toán thành công
- [ ] Thanh toán thất bại redirect đến `/checkout/vnpay-failed`
- [ ] Giỏ hàng được giữ lại khi thanh toán thất bại
