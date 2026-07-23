package Service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class DashboardService {
    private connectService connect = new connectService();

    public int countRows(String tableName) {
        try (Connection con = connect.myConnection();
             PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) FROM " + tableName)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public double getTotalRevenue() {
        try (Connection con = connect.myConnection();
             PreparedStatement ps = con.prepareStatement("SELECT SUM(TongTien) FROM HoaDon WHERE TrangThai = 1")) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getDouble(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0.0;
    }
    
    public double getTodayRevenue() {
        try (Connection con = connect.myConnection();
             PreparedStatement ps = con.prepareStatement("SELECT SUM(TongTien) FROM HoaDon WHERE CAST(NgayTao AS DATE) = CAST(GETDATE() AS DATE) AND TrangThai = 1")) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getDouble(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0.0;
    }
    
    public int getTodayOrders() {
        try (Connection con = connect.myConnection();
             PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) FROM HoaDon WHERE CAST(NgayTao AS DATE) = CAST(GETDATE() AS DATE) AND TrangThai = 1")) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    public int countLowStockBooks() {
        try (Connection con = connect.myConnection();
             PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) FROM Sach WHERE SoLuongTon <= 5")) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public double getWeeklyRevenue() {
        try (Connection con = connect.myConnection();
             PreparedStatement ps = con.prepareStatement("SELECT SUM(TongTien) FROM HoaDon WHERE DATEPART(ww, NgayTao) = DATEPART(ww, GETDATE()) AND YEAR(NgayTao) = YEAR(GETDATE()) AND TrangThai = 1")) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getDouble(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0.0;
    }

    public double getMonthlyRevenue() {
        try (Connection con = connect.myConnection();
             PreparedStatement ps = con.prepareStatement("SELECT SUM(TongTien) FROM HoaDon WHERE MONTH(NgayTao) = MONTH(GETDATE()) AND YEAR(NgayTao) = YEAR(GETDATE()) AND TrangThai = 1")) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getDouble(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0.0;
    }

    public double getYearlyRevenue() {
        try (Connection con = connect.myConnection();
             PreparedStatement ps = con.prepareStatement("SELECT SUM(TongTien) FROM HoaDon WHERE YEAR(NgayTao) = YEAR(GETDATE()) AND TrangThai = 1")) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getDouble(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0.0;
    }

    public List<Object[]> getTopSellingBooks(int limit, String filter) {
        List<Object[]> list = new ArrayList<>();
        String timeCondition = "";
        if ("today".equals(filter)) {
            timeCondition = " AND CAST(H.NgayTao AS DATE) = CAST(GETDATE() AS DATE) ";
        } else if ("week".equals(filter)) {
            timeCondition = " AND DATEPART(ww, H.NgayTao) = DATEPART(ww, GETDATE()) AND YEAR(H.NgayTao) = YEAR(GETDATE()) ";
        } else if ("month".equals(filter)) {
            timeCondition = " AND MONTH(H.NgayTao) = MONTH(GETDATE()) AND YEAR(H.NgayTao) = YEAR(GETDATE()) ";
        } else if ("year".equals(filter)) {
            timeCondition = " AND YEAR(H.NgayTao) = YEAR(GETDATE()) ";
        }

        String sql = "SELECT TOP (?) S.TenSach, SUM(CT.SoLuong) as TotalSold, S.HinhAnh " +
                     "FROM HoaDonChiTiet CT JOIN Sach S ON CT.MaSach = S.MaSach " +
                     "JOIN HoaDon H ON CT.MaHD = H.MaHD WHERE H.TrangThai = 1 " + timeCondition +
                     "GROUP BY S.MaSach, S.TenSach, S.HinhAnh ORDER BY TotalSold DESC";
        try (Connection con = connect.myConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Object[]{ rs.getString(1), rs.getInt(2), rs.getString(3) });
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public List<Object[]> getTopCategories(int limit) {
        List<Object[]> list = new ArrayList<>();
        String sql = "SELECT TOP (?) TL.TenTheLoai, SUM(CT.SoLuong) as TotalSold " +
                     "FROM HoaDonChiTiet CT JOIN Sach S ON CT.MaSach = S.MaSach " +
                     "JOIN TheLoai TL ON S.MaTheLoai = TL.MaTheLoai " +
                     "JOIN HoaDon H ON CT.MaHD = H.MaHD WHERE H.TrangThai = 1 " +
                     "GROUP BY TL.MaTheLoai, TL.TenTheLoai ORDER BY TotalSold DESC";
        try (Connection con = connect.myConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) { list.add(new Object[]{ rs.getString(1), rs.getInt(2) }); }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public List<Object[]> getTopPublishers(int limit) {
        List<Object[]> list = new ArrayList<>();
        String sql = "SELECT TOP (?) NXB.TenNXB, SUM(CT.SoLuong) as TotalSold " +
                     "FROM HoaDonChiTiet CT JOIN Sach S ON CT.MaSach = S.MaSach " +
                     "JOIN NhaXuatBan NXB ON S.MaNXB = NXB.MaNXB " +
                     "JOIN HoaDon H ON CT.MaHD = H.MaHD WHERE H.TrangThai = 1 " +
                     "GROUP BY NXB.MaNXB, NXB.TenNXB ORDER BY TotalSold DESC";
        try (Connection con = connect.myConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) { list.add(new Object[]{ rs.getString(1), rs.getInt(2) }); }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public List<Object[]> getTopEmployees(int limit) {
        List<Object[]> list = new ArrayList<>();
        String sql = "SELECT TOP (?) NV.HoTen, SUM(H.TongTien) as TotalRevenue " +
                     "FROM HoaDon H JOIN NhanVien NV ON H.MaNV = NV.MaNV " +
                     "WHERE H.TrangThai = 1 GROUP BY NV.MaNV, NV.HoTen ORDER BY TotalRevenue DESC";
        try (Connection con = connect.myConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) { list.add(new Object[]{ rs.getString(1), rs.getDouble(2) }); }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public List<Object[]> getRecentOrders(int limit) {
        List<Object[]> list = new ArrayList<>();
        String sql = "SELECT TOP (?) H.MaHD, KH.HoTen, H.TongTien, H.NgayTao " +
                     "FROM HoaDon H LEFT JOIN KhachHang KH ON H.MaKH = KH.MaKH " +
                     "ORDER BY H.NgayTao DESC";
        try (Connection con = connect.myConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                String khName = rs.getString(2) != null ? rs.getString(2) : "Khách lẻ";
                list.add(new Object[]{ rs.getInt(1), khName, rs.getDouble(3), rs.getString(4) });
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public List<Object[]> getLowStockBooksList(int limit) {
        List<Object[]> list = new ArrayList<>();
        String sql = "SELECT TOP (?) TenSach, SoLuongTon, HinhAnh FROM Sach WHERE SoLuongTon <= 5 ORDER BY SoLuongTon ASC";
        try (Connection con = connect.myConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) { list.add(new Object[]{ rs.getString(1), rs.getInt(2), rs.getString(3) }); }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public List<Object[]> getNewCustomers(int limit) {
        List<Object[]> list = new ArrayList<>();
        String sql = "SELECT TOP (?) HoTen, SDT FROM KhachHang ORDER BY MaKH DESC";
        try (Connection con = connect.myConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) { list.add(new Object[]{ rs.getString(1), rs.getString(2) }); }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public List<Object[]> getRevenueByDayChart(int days) {
        List<Object[]> list = new ArrayList<>();
        String sql = "SELECT TOP (?) CONVERT(date, NgayTao) as Ngay, SUM(TongTien) as DoanhThu " +
                     "FROM HoaDon WHERE TrangThai = 1 " +
                     "GROUP BY CONVERT(date, NgayTao) ORDER BY Ngay DESC";
        try (Connection con = connect.myConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, days);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) { list.add(new Object[]{ rs.getString(1), rs.getDouble(2) }); }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public List<Object[]> getRevenueByMonthChart(int year) {
        List<Object[]> list = new ArrayList<>();
        String sql = "SELECT MONTH(NgayTao) as Thang, SUM(TongTien) as DoanhThu " +
                     "FROM HoaDon WHERE YEAR(NgayTao) = ? AND TrangThai = 1 " +
                     "GROUP BY MONTH(NgayTao) ORDER BY Thang ASC";
        try (Connection con = connect.myConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, year);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) { list.add(new Object[]{ rs.getInt(1), rs.getDouble(2) }); }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }
}
