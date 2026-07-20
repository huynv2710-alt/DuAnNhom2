package controller;

import Models.NhanVien;
import Service.TaiKhoanService;
import Service.quanlinhanvienservlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import java.time.Period;

@WebServlet("/themnhanvien")
public class ThemnhanvienServlet extends HttpServlet {

    private void showError(HttpServletRequest request,
                           HttpServletResponse response,
                           String message)
            throws ServletException, IOException {

        request.setAttribute("error", message);
        request.getRequestDispatcher("themnhanvien.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest req,
                         HttpServletResponse resp)
            throws ServletException, IOException {

        req.getRequestDispatcher("themnhanvien.jsp")
                .forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String maNVStr = request.getParameter("maNV").trim();
        String hoTen = request.getParameter("hoTen").trim();
        String ngaySinhStr = request.getParameter("ngaySinh");
        String sdt = request.getParameter("sdt").trim();
        String email = request.getParameter("email").trim();
        String diaChi = request.getParameter("diaChi").trim();
        String cccd = request.getParameter("cccd").trim();
        String ngayCap = request.getParameter("ngayCapCCCD");
        String dacDiem = request.getParameter("dacDiemNhanDang").trim();
        String username = request.getParameter("username").trim();
        String password = request.getParameter("password");

        NhanVien nv = new NhanVien();
        quanlinhanvienservlet s = new quanlinhanvienservlet();
        TaiKhoanService tkService = new TaiKhoanService();

        // =================== Mã nhân viên ===================
        if (!maNVStr.matches("\\d{1,5}")) {
            showError(request, response, "Mã nhân viên bắt đầu từ số 1 không quá nhiều số");
            return;
        }

        int maNV = Integer.parseInt(maNVStr);

        if (s.getById(maNV) != null) {
            showError(request, response, "Mã nhân viên đã tồn tại!");
            return;
        }

        // =================== Username ===================
        if (tkService.getUser(username) != null) {
            showError(request, response, "Tên đăng nhập đã tồn tại!");
            return;
        }

        if (!username.matches("^[A-Za-z0-9_]{5,20}$")) {
            showError(request, response, "Tên đăng nhập phải từ 5 đến 20 ký tự!");
            return;
        }

        // =================== Password ===================
        if (password.length() < 3) {
            showError(request, response, "Mật khẩu phải có ít nhất 3 ký tự!");
            return;
        }

        // =================== Họ tên ===================
        if (!hoTen.matches("^[\\p{L}\\s]+$")) {
            showError(request, response, "Họ tên không được chứa số hoặc ký tự đặc biệt!");
            return;
        }

        // =================== Ngày sinh ===================
        Date ngaySinh = Date.valueOf(ngaySinhStr);
        LocalDate birth = ngaySinh.toLocalDate();

        if (birth.isAfter(LocalDate.now())) {
            showError(request, response, "Ngày sinh không được lớn hơn ngày hiện tại!");
            return;
        }


        if (Period.between(birth, LocalDate.now()).getYears() < 18) {
            showError(request, response, "Nhân viên phải từ 18 tuổi trở lên!");
            return;
        }

        // =================== SĐT ===================
        if (!sdt.matches("^0\\d{9}$")) {
            showError(request, response, "Số điện thoại phải gồm đúng 10 số!");
            return;
        }

        // =================== Email ===================
        if (!email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$")) {
            showError(request, response, "Email không đúng định dạng!");
            return;
        }

        // =================== Địa chỉ ===================
        if (diaChi.length() < 5) {
            showError(request, response, "Địa chỉ phải có ít nhất 5 ký tự!");
            return;
        }

        // =================== CCCD ===================
        if (!cccd.matches("\\d{12}")) {
            showError(request, response, "CCCD phải gồm đúng 12 số!");
            return;
        }

        // =================== Ngày cấp CCCD ===================
        Date ngayCapCCCD = Date.valueOf(ngayCap);

        if (ngayCapCCCD.after(new Date(System.currentTimeMillis()))) {
            showError(request, response, "Ngày cấp CCCD không hợp lệ!");
            return;
        }

        // =================== Đặc điểm ===================
        if (dacDiem.length() < 5) {
            showError(request, response, "Đặc điểm nhận dạng phải có ít nhất 5 ký tự!");
            return;
        }

        // ======= Gán dữ liệu =======

        nv.setMaNV(maNV);
        nv.setHoTen(hoTen);
        nv.setNgaySinh(ngaySinh);
        nv.setGioiTinh(request.getParameter("gioiTinh"));
        nv.setSdt(sdt);
        nv.setEmail(email);
        nv.setDiaChi(diaChi);
        nv.setCccd(cccd);
        nv.setNgayCapCCCD(ngayCapCCCD);
        nv.setDacDiemNhanDang(dacDiem);
        nv.setMaTrangThai(Integer.parseInt(request.getParameter("maTrangThai")));
        // ======= Thêm nhân viên =======

        if (s.addNhanVien(nv)) {

            int maQuyen = Integer.parseInt(request.getParameter("maQuyen"));

            try {

                tkService.addTaiKhoan(username, password, maNV, maQuyen);

                request.getSession().setAttribute("success",
                        "Thêm nhân viên thành công!");

                response.sendRedirect("quanlinhanvien");

            } catch (Exception e) {

                e.printStackTrace();

                showError(request, response,
                        "Đã thêm nhân viên nhưng tạo tài khoản thất bại!\n"
                                + e.getMessage());
            }

        } else {

            showError(request, response,
                    "Không thể thêm nhân viên vào cơ sở dữ liệu!");
        }

    }
}