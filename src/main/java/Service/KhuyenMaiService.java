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

    public KhuyenMai getKhuyenMaiById(int id) {
        String sql = "SELECT * FROM KhuyenMai WHERE MaKM = ?";
        try (Connection con = new connectService().myConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new KhuyenMai(
                        rs.getInt("MaKM"),
                        rs.getString("TenKM"),
                        rs.getDouble("PhanTramGiam"),
                        rs.getTimestamp("NgayBatDau"),
                        rs.getTimestamp("NgayKetThuc"),
                        rs.getInt("TrangThai")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean addKhuyenMai(KhuyenMai km) {
        String sql = "INSERT INTO KhuyenMai (TenKM, PhanTramGiam, NgayBatDau, NgayKetThuc, TrangThai) VALUES (?, ?, ?, ?, ?)";
        try (Connection con = new connectService().myConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, km.getTenKM());
            ps.setDouble(2, km.getPhanTramGiam());
            ps.setTimestamp(3, new java.sql.Timestamp(km.getNgayBatDau().getTime()));
            ps.setTimestamp(4, new java.sql.Timestamp(km.getNgayKetThuc().getTime()));
            ps.setInt(5, km.getTrangThai());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateKhuyenMai(KhuyenMai km) {
        String sql = "UPDATE KhuyenMai SET TenKM = ?, PhanTramGiam = ?, NgayBatDau = ?, NgayKetThuc = ?, TrangThai = ? WHERE MaKM = ?";
        try (Connection con = new connectService().myConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, km.getTenKM());
            ps.setDouble(2, km.getPhanTramGiam());
            ps.setTimestamp(3, new java.sql.Timestamp(km.getNgayBatDau().getTime()));
            ps.setTimestamp(4, new java.sql.Timestamp(km.getNgayKetThuc().getTime()));
            ps.setInt(5, km.getTrangThai());
            ps.setInt(6, km.getMaKM());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean toggleStatus(int maKM) {
        String sql = "UPDATE KhuyenMai SET TrangThai = CASE WHEN TrangThai = 1 THEN 0 ELSE 1 END WHERE MaKM = ?";
        try (Connection con = new connectService().myConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, maKM);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
