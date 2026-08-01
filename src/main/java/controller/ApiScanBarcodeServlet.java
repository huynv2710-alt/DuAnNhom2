package controller;

import Models.HoaDonChiTiet;
import Models.Sach;
import Service.SachService;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.JsonArray;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "ApiScanBarcodeServlet", urlPatterns = {"/api/scan-barcode"})
public class ApiScanBarcodeServlet extends HttpServlet {
    private SachService sachService = new SachService();
    private Gson gson = new Gson();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        PrintWriter out = response.getWriter();
        JsonObject jsonResponse = new JsonObject();
        HttpSession session = request.getSession();

        if (session.getAttribute("username") == null) {
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Vui lòng đăng nhập");
            out.print(gson.toJson(jsonResponse));
            out.flush();
            return;
        }

        String barcode = request.getParameter("barcode");
        if (barcode == null || barcode.trim().isEmpty()) {
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Mã vạch trống");
            out.print(gson.toJson(jsonResponse));
            out.flush();
            return;
        }

        Sach sach = sachService.getSachByBarcode(barcode);
        
        if (sach == null) {
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Không tìm thấy sản phẩm");
            out.print(gson.toJson(jsonResponse));
            out.flush();
            return;
        }
        
        if (sach.getSoLuongTon() <= 0) {
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Sản phẩm đã hết hàng");
            out.print(gson.toJson(jsonResponse));
            out.flush();
            return;
        }

        // Add to cart
        List<HoaDonChiTiet> cart = (List<HoaDonChiTiet>) session.getAttribute("cart");
        if (cart == null) {
            cart = new ArrayList<>();
        }

        boolean exists = false;
        for (HoaDonChiTiet item : cart) {
            if (item.getMaSach() == sach.getMaSach()) {
                if (item.getSoLuong() < sach.getSoLuongTon()) {
                    item.setSoLuong(item.getSoLuong() + 1);
                } else {
                    jsonResponse.addProperty("success", false);
                    jsonResponse.addProperty("message", "Sản phẩm không đủ tồn kho");
                    out.print(gson.toJson(jsonResponse));
                    out.flush();
                    return;
                }
                exists = true;
                break;
            }
        }
        if (!exists) {
            HoaDonChiTiet item = new HoaDonChiTiet(0, sach.getMaSach(), 1, sach.getGiaBan());
            item.setTenSach(sach.getTenSach());
            cart.add(item);
        }
        session.setAttribute("cart", cart);

        double tongTien = 0;
        JsonArray cartArray = new JsonArray();
        for (HoaDonChiTiet item : cart) {
            tongTien += item.getSoLuong() * item.getDonGia();
            JsonObject itemObj = new JsonObject();
            itemObj.addProperty("maSach", item.getMaSach());
            itemObj.addProperty("tenSach", item.getTenSach());
            itemObj.addProperty("soLuong", item.getSoLuong());
            itemObj.addProperty("donGia", item.getDonGia());
            cartArray.add(itemObj);
        }

        JsonObject productObj = new JsonObject();
        productObj.addProperty("maSach", sach.getMaSach());
        productObj.addProperty("tenSach", sach.getTenSach());
        productObj.addProperty("giaBan", sach.getGiaBan());

        jsonResponse.addProperty("success", true);
        jsonResponse.addProperty("message", "Đã thêm sản phẩm");
        jsonResponse.add("product", productObj);
        jsonResponse.add("cart", cartArray);
        jsonResponse.addProperty("tongTien", tongTien);

        out.print(gson.toJson(jsonResponse));
        out.flush();
    }
}
