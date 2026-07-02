package Models;

public class TaiKhoan {

    private String username;
    private String pass;
    private String hoTen;
    private String tenQuyen;

    public TaiKhoan() {
    }

    public TaiKhoan(String username, String pass, String hoTen, String tenQuyen) {
        this.username = username;
        this.pass = pass;
        this.hoTen = hoTen;
        this.tenQuyen = tenQuyen;
    }

    // Getter & Setter
    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPass() {
        return pass;
    }

    public void setPass(String pass) {
        this.pass = pass;
    }

    public String getHoTen() {
        return hoTen;
    }

    public void setHoTen(String hoTen) {
        this.hoTen = hoTen;
    }

    public String getTenQuyen() {
        return tenQuyen;
    }

    public void setTenQuyen(String tenQuyen) {
        this.tenQuyen = tenQuyen;
    }
}