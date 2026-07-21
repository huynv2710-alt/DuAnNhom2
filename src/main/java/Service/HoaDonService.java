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

        String sql = "INSERT INTO HoaDon (MaNV, MaKH, NgayTao, TongTien, TrangThai, GiamGia, PhuongThucTT, MaKM) VALUES (?, ?, GETDATE(), ?, ?, ?, ?, ?)";
        try (Connection con = new connectService().myConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, validMaNV);
            if (hd.getMaKH() > 0) {
                ps.setInt(2, hd.getMaKH());
            } else {
                ps.setNull(2, java.sql.Types.INTEGER);
            }
            ps.setDouble(3, hd.getTongTien());
            ps.setInt(4, hd.getTrangThai());
            ps.setDouble(5, hd.getGiamGia());
            ps.setString(6, hd.getPhuongThucTT());
            if (hd.getMaKM() != null && hd.getMaKM() > 0) {
                ps.setInt(7, hd.getMaKM());
            } else {
                ps.setNull(7, java.sql.Types.INTEGER);
            }
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

    // Cập nhật trạng thái hóa đơn (0: Chờ TT, 1: Đã TT, 2: Hủy)
    public boolean updateTrangThai(int maHD, int trangThai) {
        String sql = "UPDATE HoaDon SET TrangThai = ? WHERE MaHD = ?";
        try (Connection con = new connectService().myConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, trangThai);
            ps.setInt(2, maHD);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
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

    // Hoàn trả số lượng sách khi hủy hóa đơn
    public void increaseSachQuantity(int maSach, int soLuong) {
        String sql = "UPDATE Sach SET SoLuongTon = SoLuongTon + ? WHERE MaSach = ?";
        try (Connection con = new connectService().myConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, soLuong);
            ps.setInt(2, maSach);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<HoaDon> getAllHoaDon() {
        return getAllHoaDon(null, null, null);
    }

    public List<HoaDon> getAllHoaDon(String keyword, String fromDate, String toDate) {
        List<HoaDon> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT h.*, n.HoTen AS TenNV, k.HoTen AS TenKH " +
                     "FROM HoaDon h " +
                     "LEFT JOIN NhanVien n ON h.MaNV = n.MaNV " +
                     "LEFT JOIN KhachHang k ON h.MaKH = k.MaKH WHERE 1=1 ");
        
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (CAST(h.MaHD AS VARCHAR) LIKE ? OR n.HoTen LIKE ? OR k.HoTen LIKE ?) ");
        }
        if (fromDate != null && !fromDate.isEmpty()) {
            sql.append(" AND CAST(h.NgayTao AS DATE) >= CAST(? AS DATE) ");
        }
        if (toDate != null && !toDate.isEmpty()) {
            sql.append(" AND CAST(h.NgayTao AS DATE) <= CAST(? AS DATE) ");
        }
        sql.append(" ORDER BY h.NgayTao DESC");

        try (Connection con = new connectService().myConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {
            
            int paramIndex = 1;
            if (keyword != null && !keyword.trim().isEmpty()) {
                String k = "%" + keyword.trim() + "%";
                ps.setString(paramIndex++, k);
                ps.setString(paramIndex++, k);
                ps.setString(paramIndex++, k);
            }
            if (fromDate != null && !fromDate.isEmpty()) {
                ps.setString(paramIndex++, fromDate);
            }
            if (toDate != null && !toDate.isEmpty()) {
                ps.setString(paramIndex++, toDate);
            }

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
                hd.setGiamGia(rs.getDouble("GiamGia"));
                hd.setPhuongThucTT(rs.getString("PhuongThucTT"));
                hd.setTenNV(rs.getString("TenNV"));
                hd.setTenKH(rs.getString("TenKH"));
                
                int km = rs.getInt("MaKM");
                if (!rs.wasNull()) hd.setMaKM(km);
                
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
                hd.setGiamGia(rs.getDouble("GiamGia"));
                hd.setPhuongThucTT(rs.getString("PhuongThucTT"));
                hd.setTenNV(rs.getString("TenNV"));
                hd.setTenKH(rs.getString("TenKH"));
                hd.setSdtKH(rs.getString("SDTKH"));
                
                int km = rs.getInt("MaKM");
                if (!rs.wasNull()) hd.setMaKM(km);
                
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
