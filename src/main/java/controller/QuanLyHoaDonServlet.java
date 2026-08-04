package controller;

import Models.HoaDon;
import Models.HoaDonChiTiet;
import Service.HoaDonService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "QuanLyHoaDonServlet", urlPatterns = {"/quanlyhoadon"})
public class QuanLyHoaDonServlet extends HttpServlet {
    private HoaDonService hoaDonService = new HoaDonService();
    
    private int parseIntSafely(String str, int defaultVal) {
        if (str == null || str.trim().isEmpty()) return defaultVal;
        try { return Integer.parseInt(str.trim()); } catch (Exception e) { return defaultVal; }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        if (session.getAttribute("username") == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        String action = request.getParameter("action");
        if ("viewDetail".equals(action)) {
            int maHD = parseIntSafely(request.getParameter("id"), 0);
            HoaDon hd = hoaDonService.getHoaDonById(maHD);
            List<HoaDonChiTiet> details = hoaDonService.getChiTietByHoaDonId(maHD);
            request.setAttribute("hd", hd);
            request.setAttribute("details", details);
            request.getRequestDispatcher("hoadon_chitiet.jsp").forward(request, response);
            return;
        } else if ("cancel".equals(action)) {
            int maHD = parseIntSafely(request.getParameter("id"), 0);
            HoaDon hd = hoaDonService.getHoaDonById(maHD);
            
            // LỖI LOGIC ĐÃ FIX: Chỉ thực hiện hủy và hoàn kho nếu hóa đơn chưa bị hủy
            if (hd != null && hd.getTrangThai() != 2) {
                hoaDonService.updateTrangThai(maHD, 2); // 2 = Đã hủy
                

                List<HoaDonChiTiet> detailsToCancel = hoaDonService.getChiTietByHoaDonId(maHD);
                if (detailsToCancel != null) {
                    for (HoaDonChiTiet ct : detailsToCancel) {
                        hoaDonService.increaseSachQuantity(ct.getMaSach(), ct.getSoLuong());
                    }
                }
            }

            response.sendRedirect("quanlyhoadon?action=viewDetail&id=" + maHD);
            return;
        }

        String keyword = request.getParameter("keyword");
        if (keyword != null) {
            keyword = new String(keyword.getBytes("ISO-8859-1"), "UTF-8");
        }
        String fromDate = request.getParameter("fromDate");
        String toDate = request.getParameter("toDate");

        List<HoaDon> list = hoaDonService.getAllHoaDon(keyword, fromDate, toDate);
        request.setAttribute("listHD", list);
        request.setAttribute("keyword", keyword);
        request.setAttribute("fromDate", fromDate);
        request.setAttribute("toDate", toDate);
        request.getRequestDispatcher("quanlyhoadon.jsp").forward(request, response);
    }
}
