package Service;

import Models.NhanVien;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class quanlinhanvienservlet {

    public ArrayList<NhanVien> getAllNhanVien() {

        connectService service = new connectService();
        ArrayList<NhanVien> list = new ArrayList<>();

        String sql =
                "SELECT nv.MaNV, nv.HoTen, nv.NgaySinh, nv.GioiTinh, " +
                        "nv.SDT, nv.Email, nv.DiaChi, nv.MaTrangThai, " +
                        "nv.CCCD, nv.NgayCapCCCD, nv.DacDiemNhanDang, " +
                        "tt.TenTrangThai " +
                        "FROM NhanVien nv " +
                        "INNER JOIN TrangThaiNhanVien tt " +
                        "ON nv.MaTrangThai = tt.MaTrangThai";

        try (Connection conn = service.myConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                NhanVien nv = new NhanVien(
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

                list.add(nv);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}