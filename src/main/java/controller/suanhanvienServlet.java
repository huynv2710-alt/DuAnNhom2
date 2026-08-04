package controller;

import Models.NhanVien;
import Models.TaiKhoan;
import Service.NhanVienService;
import Service.TaiKhoanService;
import Service.quanlinhanvienservlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/suanhanvien")
public class suanhanvienServlet extends HttpServlet {

    private TaiKhoanService tkService = new TaiKhoanService();
    private NhanVienService nvService = new NhanVienService();
    
    private int parseIntSafely(String str, int defaultVal) {
        if (str == null || str.trim().isEmpty()) return defaultVal;
        try { return Integer.parseInt(str.trim()); } catch (Exception e) { return defaultVal; }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            
        HttpSession session = request.getSession();
        if (session.getAttribute("username") == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        String quyen = (String) session.getAttribute("quyen");

        if ("update".equals(action)) {
            handleUpdate(request, response);
        } else if ("adminUpdate".equals(action)) {
            if (!"admin".equals(quyen) && !"1".equals(quyen)) {
                response.sendRedirect("dashboard");
                return;
            }
            quanlinhanvienservlet qlService = new quanlinhanvienservlet();
            NhanVien nv = new NhanVien();
            nv.setMaNV(parseIntSafely(request.getParameter("maNV"), 0));
            nv.setHoTen(request.getParameter("hoTen"));
            nv.setNgaySinh(java.sql.Date.valueOf(request.getParameter("ngaySinh")));
            nv.setGioiTinh(request.getParameter("gioiTinh"));
            nv.setSdt(request.getParameter("sdt"));
            nv.setEmail(request.getParameter("email"));
            nv.setDiaChi(request.getParameter("diaChi"));
            nv.setCccd(request.getParameter("cccd"));
            nv.setNgayCapCCCD(java.sql.Date.valueOf(request.getParameter("ngayCapCCCD")));
            nv.setDacDiemNhanDang(request.getParameter("dacDiemNhanDang"));
            
            String noiCap = request.getParameter("noiCapCCCD");
            if(noiCap != null) nv.setNoiCapCCCD(noiCap.trim());
            
            String ngayHetHan = request.getParameter("ngayHetHanCCCD");
            if (ngayHetHan != null && !ngayHetHan.isEmpty()) {
                java.sql.Date expDate = java.sql.Date.valueOf(ngayHetHan);
                if (!nv.getNgayCapCCCD().before(expDate)) {
                    response.setContentType("text/html;charset=UTF-8");
                    response.getWriter().println("<script>alert('Ngày cấp CCCD phải nhỏ hơn ngày hết hạn!'); window.history.back();</script>");
                    return;
                }
                nv.setNgayHetHanCCCD(expDate);
            }
            nv.setMaTrangThai(parseIntSafely(request.getParameter("maTrangThai"), 1));
            
            try {
                qlService.update(nv);
                response.sendRedirect("quanlinhanvien");
            } catch (RuntimeException e) {
                response.setContentType("text/html;charset=UTF-8");
                response.getWriter().println("<script>alert('Lỗi SQL khi sửa nhân viên: " + e.getMessage().replace("'", "\\'") + "'); window.history.back();</script>");
            }
        } else {
            response.sendRedirect("index.jsp");
        }
    }


    private void handleUpdate(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String hoTen = request.getParameter("hoTen");
        String sdt = request.getParameter("sdt");
        String email = request.getParameter("email");
        String diaChi = request.getParameter("diaChi");

        boolean isUpdated = nvService.updateThongTin(username, hoTen, sdt, email, diaChi);

        if (isUpdated) {
            HttpSession session = request.getSession();
            session.setAttribute("tenTK", hoTen);
            session.setAttribute("sdt", sdt);
            session.setAttribute("email", email);
            session.setAttribute("diaChi", diaChi);
        }

        response.sendRedirect("NhanVien2.jsp");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            
        HttpSession session = request.getSession();
        if (session.getAttribute("username") == null) {
            response.sendRedirect("index.jsp");
            return;
        }
            
        String action = request.getParameter("action");
        if ("edit".equals(action)) {
            String quyen = (String) session.getAttribute("quyen");
            if (!"admin".equals(quyen) && !"1".equals(quyen)) {
                response.sendRedirect("dashboard");
                return;
            }
            String idStr = request.getParameter("id");
            if (idStr != null) {
                int maNV = parseIntSafely(idStr, 0);
                quanlinhanvienservlet qlService = new quanlinhanvienservlet();
                NhanVien nv = qlService.getById(maNV);
                request.setAttribute("nv", nv);
                request.getRequestDispatcher("editnhanvien.jsp").forward(request, response);
                return;
            }
        }
        response.sendRedirect("index.jsp");
    }
}