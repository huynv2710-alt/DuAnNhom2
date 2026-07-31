package controller;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebFilter(urlPatterns = {
        "/quanlinhanvien",
        "/themnhanvien",
        "/suanhanvien",
        "/quanlytaikhoan",
        "/quanlytheloai",
        "/quanlynxb"
})
public class AdminFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {

    }

    @Override
    public void doFilter(ServletRequest request,
                         ServletResponse response,
                         FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("quyen") == null) {
            resp.sendRedirect(req.getContextPath() + "/index.jsp");
            return;
        }

        String quyen = (String) session.getAttribute("quyen");

        if (!"admin".equalsIgnoreCase(quyen)) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN,
                    "Ban Khong Truy Cap Duoc Trang WEB này!");
            return;
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {

    }
}