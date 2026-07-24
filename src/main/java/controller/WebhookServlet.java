package controller;

import Models.HoaDonChiTiet;
import Service.HoaDonService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "WebhookServlet", urlPatterns = {"/api/webhook/sepay", "/api/simulate-payment"})
public class WebhookServlet extends HttpServlet {
    private HoaDonService hoaDonService = new HoaDonService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    private void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String uri = request.getRequestURI();
        
        if (uri.endsWith("/simulate-payment")) {
            int maHD = Integer.parseInt(request.getParameter("maHD"));
            
            // 1. Update status
            boolean updated = hoaDonService.updateTrangThai(maHD, 1); // 1 = Đã thanh toán
            // Không trừ tồn kho ở đây nữa vì đã trừ lúc tạo hóa đơn rồi (tránh âm kho)
            
            if ("GET".equalsIgnoreCase(request.getMethod())) {
                response.setContentType("text/html;charset=UTF-8");
                response.getWriter().write("<html><head><meta name='viewport' content='width=device-width, initial-scale=1.0'><title>Thanh Toán</title></head><body style='text-align:center; padding:50px; font-family:sans-serif;'><h1 style='color:#059669;'>Thanh Toán Thành Công!</h1><p>Hóa đơn #" + maHD + " đã được xác nhận.</p></body></html>");
            } else {
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": true}");
            }
        }
    }
}
