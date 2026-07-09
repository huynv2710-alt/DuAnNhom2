package controller;

import Models.TaiKhoan;
import Service.TaiKhoanService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "QuanLyTaiKhoanServlet", urlPatterns = {"/quanlytaikhoan"})
public class QuanLyTaiKhoanServlet extends HttpServlet {
    private TaiKhoanService tkService = new TaiKhoanService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("username") == null || !"admin".equalsIgnoreCase((String) session.getAttribute("quyen"))) {
            response.sendRedirect("index.jsp");
            return;
        }

        String search = request.getParameter("search");
        if (search == null) search = "";
        
        int page = 1;
        int pageSize = 15;
        if (request.getParameter("page") != null) {
            try {
                page = Integer.parseInt(request.getParameter("page"));
            } catch (Exception e) {}
        }
        
        List<TaiKhoan> list = tkService.getAllTaiKhoan(page, pageSize, search);

        request.setAttribute("listTK", list);
        request.setAttribute("search", search);

        request.getRequestDispatcher("quanlytaikhoan.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        
        if ("add".equals(action)) {
            String username = request.getParameter("username");
            String pass = request.getParameter("password");
            int maNV = Integer.parseInt(request.getParameter("maNV"));
            int maQuyen = Integer.parseInt(request.getParameter("maQuyen"));
            
            tkService.addTaiKhoan(username, pass, maNV, maQuyen);
        } else if ("edit".equals(action)) {
            String username = request.getParameter("username");
            String pass = request.getParameter("password"); 
            int maQuyen = Integer.parseInt(request.getParameter("maQuyen"));
            
            tkService.updateTaiKhoan(username, pass, maQuyen);
        }
        response.sendRedirect("quanlytaikhoan");
    }
}
