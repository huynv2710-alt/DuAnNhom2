package Service;

import Models.TaiKhoan;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class TaiKhoanService {

    private connectService connect = new connectService();

    public boolean loginCheck(String username, String password) {

        try (Connection con = connect.myConnection();
             PreparedStatement ps = con.prepareStatement(
                     "SELECT 1 FROM TaiKhoan WHERE Username=? AND PASS=?")) {

            ps.setString(1, username);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();
            return rs.next();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public TaiKhoan getUser(String username) {

        TaiKhoan tk = null;

        try (Connection con = connect.myConnection();
             PreparedStatement ps = con.prepareStatement(

                     "SELECT tk.Username, nv.HoTen, pq.TenQuyen " +
                             "FROM TaiKhoan tk " +
                             "JOIN NhanVien nv ON tk.MaNV = nv.MaNV " +
                             "JOIN PhanQuyen pq ON tk.MaPhanQuyen = pq.MaPhanQuyen " +
                             "WHERE tk.Username = ?"

             )) {

            ps.setString(1, username);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                tk = new TaiKhoan();

                tk.setUsername(rs.getString("Username"));
                tk.setHoTen(rs.getString("HoTen"));
                tk.setTenQuyen(rs.getString("TenQuyen"));

            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return tk;
    }

    public TaiKhoan forgotPassword(String username, String email) {

        TaiKhoan tk = null;

        try (Connection con = connect.myConnection();
             PreparedStatement ps = con.prepareStatement(

                     "SELECT tk.Username, tk.PASS, nv.HoTen " +
                             "FROM TaiKhoan tk " +
                             "JOIN NhanVien nv ON tk.MaNV = nv.MaNV " +
                             "WHERE tk.Username=? AND nv.Email=?"

             )) {

            ps.setString(1, username);
            ps.setString(2, email);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                tk = new TaiKhoan();

                tk.setUsername(rs.getString("Username"));
                tk.setPass(rs.getString("PASS"));
                tk.setHoTen(rs.getString("HoTen"));

            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return tk;
    }
}