package Models;

import java.sql.Date;

public class NhanVien {

    private int maNV;
    private String hoTen;
    private Date ngaySinh;
    private String gioiTinh;
    private String sdt;
    private String email;
    private String diaChi;
    private int maTrangThai;
    private String tenTrangThai;
    private String cccd;
    private Date ngayCapCCCD;
    private String dacDiemNhanDang;
    private String noiCapCCCD;
    private Date ngayHetHanCCCD;

    public NhanVien() {
    }

    public NhanVien(int maNV, String hoTen, Date ngaySinh, String gioiTinh,
                    String sdt, String email, String diaChi,
                    int maTrangThai, String tenTrangThai,
                    String cccd, Date ngayCapCCCD, String dacDiemNhanDang) {

        this(maNV, hoTen, ngaySinh, gioiTinh, sdt, email, diaChi, maTrangThai, tenTrangThai, cccd, ngayCapCCCD, dacDiemNhanDang, null, null);
    }

    public NhanVien(int maNV, String hoTen, Date ngaySinh, String gioiTinh,
                    String sdt, String email, String diaChi,
                    int maTrangThai, String tenTrangThai,
                    String cccd, Date ngayCapCCCD, String dacDiemNhanDang,
                    String noiCapCCCD, Date ngayHetHanCCCD) {

        this.maNV = maNV;
        this.hoTen = hoTen;
        this.ngaySinh = ngaySinh;
        this.gioiTinh = gioiTinh;
        this.sdt = sdt;
        this.email = email;
        this.diaChi = diaChi;
        this.maTrangThai = maTrangThai;
        this.tenTrangThai = tenTrangThai;
        this.cccd = cccd;
        this.ngayCapCCCD = ngayCapCCCD;
        this.dacDiemNhanDang = dacDiemNhanDang;
        this.noiCapCCCD = noiCapCCCD;
        this.ngayHetHanCCCD = ngayHetHanCCCD;
    }

    // ==================== GETTER & SETTER ====================

    public int getMaNV() {
        return maNV;
    }

    public void setMaNV(int maNV) {
        this.maNV = maNV;
    }

    public String getHoTen() {
        return hoTen;
    }

    public void setHoTen(String hoTen) {
        this.hoTen = hoTen;
    }

    public Date getNgaySinh() {
        return ngaySinh;
    }

    public void setNgaySinh(Date ngaySinh) {
        this.ngaySinh = ngaySinh;
    }

    public String getGioiTinh() {
        return gioiTinh;
    }

    public void setGioiTinh(String gioiTinh) {
        this.gioiTinh = gioiTinh;
    }

    public String getSdt() {
        return sdt;
    }

    public void setSdt(String sdt) {
        this.sdt = sdt;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getDiaChi() {
        return diaChi;
    }

    public void setDiaChi(String diaChi) {
        this.diaChi = diaChi;
    }

    public int getMaTrangThai() {
        return maTrangThai;
    }

    public void setMaTrangThai(int maTrangThai) {
        this.maTrangThai = maTrangThai;
    }

    public String getTenTrangThai() {
        return tenTrangThai;
    }

    public void setTenTrangThai(String tenTrangThai) {
        this.tenTrangThai = tenTrangThai;
    }

    public String getCccd() {
        return cccd;
    }

    public void setCccd(String cccd) {
        this.cccd = cccd;
    }

    public Date getNgayCapCCCD() {
        return ngayCapCCCD;
    }

    public void setNgayCapCCCD(Date ngayCapCCCD) {
        this.ngayCapCCCD = ngayCapCCCD;
    }

    public String getDacDiemNhanDang() {
        return dacDiemNhanDang;
    }

    public void setDacDiemNhanDang(String dacDiemNhanDang) {
        this.dacDiemNhanDang = dacDiemNhanDang;
    }

    public String getNoiCapCCCD() {
        return noiCapCCCD;
    }

    public void setNoiCapCCCD(String noiCapCCCD) {
        this.noiCapCCCD = noiCapCCCD;
    }

    public Date getNgayHetHanCCCD() {
        return ngayHetHanCCCD;
    }

    public void setNgayHetHanCCCD(Date ngayHetHanCCCD) {
        this.ngayHetHanCCCD = ngayHetHanCCCD;
    }
}