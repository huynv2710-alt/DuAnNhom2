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
            request.setAttribute("error", "Sai Mat Khau Moi Ban Nhap Lai!");
            request.getRequestDispatcher("index.jsp").forward(request, response);
            return;
        }


        TaiKhoan tk = service.getUser(username);

        // 3. tạo session
        HttpSession session = request.getSession();
        session.setAttribute("username", tk.getUsername());
        session.setAttribute("tenTK", tk.getTenTK());
        session.setAttribute("quyen", tk.getTenQuyen());


        if (tk.getTenQuyen() != null &&
                tk.getTenQuyen().equalsIgnoreCase("admin")) {

            response.sendRedirect("quanlinhanvien");

        } else {
            response.sendRedirect("nhanvien.jsp");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        response.sendRedirect("index.jsp");
    }
}