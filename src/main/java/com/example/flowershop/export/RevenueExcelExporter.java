package com.example.flowershop.export;

import com.example.flowershop.model.RevenueStat;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import jakarta.servlet.http.HttpServletResponse; // Nếu bạn dùng Spring Boot 3+
/* Nếu project của bạn vẫn dùng javax:
import javax.servlet.http.HttpServletResponse;
*/

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

public class RevenueExcelExporter {

    private final List<RevenueStat> stats;
    private final RevenueStat summary;
    private final LocalDate fromDate;
    private final LocalDate toDate;

    public RevenueExcelExporter(List<RevenueStat> stats,
                                RevenueStat summary,
                                LocalDate fromDate,
                                LocalDate toDate) {
        this.stats = stats;
        this.summary = summary;
        this.fromDate = fromDate;
        this.toDate = toDate;
    }

    public void export(HttpServletResponse response) throws IOException {
        // Tạo workbook & sheet
        XSSFWorkbook workbook = new XSSFWorkbook();
        XSSFSheet sheet = workbook.createSheet("Doanh thu");

        int rowIndex = 0;

        // ===== Style title =====
        CellStyle titleStyle = workbook.createCellStyle();
        Font titleFont = workbook.createFont();
        titleFont.setBold(true);
        titleFont.setFontHeightInPoints((short) 16);
        titleStyle.setFont(titleFont);

        Row titleRow = sheet.createRow(rowIndex++);
        Cell titleCell = titleRow.createCell(0);
        titleCell.setCellValue("BÁO CÁO DOANH THU");
        titleCell.setCellStyle(titleStyle);

        // Dòng khoảng thời gian
        Row rangeRow = sheet.createRow(rowIndex++);
        rangeRow.createCell(0).setCellValue("Từ ngày:");
        rangeRow.createCell(1).setCellValue(fromDate.toString());
        rangeRow.createCell(2).setCellValue("Đến ngày:");
        rangeRow.createCell(3).setCellValue(toDate.toString());

        // Dòng tổng quan
        rowIndex++;
        Row summaryHeader = sheet.createRow(rowIndex++);
        summaryHeader.createCell(0).setCellValue("Tổng doanh thu");
        summaryHeader.createCell(1).setCellValue("Tổng số đơn");
        summaryHeader.createCell(2).setCellValue("Đơn thành công");
        summaryHeader.createCell(3).setCellValue("Đơn bị hủy");

        Row summaryRow = sheet.createRow(rowIndex++);
        BigDecimal revenue = summary.getRevenue() == null ?
                BigDecimal.ZERO : summary.getRevenue();
        summaryRow.createCell(0).setCellValue(revenue.doubleValue());
        summaryRow.createCell(1).setCellValue(summary.getTotalOrders());
        summaryRow.createCell(2).setCellValue(summary.getSuccessOrders());
        summaryRow.createCell(3).setCellValue(summary.getCancelledOrders());

        // Dòng trống
        rowIndex++;

        // ===== Header bảng chi tiết =====
        Row headerRow = sheet.createRow(rowIndex++);
        headerRow.createCell(0).setCellValue("Ngày");
        headerRow.createCell(1).setCellValue("Doanh thu");
        headerRow.createCell(2).setCellValue("Số đơn");
        headerRow.createCell(3).setCellValue("Đơn thành công");
        headerRow.createCell(4).setCellValue("Đơn hủy");

        // Style header đậm
        CellStyle headerStyle = workbook.createCellStyle();
        Font headerFont = workbook.createFont();
        headerFont.setBold(true);
        headerStyle.setFont(headerFont);
        for (int i = 0; i <= 4; i++) {
            headerRow.getCell(i).setCellStyle(headerStyle);
        }

        // ===== Ghi dữ liệu chi tiết theo ngày =====
        if (stats != null) {
            for (RevenueStat s : stats) {
                Row row = sheet.createRow(rowIndex++);

                row.createCell(0).setCellValue(
                        s.getDate() != null ? s.getDate().toString() : ""
                );

                BigDecimal dayRevenue = s.getRevenue() == null ?
                        BigDecimal.ZERO : s.getRevenue();
                row.createCell(1).setCellValue(dayRevenue.doubleValue());
                row.createCell(2).setCellValue(s.getTotalOrders());
                row.createCell(3).setCellValue(s.getSuccessOrders());
                row.createCell(4).setCellValue(s.getCancelledOrders());
            }
        }

        // Auto size cột
        for (int i = 0; i <= 4; i++) {
            sheet.autoSizeColumn(i);
        }

        // Ghi file ra response
        workbook.write(response.getOutputStream());
        workbook.close();
    }
}

