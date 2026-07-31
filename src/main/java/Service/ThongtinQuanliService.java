package Service;

import Models.NhanVien;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class ThongtinQuanliService {
    public NhanVien getNhanVienByMa(int maNV) {

        connectService service = new connectService();
        NhanVien nv = null;

        String sql = "SELECT nv.*, tt.TenTrangThai " +
                "FROM NhanVien nv " +
                "JOIN TrangThaiNhanVien tt ON nv.MaTrangThai = tt.MaTrangThai " +
                "WHERE nv.MaNV = ?";

        try (Connection conn = service.myConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, maNV);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {

                    nv = new NhanVien();

                    nv.setMaNV(rs.getInt("MaNV"));
                    nv.setHoTen(rs.getString("HoTen"));
                    nv.setNgaySinh(rs.getDate("NgaySinh"));
                    nv.setGioiTinh(rs.getString("GioiTinh"));
                    nv.setSdt(rs.getString("SDT"));
                    nv.setEmail(rs.getString("Email"));
                    nv.setDiaChi(rs.getString("DiaChi"));
                    nv.setMaTrangThai(rs.getInt("MaTrangThai"));
                    nv.setTenTrangThai(rs.getString("TenTrangThai"));
                    nv.setCccd(rs.getString("CCCD"));
                    nv.setNgayCapCCCD(rs.getDate("NgayCapCCCD"));
                    nv.setDacDiemNhanDang(rs.getString("DacDiemNhanDang"));

                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return nv;
    }
}