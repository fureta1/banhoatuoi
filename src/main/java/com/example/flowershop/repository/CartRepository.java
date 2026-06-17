package com.example.flowershop.repository;

import com.example.flowershop.model.Cart;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface CartRepository extends JpaRepository<Cart, Integer> {

    /**
     * Tìm cart item theo user và product
     */
    Optional<Cart> findByUser_IdAndProduct_Id(Integer userId, Integer productId);

    /**
     * Lấy tất cả cart items của một user
     */
    List<Cart> findByUser_IdOrderByAddedAtDesc(Integer userId);

    /**
     * Xóa tất cả cart items của một user
     */
    @Modifying
    @Query("DELETE FROM Cart c WHERE c.user.id = :userId")
    void deleteByUser_Id(@Param("userId") Integer userId);

    /**
     * Xóa một cart item cụ thể
     */
    @Modifying
    @Query("DELETE FROM Cart c WHERE c.user.id = :userId AND c.product.id = :productId")
    void deleteByUser_IdAndProduct_Id(@Param("userId") Integer userId, @Param("productId") Integer productId);

    /**
     * Kiểm tra user có sản phẩm trong giỏ hàng không
     */
    boolean existsByUser_IdAndProduct_Id(Integer userId, Integer productId);

    /**
     * Đếm số sản phẩm trong giỏ hàng của user
     */
    long countByUser_Id(Integer userId);
}
