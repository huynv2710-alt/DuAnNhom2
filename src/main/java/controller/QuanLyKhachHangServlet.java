package controller;

import Models.KhachHang;
import Service.KhachHangService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "QuanLyKhachHangServlet", urlPatterns = {"/quanlykhachhang"})
public class QuanLyKhachHangServlet extends HttpServlet {
    private KhachHangService khService = new KhachHangService();

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
        if ("delete".equals(action)) {
            int maKH = Integer.parseInt(request.getParameter("id"));
            khService.deleteKhachHang(maKH);
            response.sendRedirect("quanlykhachhang");
            return;
        }

        String search = request.getParameter("search");
        List<KhachHang> list = khService.getAllKhachHang(search);
        
        request.setAttribute("listKH", list);
        request.setAttribute("search", search);
        request.getRequestDispatcher("quanlykhachhang.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        String hoTen = request.getParameter("hoTen");
        String sdt = request.getParameter("sdt");
        String diaChi = request.getParameter("diaChi");
        String email = request.getParameter("email");

        if ("add".equals(action)) {
            KhachHang kh = new KhachHang(0, hoTen, sdt, diaChi, email);
            khService.addKhachHang(kh);
        } else if ("edit".equals(action)) {
            int maKH = Integer.parseInt(request.getParameter("maKH"));
            KhachHang kh = new KhachHang(maKH, hoTen, sdt, diaChi, email);
            khService.updateKhachHang(kh);
        }
        
        response.sendRedirect("quanlykhachhang");
    }
}
