package Models;

public class SachChiTiet {
    private int maSach;
    private int soTrang;
    private String kichThuoc;
    private int trongLuong;
    private String ngonNgu;
    private String moTa;

    public SachChiTiet() {}

    public SachChiTiet(int maSach, int soTrang, String kichThuoc, int trongLuong, String ngonNgu, String moTa) {
        this.maSach = maSach;
        this.soTrang = soTrang;
        this.kichThuoc = kichThuoc;
        this.trongLuong = trongLuong;
        this.ngonNgu = ngonNgu;
        this.moTa = moTa;
    }

    public int getMaSach() { return maSach; }
    public void setMaSach(int maSach) { this.maSach = maSach; }

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
}
