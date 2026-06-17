package com.example.flowershop.dao.home;

import com.example.flowershop.model.Product;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@Repository
public class AdviceProductDAO {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    // RowMapper: map đúng CỘT trong DB sang model Product
    private final RowMapper<Product> productRowMapper = new RowMapper<Product>() {
        @Override
        public Product mapRow(ResultSet rs, int rowNum) throws SQLException {
            Product p = new Product();
            // ===== CỘT ĐÚNG THEO BẢNG PRODUCTS BẠN GỬI =====
            p.setId(rs.getInt("product_id"));
            p.setCategoryId(rs.getInt("category_id"));
            p.setName(rs.getString("product_name"));
            p.setDescription(rs.getString("description"));
            p.setPrice(rs.getBigDecimal("price"));
            p.setDiscountPrice(rs.getBigDecimal("discount_price"));
            p.setStockQuantity(rs.getInt("stock_quantity"));
            p.setSoldQuantity(rs.getInt("sold_quantity"));
            p.setMainImage(rs.getString("main_image"));
            p.setStatus(rs.getString("status"));
            p.setCreatedAt(rs.getTimestamp("created_at"));
            p.setUpdatedAt(rs.getTimestamp("updated_at"));
            return p;
        }
    };

    /**
     * Tư vấn sản phẩm chính:
     * - categoryId = null  -> tất cả danh mục
     * - minPrice / maxPrice = null -> không giới hạn ở đầu đó
     *
     * => Không chọn gì -> tất cả danh mục + tất cả giá (status = 'available')
     * => Không chọn danh mục, chọn giá -> tất cả danh mục nhưng trong khoảng giá
     * => Chọn danh mục, không giá -> 1 danh mục, mọi giá
     * => Chọn cả danh mục + giá -> giao của 2 điều kiện
     */
    public List<Product> findAdviceProducts(
            Long categoryId,
            BigDecimal minPrice,
            BigDecimal maxPrice,
            int limit
    ) {
        StringBuilder sql = new StringBuilder("""
            SELECT
                product_id,
                category_id,
                product_name,
                description,
                price,
                discount_price,
                stock_quantity,
                sold_quantity,
                main_image,
                status,
                created_at,
                updated_at
            FROM products
            WHERE status = 'available'
        """);

        List<Object> params = new ArrayList<>();

        // lọc theo danh mục (nếu chọn)
        if (categoryId != null) {
            sql.append(" AND category_id = ? ");
            params.add(categoryId);
        }

        // dùng giá thực tế: nếu có discount_price thì lấy discount_price, không thì price
        if (minPrice != null) {
            sql.append(" AND COALESCE(discount_price, price) >= ? ");
            params.add(minPrice);
        }
        if (maxPrice != null) {
            sql.append(" AND COALESCE(discount_price, price) <= ? ");
            params.add(maxPrice);
        }

        sql.append(" ORDER BY created_at DESC ");

        if (limit > 0) {
            sql.append(" LIMIT ? ");
            params.add(limit);
        }

        return jdbcTemplate.query(sql.toString(), productRowMapper, params.toArray());
    }

    /**
     * Gợi ý thêm sản phẩm:
     * - Có thể khác danh mục để đa dạng (tránh trùng category nếu có truyền categoryId).
     * - Cùng khoảng giá (nếu có min/max).
     */
    public List<Product> findRelatedProducts(
            Long categoryId,
            BigDecimal minPrice,
            BigDecimal maxPrice,
            int limit
    ) {
        StringBuilder sql = new StringBuilder("""
            SELECT
                product_id,
                category_id,
                product_name,
                description,
                price,
                discount_price,
                stock_quantity,
                sold_quantity,
                main_image,
                status,
                created_at,
                updated_at
            FROM products
            WHERE status = 'available'
        """);

        List<Object> params = new ArrayList<>();

        // nếu có categoryId thì gợi ý khác danh mục
        if (categoryId != null) {
            sql.append(" AND category_id <> ? ");
            params.add(categoryId);
        }

        if (minPrice != null) {
            sql.append(" AND COALESCE(discount_price, price) >= ? ");
            params.add(minPrice);
        }
        if (maxPrice != null) {
            sql.append(" AND COALESCE(discount_price, price) <= ? ");
            params.add(maxPrice);
        }

        sql.append(" ORDER BY created_at DESC ");

        if (limit > 0) {
            sql.append(" LIMIT ? ");
            params.add(limit);
        }

        return jdbcTemplate.query(sql.toString(), productRowMapper, params.toArray());
    }
}
