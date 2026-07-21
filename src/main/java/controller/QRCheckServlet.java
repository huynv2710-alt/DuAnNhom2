package controller;

import Models.HoaDon;
import Service.HoaDonService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "QRCheckServlet", urlPatterns = {"/api/check-payment"})
public class QRCheckServlet extends HttpServlet {
    private HoaDonService hoaDonService = new HoaDonService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try {
            int maHD = Integer.parseInt(request.getParameter("maHD"));
            HoaDon hd = hoaDonService.getHoaDonById(maHD);
            
            if (hd != null) {
                // Return JSON with status
                response.getWriter().write("{\"status\": " + hd.getTrangThai() + "}");
            } else {
                response.getWriter().write("{\"status\": -1, \"error\": \"Not found\"}");
            }
        } catch (Exception e) {
            response.getWriter().write("{\"status\": -1, \"error\": \"Invalid ID\"}");
        }
    }
}
