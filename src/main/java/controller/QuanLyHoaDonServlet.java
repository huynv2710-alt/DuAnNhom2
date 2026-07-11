package controller;

import Models.HoaDon;
import Models.HoaDonChiTiet;
import Service.HoaDonService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "QuanLyHoaDonServlet", urlPatterns = {"/quanlyhoadon"})
public class QuanLyHoaDonServlet extends HttpServlet {
    private HoaDonService hoaDonService = new HoaDonService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        if (session.getAttribute("username") == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        String action = request.getParameter("action");
        if ("viewDetail".equals(action)) {
            int maHD = Integer.parseInt(request.getParameter("id"));
            HoaDon hd = hoaDonService.getHoaDonById(maHD);
            List<HoaDonChiTiet> details = hoaDonService.getChiTietByHoaDonId(maHD);
            request.setAttribute("hd", hd);
            request.setAttribute("details", details);
            request.getRequestDispatcher("hoadon_chitiet.jsp").forward(request, response);
            return;
        }

        List<HoaDon> list = hoaDonService.getAllHoaDon();
        request.setAttribute("listHD", list);
        request.getRequestDispatcher("quanlyhoadon.jsp").forward(request, response);
    }
}
