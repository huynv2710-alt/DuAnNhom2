package controller;

import Models.NhanVien;
import Service.ThongtinQuanliService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/thongtinquanli")
public class ThongtinquanliServlet extends HttpServlet {
    ThongtinQuanliService service = new ThongtinQuanliService();

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        Integer maNV = (Integer) session.getAttribute("maNV");

//        if (maNV == null) {
//            response.sendRedirect("index.jsp");
//            return;
//        }

        NhanVien nv = service.getNhanVienByMa(1);

        request.setAttribute("nv", nv);

        request.getRequestDispatcher("Quanli.jsp")
                .forward(request, response);

    }
}
