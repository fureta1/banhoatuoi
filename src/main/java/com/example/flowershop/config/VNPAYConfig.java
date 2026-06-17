package com.example.flowershop.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;

@Configuration
public class VNPAYConfig {
    
    @Value("${vnpay.tmncode}")
    private String tmnCode;
    
    @Value("${vnpay.hashsecret}")
    private String hashSecret;
    
    @Value("${vnpay.url}")
    private String vnpayUrl;
    
    @Value("${vnpay.returnurl}")
    private String returnUrl;
    
    @Value("${vnpay.ipnurl}")
    private String ipnUrl;
    
    public String getTmnCode() {
        return tmnCode;
    }
    
    public String getHashSecret() {
        return hashSecret;
    }
    
    public String getVnpayUrl() {
        return vnpayUrl;
    }
    
    public String getReturnUrl() {
        return returnUrl;
    }
    
    public String getIpnUrl() {
        return ipnUrl;
    }
}
