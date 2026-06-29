package controller;

import Models.NhanVien;
import Service.connectService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.*;

@WebServlet("/themnhanvien")
public class ThemnhanvienServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {


            req.getRequestDispatcher("themnhanvien.jsp")
                    .forward(req, resp);
    }
    public boolean addNhanVien(NhanVien nv) {

        connectService service = new connectService();

        String sql = "INSERT INTO NhanVien "
                + "(MaNV, HoTen, NgaySinh, GioiTinh, SDT, Email, DiaChi, "
                + "MaTrangThai, CCCD, NgayCapCCCD, DacDiemNhanDang) "
                + "VALUES (?,?,?,?,?,?,?,?,?,?,?)";

        try (Connection conn = service.myConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, nv.getMaNV());
            ps.setString(2, nv.getHoTen());
            ps.setDate(3, nv.getNgaySinh());
            ps.setString(4, nv.getGioiTinh());
            ps.setString(5, nv.getSdt());
            ps.setString(6, nv.getEmail());
            ps.setString(7, nv.getDiaChi());
            ps.setInt(8, nv.getMaTrangThai());
            ps.setString(9, nv.getCccd());
            ps.setDate(10, nv.getNgayCapCCCD());
            ps.setString(11, nv.getDacDiemNhanDang());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }
}
