package com.example.excel.sevice;

import com.example.excel.repository.ExcelRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

@Service
public class ExcelService {

    @Autowired
    private ExcelRepository excelRepository;

    public void processExcelFile(MultipartFile file) throws Exception {

    }
}