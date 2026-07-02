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
                "JOIN NhanVien nv ON tk.MaNV = nv.MaNV " +
                "JOIN TrangThaiNhanVien tt ON nv.MaTrangThai = tt.MaTrangThai " +
                "WHERE tk.TenDangNhap = ?";

        try (
                Connection conn = service.myConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setString(1, username);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                nv = new NhanVien(
                        rs.getInt("MaNV"),
                        rs.getString("HoTen"),
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

        } catch (Exception e) {
            e.printStackTrace();
        }

        return nv;
    }
}
