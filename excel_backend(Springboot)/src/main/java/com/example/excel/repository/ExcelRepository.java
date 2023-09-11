package com.example.excel.repository;

import com.example.excel.entity.ExcelData;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
@Repository
public interface ExcelRepository extends JpaRepository<ExcelData, Long> {
}