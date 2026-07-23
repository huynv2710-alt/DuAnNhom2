package controller;

import Models.KhachHang;
import Service.KhachHangService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "QuanLyKhachHangServlet", urlPatterns = {"/quanlykhachhang"})
public class QuanLyKhachHangServlet extends HttpServlet {

    private KhachHangService khService = new KhachHangService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();

        if (session.getAttribute("username") == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        String action = request.getParameter("action");

        if ("delete".equals(action)) {

            int maKH = Integer.parseInt(request.getParameter("id"));

            khService.deleteKhachHang(maKH);

            session.setAttribute("success", "Xóa khách hàng thành công!");

            response.sendRedirect("quanlykhachhang");
            return;
        }

        String search = request.getParameter("search");

        List<KhachHang> list = khService.getAllKhachHang(search);

        request.setAttribute("listKH", list);
        request.setAttribute("search", search);

        request.getRequestDispatcher("quanlykhachhang.jsp")
                .forward(request, response);
    }

    // ===========================
    // HIỂN THỊ LỖI
    // ===========================

    private void showError(HttpServletRequest request,
                           HttpServletResponse response,
                           String message)
            throws ServletException, IOException {

        String search = request.getParameter("search");

        request.setAttribute("listKH",
                khService.getAllKhachHang(search));

        request.setAttribute("search", search);

        request.setAttribute("error", message);

        request.setAttribute("showModal", true);

        request.getRequestDispatcher("quanlykhachhang.jsp")
                .forward(request, response);
    }

    // ===========================
    // VALIDATE HỌ TÊN
    // ===========================

    private boolean isValidName(String name) {

        return name.matches(
                "^[A-Za-zÀ-Ỹà-ỹ\\s]{2,50}$"
        );

    }

    // ===========================
    // VALIDATE SĐT
    // ===========================

    private boolean isValidPhone(String phone) {

        return phone.matches("^0\\d{9}$");

    }

    // ===========================
    // VALIDATE EMAIL
    // ===========================

    private boolean isValidEmail(String email) {

        if (email == null || email.trim().isEmpty()) {
            return true;
        }

        return email.matches(
                "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$"
        );

    }

    // ===========================
    // VALIDATE ĐỊA CHỈ
    // ===========================

    private boolean isValidAddress(String diaChi) {

        if (diaChi == null || diaChi.trim().isEmpty()) {
            return true;
        }

        return diaChi.trim().length() >= 5;

    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();

        String action = request.getParameter("action");

        String hoTen = request.getParameter("hoTen").trim();
        String sdt = request.getParameter("sdt").trim();
        String diaChi = request.getParameter("diaChi").trim();
        String email = request.getParameter("email").trim();

        // Giữ dữ liệu khi lỗi
        request.setAttribute("hoTen", hoTen);
        request.setAttribute("sdt", sdt);
        request.setAttribute("diaChi", diaChi);
        request.setAttribute("email", email);

        // ===================
        // VALIDATE
        // ===================

        if (hoTen.isEmpty()) {

            showError(request, response,
                    "Họ tên không được để trống!");

            return;
        }

        if (!isValidName(hoTen)) {

            showError(request, response,
                    "Họ tên chỉ được chứa chữ và khoảng trắng.");

            return;
        }

        if (!isValidPhone(sdt)) {

            showError(request, response,
                    "Số điện thoại phải gồm 10 số và bắt đầu bằng số 0.");

            return;
        }

        if (!isValidEmail(email)) {

            showError(request, response,
                    "Email không đúng định dạng.");

            return;
        }

        if (!isValidAddress(diaChi)) {

            showError(request, response,
                    "Địa chỉ phải từ 5 ký tự trở lên.");

            return;
        }

        // ==========================
        // XỬ LÝ THÊM KHÁCH HÀNG
        // ==========================
        if ("add".equals(action)) {

            // Kiểm tra trùng SĐT
            if (khService.isPhoneExists(sdt)) {

                showError(request, response,
                        "Số điện thoại đã tồn tại!");

                return;
            }

            // Kiểm tra trùng Email
            if (!email.isEmpty()
                    && khService.isEmailExists(email)) {

                showError(request, response,
                        "Email đã tồn tại!");

                return;
            }

            KhachHang kh = new KhachHang(
                    0,
                    hoTen,
                    sdt,
                    diaChi,
                    email
            );

            boolean check = khService.addKhachHang(kh);

            if (check) {

                session.setAttribute(
                        "success",
                        "Thêm khách hàng thành công!"
                );

            } else {

                session.setAttribute(
                        "error",
                        "Không thể thêm khách hàng!"
                );
            }

            response.sendRedirect("quanlykhachhang");
            return;
        }

        // ==========================
        // XỬ LÝ SỬA KHÁCH HÀNG
        // ==========================
        if ("edit".equals(action)) {

            int maKH = Integer.parseInt(
                    request.getParameter("maKH")
            );

            // Kiểm tra SĐT trùng
            if (khService.isPhoneExists(sdt, maKH)) {

                showError(request, response,
                        "Số điện thoại đã tồn tại!");

                return;
            }

            // Kiểm tra Email trùng
            if (!email.isEmpty()
                    && khService.isEmailExists(email, maKH)) {

                showError(request, response,
                        "Email đã tồn tại!");

                return;
            }

            KhachHang kh = new KhachHang(
                    maKH,
                    hoTen,
                    sdt,
                    diaChi,
                    email
            );

            boolean check = khService.updateKhachHang(kh);

            if (check) {

                session.setAttribute(
                        "success",
                        "Cập nhật khách hàng thành công!"
                );

            } else {

                session.setAttribute(
                        "error",
                        "Không thể cập nhật khách hàng!"
                );
            }

            response.sendRedirect("quanlykhachhang");
            return;
        }

        response.sendRedirect("quanlykhachhang");
    }

}