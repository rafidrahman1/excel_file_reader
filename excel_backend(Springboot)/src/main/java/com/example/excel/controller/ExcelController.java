package com.example.excel.controller;

import com.example.excel.entity.ExcelData;
import com.example.excel.repository.ExcelRepository;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

@RestController
@RequestMapping("/excel")
public class ExcelController {

    @Autowired
    private ExcelRepository excelRepository;

    @PostMapping("/upload")
    public void uploadExcelFile(@RequestParam("file") MultipartFile file) throws IOException {
        try (InputStream inputStream = file.getInputStream()) {
            Workbook workbook = new XSSFWorkbook(inputStream);
            Sheet sheet = workbook.getSheetAt(0); // Assuming the data is in the first sheet

            List<ExcelData> excelDataList = new ArrayList<>();

            Iterator<Row> iterator = sheet.iterator();
            if (iterator.hasNext()) {
                iterator.next(); // Move to the next row
            }

            while (iterator.hasNext()) {
                Row currentRow = iterator.next();
                ExcelData excelData = new ExcelData();
                Cell idCell = currentRow.getCell(0);
                Cell nameCell = currentRow.getCell(1);
                Cell emailCell = currentRow.getCell(2);
                Cell projectLinkCell = currentRow.getCell(3);

                excelData.setId((long) idCell.getNumericCellValue());
                excelData.setName(nameCell.getStringCellValue());
                excelData.setEmail(emailCell.getStringCellValue());
                excelData.setProjectLink(projectLinkCell.getStringCellValue());

                excelDataList.add(excelData);
            }

            excelRepository.saveAll(excelDataList);
        }
    }

    @GetMapping("/data")
    public List<ExcelData> getAllData() {
        return excelRepository.findAll();
    }
    @PostMapping("/add")
    public ExcelData addData(@RequestBody ExcelData excelData) {
        return excelRepository.save(excelData);
    }
    @DeleteMapping("/remove/{id}")
    public void removeExcelData(@PathVariable Long id) {
        excelRepository.deleteById(id);
    }
}