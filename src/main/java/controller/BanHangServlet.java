package controller;

import Models.HoaDon;
import Models.HoaDonChiTiet;
import Models.KhachHang;
import Models.Sach;
import Models.KhuyenMai;
import Service.HoaDonService;
import Service.KhachHangService;
import Service.SachService;
import Service.ThuocTinhSachService;
import Service.KhuyenMaiService;

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
    private ThuocTinhSachService thuocTinhSachService = new ThuocTinhSachService();
    private KhuyenMaiService khuyenMaiService = new KhuyenMaiService();

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
        } else if ("addCartMulti".equals(action)) {
            int maSach = Integer.parseInt(request.getParameter("maSach"));
            int soLuong = Integer.parseInt(request.getParameter("soLuong"));
            Sach sach = sachService.getSachById(maSach);
            if (sach != null && sach.getSoLuongTon() > 0 && soLuong > 0) {
                List<HoaDonChiTiet> cart = (List<HoaDonChiTiet>) session.getAttribute("cart");
                boolean exists = false;
                for (HoaDonChiTiet item : cart) {
                    if (item.getMaSach() == maSach) {
                        int newQty = item.getSoLuong() + soLuong;
                        if (newQty > sach.getSoLuongTon()) newQty = sach.getSoLuongTon();
                        item.setSoLuong(newQty);
                        exists = true;
                        break;
                    }
                }
                if (!exists) {
                    if (soLuong > sach.getSoLuongTon()) soLuong = sach.getSoLuongTon();
                    HoaDonChiTiet item = new HoaDonChiTiet(0, maSach, soLuong, sach.getGiaBan());
                    item.setTenSach(sach.getTenSach());
                    cart.add(item);
                }
            }
            response.sendRedirect("banhang");
            return;
        } else if ("updateCart".equals(action)) {
            int maSach = Integer.parseInt(request.getParameter("maSach"));
            int soLuong = Integer.parseInt(request.getParameter("soLuong"));
            Sach sach = sachService.getSachById(maSach);
            List<HoaDonChiTiet> cart = (List<HoaDonChiTiet>) session.getAttribute("cart");
            if (sach != null) {
                if (soLuong > 0) {
                    if (soLuong > sach.getSoLuongTon()) {
                        soLuong = sach.getSoLuongTon();
                    }
                    for (HoaDonChiTiet item : cart) {
                        if (item.getMaSach() == maSach) {
                            item.setSoLuong(soLuong);
                            break;
                        }
                    }
                } else {
                    // Remove item if quantity is zero or negative
                    cart.removeIf(item -> item.getMaSach() == maSach);
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
        String theLoaiParam = request.getParameter("maTheLoai");
        int maTheLoai = 0;
        try { if(theLoaiParam != null) maTheLoai = Integer.parseInt(theLoaiParam); } catch(Exception e){}

        List<Sach> dsSach = sachService.getAllSach(searchSach, maTheLoai);
        // Filter out out-of-stock
        dsSach.removeIf(s -> s.getSoLuongTon() <= 0 || s.getTrangThai() == 0);
        
        List<KhachHang> dsKhachHang = khService.getAllKhachHang(null);

        request.setAttribute("dsSach", dsSach);
        request.setAttribute("searchSach", searchSach);
        request.setAttribute("maTheLoai", maTheLoai);
        request.setAttribute("dsKhachHang", dsKhachHang);
        request.setAttribute("dsTheLoai", thuocTinhSachService.getAllTheLoai());
        request.setAttribute("dsKhuyenMai", khuyenMaiService.getActiveKhuyenMai()); // Thêm khuyến mãi
        
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
            int maNV = session.getAttribute("MaNV") != null ? (Integer) session.getAttribute("MaNV") : 1; 

            double tongTien = 0;
            for (HoaDonChiTiet item : cart) {
                Sach dbSach = sachService.getSachById(item.getMaSach());
                if (dbSach == null || dbSach.getSoLuongTon() < item.getSoLuong() || dbSach.getTrangThai() == 0) {
                    response.sendRedirect("banhang?error=out_of_stock");
                    return;
                }
                tongTien += item.getSoLuong() * item.getDonGia();
            }

            String phuongThucTT = request.getParameter("phuongThucTT");
            int trangThai = "ChuyenKhoan".equals(phuongThucTT) ? 0 : 1;

            double giamGia = 0;
            Integer maKM = null;
            try {
                int selectedMaKM = Integer.parseInt(request.getParameter("maKM"));
                if (selectedMaKM > 0) {
                    maKM = selectedMaKM;
                    // Lấy % giảm giá
                    List<KhuyenMai> activeKM = khuyenMaiService.getActiveKhuyenMai();
                    for (KhuyenMai km : activeKM) {
                        if (km.getMaKM() == maKM) {
                            giamGia = tongTien * (km.getPhanTramGiam() / 100.0);
                            break;
                        }
                    }
                }
            } catch (Exception e) {}

            HoaDon hd = new HoaDon(0, maNV, maKH, new java.sql.Timestamp(System.currentTimeMillis()), tongTien, trangThai);
            hd.setGiamGia(giamGia);
            hd.setMaKM(maKM);
            hd.setPhuongThucTT("ChuyenKhoan".equals(phuongThucTT) ? "Chuyển khoản QR" : "Tiền mặt");
            int newMaHD = hoaDonService.createHoaDon(hd);
            
            if (newMaHD > 0) {
                for (HoaDonChiTiet item : cart) {
                    item.setMaHD(newMaHD);
                    hoaDonService.addHoaDonChiTiet(item);
                    // Luôn trừ tồn kho để giữ hàng cho khách
                    hoaDonService.reduceSachQuantity(item.getMaSach(), item.getSoLuong());
                }
                
                session.setAttribute("cart", new ArrayList<HoaDonChiTiet>());
                session.setAttribute("lastGiamGia", giamGia);
                session.setAttribute("lastPhuongThucTT", phuongThucTT);
                
                try {
                    session.setAttribute("lastTienKhachDua", Double.parseDouble(request.getParameter("tienKhachDua")));
                } catch (Exception e) { session.setAttribute("lastTienKhachDua", null); }
                
                if (trangThai == 1) {
                    response.sendRedirect("quanlyhoadon?action=viewDetail&id=" + newMaHD + "&fromPOS=1");
                } else {
                    double finalAmount = tongTien - giamGia;
                    if (finalAmount < 0) finalAmount = 0;
                    response.sendRedirect("checkout_qr.jsp?id=" + newMaHD + "&amount=" + (int)finalAmount);
                }
            } else {
                response.sendRedirect("banhang?error=db_error");
            }
        }
    }
}
