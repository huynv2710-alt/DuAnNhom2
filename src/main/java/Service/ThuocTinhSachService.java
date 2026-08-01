package Service;

import Models.NhaXuatBan;
import Models.TheLoai;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ThuocTinhSachService {

    // ==== THE LOAI ====
    public List<TheLoai> getAllTheLoai() {
        List<TheLoai> list = new ArrayList<>();
        String sql = "SELECT t.*, (SELECT COUNT(*) FROM Sach s WHERE s.MaTheLoai = t.MaTheLoai) AS SoLuongSach FROM TheLoai t";
        try (Connection con = new connectService().myConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Integer maTheLoaiCha = rs.getObject("MaTheLoaiCha") != null ? rs.getInt("MaTheLoaiCha") : null;
                TheLoai tl = new TheLoai(rs.getInt("MaTheLoai"), rs.getString("TenTheLoai"), rs.getString("MoTa"), maTheLoaiCha);
                tl.setSoLuongSach(rs.getInt("SoLuongSach"));
                list.add(tl);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public boolean addTheLoai(String ten, String moTa, Integer maTheLoaiCha) {
        try (Connection con = new connectService().myConnection()) {
            // Check unique within the same parent
            PreparedStatement checkPs;
            if (maTheLoaiCha != null) {
                checkPs = con.prepareStatement("SELECT COUNT(*) FROM TheLoai WHERE TenTheLoai = ? AND MaTheLoaiCha = ?");
                checkPs.setString(1, ten);
                checkPs.setInt(2, maTheLoaiCha);
            } else {
                checkPs = con.prepareStatement("SELECT COUNT(*) FROM TheLoai WHERE TenTheLoai = ? AND MaTheLoaiCha IS NULL");
                checkPs.setString(1, ten);
            }
            ResultSet rs = checkPs.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                throw new RuntimeException("Tên thể loại đã tồn tại!");
            }
            
            String sql = "INSERT INTO TheLoai (TenTheLoai, MoTa, MaTheLoaiCha) VALUES (?, ?, ?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, ten);
            ps.setString(2, moTa);
            if (maTheLoaiCha != null) ps.setInt(3, maTheLoaiCha);
            else ps.setNull(3, java.sql.Types.INTEGER);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException(e.getMessage());
        }
    }

    public boolean updateTheLoai(int id, String ten, String moTa, Integer maTheLoaiCha) {
        try (Connection con = new connectService().myConnection()) {
            // Check unique within the same parent
            PreparedStatement checkPs;
            if (maTheLoaiCha != null) {
                checkPs = con.prepareStatement("SELECT COUNT(*) FROM TheLoai WHERE TenTheLoai = ? AND MaTheLoai != ? AND MaTheLoaiCha = ?");
                checkPs.setString(1, ten);
                checkPs.setInt(2, id);
                checkPs.setInt(3, maTheLoaiCha);
            } else {
                checkPs = con.prepareStatement("SELECT COUNT(*) FROM TheLoai WHERE TenTheLoai = ? AND MaTheLoai != ? AND MaTheLoaiCha IS NULL");
                checkPs.setString(1, ten);
                checkPs.setInt(2, id);
            }
            ResultSet rs = checkPs.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                throw new RuntimeException("Tên thể loại đã tồn tại!");
            }
            
            String sql = "UPDATE TheLoai SET TenTheLoai=?, MoTa=?, MaTheLoaiCha=? WHERE MaTheLoai=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, ten);
            ps.setString(2, moTa);
            if (maTheLoaiCha != null) ps.setInt(3, maTheLoaiCha);
            else ps.setNull(3, java.sql.Types.INTEGER);
            ps.setInt(4, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException(e.getMessage());
        }
    }

    public boolean deleteTheLoai(int id) {
        try (Connection con = new connectService().myConnection()) {
            // Check constraints
            PreparedStatement checkPs = con.prepareStatement("SELECT COUNT(*) FROM Sach WHERE MaTheLoai = ?");
            checkPs.setInt(1, id);
            ResultSet rs = checkPs.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                throw new RuntimeException("Thể loại này đang chứa sách, không thể xóa!");
            }
            
            String sql = "DELETE FROM TheLoai WHERE MaTheLoai=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException(e.getMessage());
        }
    }

    // ==== NHA XUAT BAN ====
    public List<NhaXuatBan> getAllNXB() {
        List<NhaXuatBan> list = new ArrayList<>();
        String sql = "SELECT * FROM NhaXuatBan";
        try (Connection con = new connectService().myConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new NhaXuatBan(rs.getInt("MaNXB"), rs.getString("TenNXB"), rs.getString("DiaChi"), rs.getString("SDT")));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public boolean addNXB(NhaXuatBan n) {
        String sql = "INSERT INTO NhaXuatBan (TenNXB, DiaChi, SDT) VALUES (?, ?, ?)";
        try (Connection con = new connectService().myConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, n.getTenNXB());
            ps.setString(2, n.getDiaChi());
            ps.setString(3, n.getSdt());
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    public boolean updateNXB(NhaXuatBan n) {
        String sql = "UPDATE NhaXuatBan SET TenNXB=?, DiaChi=?, SDT=? WHERE MaNXB=?";
        try (Connection con = new connectService().myConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, n.getTenNXB());
            ps.setString(2, n.getDiaChi());
            ps.setString(3, n.getSdt());
            ps.setInt(4, n.getMaNXB());
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    public boolean deleteNXB(int id) {
        String sql = "DELETE FROM NhaXuatBan WHERE MaNXB=?";
        try (Connection con = new connectService().myConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }
}
