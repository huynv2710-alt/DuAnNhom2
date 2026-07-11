<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản lý nhân viên</title>
    <link rel="stylesheet" href="css/qlnv.css">
    <style>
        /* Mặc định: không animation */
        .sidebar,
        .content {
            opacity: 1;
        }

        /* Chỉ chạy animation khi có class .do-animate */
        .sidebar.do-animate {
            opacity: 0;
            animation: slideInSidebar 0.5s ease forwards;
        }
        .content.do-animate {
            opacity: 0;
            animation: fadeInContent 0.6s ease 0.15s forwards;
        }

        @keyframes slideInSidebar {
            from { opacity: 0; transform: translateX(-30px); }
            to   { opacity: 1; transform: translateX(0); }
        }

        @keyframes fadeInContent {
            from { opacity: 0; transform: translateY(20px); }
            to   { opacity: 1; transform: translateY(0); }
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
        <a href="themnhanvien.jsp" class="btn-add">+ Thêm nhân viên</a>
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
                        <td class="${nv.maTrangThai == 1 ? 'status-active' :
                                     nv.maTrangThai == 2 ? 'status-trial' :
                                     'status-leave'}">
                            ${nv.tenTrangThai}
                        </td>
                        <td>
                            <a href="suanhanvien.jsp" class="btn-edit">Sửa</a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

</main>

<script>
    var KEY = 'visited_quanlinhanvien';
    if (!sessionStorage.getItem(KEY)) {
        var sidebar = document.querySelector('.sidebar');
        var content = document.querySelector('.content');
        if (sidebar) sidebar.classList.add('do-animate');
        if (content) content.classList.add('do-animate');
        sessionStorage.setItem(KEY, '1');
    }
</script>

</body>
</html>
