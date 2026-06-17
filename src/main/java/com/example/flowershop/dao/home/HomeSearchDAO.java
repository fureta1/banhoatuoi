package com.example.flowershop.dao.home;

import com.example.flowershop.model.Category;
import com.example.flowershop.model.Product;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class HomeSearchDAO {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    /* ========================================================= */
    /* 1. Tìm danh mục theo từ khóa                               */
    /* ========================================================= */
    public List<Category> searchCategories(String keyword) {
        String like = "%" + keyword + "%";
        String sql = """
                SELECT
                    category_id   AS id,
                    category_name AS name,
                    description,
                    status
                FROM categories
                WHERE category_name LIKE ? AND status = 1
                """;
        return jdbcTemplate.query(
                sql,
                new BeanPropertyRowMapper<>(Category.class),
                like
        );
    }

    /* ========================================================= */
    /* 2. Lấy 1 danh mục theo ID (DÙNG ĐỂ HIỂN THỊ TÊN DANH MỤC) */
    /* ========================================================= */
    public Category findCategoryById(Integer categoryId) {
        String sql = """
                SELECT
                    category_id   AS id,
                    category_name AS name,
                    description,
                    status
                FROM categories
                WHERE category_id = ? AND status = 1
                """;
        try {
            return jdbcTemplate.queryForObject(
                    sql,
                    new BeanPropertyRowMapper<>(Category.class),
                    categoryId
            );
        } catch (Exception e) {
            // Không tìm thấy hoặc lỗi → trả null, tránh crash
            return null;
        }
    }

    /* ========================================================= */
    /* 3. Lấy tất cả sản phẩm của một danh mục                   */
    /* ========================================================= */
    public List<Product> getProductsByCategory(int categoryId) {
        String sql = """
                SELECT
                    product_id     AS id,
                    product_name   AS name,
                    description,
                    price,
                    discount_price AS discountPrice,
                    stock_quantity AS stockQuantity,
                    sold_quantity  AS soldQuantity,
                    main_image     AS mainImage,
                    status,
                    created_at     AS createdAt,
                    updated_at     AS updatedAt
                FROM products
                WHERE category_id = ?
                  AND status = 1
                ORDER BY created_at DESC
                """;
        return jdbcTemplate.query(
                sql,
                new BeanPropertyRowMapper<>(Product.class),
                categoryId
        );
    }

    /* ========================================================= */
    /* 4. Tìm sản phẩm theo tên                                  */
    /* ========================================================= */
    public List<Product> searchProducts(String keyword) {
        String like = "%" + keyword + "%";
        String sql = """
                SELECT
                    product_id     AS id,
                    product_name   AS name,
                    description,
                    price,
                    discount_price AS discountPrice,
                    stock_quantity AS stockQuantity,
                    sold_quantity  AS soldQuantity,
                    main_image     AS mainImage,
                    status,
                    created_at     AS createdAt,
                    updated_at     AS updatedAt
                FROM products
                WHERE product_name LIKE ?
                  AND status = 1
                ORDER BY created_at DESC
                """;
        return jdbcTemplate.query(
                sql,
                new BeanPropertyRowMapper<>(Product.class),
                like
        );
    }

    /* ========================================================= */
    /* 5. Lấy sản phẩm liên quan (cùng danh mục, khác product)   */
    /* ========================================================= */
    public List<Product> getRelatedProducts(int productId) {
        String sql = """
                SELECT
                    p2.product_id     AS id,
                    p2.product_name   AS name,
                    p2.description,
                    p2.price,
                    p2.discount_price AS discountPrice,
                    p2.stock_quantity AS stockQuantity,
                    p2.sold_quantity  AS soldQuantity,
                    p2.main_image     AS mainImage,
                    p2.status,
                    p2.created_at     AS createdAt,
                    p2.updated_at     AS updatedAt
                FROM products p1
                JOIN products p2
                  ON p1.category_id = p2.category_id
                 AND p2.product_id <> p1.product_id
                WHERE p1.product_id = ?
                  AND p2.status = 1
                ORDER BY p2.created_at DESC
                LIMIT 5
                """;
        return jdbcTemplate.query(
                sql,
                new BeanPropertyRowMapper<>(Product.class),
                productId
        );
    }

    /* ========================================================= */
    /* 6. Lấy chi tiết 1 sản phẩm theo product_id                */
    /* ========================================================= */
    public Product findProductById(int productId) {
        String sql = """
                SELECT
                    product_id     AS id,
                    product_name   AS name,
                    description,
                    price,
                    discount_price AS discountPrice,
                    stock_quantity AS stockQuantity,
                    sold_quantity  AS soldQuantity,
                    main_image     AS mainImage,
                    status,
                    created_at     AS createdAt,
                    updated_at     AS updatedAt
                FROM products
                WHERE product_id = ?
                """;
        try {
            return jdbcTemplate.queryForObject(
                    sql,
                    new BeanPropertyRowMapper<>(Product.class),
                    productId
            );
        } catch (Exception e) {
            return null;
        }
    }

    /* ========================================================= */
    /* 7. Lấy danh mục dựa theo product_id (phục vụ breadcrumb)  */
    /* ========================================================= */
    public Category findCategoryByProductId(int productId) {
        String sql = """
                SELECT
                    c.category_id   AS id,
                    c.category_name AS name,
                    c.description,
                    c.status
                FROM products p
                JOIN categories c ON p.category_id = c.category_id
                WHERE p.product_id = ?
                """;
        try {
            return jdbcTemplate.queryForObject(
                    sql,
                    new BeanPropertyRowMapper<>(Category.class),
                    productId
            );
        } catch (Exception e) {
            return null;
        }
    }
}
