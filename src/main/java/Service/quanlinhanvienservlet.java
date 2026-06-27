package Service;

import Models.NhanVien;

import java.sql.Connection;
import java.util.ArrayList;
import java.sql.*;

public class quanlinhanvienservlet {
    public ArrayList<NhanVien> getAllNhanVien() {
            connectService service = new connectService();
        ArrayList<NhanVien> list = new ArrayList<>();

        String sql =" SELECT nv.*, tt.TenTrangThai\n" +
                "        FROM NhanVien nv\n" +
                "        JOIN TrangThaiNhanVien tt\n" +
                "        ON nv.MaTrangThai = tt.MaTrangThai";

        try (Connection conn = service.myConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                list.add(new NhanVien(
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
                ));

            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}
