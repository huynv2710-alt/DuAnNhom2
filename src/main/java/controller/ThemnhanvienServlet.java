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
        int maNV = Integer.parseInt(request.getParameter("maNV"));
        String username = request.getParameter("username");

        if (s.getById(maNV) != null) {
            response.setContentType("text/html;charset=UTF-8");
            response.getWriter().println("<script>alert('Lỗi: Mã Nhân Viên [" + maNV + "] đã tồn tại! Vui lòng chọn mã khác.'); window.history.back();</script>");
            return;
        }

        TaiKhoanService tkService = new TaiKhoanService();
        if (tkService.getUser(username) != null) {
            response.setContentType("text/html;charset=UTF-8");
            response.getWriter().println("<script>alert('Lỗi: Tên đăng nhập [" + username + "] đã có người sử dụng! Vui lòng chọn tên khác.'); window.history.back();</script>");
            return;
        }

        nv.setMaNV(maNV);
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
            String pass = request.getParameter("password");
            int maQuyen = Integer.parseInt(request.getParameter("maQuyen"));
            try {
                tkService.addTaiKhoan(username, pass, maNV, maQuyen);
                response.sendRedirect("quanlinhanvien");
            } catch (Exception e) {
                e.printStackTrace();
                response.setContentType("text/html;charset=UTF-8");
                response.getWriter().println("<html><body>");
                response.getWriter().println("<h3 style='color:red;'>Thêm nhân viên thành công nhưng tạo Tài Khoản thất bại!</h3>");
                response.getWriter().println("<p><b>Chi tiết lỗi từ Database:</b> " + e.getMessage() + "</p>");
                response.getWriter().println("<button onclick='window.history.back()'>Quay lại</button>");
                response.getWriter().println("</body></html>");
            }
        } else {
            response.setContentType("text/html;charset=UTF-8");
            response.getWriter().println("<script>alert('Lỗi hệ thống: Không thể thêm nhân viên vào Database!'); window.history.back();</script>");
        }
    }
}
