package com.example.flowershop.dao.home;

import com.example.flowershop.model.Product;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.util.ArrayList;
import java.util.List;

@Repository
public class HomeProductDAO {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    // Map cột trong bảng products -> fields trong Product
    private final RowMapper<Product> productRowMapper =
            new BeanPropertyRowMapper<>(Product.class);

    /**
     * Lấy top N sản phẩm của 1 danh mục theo tên danh mục
     * (dùng cho 3 block: Sinh nhật, Khai trương, Cưới ở trang index).
     */
    public List<Product> findTopProductsByCategoryName(String categoryName, int limit) {
        String sql = """
                SELECT p.*
                FROM products p
                JOIN categories c ON p.category_id = c.category_id
                WHERE p.status = 'available'
                  AND c.status = 'active'
                  AND c.category_name = ?
                ORDER BY p.created_at DESC
                LIMIT ?
                """;
        return jdbcTemplate.query(sql, productRowMapper, categoryName, limit);
    }

    /**
     * Tìm kiếm theo keyword + categoryId (từ thanh tìm kiếm trên cùng).
     */
    public List<Product> searchProducts(String keyword, Integer categoryId) {
        StringBuilder sql = new StringBuilder("""
                SELECT p.*
                FROM products p
                LEFT JOIN categories c ON p.category_id = c.category_id
                WHERE p.status = 'available'
                """);

        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("""
                    AND (
                        p.product_name LIKE ?
                        OR p.description LIKE ?
                        OR c.category_name LIKE ?
                    )
                    """);
            String like = "%" + keyword.trim() + "%";
            params.add(like);
            params.add(like);
            params.add(like);
        }

        if (categoryId != null) {
            sql.append(" AND p.category_id = ? ");
            params.add(categoryId);
        }

        sql.append(" ORDER BY p.product_name ASC ");

        return jdbcTemplate.query(sql.toString(), productRowMapper, params.toArray());
    }

    /**
     * Lọc sản phẩm theo danh mục + mức giá (Tư vấn chọn hoa / trang lọc).
     *
     * priceRange hỗ trợ:
     *  - UNDER_300   : < 300.000
     *  - 300_700     : 300.000 – 700.000
     *  - 700_1000    : 700.000 – 1.000.000
     *  - 1000_2000   : 1.000.000 – 2.000.000
     *  - OVER_2000   : > 2.000.000
     *
     * Không truyền hoặc truyền rỗng -> không lọc theo giá.
     */
    public List<Product> filterByCategoryAndPrice(Integer categoryId, String priceRange) {
        StringBuilder sql = new StringBuilder("""
                SELECT p.*
                FROM products p
                WHERE p.status = 'available'
                """);
        List<Object> params = new ArrayList<>();

        // Lọc theo danh mục (nếu có chọn)
        if (categoryId != null) {
            sql.append(" AND p.category_id = ? ");
            params.add(categoryId);
        }

        // Dùng giá thực tế = COALESCE(discount_price, price)
        if (priceRange != null && !priceRange.isBlank()) {
            switch (priceRange) {
                case "UNDER_300" -> {
                    sql.append(" AND COALESCE(p.discount_price, p.price) < 300000 ");
                }
                case "300_700" -> {
                    sql.append("""
                            AND COALESCE(p.discount_price, p.price)
                                BETWEEN 300000 AND 700000
                            """);
                }
                case "700_1000" -> {
                    sql.append("""
                            AND COALESCE(p.discount_price, p.price)
                                BETWEEN 700000 AND 1000000
                            """);
                }
                case "1000_2000" -> {
                    sql.append("""
                            AND COALESCE(p.discount_price, p.price)
                                BETWEEN 1000000 AND 2000000
                            """);
                }
                case "OVER_2000" -> {
                    sql.append(" AND COALESCE(p.discount_price, p.price) > 2000000 ");
                }
                default -> {
                    // giá trị lạ -> không lọc theo giá
                }
            }
        }

        sql.append(" ORDER BY p.created_at DESC ");

        return jdbcTemplate.query(sql.toString(), productRowMapper, params.toArray());
    }

    /**
     * Lấy tất cả sản phẩm của 1 danh mục (dùng cho trang category.jsp / Hoa Sinh Nhật,…)
     */
    public List<Product> findProductsByCategory(Long categoryId) {
        String sql = """
                SELECT p.*
                FROM products p
                WHERE p.status = 'available'
                  AND p.category_id = ?
                ORDER BY p.created_at DESC
                """;

        return jdbcTemplate.query(sql, productRowMapper, categoryId);
    }
    // ================== TÌM SẢN PHẨM THEO ID (dùng cho giỏ hàng) ==================
public Product findById(Integer productId) {
    String sql = """
            SELECT *
            FROM products
            WHERE product_id = ?
            """;

    List<Product> list = jdbcTemplate.query(sql, productRowMapper, productId);
    return list.isEmpty() ? null : list.get(0);
}

}
