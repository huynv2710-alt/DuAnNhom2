package Service;

import Models.KhuyenMai;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class KhuyenMaiService {
    
    public List<KhuyenMai> getAllKhuyenMai() {
        List<KhuyenMai> list = new ArrayList<>();
        String sql = "SELECT * FROM KhuyenMai";
        try (Connection con = new connectService().myConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new KhuyenMai(
                        rs.getInt("MaKM"),
                        rs.getString("TenKM"),
                        rs.getDouble("PhanTramGiam"),
                        rs.getTimestamp("NgayBatDau"),
                        rs.getTimestamp("NgayKetThuc"),
                        rs.getInt("TrangThai")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<KhuyenMai> getActiveKhuyenMai() {
        List<KhuyenMai> list = new ArrayList<>();
        String sql = "SELECT * FROM KhuyenMai WHERE TrangThai = 1 AND GETDATE() BETWEEN NgayBatDau AND NgayKetThuc";
        try (Connection con = new connectService().myConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new KhuyenMai(
                        rs.getInt("MaKM"),
                        rs.getString("TenKM"),
                        rs.getDouble("PhanTramGiam"),
                        rs.getTimestamp("NgayBatDau"),
                        rs.getTimestamp("NgayKetThuc"),
                        rs.getInt("TrangThai")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
