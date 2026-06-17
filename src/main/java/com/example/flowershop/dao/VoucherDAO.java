package com.example.flowershop.dao;

import com.example.flowershop.model.Voucher;
import org.springframework.data.jpa.repository.JpaRepository;

public interface VoucherDAO extends JpaRepository<Voucher, Integer> {
    Voucher findByCode(String code);
}
