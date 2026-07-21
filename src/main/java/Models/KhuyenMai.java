package Models;

import java.sql.Timestamp;

public class KhuyenMai {
    private int maKM;
    private String tenKM;
    private double phanTramGiam;
    private Timestamp ngayBatDau;
    private Timestamp ngayKetThuc;
    private int trangThai;

    public KhuyenMai() {}

    public KhuyenMai(int maKM, String tenKM, double phanTramGiam, Timestamp ngayBatDau, Timestamp ngayKetThuc, int trangThai) {
        this.maKM = maKM;
        this.tenKM = tenKM;
        this.phanTramGiam = phanTramGiam;
        this.ngayBatDau = ngayBatDau;
        this.ngayKetThuc = ngayKetThuc;
        this.trangThai = trangThai;
    }

    public int getMaKM() { return maKM; }
    public void setMaKM(int maKM) { this.maKM = maKM; }

    public String getTenKM() { return tenKM; }
    public void setTenKM(String tenKM) { this.tenKM = tenKM; }

    public double getPhanTramGiam() { return phanTramGiam; }
    public void setPhanTramGiam(double phanTramGiam) { this.phanTramGiam = phanTramGiam; }

    public Timestamp getNgayBatDau() { return ngayBatDau; }
    public void setNgayBatDau(Timestamp ngayBatDau) { this.ngayBatDau = ngayBatDau; }

    public Timestamp getNgayKetThuc() { return ngayKetThuc; }
    public void setNgayKetThuc(Timestamp ngayKetThuc) { this.ngayKetThuc = ngayKetThuc; }

    public int getTrangThai() { return trangThai; }
    public void setTrangThai(int trangThai) { this.trangThai = trangThai; }
}
