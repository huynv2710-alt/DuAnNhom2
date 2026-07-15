package Models;

public class TheLoai {
    private int maTheLoai;
    private String tenTheLoai;
    private String moTa;
    private Integer maTheLoaiCha; // Dùng Integer để có thể null

    public TheLoai() {}

    public TheLoai(int maTheLoai, String tenTheLoai, String moTa, Integer maTheLoaiCha) {
        this.maTheLoai = maTheLoai;
        this.tenTheLoai = tenTheLoai;
        this.moTa = moTa;
        this.maTheLoaiCha = maTheLoaiCha;
    }

    public int getMaTheLoai() { return maTheLoai; }
    public void setMaTheLoai(int maTheLoai) { this.maTheLoai = maTheLoai; }
    public String getTenTheLoai() { return tenTheLoai; }
    public void setTenTheLoai(String tenTheLoai) { this.tenTheLoai = tenTheLoai; }
    public String getMoTa() { return moTa; }
    public void setMoTa(String moTa) { this.moTa = moTa; }
    public Integer getMaTheLoaiCha() { return maTheLoaiCha; }
    public void setMaTheLoaiCha(Integer maTheLoaiCha) { this.maTheLoaiCha = maTheLoaiCha; }
}
