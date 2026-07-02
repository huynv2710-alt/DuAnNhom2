package controller;

import Models.TaiKhoan;
import Service.TaiKhoanService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "LoginServlet", urlPatterns = {"/LoginServlet"})
public class LoginServlet extends HttpServlet {

    private TaiKhoanService service = new TaiKhoanService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        boolean ok = service.loginCheck(username, password);

        if (!ok) {
            request.setAttribute("error", "Sai mật khẩu hoặc tên đăng nhập!");
            request.getRequestDispatcher("index.jsp").forward(request, response);
            return;
        }

        TaiKhoan tk = service.getUser(username);

        HttpSession session = request.getSession();
        session.setAttribute("username", tk.getUsername());
        session.setAttribute("hoTen", tk.getHoTen());
        session.setAttribute("quyen", tk.getTenQuyen());

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