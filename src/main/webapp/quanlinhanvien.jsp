
            <tbody>

            <%
                ArrayList<NhanVien> list =
                        (ArrayList<NhanVien>)request.getAttribute("listNV");

                if(list != null && !list.isEmpty()){

                    for(NhanVien nv : list){
            %>

                <tr>

                    <td><%= nv.getMaNV() %></td>

                    <td><%= nv.getHoTen() %></td>

                    <td><%= nv.getNgaySinh() %></td>

                    <td><%= nv.getGioiTinh() %></td>

                    <td><%= nv.getSdt() %></td>

                    <td><%= nv.getEmail() %></td>

                    <td><%= nv.getDiaChi() %></td>

                    <td><%= nv.getCccd() %></td>

                    <td><%= nv.getNgayCapCCCD() %></td>

                    <td><%= nv.getDacDiemNhanDang() %></td>

                    <td class="status-active">
                        <%= nv.getTenTrangThai() %>
                    </td>

                </tr>

            <%
                    }

                }else{
            %>

                <tr>
                    <td colspan="11">
                        Không có dữ liệu nhân viên.
                    </td>
                </tr>

            <%
                }
            %>

            </tbody>

        </table>

    </div>

</main>

</body>
</html>