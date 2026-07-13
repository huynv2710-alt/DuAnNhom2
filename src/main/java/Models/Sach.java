package Models;

public class Sach {
    private int maSach;
    private String tenSach;
    private String tacGia;
    private int maTheLoai;
    private int maNXB;
    private double giaNhap;
    private double giaBan;
    private int soLuongTon;
    private String hinhAnh;
    private int trangThai; 
    private String isbn;
    
    // Thuộc tính phụ hiển thị UI
    private String tenTheLoai;
    private String tenNXB;

    public Sach() {}

    public Sach(int maSach, String tenSach, String tacGia, String isbn, int maTheLoai, int maNXB, double giaNhap, double giaBan, int soLuongTon, String hinhAnh, int trangThai) {
        this.maSach = maSach;
        this.tenSach = tenSach;
        this.tacGia = tacGia;
        this.isbn = isbn;
        this.maTheLoai = maTheLoai;
        this.maNXB = maNXB;
        this.giaNhap = giaNhap;
        this.giaBan = giaBan;
        this.soLuongTon = soLuongTon;
        this.hinhAnh = hinhAnh;
        this.trangThai = trangThai;
    }

    public int getMaSach() { return maSach; }
    public void setMaSach(int maSach) { this.maSach = maSach; }
    public String getTenSach() { return tenSach; }
    public void setTenSach(String tenSach) { this.tenSach = tenSach; }
    public String getTacGia() { return tacGia; }
    public void setTacGia(String tacGia) { this.tacGia = tacGia; }
    public int getMaTheLoai() { return maTheLoai; }
    public void setMaTheLoai(int maTheLoai) { this.maTheLoai = maTheLoai; }
    public int getMaNXB() { return maNXB; }
    public void setMaNXB(int maNXB) { this.maNXB = maNXB; }
    public double getGiaNhap() { return giaNhap; }
    public void setGiaNhap(double giaNhap) { this.giaNhap = giaNhap; }
    public double getGiaBan() { return giaBan; }
    public void setGiaBan(double giaBan) { this.giaBan = giaBan; }
    public int getSoLuongTon() { return soLuongTon; }
    public void setSoLuongTon(int soLuongTon) { this.soLuongTon = soLuongTon; }
    public String getHinhAnh() { return hinhAnh; }
    public void setHinhAnh(String hinhAnh) { this.hinhAnh = hinhAnh; }
    public int getTrangThai() { return trangThai; }
    public void setTrangThai(int trangThai) { this.trangThai = trangThai; }
    public String getIsbn() { return isbn; }
    public void setIsbn(String isbn) { this.isbn = isbn; }

    public String getTenTheLoai() { return tenTheLoai; }
    public void setTenTheLoai(String tenTheLoai) { this.tenTheLoai = tenTheLoai; }
    public String getTenNXB() { return tenNXB; }
    public void setTenNXB(String tenNXB) { this.tenNXB = tenNXB; }
}
