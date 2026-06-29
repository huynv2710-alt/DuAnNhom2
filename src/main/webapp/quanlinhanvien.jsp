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
    font-family:Arial, sans-serif;
}

body{
    display:flex;
    min-height:100vh;
    background:#f4f4f4;
}

.content{
    flex:1;
    padding:25px;
    overflow:hidden;
}

.table-container{
    background:#fff;
    padding:20px;
    border-radius:12px;
    box-shadow:0 2px 10px rgba(0,0,0,0.1);
    overflow-x:auto;
}

table{
    width:100%;
    min-width:1200px;
    border-collapse:collapse;
}

th{
    background:#00897b;
    color:white;
    padding:15px 12px;
    border:1px solid #ddd;
    white-space:nowrap;
    font-size:18px;
}

td{
    padding:12px;
    border:1px solid #ddd;
    text-align:center;
    white-space:nowrap;
    font-size:16px;
}

tr:nth-child(even){
    background:#fafafa;
}

tr:hover{
    background:#f2f2f2;
}

.status-active{
    color:#2e7d32;
    font-weight:bold;
}

.table-container::-webkit-scrollbar{
    height:8px;
}

.table-container::-webkit-scrollbar-thumb{
    background:#bdbdbd;
    border-radius:10px;
}

.table-container::-webkit-scrollbar-track{
    background:#f1f1f1;
}

.header{
    width:100%;
    display:flex;
    justify-content:space-between;
    align-items:center;
    margin-bottom:18px;
}

.header h1{
    margin:0;
    color:#00897b;
    font-size:38px;
    font-weight:bold;
    letter-spacing:2px;
}

.btn-add{
    display:inline-block;
    margin-left:auto;
    background:#00897b;
    color:#fff;
    text-decoration:none;
    padding:8px 16px;
    border-radius:6px;
    font-size:14px;
    font-weight:bold;
    transition:0.3s;
}

.btn-add:hover{
    background:#00695c;
}
    </style>

</head>

<body>
<%
    String successMsg = (String) session.getAttribute("successMsg");
    if (successMsg != null) {
%>
    <script>
        alert("<%= successMsg %>");
    </script>
<%
        session.removeAttribute("successMsg");
    }
%>

<jsp:include page="menu.jsp"/>

<main class="content">

<div class="header">

    <h1>QUẢN LÝ NHÂN VIÊN</h1>

    <a href="themnhanvien.jsp" class="btn-add">
        + Thêm nhân viên
    </a>

</div>
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
                 <th>Thao tác</th>
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
                    <td>
                        <a href="NhanVienServlet?action=edit&id=${nv.maNV}" class="btn-edit">
                            Sửa
                        </a>
                    </td>

                </tr>

            </c:forEach>

            </tbody>

        </table>

    </div>

</main>

</body>
</html>