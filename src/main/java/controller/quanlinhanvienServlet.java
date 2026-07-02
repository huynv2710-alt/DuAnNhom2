package controller;

import Models.NhanVien;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.ArrayList;

@WebServlet("/quanlinhanvien")
public class quanlinhanvienServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Kiểm tra đăng nhập
        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("quyen") == null) {
            resp.sendRedirect("index.jsp");
            return;
        }


        String quyen = (String) session.getAttribute("quyen");

        if (!"admin".equalsIgnoreCase(quyen)) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN,
                    "Ban ko co quyen truy cap");
            return;
        }


        Service.quanlinhanvienservlet dao = new Service.quanlinhanvienservlet();

        ArrayList<NhanVien> list = dao.getAllNhanVien();

        req.setAttribute("lst", list);

        req.getRequestDispatcher("quanlinhanvien.jsp").forward(req, resp);
    }
}