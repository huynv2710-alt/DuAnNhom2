package controller;

import Models.NhanVien;
import Models.TaiKhoan;
import Service.NhanVienService;
import Service.TaiKhoanService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/suanhanvien")
public class suanhanvienServlet extends HttpServlet {

    private TaiKhoanService tkService = new TaiKhoanService();
    private NhanVienService nvService = new NhanVienService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");

        if ("login".equals(action)) {
            handleLogin(request, response);
        } else if ("update".equals(action)) {
            handleUpdate(request, response);
        } else {
            response.sendRedirect("index.jsp");
        }
    }

    private void handleLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        boolean ok = tkService.loginCheck(username, password);

        if (!ok) {
            request.setAttribute("error", "Sai Mat Khau Moi Ban Nhap Lai!");
            request.getRequestDispatcher("index.jsp").forward(request, response);
            return;
        }

        TaiKhoan tk = tkService.getUser(username);
        HttpSession session = request.getSession();
        session.setAttribute("username", tk.getUsername());
        session.setAttribute("tenTK", tk.getHoTen());
        session.setAttribute("quyen", tk.getTenQuyen());

        NhanVien nv = nvService.getNhanVienTheoUsername(username);
        if (nv != null) {
            session.setAttribute("sdt", nv.getSdt());
            session.setAttribute("email", nv.getEmail());
            session.setAttribute("diaChi", nv.getDiaChi());
            session.setAttribute("cccd", nv.getCccd());
            session.setAttribute("ngayCapCCCD", nv.getNgayCapCCCD());
            session.setAttribute("dacDiemNhanDang", nv.getDacDiemNhanDang());
            session.setAttribute("tenTrangThai", nv.getTenTrangThai());
            session.setAttribute("maNV", nv.getMaNV());
        }

        if (tk.getTenQuyen() != null && tk.getTenQuyen().equalsIgnoreCase("admin")) {
            response.sendRedirect("quanlinhanvien");
        } else {
            response.sendRedirect("NhanVien2.jsp");
        }
    }

    private void handleUpdate(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String hoTen = request.getParameter("hoTen");
        String sdt = request.getParameter("sdt");
        String email = request.getParameter("email");
        String diaChi = request.getParameter("diaChi");

        boolean isUpdated = nvService.updateThongTin(username, hoTen, sdt, email, diaChi);

        if (isUpdated) {
            HttpSession session = request.getSession();
            session.setAttribute("tenTK", hoTen);
            session.setAttribute("sdt", sdt);
            session.setAttribute("email", email);
            session.setAttribute("diaChi", diaChi);
        }

        response.sendRedirect("NhanVien2.jsp");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.sendRedirect("index.jsp");
    }
}