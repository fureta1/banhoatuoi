package com.example.flowershop.service;

import com.example.flowershop.model.Cart;
import com.example.flowershop.model.CartItem;
import com.example.flowershop.model.Product;
import com.example.flowershop.model.User;
import com.example.flowershop.repository.CartRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service("cartDatabaseService")
@Transactional
public class CartService {

    @Autowired
    private CartRepository cartRepository;

    /**
     * Thêm sản phẩm vào giỏ hàng hoặc tăng số lượng nếu đã tồn tại
     */
    public Cart addToCart(User user, Product product, int quantity) {
        try {
            if (user == null || product == null || quantity <= 0) {
                return null;
            }

            Optional<Cart> existingCart = cartRepository.findByUser_IdAndProduct_Id(user.getId(), product.getId());
            
            if (existingCart.isPresent()) {
                Cart cart = existingCart.get();
                cart.setQuantity(cart.getQuantity() + quantity);
                return cartRepository.save(cart);
            } else {
                Cart newCart = new Cart();
                newCart.setUser(user);
                newCart.setProduct(product);
                newCart.setQuantity(quantity);
                return cartRepository.save(newCart);
            }
        } catch (Exception e) {
            // Log error and return null
            System.err.println("Error adding to cart: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }

    /**
     * Lấy tất cả items trong giỏ hàng của user
     */
    @Transactional(readOnly = true)
    public List<Cart> getUserCart(User user) {
        if (user == null) {
            return new ArrayList<>();
        }
        return cartRepository.findByUser_IdOrderByAddedAtDesc(user.getId());
    }

    /**
     * Chuyển đổi từ Cart entities sang CartItem để dùng với UI
     */
    @Transactional(readOnly = true)
    public List<CartItem> getCartItems(User user) {
        List<Cart> carts = getUserCart(user);
        List<CartItem> items = new ArrayList<>();
        
        for (Cart cart : carts) {
            CartItem item = new CartItem();
            item.setProduct(cart.getProduct());
            item.setQuantity(cart.getQuantity());
            item.setSelected(true); // Mặc định được chọn
            items.add(item);
        }
        
        return items;
    }

    /**
     * Cập nhật số lượng sản phẩm trong giỏ hàng
     */
    public Cart updateQuantity(User user, Product product, int quantity) {
        if (user == null || product == null || quantity <= 0) {
            return null;
        }

        Optional<Cart> existingCart = cartRepository.findByUser_IdAndProduct_Id(user.getId(), product.getId());
        
        if (existingCart.isPresent()) {
            Cart cart = existingCart.get();
            cart.setQuantity(quantity);
            return cartRepository.save(cart);
        }
        
        return null;
    }

    /**
     * Xóa sản phẩm khỏi giỏ hàng
     */
    public void removeFromCart(User user, Product product) {
        if (user == null || product == null) {
            return;
        }
        cartRepository.deleteByUser_IdAndProduct_Id(user.getId(), product.getId());
    }

    /**
     * Xóa toàn bộ giỏ hàng của user
     */
    public void clearCart(User user) {
        if (user == null) {
            return;
        }
        cartRepository.deleteByUser_Id(user.getId());
    }

    /**
     * Lấy tổng số lượng sản phẩm trong giỏ hàng
     */
    @Transactional(readOnly = true)
    public int getTotalQuantity(User user) {
        if (user == null) {
            return 0;
        }
        return cartRepository.findByUser_IdOrderByAddedAtDesc(user.getId())
                .stream()
                .mapToInt(Cart::getQuantity)
                .sum();
    }

    /**
     * Tính tổng tiền các sản phẩm được chọn
     */
    @Transactional(readOnly = true)
    public BigDecimal getSubTotal(User user, List<Integer> selectedProductIds) {
        if (user == null || selectedProductIds == null || selectedProductIds.isEmpty()) {
            return BigDecimal.ZERO;
        }

        return cartRepository.findByUser_IdOrderByAddedAtDesc(user.getId())
                .stream()
                .filter(cart -> selectedProductIds.contains(cart.getProduct().getId()))
                .map(cart -> {
                    Product product = cart.getProduct();
                    BigDecimal unitPrice = (product.getDiscountPrice() != null && 
                            product.getDiscountPrice().compareTo(BigDecimal.ZERO) > 0) 
                            ? product.getDiscountPrice() 
                            : product.getPrice();
                    return unitPrice.multiply(BigDecimal.valueOf(cart.getQuantity()));
                })
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    /**
     * Kiểm tra sản phẩm có trong giỏ hàng không
     */
    @Transactional(readOnly = true)
    public boolean isProductInCart(User user, Product product) {
        if (user == null || product == null) {
            return false;
        }
        return cartRepository.existsByUser_IdAndProduct_Id(user.getId(), product.getId());
    }

    /**
     * Lấy cart item cụ thể
     */
    @Transactional(readOnly = true)
    public Optional<Cart> getCartItem(User user, Product product) {
        if (user == null || product == null) {
            return Optional.empty();
        }
        return cartRepository.findByUser_IdAndProduct_Id(user.getId(), product.getId());
    }

    /**
     * Đồng bộ giỏ hàng từ session sang database khi user đăng nhập
     */
    public void syncCartFromSession(User user, List<CartItem> sessionCartItems) {
        if (user == null || sessionCartItems == null) {
            return;
        }

        for (CartItem item : sessionCartItems) {
            if (item.getProduct() != null && item.getQuantity() > 0) {
                addToCart(user, item.getProduct(), item.getQuantity());
            }
        }
    }
}
