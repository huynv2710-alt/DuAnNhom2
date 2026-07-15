package Service;

import Models.Sach;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class SachService {

    public List<Sach> getAllSach(String search) {
        List<Sach> list = new ArrayList<>();
        String sql = "SELECT s.*, t.TenTheLoai, n.TenNXB FROM Sach s " +
                     "LEFT JOIN TheLoai t ON s.MaTheLoai = t.MaTheLoai " +
                     "LEFT JOIN NhaXuatBan n ON s.MaNXB = n.MaNXB " +
                     "WHERE s.TenSach LIKE ? OR s.TacGia LIKE ?";
        try (Connection con = new connectService().myConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            String query = "%" + (search != null ? search : "") + "%";
            ps.setString(1, query);
            ps.setString(2, query);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Sach s = new Sach(
                        rs.getInt("MaSach"),
                        rs.getString("TenSach"),
                        rs.getString("TacGia"),
                        rs.getString("MaISBN"),
                        rs.getInt("MaTheLoai"),
                        rs.getInt("MaNXB"),
                        rs.getDouble("GiaNhap"),
                        rs.getDouble("GiaBan"),
                        rs.getInt("SoLuongTon"),
                        rs.getString("HinhAnh"),
                        rs.getInt("TrangThai"),
                        rs.getInt("SoTrang"),
                        rs.getString("KichThuoc"),
                        rs.getInt("TrongLuong"),
                        rs.getString("NgonNgu")
                );
                s.setTenTheLoai(rs.getString("TenTheLoai"));
                s.setTenNXB(rs.getString("TenNXB"));
                list.add(s);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Sach getSachById(int id) {
        String sql = "SELECT s.*, t.TenTheLoai, n.TenNXB FROM Sach s " +
                     "LEFT JOIN TheLoai t ON s.MaTheLoai = t.MaTheLoai " +
                     "LEFT JOIN NhaXuatBan n ON s.MaNXB = n.MaNXB " +
                     "WHERE s.MaSach = ?";
        try (Connection con = new connectService().myConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Sach s = new Sach(
                        rs.getInt("MaSach"),
                        rs.getString("TenSach"),
                        rs.getString("TacGia"),
                        rs.getString("MaISBN"),
                        rs.getInt("MaTheLoai"),
                        rs.getInt("MaNXB"),
                        rs.getDouble("GiaNhap"),
                        rs.getDouble("GiaBan"),
                        rs.getInt("SoLuongTon"),
                        rs.getString("HinhAnh"),
                        rs.getInt("TrangThai"),
                        rs.getInt("SoTrang"),
                        rs.getString("KichThuoc"),
                        rs.getInt("TrongLuong"),
                        rs.getString("NgonNgu")
                );
                s.setTenTheLoai(rs.getString("TenTheLoai"));
                s.setTenNXB(rs.getString("TenNXB"));
                return s;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean addSach(Sach s) {
        String sql = "INSERT INTO Sach (TenSach, TacGia, MaISBN, MaTheLoai, MaNXB, GiaNhap, GiaBan, SoLuongTon, HinhAnh, TrangThai, SoTrang, KichThuoc, TrongLuong, NgonNgu) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection con = new connectService().myConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, s.getTenSach());
            ps.setString(2, s.getTacGia());
            ps.setString(3, s.getIsbn());
            ps.setInt(4, s.getMaTheLoai());
            ps.setInt(5, s.getMaNXB());
            ps.setDouble(6, s.getGiaNhap());
            ps.setDouble(7, s.getGiaBan());
            ps.setInt(8, s.getSoLuongTon());
            ps.setString(9, s.getHinhAnh());
            ps.setInt(10, s.getTrangThai());
            ps.setInt(11, s.getSoTrang());
            ps.setString(12, s.getKichThuoc());
            ps.setInt(13, s.getTrongLuong());
            ps.setString(14, s.getNgonNgu());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateSach(Sach s) {
        String sql = "UPDATE Sach SET TenSach=?, TacGia=?, MaISBN=?, MaTheLoai=?, MaNXB=?, GiaNhap=?, GiaBan=?, SoLuongTon=?, HinhAnh=?, TrangThai=?, SoTrang=?, KichThuoc=?, TrongLuong=?, NgonNgu=? WHERE MaSach=?";
        try (Connection con = new connectService().myConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, s.getTenSach());
            ps.setString(2, s.getTacGia());
            ps.setString(3, s.getIsbn());
            ps.setInt(4, s.getMaTheLoai());
            ps.setInt(5, s.getMaNXB());
            ps.setDouble(6, s.getGiaNhap());
            ps.setDouble(7, s.getGiaBan());
            ps.setInt(8, s.getSoLuongTon());
            ps.setString(9, s.getHinhAnh());
            ps.setInt(10, s.getTrangThai());
            ps.setInt(11, s.getSoTrang());
            ps.setString(12, s.getKichThuoc());
            ps.setInt(13, s.getTrongLuong());
            ps.setString(14, s.getNgonNgu());
            ps.setInt(15, s.getMaSach());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteSach(int id) {
        String sql = "DELETE FROM Sach WHERE MaSach=?";
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
