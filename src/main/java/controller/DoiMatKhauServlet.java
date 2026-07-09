package controller;

import Models.TaiKhoan;
import Service.TaiKhoanService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "DoiMatKhauServlet", urlPatterns = {"/doimatkhau"})
public class DoiMatKhauServlet extends HttpServlet {
    private TaiKhoanService tkService = new TaiKhoanService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("username") == null) {
            response.sendRedirect("index.jsp");
            return;
        }
        request.getRequestDispatcher("doimatkhau.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");

        if (username == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        String oldPass = request.getParameter("oldPass");
        String newPass = request.getParameter("newPass");
        String confirmPass = request.getParameter("confirmPass");

        if (!newPass.equals(confirmPass)) {
            request.setAttribute("error", "Mat khau xac nhan khong khop!");
            request.getRequestDispatcher("doimatkhau.jsp").forward(request, response);
            return;
        }

        TaiKhoan tk = tkService.getUser(username);
        if (tk == null || !tk.getPass().equals(oldPass)) {
            request.setAttribute("error", "Mat khau cu khong chinh xac!");
            request.getRequestDispatcher("doimatkhau.jsp").forward(request, response);
            return;
        }

        boolean success = tkService.changePassword(username, newPass);
        if (success) {
            request.setAttribute("success", "Doi mat khau thanh cong!");
        } else {
            request.setAttribute("error", "Doi mat khau that bai!");
        }
        request.getRequestDispatcher("doimatkhau.jsp").forward(request, response);
    }
}
