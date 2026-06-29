package controller;

import Models.NhanVien;

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
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Service.quanlinhanvienservlet dao = new Service.quanlinhanvienservlet();

        ArrayList<NhanVien> list = dao.getAllNhanVien();

        req.setAttribute("lst", list);

        req.getRequestDispatcher("quanlinhanvien").forward(req, resp);
    }
}
