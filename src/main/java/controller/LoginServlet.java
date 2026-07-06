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

        boolean ok = service.loginCheck(username, password);

        if (!ok) {
            request.setAttribute("error", "Sai mật khẩu hoặc tên đăng nhập! <br> Hãy liên hệ đến quản lí");
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
            session.setAttribute("tenTK", tk.getHoTen() != null ? tk.getHoTen() : "Chưa có tên");
            session.setAttribute("sdt", "Chưa cập nhật");
            session.setAttribute("email", "Chưa cập nhật");
            session.setAttribute("diaChi", "Chưa cập nhật");
            session.setAttribute("cccd", "Chưa cập nhật");
            session.setAttribute("tenTrangThai", "Chưa xác định");
        }

        if ("admin".equalsIgnoreCase(tk.getTenQuyen())) {
            response.sendRedirect("quanlinhanvien");
        } else {
            response.sendRedirect("NhanVien2.jsp");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.sendRedirect("index.jsp");
    }
}