<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Lịch Sử Hóa Đơn</title>
    <link rel="stylesheet" href="css/qlnv.css?v=2.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>

<body>

<jsp:include page="menu.jsp"/>

<main class="content">

    <div class="header">
        <h1>Lịch Sử Hóa Đơn Bán Hàng</h1>
    </div>

    <form class="filter-card" action="quanlyhoadon" method="get">
        <div class="filter-group" style="flex: 2;">
            <label>TÌM KIẾM</label>
            <input type="text" name="keyword" value="${keyword}" placeholder="Mã HĐ hoặc Tên khách, nhân viên" style="width: 100%;">
        </div>
        <div class="filter-group">
            <label>TỪ NGÀY</label>
            <input type="date" name="fromDate" value="${fromDate}">
        </div>
        <div class="filter-group">
            <label>ĐẾN NGÀY</label>
            <input type="date" name="toDate" value="${toDate}">
        </div>
        <button type="submit" class="btn-filter" style="margin-bottom: 2px;">Lọc</button>
        <a href="quanlyhoadon" class="btn-reset" style="margin-bottom: 2px; display: flex; align-items: center; justify-content: center; text-decoration: none;"><i class="fas fa-undo"></i></a>
    </form>

    <div class="table-container">
        <table>
            <thead>
                <tr>
                    <th>MÃ HĐ</th>
                    <th>NGÀY LẬP</th>
                    <th>NGƯỜI BÁN</th>
                    <th>KHÁCH HÀNG</th>
                    <th>TỔNG TIỀN THANH TOÁN</th>
                    <th>TRẠNG THÁI</th>
                    <th>HÀNH ĐỘNG</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="hd" items="${listHD}">
                    <tr>
                        <td style="font-weight:600; color:#1e293b;">#HD${hd.maHD}</td>
                        <td><fmt:formatDate value="${hd.ngayTao}" pattern="dd/MM/yyyy HH:mm"/></td>
                        <td>${hd.tenNV}</td>
                        <td>${hd.tenKH}</td>
                        <td style="font-weight:700; color:#1e293b;"><fmt:formatNumber value="${hd.tongTien}" type="currency" currencySymbol="đ" maxFractionDigits="0"/></td>
                        <td class="${hd.trangThai == 1 ? 'status-active' : (hd.trangThai == 0 ? 'status-leave' : 'status-leave')}">
                            ${hd.trangThai == 1 ? 'Thành công' : (hd.trangThai == 0 ? 'Chờ TT' : 'Đã hủy')}
                        </td>
                        <td>
                            <a href="quanlyhoadon?action=viewDetail&id=${hd.maHD}" style="color:#2d6652; text-decoration:none; font-weight:600;"><i class="fas fa-eye"></i> Chi tiết</a>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty listHD}">
                    <tr><td colspan="7" style="text-align:center; color:#64748b; padding:40px;">Không tìm thấy hóa đơn nào phù hợp.</td></tr>
                </c:if>
            </tbody>
        </table>
    </div>

</main>

</body>
</html>
