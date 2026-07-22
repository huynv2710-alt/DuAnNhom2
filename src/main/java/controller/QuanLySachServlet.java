package controller;

import Models.Sach;
import Service.SachService;
import Service.ThuocTinhSachService;
import Service.TacGiaService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "QuanLySachServlet", urlPatterns = {"/quanlysach"})
public class QuanLySachServlet extends HttpServlet {
    private SachService sachService = new SachService();
    private ThuocTinhSachService thuocTinhService = new ThuocTinhSachService();
    private TacGiaService tacGiaService = new TacGiaService();

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
        request.setAttribute("listTG", tacGiaService.getAllTacGia()); // Mới thêm
        
        request.getRequestDispatcher("quanlysach.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        String tenSach = request.getParameter("tenSach");
        String tacGiasStr = request.getParameter("tacGias"); // Nhận chuỗi tác giả
        
        String isbn = request.getParameter("isbn");
        int maTheLoai = Integer.parseInt(request.getParameter("maTheLoai"));
        int maNXB = Integer.parseInt(request.getParameter("maNXB"));
        double giaNhap = 0;
        double giaBan = 0;
        int soLuongTon = 0;
        try { giaNhap = Double.parseDouble(request.getParameter("giaNhap")); } catch(Exception e){}
        try { giaBan = Double.parseDouble(request.getParameter("giaBan")); } catch(Exception e){}
        try { soLuongTon = Integer.parseInt(request.getParameter("soLuongTon")); } catch(Exception e){}
        
        String hinhAnh = request.getParameter("hinhAnh");
        int trangThai = 1;
        try { trangThai = Integer.parseInt(request.getParameter("trangThai")); } catch(Exception e){}

        int soTrang = 0;
        int trongLuong = 0;
        try { soTrang = Integer.parseInt(request.getParameter("soTrang")); } catch (Exception e) {}
        try { trongLuong = Integer.parseInt(request.getParameter("trongLuong")); } catch (Exception e) {}
        
        String kichThuoc = request.getParameter("kichThuoc");
        String ngonNgu = request.getParameter("ngonNgu");
        String moTa = request.getParameter("moTa");

        Sach s = new Sach();
        s.setTenSach(tenSach);
        s.setIsbn(isbn);
        s.setMaTheLoai(maTheLoai);
        s.setMaNXB(maNXB);
        s.setGiaNhap(giaNhap);
        s.setGiaBan(giaBan);
        s.setSoLuongTon(soLuongTon);
        s.setHinhAnh(hinhAnh);
        s.setTrangThai(trangThai);
        s.setSoTrang(soTrang);
        s.setTrongLuong(trongLuong);
        s.setKichThuoc(kichThuoc);
        s.setNgonNgu(ngonNgu);
        s.setMoTa(moTa);

        if ("add".equals(action)) {
            sachService.addSach(s, tacGiasStr);
        } else if ("edit".equals(action)) {
            int maSach = Integer.parseInt(request.getParameter("maSach"));
            s.setMaSach(maSach);
            sachService.updateSach(s, tacGiasStr);
        }
        
        response.sendRedirect("quanlysach");
    }
}
