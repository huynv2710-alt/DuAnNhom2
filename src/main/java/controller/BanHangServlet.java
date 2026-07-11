package controller;

import Models.HoaDon;
import Models.HoaDonChiTiet;
import Models.KhachHang;
import Models.Sach;
import Service.HoaDonService;
import Service.KhachHangService;
import Service.SachService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@WebServlet(name = "BanHangServlet", urlPatterns = {"/banhang"})
public class BanHangServlet extends HttpServlet {
    private SachService sachService = new SachService();
    private KhachHangService khService = new KhachHangService();
    private HoaDonService hoaDonService = new HoaDonService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        if (session.getAttribute("username") == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        // Initialize Cart if null
        if (session.getAttribute("cart") == null) {
            session.setAttribute("cart", new ArrayList<HoaDonChiTiet>());
        }

        String action = request.getParameter("action");
        if ("addCart".equals(action)) {
            int maSach = Integer.parseInt(request.getParameter("maSach"));
            Sach sach = sachService.getSachById(maSach);
            if (sach != null && sach.getSoLuongTon() > 0) {
                List<HoaDonChiTiet> cart = (List<HoaDonChiTiet>) session.getAttribute("cart");
                boolean exists = false;
                for (HoaDonChiTiet item : cart) {
                    if (item.getMaSach() == maSach) {
                        if (item.getSoLuong() < sach.getSoLuongTon()) {
                            item.setSoLuong(item.getSoLuong() + 1);
                        }
                        exists = true;
                        break;
                    }
                }
                if (!exists) {
                    HoaDonChiTiet item = new HoaDonChiTiet(0, maSach, 1, sach.getGiaBan());
                    item.setTenSach(sach.getTenSach());
                    cart.add(item);
                }
            }
            response.sendRedirect("banhang");
            return;
        } else if ("removeCart".equals(action)) {
            int maSach = Integer.parseInt(request.getParameter("maSach"));
            List<HoaDonChiTiet> cart = (List<HoaDonChiTiet>) session.getAttribute("cart");
            cart.removeIf(item -> item.getMaSach() == maSach);
            response.sendRedirect("banhang");
            return;
        } else if ("clearCart".equals(action)) {
            session.setAttribute("cart", new ArrayList<HoaDonChiTiet>());
            response.sendRedirect("banhang");
            return;
        }

        // Load data for POS View
        String searchSach = request.getParameter("searchSach");
        List<Sach> dsSach = sachService.getAllSach(searchSach);
        // Filter out out-of-stock
        dsSach.removeIf(s -> s.getSoLuongTon() <= 0 || s.getTrangThai() == 0);
        
        List<KhachHang> dsKhachHang = khService.getAllKhachHang(null);

        request.setAttribute("dsSach", dsSach);
        request.setAttribute("searchSach", searchSach);
        request.setAttribute("dsKhachHang", dsKhachHang);
        
        // Calculate Total
        List<HoaDonChiTiet> cart = (List<HoaDonChiTiet>) session.getAttribute("cart");
        double tongTien = 0;
        for (HoaDonChiTiet item : cart) {
            tongTien += item.getSoLuong() * item.getDonGia();
        }
        request.setAttribute("tongTien", tongTien);

        request.getRequestDispatcher("banhang.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession();
        String action = request.getParameter("action");
        
        if ("checkout".equals(action)) {
            List<HoaDonChiTiet> cart = (List<HoaDonChiTiet>) session.getAttribute("cart");
            if (cart == null || cart.isEmpty()) {
                response.sendRedirect("banhang?error=empty_cart");
                return;
            }
            
            int maKH = Integer.parseInt(request.getParameter("maKH"));
            // Assuming we store MaNV in session, but since login only stored username/quyen, 
            // wait, we need MaNV. If session doesn't have MaNV, we'll need to fetch it.
            // For now, let's just use 1 if MaNV is not in session, or try to get it.
            int maNV = session.getAttribute("MaNV") != null ? (Integer) session.getAttribute("MaNV") : 1; 

            double tongTien = 0;
            for (HoaDonChiTiet item : cart) {
                tongTien += item.getSoLuong() * item.getDonGia();
            }

            HoaDon hd = new HoaDon(0, maNV, maKH, new Date(), tongTien, 1);
            int newMaHD = hoaDonService.createHoaDon(hd);
            
            if (newMaHD > 0) {
                for (HoaDonChiTiet item : cart) {
                    item.setMaHD(newMaHD);
                    hoaDonService.addHoaDonChiTiet(item);
                    hoaDonService.reduceSachQuantity(item.getMaSach(), item.getSoLuong());
                }
                // Clear cart
                session.setAttribute("cart", new ArrayList<HoaDonChiTiet>());
                response.sendRedirect("quanlyhoadon?action=viewDetail&id=" + newMaHD);
            } else {
                response.sendRedirect("banhang?error=db_error");
            }
        }
    }
}
