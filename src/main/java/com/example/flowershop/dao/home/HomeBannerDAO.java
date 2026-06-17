package com.example.flowershop.dao.home;

import com.example.flowershop.model.Banner;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class HomeBannerDAO {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    private final RowMapper<Banner> bannerRowMapper =
            new BeanPropertyRowMapper<>(Banner.class);

    /**
     * Lấy các banner đang active và còn hiệu lực (tối đa 5 cái) để chạy slider.
     */
    public List<Banner> findActiveBanners() {
        String sql = """
                SELECT banner_id, title, image_url, link_url, display_order,
                       status, start_date, end_date, created_at
                FROM banners
                WHERE status = 'active'
                  AND (start_date IS NULL OR start_date <= CURDATE())
                  AND (end_date IS NULL OR end_date >= CURDATE())
                ORDER BY display_order ASC, created_at DESC
                LIMIT 5
                """;
        return jdbcTemplate.query(sql, bannerRowMapper);
    }
}
