package controller;

import Models.Sach;
import Service.SachService;
import Service.ThuocTinhSachService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "QuanLySachServlet", urlPatterns = {"/quanlysach"})
public class QuanLySachServlet extends HttpServlet {
    private SachService sachService = new SachService();
    private ThuocTinhSachService thuocTinhService = new ThuocTinhSachService();

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
        if ("delete".equals(action)) {
            int maSach = Integer.parseInt(request.getParameter("id"));
            sachService.deleteSach(maSach);
            response.sendRedirect("quanlysach");
            return;
        }

        String search = request.getParameter("search");
        List<Sach> list = sachService.getAllSach(search);
        
        request.setAttribute("listSach", list);
        request.setAttribute("search", search);
        
        // Load dropdown lists
        request.setAttribute("listTL", thuocTinhService.getAllTheLoai());
        request.setAttribute("listNXB", thuocTinhService.getAllNXB());
        
        request.getRequestDispatcher("quanlysach.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        String tenSach = request.getParameter("tenSach");
        String tacGia = request.getParameter("tacGia");
        String isbn = request.getParameter("isbn");
        int maTheLoai = Integer.parseInt(request.getParameter("maTheLoai"));
        int maNXB = Integer.parseInt(request.getParameter("maNXB"));
        double giaNhap = Double.parseDouble(request.getParameter("giaNhap") != null ? request.getParameter("giaNhap") : "0");
        double giaBan = Double.parseDouble(request.getParameter("giaBan"));
        int soLuongTon = Integer.parseInt(request.getParameter("soLuongTon"));
        String hinhAnh = request.getParameter("hinhAnh");
        int trangThai = Integer.parseInt(request.getParameter("trangThai"));

        int soTrang = 0;
        int trongLuong = 0;
        try { soTrang = Integer.parseInt(request.getParameter("soTrang")); } catch (Exception e) {}
        try { trongLuong = Integer.parseInt(request.getParameter("trongLuong")); } catch (Exception e) {}
        
        String kichThuoc = request.getParameter("kichThuoc");
        String ngonNgu = request.getParameter("ngonNgu");

        if ("add".equals(action)) {
            Sach s = new Sach(0, tenSach, tacGia, isbn, maTheLoai, maNXB, giaNhap, giaBan, soLuongTon, hinhAnh, trangThai, soTrang, kichThuoc, trongLuong, ngonNgu);
            sachService.addSach(s);
        } else if ("edit".equals(action)) {
            int maSach = Integer.parseInt(request.getParameter("maSach"));
            Sach s = new Sach(maSach, tenSach, tacGia, isbn, maTheLoai, maNXB, giaNhap, giaBan, soLuongTon, hinhAnh, trangThai, soTrang, kichThuoc, trongLuong, ngonNgu);
            sachService.updateSach(s);
        }
        
        response.sendRedirect("quanlysach");
    }
}
