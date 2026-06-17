package com.example.flowershop.service;

import com.example.flowershop.config.VNPAYConfig;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Map;
import java.util.TreeMap;

@Service
public class VNPAYService {

    @Autowired
    private VNPAYConfig vnpayConfig;

    private static final ZoneId VNPAY_ZONE = ZoneId.of("Asia/Ho_Chi_Minh");
    private static final DateTimeFormatter FORMATTER = DateTimeFormatter.ofPattern("yyyyMMddHHmmss");

    public String createPaymentUrl(Map<String, String> params) {
        try {
            Map<String, String> vnpParams = new TreeMap<>();

            vnpParams.put("vnp_Version", "2.1.0");
            vnpParams.put("vnp_Command", "pay");
            vnpParams.put("vnp_TmnCode", vnpayConfig.getTmnCode());

            long amount = Long.parseLong(params.get("amount"));
            vnpParams.put("vnp_Amount", String.valueOf(amount * 100));
            vnpParams.put("vnp_CurrCode", "VND");

            String orderCode = params.getOrDefault("orderCode", String.valueOf(System.currentTimeMillis()));
            vnpParams.put("vnp_TxnRef", orderCode);

            // ❗ KHÔNG normalize
            vnpParams.put("vnp_OrderInfo", params.get("orderInfo"));

            vnpParams.put("vnp_OrderType", "billpayment");
            vnpParams.put("vnp_Locale", "vn");
            vnpParams.put("vnp_ReturnUrl", vnpayConfig.getReturnUrl());

            String ipAddr = params.getOrDefault("ipAddr", "127.0.0.1");
            if ("::1".equals(ipAddr) || "0:0:0:0:0:0:0:1".equals(ipAddr)) {
                ipAddr = "127.0.0.1";
            }
            vnpParams.put("vnp_IpAddr", ipAddr);

            ZonedDateTime now = ZonedDateTime.now(VNPAY_ZONE);
            vnpParams.put("vnp_CreateDate", now.format(FORMATTER));
            vnpParams.put("vnp_ExpireDate", now.plusMinutes(15).format(FORMATTER));

            // (optional nhưng nên có)
            vnpParams.put("vnp_SecureHashType", "HmacSHA512");

            StringBuilder hashData = new StringBuilder();
            StringBuilder query = new StringBuilder();

            for (Map.Entry<String, String> entry : vnpParams.entrySet()) {
                String key = entry.getKey();
                String value = entry.getValue();

                if (value == null || value.isEmpty()) continue;
                // ❗ Bỏ qua vnp_SecureHashType trong hashData
                if ("vnp_SecureHashType".equals(key)) continue;

                String encodedValue = URLEncoder.encode(value, StandardCharsets.UTF_8.toString());

                if (hashData.length() > 0) {
                    hashData.append("&");
                    query.append("&");
                }

                hashData.append(key).append("=").append(encodedValue);
                query.append(URLEncoder.encode(key, StandardCharsets.UTF_8.toString()))
                     .append("=")
                     .append(encodedValue);
            }

            String secureHash = hmacSHA512(vnpayConfig.getHashSecret(), hashData.toString());

            System.out.println("=== CREATE PAYMENT ===");
            System.out.println("HashData: " + hashData);
            System.out.println("SecureHash: " + secureHash);

            return vnpayConfig.getVnpayUrl() + "?" + query + "&vnp_SecureHash=" + secureHash;

        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public boolean validateResponse(Map<String, String> responseParams) {
        try {
            String receivedHash = responseParams.get("vnp_SecureHash");
            if (receivedHash == null) return false;

            Map<String, String> sortedParams = new TreeMap<>();

            for (Map.Entry<String, String> entry : responseParams.entrySet()) {
                String key = entry.getKey();
                String value = entry.getValue();

                if (!"vnp_SecureHash".equals(key)
                        && !"vnp_SecureHashType".equals(key)
                        && value != null && !value.isEmpty()) {
                    sortedParams.put(key, value);
                }
            }

            StringBuilder hashData = new StringBuilder();

            for (Map.Entry<String, String> entry : sortedParams.entrySet()) {
                if (hashData.length() > 0) hashData.append("&");

                // ❗ KHÔNG encode lại
                hashData.append(entry.getKey()).append("=").append(entry.getValue());
            }

            String calculatedHash = hmacSHA512(vnpayConfig.getHashSecret(), hashData.toString());

            System.out.println("=== VALIDATE RESPONSE ===");
            System.out.println("HashData: " + hashData);
            System.out.println("Calculated: " + calculatedHash);
            System.out.println("Received: " + receivedHash);

            return calculatedHash.equalsIgnoreCase(receivedHash);

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    private String hmacSHA512(String key, String data) {
        try {
            Mac mac = Mac.getInstance("HmacSHA512");
            SecretKeySpec secretKey = new SecretKeySpec(key.getBytes(StandardCharsets.UTF_8), "HmacSHA512");
            mac.init(secretKey);
            byte[] raw = mac.doFinal(data.getBytes(StandardCharsets.UTF_8));

            StringBuilder hex = new StringBuilder();
            for (byte b : raw) {
                hex.append(String.format("%02x", b));
            }
            return hex.toString();

        } catch (Exception e) {
            throw new RuntimeException("HMAC error", e);
        }
    }
}
