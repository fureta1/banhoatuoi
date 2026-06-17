package com.example.flowershop.config;

import com.example.flowershop.dao.UserDAO;
import com.example.flowershop.model.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.*;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class CustomUserDetailsService implements UserDetailsService {

    @Autowired
    private UserDAO userDAO;

    @Override
    public UserDetails loadUserByUsername(String email) throws UsernameNotFoundException {
        User u = userDAO.findByEmail(email);
        if (u == null)
            throw new UsernameNotFoundException("Không tìm thấy tài khoản: " + email);

        List<SimpleGrantedAuthority> authorities =
                List.of(new SimpleGrantedAuthority(u.getRole())); // "admin" hoặc "customer"

        return new org.springframework.security.core.userdetails.User(
                u.getEmail(),
                u.getPassword(),
                authorities
        );
    }
}
