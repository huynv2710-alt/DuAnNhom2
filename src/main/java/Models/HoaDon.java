package Models;
import java.util.Date;

public class HoaDon {
    private int maHD;
    private int maNV;
    private int maKH;
    private Date ngayTao;
    private double tongTien;
    private int trangThai; // 1: Hoàn thành, 0: Đã hủy
    
    // For display purpose
    private String tenNV;
    private String tenKH;
    private String sdtKH;

    public HoaDon() {}

    public HoaDon(int maHD, int maNV, int maKH, Date ngayTao, double tongTien, int trangThai) {
        this.maHD = maHD;
        this.maNV = maNV;
        this.maKH = maKH;
        this.ngayTao = ngayTao;
        this.tongTien = tongTien;
        this.trangThai = trangThai;
    }

    public int getMaHD() { return maHD; }
    public void setMaHD(int maHD) { this.maHD = maHD; }
    public int getMaNV() { return maNV; }
    public void setMaNV(int maNV) { this.maNV = maNV; }
    public int getMaKH() { return maKH; }
    public void setMaKH(int maKH) { this.maKH = maKH; }
    public Date getNgayTao() { return ngayTao; }
    public void setNgayTao(Date ngayTao) { this.ngayTao = ngayTao; }
    public double getTongTien() { return tongTien; }
    public void setTongTien(double tongTien) { this.tongTien = tongTien; }
    public int getTrangThai() { return trangThai; }
    public void setTrangThai(int trangThai) { this.trangThai = trangThai; }

    public String getTenNV() { return tenNV; }
    public void setTenNV(String tenNV) { this.tenNV = tenNV; }
    public String getTenKH() { return tenKH; }
    public void setTenKH(String tenKH) { this.tenKH = tenKH; }
    public String getSdtKH() { return sdtKH; }
    public void setSdtKH(String sdtKH) { this.sdtKH = sdtKH; }
}
