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

        quanlinhanvienservlet dao = new quanlinhanvienservlet();

        String search = req.getParameter("search");
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
}