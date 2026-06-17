package com.example.flowershop.dao;

import com.example.flowershop.model.Product;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ProductDAO extends JpaRepository<Product, Integer> {

    // đã có
    List<Product> findByCategory_Id(Integer categoryId);

    // thêm để search theo tên (dùng cho trang /admin/products)
    List<Product> findByNameContainingIgnoreCase(String keyword);
}
