package Service;

import Models.Sach;
import Models.TacGia;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class SachService {

    public List<Sach> getAllSach(String search) {
        return getAllSach(search, 0);
    }

    public List<Sach> getAllSach(String search, int maTheLoai) {
        List<Sach> list = new ArrayList<>();
        // Removed s.TacGia LIKE ? since TacGia is in another table, we'll simplify search for now
        String sql = "SELECT s.*, c.SoTrang, c.KichThuoc, c.TrongLuong, c.NgonNgu, c.MoTa, t.TenTheLoai, n.TenNXB " +
                     "FROM Sach s " +
                     "LEFT JOIN SachChiTiet c ON s.MaSach = c.MaSach " +
                     "LEFT JOIN TheLoai t ON s.MaTheLoai = t.MaTheLoai " +
                     "LEFT JOIN NhaXuatBan n ON s.MaNXB = n.MaNXB " +
                     "WHERE s.TenSach LIKE ? ";
        if (maTheLoai > 0) sql += " AND s.MaTheLoai = ?";
        
        try (Connection con = new connectService().myConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            String query = "%" + (search != null ? search : "") + "%";
            ps.setString(1, query);
            if (maTheLoai > 0) ps.setInt(2, maTheLoai);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Sach s = new Sach();
                s.setMaSach(rs.getInt("MaSach"));
                s.setTenSach(rs.getString("TenSach"));
                s.setIsbn(rs.getString("MaISBN"));
                s.setMaTheLoai(rs.getInt("MaTheLoai"));
                s.setMaNXB(rs.getInt("MaNXB"));
                s.setGiaNhap(rs.getDouble("GiaNhap"));
                s.setGiaBan(rs.getDouble("GiaBan"));
                s.setSoLuongTon(rs.getInt("SoLuongTon"));
                s.setHinhAnh(rs.getString("HinhAnh"));
                s.setTrangThai(rs.getInt("TrangThai"));
                
                s.setSoTrang(rs.getInt("SoTrang"));
                s.setKichThuoc(rs.getString("KichThuoc"));
                s.setTrongLuong(rs.getInt("TrongLuong"));
                s.setNgonNgu(rs.getString("NgonNgu"));
                s.setMoTa(rs.getString("MoTa"));
                
                s.setTenTheLoai(rs.getString("TenTheLoai"));
                s.setTenNXB(rs.getString("TenNXB"));
                
                s.setTacGias(getTacGiasOfSach(s.getMaSach(), con));
                
                list.add(s);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Sach getSachById(int id) {
        String sql = "SELECT s.*, c.SoTrang, c.KichThuoc, c.TrongLuong, c.NgonNgu, c.MoTa, t.TenTheLoai, n.TenNXB " +
                     "FROM Sach s " +
                     "LEFT JOIN SachChiTiet c ON s.MaSach = c.MaSach " +
                     "LEFT JOIN TheLoai t ON s.MaTheLoai = t.MaTheLoai " +
                     "LEFT JOIN NhaXuatBan n ON s.MaNXB = n.MaNXB " +
                     "WHERE s.MaSach = ?";
        try (Connection con = new connectService().myConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Sach s = new Sach();
                s.setMaSach(rs.getInt("MaSach"));
                s.setTenSach(rs.getString("TenSach"));
                s.setIsbn(rs.getString("MaISBN"));
                s.setMaTheLoai(rs.getInt("MaTheLoai"));
                s.setMaNXB(rs.getInt("MaNXB"));
                s.setGiaNhap(rs.getDouble("GiaNhap"));
                s.setGiaBan(rs.getDouble("GiaBan"));
                s.setSoLuongTon(rs.getInt("SoLuongTon"));
                s.setHinhAnh(rs.getString("HinhAnh"));
                s.setTrangThai(rs.getInt("TrangThai"));
                
                s.setSoTrang(rs.getInt("SoTrang"));
                s.setKichThuoc(rs.getString("KichThuoc"));
                s.setTrongLuong(rs.getInt("TrongLuong"));
                s.setNgonNgu(rs.getString("NgonNgu"));
                s.setMoTa(rs.getString("MoTa"));
                
                s.setTenTheLoai(rs.getString("TenTheLoai"));
                s.setTenNXB(rs.getString("TenNXB"));
                
                s.setTacGias(getTacGiasOfSach(s.getMaSach(), con));
                return s;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    private List<TacGia> getTacGiasOfSach(int maSach, Connection con) {
        List<TacGia> tgList = new ArrayList<>();
        String sql = "SELECT t.* FROM TacGia t JOIN Sach_TacGia st ON t.MaTacGia = st.MaTacGia WHERE st.MaSach = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, maSach);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                tgList.add(new TacGia(rs.getInt("MaTacGia"), rs.getString("TenTacGia")));
            }
        } catch (Exception e) {}
        return tgList;
    }

    private List<Integer> resolveTacGias(String tacGiasStr, Connection con) throws Exception {
        List<Integer> maTacGias = new ArrayList<>();
        if (tacGiasStr == null || tacGiasStr.trim().isEmpty()) return maTacGias;
        
        String[] names = tacGiasStr.split(",");
        for (String name : names) {
            name = name.trim();
            if (name.isEmpty()) continue;
            
            try (PreparedStatement ps = con.prepareStatement("SELECT MaTacGia FROM TacGia WHERE TenTacGia = ?")) {
                ps.setString(1, name);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    maTacGias.add(rs.getInt(1));
                } else {
                    try (PreparedStatement psInsert = con.prepareStatement("INSERT INTO TacGia (TenTacGia) VALUES (?)", Statement.RETURN_GENERATED_KEYS)) {
                        psInsert.setString(1, name);
                        psInsert.executeUpdate();
                        ResultSet rsKeys = psInsert.getGeneratedKeys();
                        if (rsKeys.next()) {
                            maTacGias.add(rsKeys.getInt(1));
                        }
                    }
                }
            }
        }
        return maTacGias;
    }

    public boolean addSach(Sach s, String tacGiasStr) {
        String sqlSach = "INSERT INTO Sach (TenSach, MaISBN, MaTheLoai, MaNXB, GiaNhap, GiaBan, SoLuongTon, HinhAnh, TrangThai) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection con = new connectService().myConnection()) {
            con.setAutoCommit(false);
            int newMaSach = -1;
            
            try (PreparedStatement ps = con.prepareStatement(sqlSach, Statement.RETURN_GENERATED_KEYS)) {
                ps.setString(1, s.getTenSach());
                ps.setString(2, s.getIsbn());
                ps.setInt(3, s.getMaTheLoai());
                ps.setInt(4, s.getMaNXB());
                ps.setDouble(5, s.getGiaNhap());
                ps.setDouble(6, s.getGiaBan());
                ps.setInt(7, s.getSoLuongTon());
                ps.setString(8, s.getHinhAnh());
                ps.setInt(9, s.getTrangThai());
                ps.executeUpdate();
                
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    newMaSach = rs.getInt(1);
                }
            }

            if (newMaSach > 0) {
                // Insert SachChiTiet
                String sqlCT = "INSERT INTO SachChiTiet (MaSach, SoTrang, KichThuoc, TrongLuong, NgonNgu, MoTa) VALUES (?, ?, ?, ?, ?, ?)";
                try (PreparedStatement ps = con.prepareStatement(sqlCT)) {
                    ps.setInt(1, newMaSach);
                    ps.setInt(2, s.getSoTrang());
                    ps.setString(3, s.getKichThuoc());
                    ps.setInt(4, s.getTrongLuong());
                    ps.setString(5, s.getNgonNgu());
                    ps.setString(6, s.getMoTa());
                    ps.executeUpdate();
                }

                // Insert Sach_TacGia
                List<Integer> listMaTG = resolveTacGias(tacGiasStr, con);
                if (!listMaTG.isEmpty()) {
                    String sqlTG = "INSERT INTO Sach_TacGia (MaSach, MaTacGia) VALUES (?, ?)";
                    try (PreparedStatement ps = con.prepareStatement(sqlTG)) {
                        for (int maTG : listMaTG) {
                            ps.setInt(1, newMaSach);
                            ps.setInt(2, maTG);
                            ps.addBatch();
                        }
                        ps.executeBatch();
                    }
                }
                
                con.commit();
                return true;
            }
            con.rollback();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateSach(Sach s, String tacGiasStr) {
        String sqlSach = "UPDATE Sach SET TenSach=?, MaISBN=?, MaTheLoai=?, MaNXB=?, GiaNhap=?, GiaBan=?, SoLuongTon=?, HinhAnh=?, TrangThai=? WHERE MaSach=?";
        try (Connection con = new connectService().myConnection()) {
            con.setAutoCommit(false);
            
            try (PreparedStatement ps = con.prepareStatement(sqlSach)) {
                ps.setString(1, s.getTenSach());
                ps.setString(2, s.getIsbn());
                ps.setInt(3, s.getMaTheLoai());
                ps.setInt(4, s.getMaNXB());
                ps.setDouble(5, s.getGiaNhap());
                ps.setDouble(6, s.getGiaBan());
                ps.setInt(7, s.getSoLuongTon());
                ps.setString(8, s.getHinhAnh());
                ps.setInt(9, s.getTrangThai());
                ps.setInt(10, s.getMaSach());
                ps.executeUpdate();
            }

            // Upsert SachChiTiet
            String sqlCT = "UPDATE SachChiTiet SET SoTrang=?, KichThuoc=?, TrongLuong=?, NgonNgu=?, MoTa=? WHERE MaSach=?";
            try (PreparedStatement ps = con.prepareStatement(sqlCT)) {
                ps.setInt(1, s.getSoTrang());
                ps.setString(2, s.getKichThuoc());
                ps.setInt(3, s.getTrongLuong());
                ps.setString(4, s.getNgonNgu());
                ps.setString(5, s.getMoTa());
                ps.setInt(6, s.getMaSach());
                int rows = ps.executeUpdate();
                if (rows == 0) {
                    // if it didn't exist, insert
                    String sqlInsCT = "INSERT INTO SachChiTiet (MaSach, SoTrang, KichThuoc, TrongLuong, NgonNgu, MoTa) VALUES (?, ?, ?, ?, ?, ?)";
                    try (PreparedStatement ps2 = con.prepareStatement(sqlInsCT)) {
                        ps2.setInt(1, s.getMaSach());
                        ps2.setInt(2, s.getSoTrang());
                        ps2.setString(3, s.getKichThuoc());
                        ps2.setInt(4, s.getTrongLuong());
                        ps2.setString(5, s.getNgonNgu());
                        ps2.setString(6, s.getMoTa());
                        ps2.executeUpdate();
                    }
                }
            }

            // Update Sach_TacGia
            try (PreparedStatement psDel = con.prepareStatement("DELETE FROM Sach_TacGia WHERE MaSach=?")) {
                psDel.setInt(1, s.getMaSach());
                psDel.executeUpdate();
            }
            List<Integer> listMaTG = resolveTacGias(tacGiasStr, con);
            if (!listMaTG.isEmpty()) {
                String sqlTG = "INSERT INTO Sach_TacGia (MaSach, MaTacGia) VALUES (?, ?)";
                try (PreparedStatement ps = con.prepareStatement(sqlTG)) {
                    for (int maTG : listMaTG) {
                        ps.setInt(1, s.getMaSach());
                        ps.setInt(2, maTG);
                        ps.addBatch();
                    }
                    ps.executeBatch();
                }
            }
            
            con.commit();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteSach(int id) {
        // DELETE CASCADE will handle SachChiTiet and Sach_TacGia automatically based on our foreign keys
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
