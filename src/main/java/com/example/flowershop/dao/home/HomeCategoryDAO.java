package com.example.flowershop.dao.home;

import com.example.flowershop.model.Category;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

@Repository
public class HomeCategoryDAO {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    // Map từ bảng categories sang model Category
    private final RowMapper<Category> categoryRowMapper = new RowMapper<Category>() {
        @Override
        public Category mapRow(ResultSet rs, int rowNum) throws SQLException {
            Category c = new Category();
            c.setId(rs.getInt("category_id"));             // id trong model
            c.setName(rs.getString("category_name"));      // name trong model
            c.setDescription(rs.getString("description"));
            c.setImageUrl(rs.getString("image_url"));
            c.setStatus(rs.getString("status"));
            c.setCreatedAt(rs.getTimestamp("created_at"));
            return c;
        }
    };

    // Lấy tất cả danh mục đang active – dùng cho combobox, tư vấn chọn hoa
    public List<Category> findActiveCategories() {
        String sql = """
                SELECT category_id, category_name, description, image_url, status, created_at
                FROM categories
                WHERE status = 'active'
                ORDER BY category_name
                """;
        return jdbcTemplate.query(sql, categoryRowMapper);
    }

    // Alias cho dễ nhớ dùng trong view
    public List<Category> findAllActive() {
        return findActiveCategories();
    }

    // Lấy 5 danh mục cho mega menu
    public List<Category> findCategoriesForHomeMenu() {
        String sql = """
                SELECT category_id, category_name, description, image_url, status, created_at
                FROM categories
                WHERE status = 'active'
                  AND category_name IN (
                      'Hoa Sinh Nhật',
                      'Hoa Khai Trương',
                      'Hoa Cưới',
                      'Hoa Tình Yêu',
                      'Hoa Chia Buồn'
                  )
                ORDER BY FIELD(
                      category_name,
                      'Hoa Sinh Nhật',
                      'Hoa Khai Trương',
                      'Hoa Cưới',
                      'Hoa Tình Yêu',
                      'Hoa Chia Buồn'
                )
                """;
        return jdbcTemplate.query(sql, categoryRowMapper);
    }

    // Tìm 1 danh mục theo ID
    public Category findById(Long id) {
        String sql = """
                SELECT category_id, category_name, description, image_url, status, created_at
                FROM categories
                WHERE category_id = ?
                  AND status = 'active'
                """;
        List<Category> list = jdbcTemplate.query(sql, categoryRowMapper, id);
        return list.isEmpty() ? null : list.get(0);
    }

    // Tìm 1 danh mục theo tên (dùng cho /category?categoryName=Hoa Sinh Nhật)
    public Category findByName(String name) {
        String sql = """
                SELECT category_id, category_name, description, image_url, status, created_at
                FROM categories
                WHERE category_name = ?
                  AND status = 'active'
                """;
        List<Category> list = jdbcTemplate.query(sql, categoryRowMapper, name);
        return list.isEmpty() ? null : list.get(0);
    }
}
