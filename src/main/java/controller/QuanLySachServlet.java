package controller;

import Models.Sach;
import Service.SachService;
import Service.ThuocTinhSachService;
import Service.TacGiaService;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.List;

@WebServlet(name = "QuanLySachServlet", urlPatterns = {"/quanlysach"})
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
                 maxFileSize = 1024 * 1024 * 10,      // 10MB
                 maxRequestSize = 1024 * 1024 * 50)   // 50MB
public class QuanLySachServlet extends HttpServlet {
    private int parseIntSafely(String str, int defaultVal) {
        if (str == null || str.trim().isEmpty()) return defaultVal;
        try { return Integer.parseInt(str.trim()); } catch (Exception e) { return defaultVal; }
    }

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
            int maSach = parseIntSafely(request.getParameter("id"), 0);
            if (maSach > 0) sachService.deleteSach(maSach);
            response.sendRedirect("quanlysach");
            return;
        }

        String search = request.getParameter("search");
        int maTheLoai = parseIntSafely(request.getParameter("maTheLoai"), 0);
        int maNXB = parseIntSafely(request.getParameter("maNXB"), 0);
        
        List<Sach> list = sachService.getAllSach(search, maTheLoai, maNXB);
        
        // Removed TacGia filtering for now as it requires complex joining or post-filtering
        
        request.setAttribute("listSach", list);
        request.setAttribute("search", search);
        request.setAttribute("maTheLoai", maTheLoai);
        request.setAttribute("maNXB", maNXB);
        
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
        int maTheLoai = parseIntSafely(request.getParameter("maTheLoai"), 0);
        int maNXB = parseIntSafely(request.getParameter("maNXB"), 0);
        double giaNhap = 0;
        double giaBan = 0;
        int soLuongTon = 0;
        try { giaNhap = Double.parseDouble(request.getParameter("giaNhap")); } catch(Exception e){}
        try { giaBan = Double.parseDouble(request.getParameter("giaBan")); } catch(Exception e){}
        try { soLuongTon = Integer.parseInt(request.getParameter("soLuongTon")); } catch(Exception e){}
        
        String hinhAnh = request.getParameter("hinhAnh");
        
        // Xử lý upload file ảnh
        try {
            Part filePart = request.getPart("hinhAnhFile");
            if (filePart != null && filePart.getSize() > 0) {
                // Compatible with Servlet 3.0 (Tomcat 7)
                String fileName = "";
                String contentDisp = filePart.getHeader("content-disposition");
                if (contentDisp != null) {
                    for (String token : contentDisp.split(";")) {
                        if (token.trim().startsWith("filename")) {
                            fileName = token.substring(token.indexOf("=") + 2, token.length() - 1);
                            // Extract just the file name to avoid IE path issues
                            fileName = Paths.get(fileName).getFileName().toString();
                            break;
                        }
                    }
                }
                
                if (!fileName.isEmpty()) {
                    String uploadPath = request.getServletContext().getRealPath("") + File.separator + "uploads";
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) uploadDir.mkdir();
                    
                    String filePath = uploadPath + File.separator + fileName;
                    filePart.write(filePath);
                    hinhAnh = "uploads/" + fileName; // Update hinhAnh to local path
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

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
            boolean ok = sachService.addSach(s, tacGiasStr);
            response.sendRedirect("quanlysach?" + (ok ? "success=add" : "error=add"));
            return;
        } else if ("edit".equals(action)) {
            int maSach = parseIntSafely(request.getParameter("maSach"), 0);
            s.setMaSach(maSach);
            boolean ok = sachService.updateSach(s, tacGiasStr);
            response.sendRedirect("quanlysach?" + (ok ? "success=edit" : "error=edit"));
            return;
        }
        
        response.sendRedirect("quanlysach");
    }
}
