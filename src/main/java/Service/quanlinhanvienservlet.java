package Service;

import Models.NhanVien;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class quanlinhanvienservlet {

    public ArrayList<NhanVien> getAllNhanVien() {

        connectService service = new connectService();
        ArrayList<NhanVien> list = new ArrayList<>();

        String sql =
                "SELECT nv.MaNV, nv.HoTen, nv.NgaySinh, nv.GioiTinh, " +
                        "nv.SDT, nv.Email, nv.DiaChi, nv.MaTrangThai, " +
                        "nv.CCCD, nv.NgayCapCCCD, nv.DacDiemNhanDang, " +
                        "tt.TenTrangThai " +
                        "FROM NhanVien nv " +
                        "INNER JOIN TrangThaiNhanVien tt " +
                        "ON nv.MaTrangThai = tt.MaTrangThai";

        try (Connection conn = service.myConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                NhanVien nv = new NhanVien(
                        rs.getInt("MaNV"),
                        rs.getString("HoTen"),
                        rs.getDate("NgaySinh"),
                        rs.getString("GioiTinh"),
                        rs.getString("SDT"),
                        rs.getString("Email"),
                        rs.getString("DiaChi"),
                        rs.getInt("MaTrangThai"),
                        rs.getString("TenTrangThai"),
                        rs.getString("CCCD"),
                        rs.getDate("NgayCapCCCD"),
                        rs.getString("DacDiemNhanDang")
                );

                list.add(nv);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public ArrayList<NhanVien> searchNhanVien(String keyword) {
        connectService service = new connectService();
        ArrayList<NhanVien> list = new ArrayList<>();

        String sql =
                "SELECT nv.MaNV, nv.HoTen, nv.NgaySinh, nv.GioiTinh, " +
                        "nv.SDT, nv.Email, nv.DiaChi, nv.MaTrangThai, " +
                        "nv.CCCD, nv.NgayCapCCCD, nv.DacDiemNhanDang, " +
                        "tt.TenTrangThai " +
                        "FROM NhanVien nv " +
                        "INNER JOIN TrangThaiNhanVien tt " +
                        "ON nv.MaTrangThai = tt.MaTrangThai " +
                        "WHERE nv.HoTen LIKE ? OR nv.SDT LIKE ? OR nv.Email LIKE ? OR CAST(nv.MaNV AS VARCHAR) LIKE ?";

        try (Connection conn = service.myConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            String kw = "%" + keyword + "%";
            ps.setString(1, kw);
            ps.setString(2, kw);
            ps.setString(3, kw);
            ps.setString(4, kw);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                NhanVien nv = new NhanVien(
                        rs.getInt("MaNV"),
                        rs.getString("HoTen"),
                        rs.getDate("NgaySinh"),
                        rs.getString("GioiTinh"),
                        rs.getString("SDT"),
                        rs.getString("Email"),
                        rs.getString("DiaChi"),
                        rs.getInt("MaTrangThai"),
                        rs.getString("TenTrangThai"),
                        rs.getString("CCCD"),
                        rs.getDate("NgayCapCCCD"),
                        rs.getString("DacDiemNhanDang")
                );
                list.add(nv);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public boolean addNhanVien(NhanVien nv) {

        connectService service = new connectService();

        String sql = "INSERT INTO NhanVien "
                + "(MaNV, HoTen, NgaySinh, GioiTinh, SDT, Email, DiaChi, "
                + "MaTrangThai, CCCD, NgayCapCCCD, DacDiemNhanDang) "
                + "VALUES (?,?,?,?,?,?,?,?,?,?,?)";

        try (Connection conn = service.myConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, nv.getMaNV());
            ps.setString(2, nv.getHoTen());
            ps.setDate(3, nv.getNgaySinh());
            ps.setString(4, nv.getGioiTinh());
            ps.setString(5, nv.getSdt());
            ps.setString(6, nv.getEmail());
            ps.setString(7, nv.getDiaChi());
            ps.setInt(8, nv.getMaTrangThai());
            ps.setString(9, nv.getCccd());
            ps.setDate(10, nv.getNgayCapCCCD());
            ps.setString(11, nv.getDacDiemNhanDang());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException(e.getMessage());
        }
    }
    public NhanVien getById(int maNV) {

        connectService service = new connectService();

        String sql =
                "SELECT nv.MaNV, nv.HoTen, nv.NgaySinh, nv.GioiTinh, " +
                        "nv.SDT, nv.Email, nv.DiaChi, nv.MaTrangThai, " +
                        "nv.CCCD, nv.NgayCapCCCD, nv.DacDiemNhanDang, " +
                        "tt.TenTrangThai " +
                        "FROM NhanVien nv " +
                        "INNER JOIN TrangThaiNhanVien tt " +
                        "ON nv.MaTrangThai = tt.MaTrangThai " +
                        "WHERE nv.MaNV = ?";

        try (Connection conn = service.myConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, maNV);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                return new NhanVien(
                        rs.getInt("MaNV"),
                        rs.getString("HoTen"),
                        rs.getDate("NgaySinh"),
                        rs.getString("GioiTinh"),
                        rs.getString("SDT"),
                        rs.getString("Email"),
                        rs.getString("DiaChi"),
                        rs.getInt("MaTrangThai"),
                        rs.getString("TenTrangThai"),
                        rs.getString("CCCD"),
                        rs.getDate("NgayCapCCCD"),
                        rs.getString("DacDiemNhanDang")
                );
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }
    public boolean update(NhanVien nv) {

        connectService service = new connectService();

        String sql = "UPDATE NhanVien SET "
                + "HoTen=?, "
                + "NgaySinh=?, "
                + "GioiTinh=?, "
                + "SDT=?, "
                + "Email=?, "
                + "DiaChi=?, "
                + "MaTrangThai=?, "
                + "CCCD=?, "
                + "NgayCapCCCD=?, "
                + "DacDiemNhanDang=? "
                + "WHERE MaNV=?";

        try (Connection conn = service.myConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, nv.getHoTen());
            ps.setDate(2, nv.getNgaySinh());
            ps.setString(3, nv.getGioiTinh());
            ps.setString(4, nv.getSdt());
            ps.setString(5, nv.getEmail());
            ps.setString(6, nv.getDiaChi());
            ps.setInt(7, nv.getMaTrangThai());
            ps.setString(8, nv.getCccd());
            ps.setDate(9, nv.getNgayCapCCCD());
            ps.setString(10, nv.getDacDiemNhanDang());
            ps.setInt(11, nv.getMaNV());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException(e.getMessage());
        }
    }

    }
