package controller;

import Models.NhanVien;
import Service.NhanVienService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;

@WebServlet("/suanhanvien")
public class suanhanvienServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");

        if (username != null) {
            NhanVienService nvService = new NhanVienService();
            NhanVien nv = nvService.getNhanVienTheoUsername(username);

            if (nv != null) {
                session.setAttribute("tenTK", nv.getHoTen());
                session.setAttribute("sdt", nv.getSdt());
                session.setAttribute("email", nv.getEmail());
                session.setAttribute("diaChi", nv.getDiaChi());
                session.setAttribute("cccd", nv.getCccd());
                session.setAttribute("ngayCapCCCD", nv.getNgayCapCCCD());
                session.setAttribute("dacDiemNhanDang", nv.getDacDiemNhanDang());
                session.setAttribute("tenTrangThai", nv.getTenTrangThai());
            }

            request.getRequestDispatcher("NhanVien2.jsp").forward(request, response);
        } else {
            response.sendRedirect("login.jsp");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}
