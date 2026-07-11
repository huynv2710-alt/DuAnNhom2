package controller;

import Service.ThuocTinhSachService;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "TheLoaiServlet", urlPatterns = {"/quanlytheloai"})
public class TheLoaiServlet extends HttpServlet {
    private ThuocTinhSachService service = new ThuocTinhSachService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        request.setAttribute("listTL", service.getAllTheLoai());
        request.getRequestDispatcher("quanlytheloai.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        String tenTheLoai = request.getParameter("tenTheLoai");
        String moTa = request.getParameter("moTa");

        if ("add".equals(action)) {
            service.addTheLoai(tenTheLoai, moTa);
        } else if ("edit".equals(action)) {
            int id = Integer.parseInt(request.getParameter("maTheLoai"));
            service.updateTheLoai(id, tenTheLoai, moTa);
        }

        response.sendRedirect("quanlytheloai");
    }
}
