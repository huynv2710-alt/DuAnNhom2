package controller;

import Models.KhuyenMai;
import Service.KhuyenMaiService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@WebServlet("/quanlykhuyenmai")
public class QuanLyKhuyenMaiServlet extends HttpServlet {

    private KhuyenMaiService kmService = new KhuyenMaiService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("username") == null || !"Admin".equalsIgnoreCase((String) session.getAttribute("quyen"))) {
            response.sendRedirect("index.jsp");
            return;
        }

        List<KhuyenMai> dsKhuyenMai = kmService.getAllKhuyenMai();
        request.setAttribute("dsKhuyenMai", dsKhuyenMai);
        request.getRequestDispatcher("quanlykhuyenmai.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        if (session.getAttribute("username") == null || !"Admin".equalsIgnoreCase((String) session.getAttribute("quyen"))) {
            response.sendRedirect("index.jsp");
            return;
        }

        String action = request.getParameter("action");
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");

        try {
            if ("add".equals(action)) {
                String tenKM = request.getParameter("tenKM");
                double phanTram = Double.parseDouble(request.getParameter("phanTramGiam"));
                Date ngayBatDau = sdf.parse(request.getParameter("ngayBatDau"));
                Date ngayKetThuc = sdf.parse(request.getParameter("ngayKetThuc"));
                int trangThai = Integer.parseInt(request.getParameter("trangThai"));

                if (ngayKetThuc.before(ngayBatDau)) {
                    request.getSession().setAttribute("error", "Ngày kết thúc phải lớn hơn ngày bắt đầu!");
                } else {
                    KhuyenMai km = new KhuyenMai(0, tenKM, phanTram, new java.sql.Timestamp(ngayBatDau.getTime()), new java.sql.Timestamp(ngayKetThuc.getTime()), trangThai);
                    if (kmService.addKhuyenMai(km)) {
                        request.getSession().setAttribute("success", "Thêm khuyến mãi thành công!");
                    } else {
                        request.getSession().setAttribute("error", "Thêm khuyến mãi thất bại!");
                    }
                }
            } else if ("update".equals(action)) {
                int maKM = Integer.parseInt(request.getParameter("maKM"));
                String tenKM = request.getParameter("tenKM");
                double phanTram = Double.parseDouble(request.getParameter("phanTramGiam"));
                Date ngayBatDau = sdf.parse(request.getParameter("ngayBatDau"));
                Date ngayKetThuc = sdf.parse(request.getParameter("ngayKetThuc"));
                int trangThai = Integer.parseInt(request.getParameter("trangThai"));

                if (ngayKetThuc.before(ngayBatDau)) {
                    request.getSession().setAttribute("error", "Ngày kết thúc phải lớn hơn ngày bắt đầu!");
                } else {
                    KhuyenMai km = new KhuyenMai(maKM, tenKM, phanTram, new java.sql.Timestamp(ngayBatDau.getTime()), new java.sql.Timestamp(ngayKetThuc.getTime()), trangThai);
                    if (kmService.updateKhuyenMai(km)) {
                        request.getSession().setAttribute("success", "Cập nhật khuyến mãi thành công!");
                    } else {
                        request.getSession().setAttribute("error", "Cập nhật khuyến mãi thất bại!");
                    }
                }
            } else if ("toggle".equals(action)) {
                int maKM = Integer.parseInt(request.getParameter("maKM"));
                if (kmService.toggleStatus(maKM)) {
                    request.getSession().setAttribute("success", "Đổi trạng thái thành công!");
                } else {
                    request.getSession().setAttribute("error", "Đổi trạng thái thất bại!");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Lỗi: " + e.getMessage());
        }

        response.sendRedirect("banhang");
    }
}
