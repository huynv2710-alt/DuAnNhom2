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

        try {
            if ("add".equals(action)) {
                String cha = request.getParameter("maTheLoaiCha");
                Integer maTheLoaiCha = (cha != null && !cha.trim().isEmpty()) ? Integer.parseInt(cha) : null;
                service.addTheLoai(tenTheLoai, moTa, maTheLoaiCha);
                request.getSession().setAttribute("success", "Thêm thể loại thành công!");
            } else if ("edit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("maTheLoai"));
                String cha = request.getParameter("maTheLoaiCha");
                Integer maTheLoaiCha = (cha != null && !cha.trim().isEmpty()) ? Integer.parseInt(cha) : null;
                service.updateTheLoai(id, tenTheLoai, moTa, maTheLoaiCha);
                request.getSession().setAttribute("success", "Cập nhật thể loại thành công!");
            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("maTheLoai"));
                service.deleteTheLoai(id);
                request.getSession().setAttribute("success", "Xóa thể loại thành công!");
            }
        } catch (RuntimeException e) {
            request.getSession().setAttribute("error", e.getMessage());
        }

        response.sendRedirect("quanlytheloai");
    }
}
