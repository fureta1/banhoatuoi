package com.example.flowershop.config;

import com.example.flowershop.dao.UserDAO;
import com.example.flowershop.dao.home.CartDAO;
import com.example.flowershop.model.CartItem;
import com.example.flowershop.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.password.NoOpPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;

import java.io.IOException;
import java.util.List;

@Configuration
public class SecurityConfig {

    @Autowired
    private CustomUserDetailsService customUserDetailsService;

    // Để lấy user & giỏ trong successHandler
    @Autowired
    private UserDAO userDAO;

    @Autowired
    private CartDAO cartDAO;

    @Bean
    @SuppressWarnings("deprecation")
    public PasswordEncoder passwordEncoder() {
        // Demo: dùng NoOp (mật khẩu plain-text). Làm thật thì dùng BCryptPasswordEncoder.
        return NoOpPasswordEncoder.getInstance();
    }

    @Bean
    public DaoAuthenticationProvider authenticationProvider() {
        DaoAuthenticationProvider auth = new DaoAuthenticationProvider();
        auth.setUserDetailsService(customUserDetailsService);
        auth.setPasswordEncoder(passwordEncoder());
        return auth;
    }

    // Phân luồng + NẠP GIỎ HÀNG sau khi đăng nhập thành công
    @Bean
    public AuthenticationSuccessHandler successHandler() {
        return new AuthenticationSuccessHandler() {
            @Override
            public void onAuthenticationSuccess(
                    HttpServletRequest req,
                    HttpServletResponse res,
                    Authentication auth
            ) throws IOException, ServletException {

                // 1. Lấy email user vừa login
                String email = auth.getName();
                User user = userDAO.findByEmail(email);

                if (user != null) {
                    // Lưu user vào session cho các chỗ khác dùng
                    req.getSession().setAttribute("currentUser", user);

                    // 2. NẠP GIỎ HÀNG TỪ DB
                    List<CartItem> items = cartDAO.findCartItemsByUserId(user.getUserId());
                    req.getSession().setAttribute("CART_ITEMS", items);

                    int totalQty = 0;
                    for (CartItem ci : items) {
                        totalQty += ci.getQuantity();
                    }
                    req.getSession().setAttribute("cartItemCount", totalQty);
                }

                // 3. Phân luồng theo quyền
                String role = auth.getAuthorities().iterator().next().getAuthority();
                String ctx = req.getContextPath();

                if ("admin".equals(role)) {
                    res.sendRedirect(ctx + "/admin/dashboard");
                } else {
                    res.sendRedirect(ctx + "/home/index");
                }
            }
        };
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
                .csrf(csrf -> csrf.disable())
                .authorizeHttpRequests(auth -> auth
                        // Public: trang ngoài, giỏ hàng, thanh toán, auth
                        .requestMatchers(
                                "/",
                                "/home/**",
                                "/product/**",
                                "/category/**",
                                "/tu-van-chon-hoa",
                                "/cart/**",
                                "/checkout/**",
                                "/search/**",
                                "/images/**",
                                "/css/**",
                                "/js/**",
                                "/static/**",
                                "/auth/**"
                        ).permitAll()

                        // Khu vực admin yêu cầu quyền "admin"
                        .requestMatchers("/admin/**").hasAuthority("admin")

                        // Các request còn lại
                        .anyRequest().permitAll()
                )
                .formLogin(form -> form
                        .loginPage("/auth/login")
                        .loginProcessingUrl("/auth/login")   // action trong form login
                        .usernameParameter("email")
                        .passwordParameter("password")
                        .successHandler(successHandler())     // DÙNG successHandler bên trên
                        .failureUrl("/auth/login?error=true")
                        .permitAll()
                )
                .logout(logout -> logout
                        .logoutUrl("/auth/logout")
                        .logoutSuccessUrl("/auth/login?logout=true")
                        .permitAll()
                );

        http.authenticationProvider(authenticationProvider());
        return http.build();
    }
}
