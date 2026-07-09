package controller;

import Service.DashboardService;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "DashboardServlet", urlPatterns = {"/dashboard"})
public class DashboardServlet extends HttpServlet {
    private DashboardService dashboardService = new DashboardService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("username") == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        int totalAccounts = dashboardService.countRows("TaiKhoan");
        int totalEmployees = dashboardService.countRows("NhanVien");
        int totalBooks = dashboardService.countRows("Sach");
        int totalOrders = dashboardService.countRows("HoaDon");
        double totalRevenue = dashboardService.getTotalRevenue();

        request.setAttribute("totalAccounts", totalAccounts);
        request.setAttribute("totalEmployees", totalEmployees);
        request.setAttribute("totalBooks", totalBooks);
        request.setAttribute("totalOrders", totalOrders);
        request.setAttribute("totalRevenue", totalRevenue);

        request.getRequestDispatcher("dashboard.jsp").forward(request, response);
    }
}
