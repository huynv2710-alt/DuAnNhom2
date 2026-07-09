package controller;

import Models.NhanVien;
import Service.TaiKhoanService;
import Service.connectService;
import Service.quanlinhanvienservlet;

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
    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        NhanVien nv = new NhanVien();
        quanlinhanvienservlet s = new quanlinhanvienservlet();
        nv.setMaNV(Integer.parseInt(request.getParameter("maNV")));
        nv.setHoTen(request.getParameter("hoTen"));
        nv.setNgaySinh(Date.valueOf(request.getParameter("ngaySinh")));
        nv.setGioiTinh(request.getParameter("gioiTinh"));
        nv.setSdt(request.getParameter("sdt"));
        nv.setEmail(request.getParameter("email"));
        nv.setDiaChi(request.getParameter("diaChi"));
        nv.setCccd(request.getParameter("cccd"));
        nv.setNgayCapCCCD(Date.valueOf(request.getParameter("ngayCapCCCD")));
        nv.setDacDiemNhanDang(request.getParameter("dacDiemNhanDang"));
        nv.setMaTrangThai(Integer.parseInt(request.getParameter("maTrangThai")));

        if (s.addNhanVien(nv)) {
            TaiKhoanService tkService = new TaiKhoanService();
            String username = request.getParameter("username");
            String pass = request.getParameter("password");
            int maQuyen = Integer.parseInt(request.getParameter("maQuyen"));
            tkService.addTaiKhoan(username, pass, nv.getMaNV(), maQuyen);
            response.sendRedirect("quanlinhanvien");
        } else {
            response.getWriter().println("Them that bai!");
        }
    }
}
