package com.example.flowershop.controller.home;

import com.example.flowershop.model.CartItem;
import com.example.flowershop.model.Product;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@Service
public class CartService {

    private static final String CART_SESSION_KEY = "CART_SESSION";
    private static final BigDecimal FREE_SHIP_MIN = new BigDecimal("500000");
    private static final BigDecimal SHIPPING_FEE   = new BigDecimal("60000");

    @SuppressWarnings("unchecked")
    private Map<Integer, CartItem> getCartMap(HttpSession session) {
        Object obj = session.getAttribute(CART_SESSION_KEY);
        Map<Integer, CartItem> cart;
        if (obj instanceof Map<?, ?>) {
            cart = (Map<Integer, CartItem>) obj;
        } else {
            cart = new LinkedHashMap<>();
            session.setAttribute(CART_SESSION_KEY, cart);
        }
        return cart;
    }

    public void addToCart(Product product, int quantity, HttpSession session) {
        if (product == null || quantity <= 0) return;

        Map<Integer, CartItem> cart = getCartMap(session);
        CartItem item = cart.get(product.getId());

        if (item == null) {
            item = new CartItem(product, quantity);
        } else {
            item.setQuantity(item.getQuantity() + quantity);
        }
        cart.put(product.getId(), item);
    }

    public List<CartItem> getCartItems(HttpSession session) {
        return new ArrayList<>(getCartMap(session).values());
    }

    public int getTotalQuantity(HttpSession session) {
        return getCartMap(session).values().stream()
                .mapToInt(CartItem::getQuantity)
                .sum();
    }

    // Chỉ tính tiền những sản phẩm ĐƯỢC CHỌN
    public BigDecimal getSubTotal(HttpSession session) {
        return getCartMap(session).values().stream()
                .filter(CartItem::isSelected)
                .map(CartItem::getLineTotal)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    public BigDecimal getShippingFee(HttpSession session) {
        BigDecimal sub = getSubTotal(session);
        if (sub.compareTo(BigDecimal.ZERO) == 0) return BigDecimal.ZERO;
        return sub.compareTo(FREE_SHIP_MIN) >= 0 ? BigDecimal.ZERO : SHIPPING_FEE;
    }

    public BigDecimal getTotalAmount(HttpSession session) {
        return getSubTotal(session).add(getShippingFee(session));
    }

    // Cập nhật số lượng từ form qty_1, qty_2...
    public void updateQuantities(Map<String, String> params, HttpSession session) {
        Map<Integer, CartItem> cart = getCartMap(session);
        for (Map.Entry<String, String> e : params.entrySet()) {
            if (e.getKey().startsWith("qty_")) {
                try {
                    Integer pid = Integer.parseInt(e.getKey().substring(4));
                    int qty = Integer.parseInt(e.getValue());

                    CartItem item = cart.get(pid);
                    if (item != null) {
                        if (qty <= 0) {
                            cart.remove(pid);
                        } else {
                            int max = item.getProduct().getStockQuantity();
                            item.setQuantity(Math.min(qty, max));
                        }
                    }
                } catch (Exception ignored) {}
            }
        }
    }

    // Cập nhật các sản phẩm được CHỌN để thanh toán
    public void updateSelectedItems(List<Integer> selectedIds, HttpSession session) {
        Map<Integer, CartItem> cart = getCartMap(session);
        for (CartItem item : cart.values()) {
            boolean sel = selectedIds != null
                    && selectedIds.contains(item.getProduct().getId());
            item.setSelected(sel);
        }
    }

    public void removeFromCart(Integer productId, HttpSession session) {
        getCartMap(session).remove(productId);
    }

    // Xóa toàn bộ giỏ (nếu cần sau khi đặt hàng thành công)
    public void clearCart(HttpSession session) {
        session.removeAttribute(CART_SESSION_KEY);
    }
}
