<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>

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
            background:#f4f4f4;
        }

        .content{
            flex:1;
            padding:25px;
        }

        h1{
            margin-bottom:20px;
        }

        .table-container{
            background:white;
            padding:20px;
            border-radius:8px;
            box-shadow:0 2px 5px rgba(0,0,0,0.2);
            overflow-x:auto;
        }

        table{
            width:100%;
            min-width:1600px;
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

<jsp:include page="menu.jsp"/>

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

            <c:forEach var="nv" items="${lst}">

                <tr>

                    <td>${nv.maNV}</td>

                    <td>${nv.hoTen}</td>

                    <td>${nv.ngaySinh}</td>

                    <td>${nv.gioiTinh}</td>

                    <td>${nv.sdt}</td>

                    <td>${nv.email}</td>

                    <td>${nv.diaChi}</td>

                    <td>${nv.cccd}</td>

                    <td>${nv.ngayCapCCCD}</td>

                    <td>${nv.dacDiemNhanDang}</td>

                    <td class="status-active">${nv.tenTrangThai}</td>

                </tr>

            </c:forEach>

            </tbody>

        </table>

    </div>

</main>

</body>
</html>