package controller;

import Models.NhanVien;
import Service.quanlinhanvienservlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;

@WebServlet("/suanhanvien")
public class suanhanvienServlet extends HttpServlet {

    quanlinhanvienservlet service = new quanlinhanvienservlet();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int id = Integer.parseInt(req.getParameter("id"));

        NhanVien nv = service.getById(id);

        req.setAttribute("nv", nv);

        req.getRequestDispatcher("suanhanvien.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int maNV = Integer.parseInt(req.getParameter("maNV"));
        String hoTen = req.getParameter("hoTen");
        Date ngaySinh = Date.valueOf(req.getParameter("ngaySinh"));
        String gioiTinh = req.getParameter("gioiTinh");
        String sdt = req.getParameter("sdt");
        String email = req.getParameter("email");
        String diaChi = req.getParameter("diaChi");
        String cccd = req.getParameter("cccd");
        Date ngayCapCCCD = Date.valueOf(req.getParameter("ngayCapCCCD"));
        String dacDiemNhanDang = req.getParameter("dacDiemNhanDang");
        int maTrangThai = Integer.parseInt(req.getParameter("maTrangThai"));

        NhanVien nv = new NhanVien();

        nv.setMaNV(maNV);
        nv.setHoTen(hoTen);
        nv.setNgaySinh(ngaySinh);
        nv.setGioiTinh(gioiTinh);
        nv.setSdt(sdt);
        nv.setEmail(email);
        nv.setDiaChi(diaChi);
        nv.setCccd(cccd);
        nv.setNgayCapCCCD(ngayCapCCCD);
        nv.setDacDiemNhanDang(dacDiemNhanDang);
        nv.setMaTrangThai(maTrangThai);

        boolean check = service.update(nv);

        if (check) {
            HttpSession session = req.getSession();
            session.setAttribute("successMsg", "Cập nhật nhân viên thành công!");
            resp.sendRedirect("quanlinhanvien");
        } else {
            req.setAttribute("error", "Cập nhật thất bại!");
            req.setAttribute("nv", nv);
            req.getRequestDispatcher("suanhanvien.jsp").forward(req, resp);
        }
    }
}
