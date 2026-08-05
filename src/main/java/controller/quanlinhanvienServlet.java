package controller;

import Models.NhanVien;
import Service.quanlinhanvienservlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;

@WebServlet("/quanlinhanvien")
public class quanlinhanvienServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        javax.servlet.http.HttpSession session = req.getSession();
        if (session.getAttribute("username") == null) {
            resp.sendRedirect("index.jsp");
            return;
        }
        String quyen = (String) session.getAttribute("quyen");
        if (!"admin".equals(quyen) && !"1".equals(quyen)) {
            // Only admin can access this page
            resp.sendRedirect("dashboard");
            return;
        }

        quanlinhanvienservlet dao = new quanlinhanvienservlet();

        String search = req.getParameter("search");
        if (search != null) {
            search = new String(search.getBytes("ISO-8859-1"), "UTF-8");
        }
        ArrayList<NhanVien> list;

        if (search != null && !search.trim().isEmpty()) {
            list = dao.searchNhanVien(search.trim());
        } else {
            list = dao.getAllNhanVien();
        }

        req.setAttribute("lst", list);
        req.setAttribute("search", search);

        req.getRequestDispatcher("quanlinhanvien.jsp")
                .forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        doGet(req, resp);
    }
}