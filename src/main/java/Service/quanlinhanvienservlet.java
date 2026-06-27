package Service;

import Models.NhanVien;

import java.sql.Connection;
import java.util.ArrayList;
import java.sql.*;

public class quanlinhanvienservlet {
    public ArrayList<NhanVien> getAllNhanVien() {
            connectService service = new connectService();
        ArrayList<NhanVien> list = new ArrayList<>();

        String sql =" SELECT NhanVien.MaNV, NhanVien.HoTen, NhanVien.NgaySinh, NhanVien.GioiTinh, NhanVien.SDT, NhanVien.Email, NhanVien.DiaChi, NhanVien.CCCD, NhanVien.DacDiemNhanDang, NhanVien.NgayCapCCCD, \n" +
                "                  TrangThaiNhanVien.TenTrangThai\n" +
                "FROM     NhanVien INNER JOIN\n" +
                "                  TrangThaiNhanVien ON NhanVien.MaTrangThai = TrangThaiNhanVien.MaTrangThai INNER JOIN\n" +
                "                  NhanVien AS NhanVien_1 ON TrangThaiNhanVien.MaTrangThai = NhanVien_1.MaTrangThai INNER JOIN\n" +
                "                  TrangThaiNhanVien AS TrangThaiNhanVien_1 ON NhanVien.MaTrangThai = TrangThaiNhanVien_1.MaTrangThai AND NhanVien_1.MaTrangThai = TrangThaiNhanVien_1.MaTrangThai";

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
