package Service;

import Models.NhanVien;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class NhanVienService {

    public NhanVien getNhanVienTheoUsername(String username) {
        connectService service = new connectService();
        NhanVien nv = null;

        String sql = "SELECT nv.MaNV, nv.HoTen, nv.NgaySinh, nv.GioiTinh, " +
                "nv.SDT, nv.Email, nv.DiaChi, nv.MaTrangThai, tt.TenTrangThai, " +
                "nv.CCCD, nv.NgayCapCCCD, nv.DacDiemNhanDang " +
                "FROM TaiKhoan tk " +
                "LEFT JOIN NhanVien nv ON tk.MaNV = nv.MaNV " +
                "LEFT JOIN TrangThaiNhanVien tt ON nv.MaTrangThai = tt.MaTrangThai " +
                "WHERE tk.Username = ?";

        try (
                Connection conn = service.myConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String hoTen = rs.getString("HoTen");
                if (hoTen != null) {
                    nv = new NhanVien(
                            rs.getInt("MaNV"),
                            hoTen,
                            rs.getDate("NgaySinh"),
                            rs.getString("GioiTinh"),
                            rs.getString("SDT"),
                            rs.getString("Email"),
                            rs.getString("DiaChi"),
                            rs.getInt("MaTrangThai"),
                            rs.getString("TenTrangThai"),
                            rs.getString("CCCD"),
                            rs.getDate("NgayCapCCCD"),
                            rs.getString("DacDiemNhanDang")
                    );
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return nv;
    }

    public boolean updateThongTin(String username, String hoTen, String sdt, String email, String diaChi) {
        connectService service = new connectService();
        String sql = "UPDATE NhanVien SET HoTen = ?, SDT = ?, Email = ?, DiaChi = ? " +
                "WHERE MaNV = (SELECT MaNV FROM TaiKhoan WHERE Username = ?)";

        try (
                Connection conn = service.myConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setString(1, hoTen);
            ps.setString(2, sdt);
            ps.setString(3, email);
            ps.setString(4, diaChi);
            ps.setString(5, username);

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}