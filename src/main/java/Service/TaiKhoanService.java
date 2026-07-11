package Service;

import Models.TaiKhoan;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class TaiKhoanService {

    private connectService connect = new connectService();

    public boolean loginCheck(String username, String password) {
        try (Connection con = connect.myConnection();
             PreparedStatement ps = con.prepareStatement(
                     "SELECT 1 FROM TaiKhoan tk JOIN NhanVien nv ON tk.MaNV = nv.MaNV " +
                     "WHERE tk.Username=? AND tk.PASS=? AND (nv.MaTrangThai IN (1, 2) OR nv.MaTrangThai IS NULL)")) {
            ps.setString(1, username);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public int loginStatus(String username, String password) {
        try (Connection con = connect.myConnection();
             PreparedStatement ps = con.prepareStatement(
                     "SELECT nv.MaTrangThai FROM TaiKhoan tk LEFT JOIN NhanVien nv ON tk.MaNV = nv.MaNV " +
                     "WHERE tk.Username=? AND tk.PASS=?")) {
            ps.setString(1, username);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                int maTrangThai = rs.getInt("MaTrangThai");
                if (rs.wasNull() || maTrangThai == 1 || maTrangThai == 2) {
                    return 1;
                } else {
                    return -1;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public TaiKhoan getUser(String username) {
        TaiKhoan tk = null;
        try (Connection con = connect.myConnection();
             PreparedStatement ps = con.prepareStatement(
                     "SELECT tk.Username, tk.PASS, tk.MaNV, tk.MaPhanQuyen, nv.HoTen, pq.TenQuyen " +
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
                tk.setPass(rs.getString("PASS"));
                tk.setMaNV(rs.getInt("MaNV"));
                tk.setMaQuyen(rs.getInt("MaPhanQuyen"));
                tk.setHoTen(rs.getString("HoTen"));
                tk.setTenQuyen(rs.getString("TenQuyen"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return tk;
    }

    public List<TaiKhoan> getAllTaiKhoan(int page, int pageSize, String search) {
        List<TaiKhoan> list = new ArrayList<>();
        int offset = (page - 1) * pageSize;
        if (search == null) search = "";
        try (Connection con = connect.myConnection();
             PreparedStatement ps = con.prepareStatement(
                     "SELECT tk.Username, tk.PASS, tk.MaNV, tk.MaPhanQuyen, nv.HoTen, pq.TenQuyen, nv.MaTrangThai " +
                     "FROM TaiKhoan tk " +
                     "JOIN NhanVien nv ON tk.MaNV = nv.MaNV " +
                     "JOIN PhanQuyen pq ON tk.MaPhanQuyen = pq.MaPhanQuyen " +
                     "WHERE tk.Username LIKE ? OR nv.HoTen LIKE ? " +
                     "ORDER BY tk.Username " +
                     "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY")) {
            
            ps.setString(1, "%" + search + "%");
            ps.setString(2, "%" + search + "%");
            ps.setInt(3, offset);
            ps.setInt(4, pageSize);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                TaiKhoan tk = new TaiKhoan();
                tk.setUsername(rs.getString("Username"));
                tk.setPass(rs.getString("PASS"));
                tk.setMaNV(rs.getInt("MaNV"));
                tk.setMaQuyen(rs.getInt("MaPhanQuyen"));
                tk.setHoTen(rs.getString("HoTen"));
                tk.setTenQuyen(rs.getString("TenQuyen"));
                tk.setTrangThai(rs.getInt("MaTrangThai"));
                list.add(tk);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countTaiKhoan(String search) {
        if (search == null) search = "";
        try (Connection con = connect.myConnection();
             PreparedStatement ps = con.prepareStatement(
                     "SELECT COUNT(*) FROM TaiKhoan tk " +
                     "JOIN NhanVien nv ON tk.MaNV = nv.MaNV " +
                     "WHERE tk.Username LIKE ? OR nv.HoTen LIKE ?")) {
            ps.setString(1, "%" + search + "%");
            ps.setString(2, "%" + search + "%");
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public boolean addTaiKhoan(String username, String password, int maNV, int maPhanQuyen) {
        try (Connection con = connect.myConnection();
             PreparedStatement ps = con.prepareStatement(
                     "INSERT INTO TaiKhoan (MaTK, Username, PASS, MaNV, MaPhanQuyen) " +
                     "SELECT (SELECT ISNULL(MAX(MaTK),0)+1 FROM TaiKhoan), ?, ?, ?, ?")) {
            ps.setString(1, username);
            ps.setString(2, password);
            ps.setInt(3, maNV);
            ps.setInt(4, maPhanQuyen);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException(e.getMessage());
        }
    }

    public boolean updateTaiKhoanFull(String oldUsername, String newUsername, String password, int maPhanQuyen) {
        String sql = "UPDATE TaiKhoan SET Username = ?, MaPhanQuyen = ?";
        if (password != null && !password.isEmpty()) {
            sql += ", PASS = ?";
        }
        sql += " WHERE Username = ?";
        try (Connection con = connect.myConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, newUsername);
            ps.setInt(2, maPhanQuyen);
            if (password != null && !password.isEmpty()) {
                ps.setString(3, password);
                ps.setString(4, oldUsername);
            } else {
                ps.setString(3, oldUsername);
            }
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteTaiKhoan(String username) {
        try (Connection con = connect.myConnection();
             PreparedStatement ps = con.prepareStatement("DELETE FROM TaiKhoan WHERE Username = ?")) {
            ps.setString(1, username);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean changeStatus(int maNV, int status) {
        try (Connection con = connect.myConnection();
             PreparedStatement ps = con.prepareStatement("UPDATE NhanVien SET MaTrangThai = ? WHERE MaNV = ?")) {
            ps.setInt(1, status);
            ps.setInt(2, maNV);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean changePassword(String username, String newPassword) {
        try (Connection con = connect.myConnection();
             PreparedStatement ps = con.prepareStatement("UPDATE TaiKhoan SET PASS = ? WHERE Username = ?")) {
            ps.setString(1, newPassword);
            ps.setString(2, username);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
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