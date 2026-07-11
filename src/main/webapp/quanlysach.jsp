<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    if (session.getAttribute("username") == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    // Hiện alert nếu có thông báo từ session
    String msg = (String) session.getAttribute("successMsg");
    if (msg != null) session.removeAttribute("successMsg");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản lý sách</title>
    <link rel="stylesheet" href="css/menu2.css">
    <style>
        body { display:block; background:#f4f4f4; }

        .content {
            margin-left: 260px;
            padding: 28px 30px;
            min-height: 100vh;
            box-sizing: border-box;
        }

        /* Header */
        .header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 22px;
        }

        .header h1 {
            color: #00897b;
            font-size: 28px;
            font-weight: bold;
            letter-spacing: 2px;
        }

        .btn-add {
            background: #00897b;
            color: #fff;
            padding: 10px 22px;
            border-radius: 7px;
            text-decoration: none;
            font-size: 14px;
            font-weight: bold;
            transition: .25s;
        }
        .btn-add:hover { background: #004d40; }

        /* Table */
        .table-container {
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,.1);
            overflow: hidden;
        }

        table { width: 100%; border-collapse: collapse; }

        th {
            background: #00897b;
            color: #fff;
            padding: 13px 14px;
            text-align: center;
            font-size: 14px;
            white-space: nowrap;
        }

        td {
            padding: 11px 14px;
            border-bottom: 1px solid #eee;
            text-align: center;
            font-size: 14px;
            vertical-align: middle;
        }

        tr:last-child td { border-bottom: none; }
        tr:hover td { background: #f0faf9; }

        .td-name  { text-align: left; font-weight: 500; }
        .td-price { color: #e65100; font-weight: bold; white-space: nowrap; }

        .btn-edit {
            background: #0288d1;
            color: #fff;
            padding: 6px 16px;
            border-radius: 5px;
            text-decoration: none;
            font-size: 13px;
            font-weight: bold;
            transition: .2s;
            white-space: nowrap;
        }
        .btn-edit:hover { background: #01579b; }

        /* Empty state */
        .empty-row td {
            padding: 50px;
            color: #aaa;
            font-size: 15px;
        }

        /* Toast */
        .toast {
            position: fixed;
            bottom: 28px;
            right: 28px;
            background: #00897b;
            color: #fff;
            padding: 13px 24px;
            border-radius: 8px;
            font-size: 14px;
            font-weight: bold;
            box-shadow: 0 4px 15px rgba(0,0,0,.2);
            opacity: 0;
            transform: translateY(10px);
            transition: all .3s;
            pointer-events: none;
            z-index: 9999;
        }
        .toast.show { opacity: 1; transform: translateY(0); }
    </style>
</head>
<body>

<jsp:include page="menu2.jsp"/>

<main class="content">

    <div class="header">
        <h1>📚 QUẢN LÝ SÁCH</h1>
        <a href="quanlysach?action=add" class="btn-add">+ Thêm sách</a>
    </div>

    <div class="table-container">
        <table>
            <thead>
                <tr>
                    <th>Mã sách</th>
                    <th>Tên sách</th>
                    <th>Tác giả</th>
                    <th>Thể loại</th>
                    <th>Đơn giá</th>
                    <th>Tồn kho</th>
                    <th>Thao tác</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${not empty dsSach}">
                        <c:forEach var="s" items="${dsSach}">
                            <tr>
                                <td>${s.maSach}</td>
                                <td class="td-name">${s.tenSach}</td>
                                <td>${s.tacGia}</td>
                                <td>${s.theLoai}</td>
                                <td class="td-price">${s.donGia}đ</td>
                                <td>${s.tonKho}</td>
                                <td>
                                    <a href="quanlysach?action=edit&id=${s.maSach}" class="btn-edit">✏ Sửa</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr class="empty-row">
                            <td colspan="7">Chưa có sách nào trong hệ thống</td>
                        </tr>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>

</main>

<div class="toast" id="toast"></div>

<script>
    // Hiện toast nếu có successMsg
    <% if (msg != null) { %>
    (function(){
        var t = document.getElementById('toast');
        t.textContent = '<%= msg %>';
        t.classList.add('show');
        setTimeout(function(){ t.classList.remove('show'); }, 3000);
    })();
    <% } %>
</script>

</body>
</html>
