package com.example.flowershop.dao;

import com.example.flowershop.model.Category;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CategoryDAO extends JpaRepository<Category, Integer> {

    // tìm theo tên (không phân biệt hoa/thường)
    List<Category> findByNameContainingIgnoreCase(String keyword);

}
