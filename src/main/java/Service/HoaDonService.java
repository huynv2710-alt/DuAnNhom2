package Service;

import Models.HoaDon;
import Models.HoaDonChiTiet;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class HoaDonService {

    // Tạo hóa đơn mới và trả về MaHD vừa tạo
    public int createHoaDon(HoaDon hd) {
        int validMaNV = hd.getMaNV();
        try (Connection con = new connectService().myConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery("SELECT TOP 1 MaNV FROM NhanVien WHERE MaNV = " + validMaNV)) {
            if (!rs.next()) {
                ResultSet rs2 = st.executeQuery("SELECT TOP 1 MaNV FROM NhanVien");
                if (rs2.next()) validMaNV = rs2.getInt(1);
            }
        } catch(Exception e){}

        String sql = "INSERT INTO HoaDon (MaNV, MaKH, NgayTao, TongTien, TrangThai) VALUES (?, ?, GETDATE(), ?, 1)";
        try (Connection con = new connectService().myConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, validMaNV);
            ps.setInt(2, hd.getMaKH());
            ps.setDouble(3, hd.getTongTien());
            ps.executeUpdate();
            
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    public boolean addHoaDonChiTiet(HoaDonChiTiet ct) {
        String sql = "INSERT INTO HoaDonChiTiet (MaHD, MaSach, SoLuong, DonGia) VALUES (?, ?, ?, ?)";
        try (Connection con = new connectService().myConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, ct.getMaHD());
            ps.setInt(2, ct.getMaSach());
            ps.setInt(3, ct.getSoLuong());
            ps.setDouble(4, ct.getDonGia());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Cập nhật số lượng sách sau khi bán
    public void reduceSachQuantity(int maSach, int soLuongBan) {
        String sql = "UPDATE Sach SET SoLuongTon = SoLuongTon - ? WHERE MaSach = ?";
        try (Connection con = new connectService().myConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, soLuongBan);
            ps.setInt(2, maSach);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<HoaDon> getAllHoaDon() {
        List<HoaDon> list = new ArrayList<>();
        String sql = "SELECT h.*, n.HoTen AS TenNV, k.HoTen AS TenKH " +
                     "FROM HoaDon h " +
                     "LEFT JOIN NhanVien n ON h.MaNV = n.MaNV " +
                     "LEFT JOIN KhachHang k ON h.MaKH = k.MaKH " +
                     "ORDER BY h.NgayTao DESC";
        try (Connection con = new connectService().myConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                HoaDon hd = new HoaDon(
                        rs.getInt("MaHD"),
                        rs.getInt("MaNV"),
                        rs.getInt("MaKH"),
                        rs.getTimestamp("NgayTao"),
                        rs.getDouble("TongTien"),
                        rs.getInt("TrangThai")
                );
                hd.setTenNV(rs.getString("TenNV"));
                hd.setTenKH(rs.getString("TenKH"));
                list.add(hd);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public HoaDon getHoaDonById(int maHD) {
        String sql = "SELECT h.*, n.HoTen AS TenNV, k.HoTen AS TenKH, k.SDT AS SDTKH " +
                     "FROM HoaDon h " +
                     "LEFT JOIN NhanVien n ON h.MaNV = n.MaNV " +
                     "LEFT JOIN KhachHang k ON h.MaKH = k.MaKH " +
                     "WHERE h.MaHD = ?";
        try (Connection con = new connectService().myConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, maHD);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                HoaDon hd = new HoaDon(
                        rs.getInt("MaHD"),
                        rs.getInt("MaNV"),
                        rs.getInt("MaKH"),
                        rs.getTimestamp("NgayTao"),
                        rs.getDouble("TongTien"),
                        rs.getInt("TrangThai")
                );
                hd.setTenNV(rs.getString("TenNV"));
                hd.setTenKH(rs.getString("TenKH"));
                hd.setSdtKH(rs.getString("SDTKH"));
                return hd;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<HoaDonChiTiet> getChiTietByHoaDonId(int maHD) {
        List<HoaDonChiTiet> list = new ArrayList<>();
        String sql = "SELECT c.*, s.TenSach " +
                     "FROM HoaDonChiTiet c " +
                     "JOIN Sach s ON c.MaSach = s.MaSach " +
                     "WHERE c.MaHD = ?";
        try (Connection con = new connectService().myConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, maHD);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                HoaDonChiTiet ct = new HoaDonChiTiet(
                        rs.getInt("MaHD"),
                        rs.getInt("MaSach"),
                        rs.getInt("SoLuong"),
                        rs.getDouble("DonGia")
                );
                ct.setTenSach(rs.getString("TenSach"));
                list.add(ct);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
