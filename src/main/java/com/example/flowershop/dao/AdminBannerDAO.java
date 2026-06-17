package com.example.flowershop.dao;

import com.example.flowershop.model.Banner;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class AdminBannerDAO {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    private final RowMapper<Banner> bannerRowMapper =
            new BeanPropertyRowMapper<>(Banner.class);

    /**
     * Lấy tất cả banner, dùng cho trang quản lý banner admin.
     */
    public List<Banner> findAll() {
        String sql = """
                SELECT 
                    banner_id      AS bannerId,
                    title,
                    image_url      AS imageUrl,
                    link_url       AS linkUrl,
                    display_order  AS displayOrder,
                    status,
                    start_date     AS startDate,
                    end_date       AS endDate,
                    created_at     AS createdAt
                FROM banners
                ORDER BY display_order ASC, created_at DESC
                """;
        return jdbcTemplate.query(sql, bannerRowMapper);
    }

    /**
     * Lấy 1 banner theo ID.
     */
    public Banner findById(Integer id) {
        String sql = """
                SELECT 
                    banner_id      AS bannerId,
                    title,
                    image_url      AS imageUrl,
                    link_url       AS linkUrl,
                    display_order  AS displayOrder,
                    status,
                    start_date     AS startDate,
                    end_date       AS endDate,
                    created_at     AS createdAt
                FROM banners
                WHERE banner_id = ?
                """;
        return jdbcTemplate.queryForObject(sql, bannerRowMapper, id);
    }

    /**
     * Thêm banner mới.
     */
    public void insert(Banner banner) {
        String sql = """
                INSERT INTO banners
                    (title, image_url, link_url, display_order, status, start_date, end_date)
                VALUES (?, ?, ?, ?, ?, ?, ?)
                """;
        jdbcTemplate.update(sql,
                banner.getTitle(),
                banner.getImageUrl(),
                banner.getLinkUrl(),
                banner.getDisplayOrder(),
                banner.getStatus(),
                banner.getStartDate(),
                banner.getEndDate()
        );
    }

    /**
     * Cập nhật banner.
     */
    public void update(Banner banner) {
        String sql = """
                UPDATE banners
                SET title         = ?,
                    image_url     = ?,
                    link_url      = ?,
                    display_order = ?,
                    status        = ?,
                    start_date    = ?,
                    end_date      = ?
                WHERE banner_id   = ?
                """;
        jdbcTemplate.update(sql,
                banner.getTitle(),
                banner.getImageUrl(),
                banner.getLinkUrl(),
                banner.getDisplayOrder(),
                banner.getStatus(),
                banner.getStartDate(),
                banner.getEndDate(),
                banner.getBannerId()
        );
    }

    /**
     * Xóa banner.
     */
    public void delete(Integer id) {
        String sql = "DELETE FROM banners WHERE banner_id = ?";
        jdbcTemplate.update(sql, id);
    }
}

