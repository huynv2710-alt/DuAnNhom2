package Service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

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
             PreparedStatement ps = con.prepareStatement("SELECT SUM(TongTien) FROM HoaDon")) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getDouble(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0.0;
    }
    
    public double getTodayRevenue() {
        try (Connection con = connect.myConnection();
             PreparedStatement ps = con.prepareStatement("SELECT SUM(TongTien) FROM HoaDon WHERE CAST(NgayTao AS DATE) = CAST(GETDATE() AS DATE)")) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getDouble(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0.0;
    }
    
    public int getTodayOrders() {
        try (Connection con = connect.myConnection();
             PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) FROM HoaDon WHERE CAST(NgayTao AS DATE) = CAST(GETDATE() AS DATE)")) {
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
}
