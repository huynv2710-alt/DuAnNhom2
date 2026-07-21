package controller;

import Service.DashboardService;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.Calendar;

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
            
            // New Data
            double weeklyRevenue = dashboardService.getWeeklyRevenue();
            double monthlyRevenue = dashboardService.getMonthlyRevenue();
            double yearlyRevenue = dashboardService.getYearlyRevenue();
            
            List<Object[]> topBooks = dashboardService.getTopSellingBooks(5);
            List<Object[]> topCategories = dashboardService.getTopCategories(5);
            List<Object[]> topPublishers = dashboardService.getTopPublishers(5);
            List<Object[]> topEmployees = dashboardService.getTopEmployees(5);
            List<Object[]> recentOrders = dashboardService.getRecentOrders(5);
            List<Object[]> lowStockList = dashboardService.getLowStockBooksList(5);
            List<Object[]> newCustomers = dashboardService.getNewCustomers(5);
            
            int currentYear = Calendar.getInstance().get(Calendar.YEAR);
            List<Object[]> revenueByDay = dashboardService.getRevenueByDayChart(7);
            List<Object[]> revenueByMonth = dashboardService.getRevenueByMonthChart(currentYear);
    
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
            
            request.setAttribute("weeklyRevenue", weeklyRevenue);
            request.setAttribute("monthlyRevenue", monthlyRevenue);
            request.setAttribute("yearlyRevenue", yearlyRevenue);
            
            request.setAttribute("topBooks", topBooks);
            request.setAttribute("topCategories", topCategories);
            request.setAttribute("topPublishers", topPublishers);
            request.setAttribute("topEmployees", topEmployees);
            request.setAttribute("recentOrders", recentOrders);
            request.setAttribute("lowStockList", lowStockList);
            request.setAttribute("newCustomers", newCustomers);
            
            request.setAttribute("revenueByDay", revenueByDay);
            request.setAttribute("revenueByMonth", revenueByMonth);
        } else {
            // For NhanVien, maybe just get their specific metrics or a welcome message
            // Currently, just keep it simple
        }

        request.getRequestDispatcher("dashboard.jsp").forward(request, response);
    }
}
