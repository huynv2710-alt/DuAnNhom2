<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.ArrayList"%>
<%@page import="model.NhanVien"%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý nhân viên</title>

    <style>
        *{
            margin:0;
            padding:0;
            box-sizing:border-box;
            font-family:Arial,sans-serif;
        }

        body{
            display:flex;
            background:#f5f5f5;
        }

        .content{
            flex:1;
            padding:25px;
        }

        h1{
            margin-bottom:20px;
        }

        .table-container{
            background:#fff;
            padding:20px;
            border-radius:8px;
            box-shadow:0 2px 5px rgba(0,0,0,.2);
            overflow-x:auto;
        }

        table{
            width:100%;
            min-width:1500px;
            border-collapse:collapse;
        }

        th,td{
            border:1px solid #ddd;
            padding:10px;
            text-align:center;
        }

        th{
            background:#00897b;
            color:white;
        }

        tr:nth-child(even){
            background:#f8f8f8;
        }

        tr:hover{
            background:#eeeeee;
        }

        .status-active{
            color:green;
            font-weight:bold;
        }
    </style>

</head>

<body>

<jsp:include page="index.jsp"/>

<main class="content">

    <h1>Quản lý nhân viên</h1>

    <div class="table-container">

        <table>

            <thead>

                <tr>
                    <th>Mã NV</th>
                    <th>Họ tên</th>
                    <th>Ngày sinh</th>
                    <th>Giới tính</th>
                    <th>SĐT</th>
                    <th>Email</th>
                    <th>Địa chỉ</th>
                    <th>CCCD</th>
                    <th>Ngày cấp CCCD</th>
                    <th>Đặc điểm nhận dạng</th>
                    <th>Trạng thái</th>
                </tr>

            </thead>

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