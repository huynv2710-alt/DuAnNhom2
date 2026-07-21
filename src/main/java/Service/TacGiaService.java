package Service;

import Models.TacGia;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class TacGiaService {
    public List<TacGia> getAllTacGia() {
        List<TacGia> list = new ArrayList<>();
        String sql = "SELECT * FROM TacGia";
        try (Connection con = new connectService().myConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new TacGia(rs.getInt("MaTacGia"), rs.getString("TenTacGia")));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean addTacGia(TacGia tg) {
        String sql = "INSERT INTO TacGia (TenTacGia) VALUES (?)";
        try (Connection con = new connectService().myConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, tg.getTenTacGia());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
