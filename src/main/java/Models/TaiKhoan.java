package Models;

public class TaiKhoan {
    private int maTK;
    private String username;
    private String pass;
    private int maNV;
    private int maQuyen;
    
    // Additional fields from JOINs
    private String hoTen;
    private String tenQuyen;
    private int trangThai; // From NhanVien.TrangThai

    public TaiKhoan() {
    }

    public TaiKhoan(String username, String pass, String hoTen, String tenQuyen) {
        this.username = username;
        this.pass = pass;
        this.hoTen = hoTen;
        this.tenQuyen = tenQuyen;
    }

    public int getMaTK() { return maTK; }
    public void setMaTK(int maTK) { this.maTK = maTK; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getPass() { return pass; }
    public void setPass(String pass) { this.pass = pass; }

    public int getMaNV() { return maNV; }
    public void setMaNV(int maNV) { this.maNV = maNV; }

    public int getMaQuyen() { return maQuyen; }
    public void setMaQuyen(int maQuyen) { this.maQuyen = maQuyen; }

    public String getHoTen() { return hoTen; }
    public void setHoTen(String hoTen) { this.hoTen = hoTen; }

    public String getTenQuyen() { return tenQuyen; }
    public void setTenQuyen(String tenQuyen) { this.tenQuyen = tenQuyen; }

    public int getTrangThai() { return trangThai; }
    public void setTrangThai(int trangThai) { this.trangThai = trangThai; }
}