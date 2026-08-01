package controller;

import Service.connectService;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet(name = "ExportExcelServlet", urlPatterns = {"/exportExcel"})
public class ExportExcelServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("username") == null || !"admin".equals(session.getAttribute("quyen"))) {
            response.sendRedirect("index.jsp");
            return;
        }

        String fromDate = request.getParameter("fromDate");
        String toDate = request.getParameter("toDate");

        String startDateSql = (fromDate != null && !fromDate.isEmpty()) ? fromDate + " 00:00:00" : "1900-01-01 00:00:00";
        String endDateSql = (toDate != null && !toDate.isEmpty()) ? toDate + " 23:59:59" : "2100-12-31 23:59:59";

        try (Workbook workbook = new XSSFWorkbook();
             Connection con = new connectService().myConnection()) {

            CellStyle headerStyle = workbook.createCellStyle();
            headerStyle.setFillForegroundColor(IndexedColors.TEAL.getIndex());
            headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
            Font headerFont = workbook.createFont();
            headerFont.setColor(IndexedColors.WHITE.getIndex());
            headerFont.setBold(true);
            headerStyle.setFont(headerFont);
            headerStyle.setBorderBottom(BorderStyle.THIN);
            headerStyle.setBorderTop(BorderStyle.THIN);
            headerStyle.setBorderLeft(BorderStyle.THIN);
            headerStyle.setBorderRight(BorderStyle.THIN);

            CellStyle dataStyle = workbook.createCellStyle();
            dataStyle.setBorderBottom(BorderStyle.THIN);
            dataStyle.setBorderTop(BorderStyle.THIN);
            dataStyle.setBorderLeft(BorderStyle.THIN);
            dataStyle.setBorderRight(BorderStyle.THIN);

            CellStyle currencyStyle = workbook.createCellStyle();
            currencyStyle.cloneStyleFrom(dataStyle);
            DataFormat format = workbook.createDataFormat();
            currencyStyle.setDataFormat(format.getFormat("#,##0 \"₫\""));
            
            CellStyle dateStyle = workbook.createCellStyle();
            dateStyle.cloneStyleFrom(dataStyle);
            dateStyle.setDataFormat(format.getFormat("dd/mm/yyyy hh:mm"));

            // 1. Sheet Overview
            Sheet sheet1 = workbook.createSheet("TongQuan");
            int totalHD = 0; int totalSP = 0; double totalDoanhThu = 0; double totalKhuyenMai = 0;

            String sqlOverview = "SELECT " +
                    "(SELECT COUNT(*) FROM HoaDon WHERE TrangThai=1 AND NgayTao >= ? AND NgayTao <= ?) AS TongHD, " +
                    "(SELECT ISNULL(SUM(SoLuong),0) FROM HoaDonChiTiet ct JOIN HoaDon h ON ct.MaHD = h.MaHD WHERE h.TrangThai=1 AND h.NgayTao >= ? AND h.NgayTao <= ?) AS TongSP, " +
                    "(SELECT ISNULL(SUM(TongTien),0) FROM HoaDon WHERE TrangThai=1 AND NgayTao >= ? AND NgayTao <= ?) AS TongTien, " +
                    "(SELECT ISNULL(SUM(GiamGia),0) FROM HoaDon WHERE TrangThai=1 AND NgayTao >= ? AND NgayTao <= ?) AS GiamGia";
            
            try (PreparedStatement ps = con.prepareStatement(sqlOverview)) {
                ps.setString(1, startDateSql); ps.setString(2, endDateSql);
                ps.setString(3, startDateSql); ps.setString(4, endDateSql);
                ps.setString(5, startDateSql); ps.setString(6, endDateSql);
                ps.setString(7, startDateSql); ps.setString(8, endDateSql);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    totalHD = rs.getInt("TongHD");
                    totalSP = rs.getInt("TongSP");
                    totalDoanhThu = rs.getDouble("TongTien");
                    totalKhuyenMai = rs.getDouble("GiamGia");
                }
            }
            
            Row rowTitle = sheet1.createRow(0);
            Cell cellTitle = rowTitle.createCell(0);
            cellTitle.setCellValue("BÁO CÁO DOANH THU BOOKSTORE");
            
            String[] overHeaders = {"Thống kê", "Giá trị"};
            Row rowH1 = sheet1.createRow(2);
            for(int i=0; i<overHeaders.length; i++){
                Cell c = rowH1.createCell(i); c.setCellValue(overHeaders[i]); c.setCellStyle(headerStyle);
            }
            
            Object[][] overData = {
                {"Tổng hóa đơn", totalHD},
                {"Tổng sản phẩm bán", totalSP},
                {"Tổng doanh thu", totalDoanhThu},
                {"Khuyến mãi", totalKhuyenMai},
                {"Doanh thu thực", totalDoanhThu}
            };
            
            int rId = 3;
            for(Object[] rowData : overData){
                Row r = sheet1.createRow(rId++);
                Cell c0 = r.createCell(0); c0.setCellValue(rowData[0].toString()); c0.setCellStyle(dataStyle);
                Cell c1 = r.createCell(1);
                if (rowData[1] instanceof Integer) {
                    c1.setCellValue((Integer) rowData[1]);
                    c1.setCellStyle(dataStyle);
                } else {
                    c1.setCellValue((Double) rowData[1]);
                    c1.setCellStyle(currencyStyle);
                }
            }
            sheet1.autoSizeColumn(0); sheet1.autoSizeColumn(1);

            // 2. Sheet Chi Tiet Hoa Don
            Sheet sheet2 = workbook.createSheet("ChiTietHoaDon");
            String[] hdHeaders = {"STT", "Mã HĐ", "Ngày Lập", "Khách Hàng", "Nhân Viên", "Tổng Tiền", "Khuyến Mãi", "Trạng Thái"};
            Row rHDH = sheet2.createRow(0);
            for(int i=0; i<hdHeaders.length; i++){
                Cell c = rHDH.createCell(i); c.setCellValue(hdHeaders[i]); c.setCellStyle(headerStyle);
            }
            
            String sqlHD = "SELECT h.MaHD, h.NgayTao, ISNULL(k.HoTen, N'Khách lẻ') AS Khach, n.HoTen AS NV, h.TongTien, h.GiamGia, h.TrangThai " +
                           "FROM HoaDon h LEFT JOIN KhachHang k ON h.MaKH = k.MaKH LEFT JOIN NhanVien n ON h.MaNV = n.MaNV " +
                           "WHERE h.NgayTao >= ? AND h.NgayTao <= ? ORDER BY h.NgayTao DESC";
            try (PreparedStatement ps = con.prepareStatement(sqlHD)) {
                ps.setString(1, startDateSql); ps.setString(2, endDateSql);
                ResultSet rs = ps.executeQuery();
                int stt = 1;
                while (rs.next()) {
                    Row r = sheet2.createRow(stt);
                    r.createCell(0).setCellValue(stt); r.getCell(0).setCellStyle(dataStyle);
                    r.createCell(1).setCellValue("HD" + rs.getInt("MaHD")); r.getCell(1).setCellStyle(dataStyle);
                    r.createCell(2).setCellValue(rs.getTimestamp("NgayTao")); r.getCell(2).setCellStyle(dateStyle);
                    r.createCell(3).setCellValue(rs.getString("Khach")); r.getCell(3).setCellStyle(dataStyle);
                    r.createCell(4).setCellValue(rs.getString("NV")); r.getCell(4).setCellStyle(dataStyle);
                    r.createCell(5).setCellValue(rs.getDouble("TongTien")); r.getCell(5).setCellStyle(currencyStyle);
                    r.createCell(6).setCellValue(rs.getDouble("GiamGia")); r.getCell(6).setCellStyle(currencyStyle);
                    r.createCell(7).setCellValue(rs.getInt("TrangThai") == 1 ? "Thành công" : "Hủy/Chờ"); r.getCell(7).setCellStyle(dataStyle);
                    stt++;
                }
            }
            for(int i=0; i<hdHeaders.length; i++) sheet2.autoSizeColumn(i);

            // 3. Sheet Top Sach
            Sheet sheet3 = workbook.createSheet("TopSachBanChay");
            String[] sHeaders = {"STT", "Mã Sách", "Tên Sách", "Đã Bán", "Doanh Thu"};
            Row rSH = sheet3.createRow(0);
            for(int i=0; i<sHeaders.length; i++){
                Cell c = rSH.createCell(i); c.setCellValue(sHeaders[i]); c.setCellStyle(headerStyle);
            }
            
            String sqlTop = "SELECT s.MaSach, s.TenSach, SUM(ct.SoLuong) AS DaBan, SUM(ct.SoLuong * ct.DonGia) AS DoanhThu " +
                            "FROM HoaDonChiTiet ct JOIN HoaDon h ON ct.MaHD = h.MaHD JOIN Sach s ON ct.MaSach = s.MaSach " +
                            "WHERE h.TrangThai = 1 AND h.NgayTao >= ? AND h.NgayTao <= ? " +
                            "GROUP BY s.MaSach, s.TenSach ORDER BY DaBan DESC";
            try (PreparedStatement ps = con.prepareStatement(sqlTop)) {
                ps.setString(1, startDateSql); ps.setString(2, endDateSql);
                ResultSet rs = ps.executeQuery();
                int stt = 1;
                while (rs.next()) {
                    Row r = sheet3.createRow(stt);
                    r.createCell(0).setCellValue(stt); r.getCell(0).setCellStyle(dataStyle);
                    r.createCell(1).setCellValue("S" + rs.getInt("MaSach")); r.getCell(1).setCellStyle(dataStyle);
                    r.createCell(2).setCellValue(rs.getString("TenSach")); r.getCell(2).setCellStyle(dataStyle);
                    r.createCell(3).setCellValue(rs.getInt("DaBan")); r.getCell(3).setCellStyle(dataStyle);
                    r.createCell(4).setCellValue(rs.getDouble("DoanhThu")); r.getCell(4).setCellStyle(currencyStyle);
                    stt++;
                }
            }
            for(int i=0; i<sHeaders.length; i++) sheet3.autoSizeColumn(i);

            // 4. Doanh Thu Ngay
            Sheet sheet4 = workbook.createSheet("DoanhThuNgay");
            String[] dtHeaders = {"Ngày", "Số Hóa Đơn", "Doanh Thu"};
            Row rDTH = sheet4.createRow(0);
            for(int i=0; i<dtHeaders.length; i++){
                Cell c = rDTH.createCell(i); c.setCellValue(dtHeaders[i]); c.setCellStyle(headerStyle);
            }
            
            String sqlNgay = "SELECT CAST(NgayTao AS DATE) AS Ngay, COUNT(MaHD) AS SoHD, SUM(TongTien) AS DT " +
                             "FROM HoaDon WHERE TrangThai = 1 AND NgayTao >= ? AND NgayTao <= ? " +
                             "GROUP BY CAST(NgayTao AS DATE) ORDER BY Ngay DESC";
            try (PreparedStatement ps = con.prepareStatement(sqlNgay)) {
                ps.setString(1, startDateSql); ps.setString(2, endDateSql);
                ResultSet rs = ps.executeQuery();
                int stt = 1;
                while (rs.next()) {
                    Row r = sheet4.createRow(stt);
                    r.createCell(0).setCellValue(rs.getDate("Ngay").toString()); r.getCell(0).setCellStyle(dataStyle);
                    r.createCell(1).setCellValue(rs.getInt("SoHD")); r.getCell(1).setCellStyle(dataStyle);
                    r.createCell(2).setCellValue(rs.getDouble("DT")); r.getCell(2).setCellStyle(currencyStyle);
                    stt++;
                }
            }
            for(int i=0; i<dtHeaders.length; i++) sheet4.autoSizeColumn(i);

            response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            response.setHeader("Content-Disposition", "attachment; filename=\"BaoCaoDoanhThu.xlsx\"");
            workbook.write(response.getOutputStream());
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, "Lỗi khi tạo file Excel");
        }
    }
}
