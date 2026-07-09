package controller;

import Models.NhanVien;
import Models.TaiKhoan;
import Service.NhanVienService;
import Service.TaiKhoanService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "LoginServlet", urlPatterns = {"/LoginServlet"})
public class LoginServlet extends HttpServlet {

    private TaiKhoanService service = new TaiKhoanService();
    private NhanVienService nvService = new NhanVienService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        int status = service.loginStatus(username, password);

        if (status == 0) {
            request.setAttribute("error", "Sai mật khẩu hoặc tên đăng nhập! <br> Hãy liên hệ đến quản lí");
            request.getRequestDispatcher("index.jsp").forward(request, response);
            return;
        } else if (status == -1) {
            request.setAttribute("error", "Tài khoản hiện không đăng nhập được!");
            request.getRequestDispatcher("index.jsp").forward(request, response);
            return;
        }

        TaiKhoan tk = service.getUser(username);
        HttpSession session = request.getSession();

        session.setAttribute("username", tk.getUsername());
        session.setAttribute("quyen", tk.getTenQuyen());

        NhanVien nv = nvService.getNhanVienTheoUsername(username);

        if (nv != null) {
            session.setAttribute("tenTK", nv.getHoTen());
            session.setAttribute("sdt", nv.getSdt());
            session.setAttribute("email", nv.getEmail());
            session.setAttribute("diaChi", nv.getDiaChi());
            session.setAttribute("cccd", nv.getCccd());
            session.setAttribute("ngayCapCCCD", nv.getNgayCapCCCD());
            session.setAttribute("dacDiemNhanDang", nv.getDacDiemNhanDang());
            session.setAttribute("tenTrangThai", nv.getTenTrangThai());
            session.setAttribute("maNV", nv.getMaNV());
        } else {
            session.setAttribute("tenTK", tk.getHoTen() != null ? tk.getHoTen() : "Chua co ten");
            session.setAttribute("sdt", "Chua cap nhat");
            session.setAttribute("email", "Chua cap nhat");
            session.setAttribute("diaChi", "Chua cap nhat");
            session.setAttribute("cccd", "Chua cap nhat");
            session.setAttribute("tenTrangThai", "Chua xac dinh");
        }

        response.sendRedirect("dashboard");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.sendRedirect("index.jsp");
    }
}