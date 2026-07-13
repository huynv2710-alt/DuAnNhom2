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

        String quyen = (String) session.getAttribute("quyen");
        
        if ("admin".equals(quyen)) {
            int totalAccounts = dashboardService.countRows("TaiKhoan");
            int totalEmployees = dashboardService.countRows("NhanVien");
            int totalBooks = dashboardService.countRows("Sach");
            int totalOrders = dashboardService.countRows("HoaDon");
            double totalRevenue = dashboardService.getTotalRevenue();
            
            int totalCustomers = dashboardService.countRows("KhachHang");
            double todayRevenue = dashboardService.getTodayRevenue();
            double todayProfit = todayRevenue * 0.3; // estimated 30% profit margin
            int todayOrders = dashboardService.getTodayOrders();
            int lowStock = dashboardService.countLowStockBooks();
    
            request.setAttribute("totalAccounts", totalAccounts);
            request.setAttribute("totalEmployees", totalEmployees);
            request.setAttribute("totalBooks", totalBooks);
            request.setAttribute("totalOrders", totalOrders);
            request.setAttribute("totalRevenue", totalRevenue);
            
            request.setAttribute("totalCustomers", totalCustomers);
            request.setAttribute("todayRevenue", todayRevenue);
            request.setAttribute("todayProfit", todayProfit);
            request.setAttribute("todayOrders", todayOrders);
            request.setAttribute("lowStock", lowStock);
        } else {
            // For NhanVien, maybe just get their specific metrics or a welcome message
            // Currently, just keep it simple
        }

        request.getRequestDispatcher("dashboard.jsp").forward(request, response);
    }
}
