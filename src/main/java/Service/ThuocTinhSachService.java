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
        String sql = "SELECT * FROM TheLoai";
        try (Connection con = new connectService().myConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new TheLoai(rs.getInt("MaTheLoai"), rs.getString("TenTheLoai"), rs.getString("MoTa")));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public boolean addTheLoai(String ten, String moTa) {
        String sql = "INSERT INTO TheLoai (TenTheLoai, MoTa) VALUES (?, ?)";
        try (Connection con = new connectService().myConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, ten);
            ps.setString(2, moTa);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    public boolean updateTheLoai(int id, String ten, String moTa) {
        String sql = "UPDATE TheLoai SET TenTheLoai=?, MoTa=? WHERE MaTheLoai=?";
        try (Connection con = new connectService().myConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, ten);
            ps.setString(2, moTa);
            ps.setInt(3, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    public boolean deleteTheLoai(int id) {
        String sql = "DELETE FROM TheLoai WHERE MaTheLoai=?";
        try (Connection con = new connectService().myConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
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
