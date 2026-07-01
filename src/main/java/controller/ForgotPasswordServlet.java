package controller;

import Models.TaiKhoan;
import Service.TaiKhoanService;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;

@WebServlet(name = "ForgotPasswordServlet", urlPatterns = {"/ForgotPasswordServlet"})
public class ForgotPasswordServlet extends HttpServlet {

    private TaiKhoanService service = new TaiKhoanService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String username = request.getParameter("username");
        String email = request.getParameter("email");

        TaiKhoan tk = service.forgotPassword(username, email);

        if (tk == null) {
            request.setAttribute("error", "Sai username hoac  email!");
            request.getRequestDispatcher("forgotPassword.jsp").forward(request, response);
            return;
        }

        request.setAttribute("message",
                "XIN CHAO " + tk.getHoTen() +
                        " - MAT KHAU CUA BAN LA: " + tk.getPass());

        request.getRequestDispatcher("showPassword.jsp").forward(request, response);
    }
}