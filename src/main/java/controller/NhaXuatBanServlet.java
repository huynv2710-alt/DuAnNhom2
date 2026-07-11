package controller;

import Models.NhaXuatBan;
import Service.ThuocTinhSachService;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "NhaXuatBanServlet", urlPatterns = {"/quanlynxb"})
public class NhaXuatBanServlet extends HttpServlet {
    private ThuocTinhSachService service = new ThuocTinhSachService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        request.setAttribute("listNXB", service.getAllNXB());
        request.getRequestDispatcher("quanlynxb.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        String tenNXB = request.getParameter("tenNXB");
        String diaChi = request.getParameter("diaChi");
        String sdt = request.getParameter("sdt");

        if ("add".equals(action)) {
            service.addNXB(new NhaXuatBan(0, tenNXB, diaChi, sdt));
        } else if ("edit".equals(action)) {
            int id = Integer.parseInt(request.getParameter("maNXB"));
            service.updateNXB(new NhaXuatBan(id, tenNXB, diaChi, sdt));
        }

        response.sendRedirect("quanlynxb");
    }
}
