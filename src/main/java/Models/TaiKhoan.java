package Models;

public class TaiKhoan {
    private String username;
    private String pass;
    private String tenTK;
    private String tenQuyen;

    public TaiKhoan() {}

    public TaiKhoan(String username, String pass, String tenTK, String tenQuyen) {
        this.username = username;
        this.pass = pass;
        this.tenTK = tenTK;
        this.tenQuyen = tenQuyen;
    }

    // Getter & Setter
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getPass() { return pass; }
    public void setPass(String pass) { this.pass = pass; }

    public String getTenTK() { return tenTK; }
    public void setTenTK(String tenTK) { this.tenTK = tenTK; }

    public String getTenQuyen() { return tenQuyen; }
    public void setTenQuyen(String tenQuyen) { this.tenQuyen = tenQuyen; }
}