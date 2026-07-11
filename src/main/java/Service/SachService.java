package Service;

import Models.Sach;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class SachService {

    private final connectService db = new connectService();

    // ── Lấy toàn bộ sách ───────────────────────────────────────────────────
    public ArrayList<Sach> getAllSach() {
        ArrayList<Sach> list = new ArrayList<>();
        String sql = "SELECT MaSach, TenSach, TacGia, TheLoai, DonGia, TonKho FROM Sach";

        try (Connection conn = db.myConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ── Lấy 1 sách theo mã (dùng cho trang sửa) ────────────────────────────
    public Sach getSachById(int maSach) {
        String sql = "SELECT MaSach, TenSach, TacGia, TheLoai, DonGia, TonKho " +
                "FROM Sach WHERE MaSach = ?";

        try (Connection conn = db.myConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, maSach);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // ── Thêm sách mới ───────────────────────────────────────────────────────
    public boolean addSach(Sach s) {
        String sql = "INSERT INTO Sach (TenSach, TacGia, TheLoai, DonGia, TonKho) " +
                "VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = db.myConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, s.getTenSach());
            ps.setString(2, s.getTacGia());
            ps.setString(3, s.getTheLoai());
            ps.setDouble(4, s.getDonGia());
            ps.setInt   (5, s.getTonKho());

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // ── Cập nhật sách ───────────────────────────────────────────────────────
    public boolean updateSach(Sach s) {
        String sql = "UPDATE Sach SET TenSach=?, TacGia=?, TheLoai=?, DonGia=?, TonKho=? " +
                "WHERE MaSach=?";

        try (Connection conn = db.myConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, s.getTenSach());
            ps.setString(2, s.getTacGia());
            ps.setString(3, s.getTheLoai());
            ps.setDouble(4, s.getDonGia());
            ps.setInt   (5, s.getTonKho());
            ps.setInt   (6, s.getMaSach());

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // ── Mapper dùng chung ───────────────────────────────────────────────────
    private Sach mapRow(ResultSet rs) throws Exception {
        return new Sach(
                rs.getInt   ("MaSach"),
                rs.getString("TenSach"),
                rs.getString("TacGia"),
                rs.getString("TheLoai"),
                rs.getDouble("DonGia"),
                rs.getInt   ("TonKho")
        );
    }
}
