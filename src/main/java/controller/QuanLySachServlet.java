package controller;

import Models.Sach;
import Service.SachService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/quanlysach")
public class QuanLySachServlet extends HttpServlet {

    private final SachService service = new SachService();

    // ── GET: hiển thị danh sách HOẶC form sửa ──────────────────────────────
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");

        if ("add".equals(action)) {
            // Mở form thêm mới (không set attribute "sach" → JSP hiểu là form trống)
            req.getRequestDispatcher("suasach.jsp").forward(req, resp);

        } else if ("edit".equals(action)) {
            // Mở form sửa với dữ liệu điền sẵn
            int maSach = Integer.parseInt(req.getParameter("id"));
            Sach sach  = service.getSachById(maSach);
            req.setAttribute("sach", sach);
            req.getRequestDispatcher("suasach.jsp").forward(req, resp);

        } else {
            // Mặc định: danh sách sách
            req.setAttribute("dsSach", service.getAllSach());
            req.getRequestDispatcher("quanlysach.jsp").forward(req, resp);
        }
    }

    // ── POST: thêm mới HOẶC cập nhật ───────────────────────────────────────
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");

        Sach s = new Sach();
        s.setTenSach(req.getParameter("tenSach"));
        s.setTacGia (req.getParameter("tacGia"));
        s.setTheLoai(req.getParameter("theLoai"));
        s.setDonGia (Double.parseDouble(req.getParameter("donGia")));
        s.setTonKho (Integer.parseInt(req.getParameter("tonKho")));

        if ("add".equals(action)) {
            service.addSach(s);
            req.getSession().setAttribute("successMsg", "Thêm sách thành công!");

        } else if ("update".equals(action)) {
            s.setMaSach(Integer.parseInt(req.getParameter("maSach")));
            service.updateSach(s);
            req.getSession().setAttribute("successMsg", "Cập nhật sách thành công!");
        }

        resp.sendRedirect("quanlysach.jsp");
    }
}
 