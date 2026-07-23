package Service;

import Models.KhachHang;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class KhachHangService {

    public List<KhachHang> getAllKhachHang(String search) {
        List<KhachHang> list = new ArrayList<>();

        String sql = "SELECT * FROM KhachHang " +
                "WHERE HoTen LIKE ? OR SDT LIKE ? " +
                "ORDER BY MaKH DESC";

        try (Connection con = new connectService().myConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            String keyword = "%" + (search == null ? "" : search.trim()) + "%";

            ps.setString(1, keyword);
            ps.setString(2, keyword);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                KhachHang kh = new KhachHang(
                        rs.getInt("MaKH"),
                        rs.getString("HoTen"),
                        rs.getString("SDT"),
                        rs.getString("DiaChi"),
                        rs.getString("Email")
                );

                list.add(kh);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public KhachHang getKhachHangById(int id) {

        String sql = "SELECT * FROM KhachHang WHERE MaKH=?";

        try (Connection con = new connectService().myConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                return new KhachHang(
                        rs.getInt("MaKH"),
                        rs.getString("HoTen"),
                        rs.getString("SDT"),
                        rs.getString("DiaChi"),
                        rs.getString("Email")
                );

            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    // ============================
    // KIỂM TRA TRÙNG SĐT
    // ============================

    public boolean isPhoneExists(String sdt) {

        String sql = "SELECT COUNT(*) FROM KhachHang WHERE SDT=?";

        try (Connection con = new connectService().myConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, sdt);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // Khi sửa
    public boolean isPhoneExists(String sdt, int maKH) {

        String sql =
                "SELECT COUNT(*) FROM KhachHang " +
                        "WHERE SDT=? AND MaKH<>?";

        try (Connection con = new connectService().myConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, sdt);
            ps.setInt(2, maKH);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // ============================
    // KIỂM TRA EMAIL
    // ============================

    public boolean isEmailExists(String email) {

        if (email == null || email.trim().isEmpty()) {
            return false;
        }

        String sql = "SELECT COUNT(*) FROM KhachHang WHERE Email=?";

        try (Connection con = new connectService().myConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, email);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // Khi sửa
    public boolean isEmailExists(String email, int maKH) {

        if (email == null || email.trim().isEmpty()) {
            return false;
        }

        String sql =
                "SELECT COUNT(*) FROM KhachHang " +
                        "WHERE Email=? AND MaKH<>?";

        try (Connection con = new connectService().myConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, email);
            ps.setInt(2, maKH);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // ============================
    // THÊM
    // ============================

    public boolean addKhachHang(KhachHang kh) {

        String sql =
                "INSERT INTO KhachHang(HoTen,SDT,DiaChi,Email) " +
                        "VALUES(?,?,?,?)";

        try (Connection con = new connectService().myConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, kh.getHoTen());
            ps.setString(2, kh.getSdt());
            ps.setString(3, kh.getDiaChi());
            ps.setString(4, kh.getEmail());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // ============================
    // CẬP NHẬT
    // ============================

    public boolean updateKhachHang(KhachHang kh) {

        String sql =
                "UPDATE KhachHang SET " +
                        "HoTen=?,SDT=?,DiaChi=?,Email=? " +
                        "WHERE MaKH=?";

        try (Connection con = new connectService().myConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, kh.getHoTen());
            ps.setString(2, kh.getSdt());
            ps.setString(3, kh.getDiaChi());
            ps.setString(4, kh.getEmail());
            ps.setInt(5, kh.getMaKH());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // ============================
    // XÓA
    // ============================

    public boolean deleteKhachHang(int id) {

        String sql = "DELETE FROM KhachHang WHERE MaKH=?";

        try (Connection con = new connectService().myConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

}