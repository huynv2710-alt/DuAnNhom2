package Models;

import java.util.List;

public class Sach {
    private int maSach;
    private String tenSach;
    private int maTheLoai;
    private int maNXB;
    private double giaNhap;
    private double giaBan;
    private int soLuongTon;
    private String hinhAnh;
    private int trangThai; 
    private String isbn;
    
    // Thuộc tính mới bổ sung (DTO mapping cho SachChiTiet)
    private int soTrang;
    private String kichThuoc;
    private int trongLuong;
    private String ngonNgu;
    private String moTa;
    
    // Tác giả
    private List<TacGia> tacGias;
    
    // Thuộc tính phụ hiển thị UI
    private String tenTheLoai;
    private String tenNXB;

    public Sach() {}

    public int getMaSach() { return maSach; }
    public void setMaSach(int maSach) { this.maSach = maSach; }
    public String getTenSach() { return tenSach; }
    public void setTenSach(String tenSach) { this.tenSach = tenSach; }
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

    public int getSoTrang() { return soTrang; }
    public void setSoTrang(int soTrang) { this.soTrang = soTrang; }
    public String getKichThuoc() { return kichThuoc; }
    public void setKichThuoc(String kichThuoc) { this.kichThuoc = kichThuoc; }
    public int getTrongLuong() { return trongLuong; }
    public void setTrongLuong(int trongLuong) { this.trongLuong = trongLuong; }
    public String getNgonNgu() { return ngonNgu; }
    public void setNgonNgu(String ngonNgu) { this.ngonNgu = ngonNgu; }
    public String getMoTa() { return moTa; }
    public void setMoTa(String moTa) { this.moTa = moTa; }

    public List<TacGia> getTacGias() { return tacGias; }
    public void setTacGias(List<TacGia> tacGias) { this.tacGias = tacGias; }

    public String getTenTheLoai() { return tenTheLoai; }
    public void setTenTheLoai(String tenTheLoai) { this.tenTheLoai = tenTheLoai; }
    public String getTenNXB() { return tenNXB; }
    public void setTenNXB(String tenNXB) { this.tenNXB = tenNXB; }
    
    public String getTacGiaString() {
        if (tacGias == null || tacGias.isEmpty()) return "";
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < tacGias.size(); i++) {
            sb.append(tacGias.get(i).getTenTacGia());
            if (i < tacGias.size() - 1) sb.append(", ");
        }
        return sb.toString();
    }
    
    public String getMaTacGiasString() {
        if (tacGias == null || tacGias.isEmpty()) return "";
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < tacGias.size(); i++) {
            sb.append(tacGias.get(i).getMaTacGia());
            if (i < tacGias.size() - 1) sb.append(",");
        }
        return sb.toString();
    }
}
