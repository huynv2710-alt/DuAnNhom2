<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    if (session.getAttribute("username") == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    // action=add khi thêm mới, action=edit khi sửa (sach != null)
    String action = request.getParameter("action");
    boolean isEdit = "edit".equals(action);
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${empty sach ? 'Thêm sách' : 'Sửa sách'} - Book Store</title>
    <link rel="stylesheet" href="css/menu2.css">
    <style>
        body { display: block; background: #f4f4f4; }

        .content {
            margin-left: 260px;
            padding: 28px 30px;
            min-height: 100vh;
            box-sizing: border-box;
        }

        .title {
            color: #00897b;
            font-size: 28px;
            font-weight: bold;
            letter-spacing: 2px;
            margin-bottom: 22px;
        }

        .form-container {
            max-width: 700px;
            background: #fff;
            border-radius: 12px;
            padding: 28px 30px;
            box-shadow: 0 2px 10px rgba(0,0,0,.12);
        }

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px 24px;
        }

        /* Tên sách chiếm full width */
        .form-group.full { grid-column: 1 / -1; }

        .form-group { display: flex; flex-direction: column; }

        .form-group label {
            font-size: 14px;
            font-weight: bold;
            color: #444;
            margin-bottom: 6px;
        }

        .form-group input,
        .form-group select {
            height: 38px;
            border: 1px solid #ccc;
            border-radius: 6px;
            padding: 0 12px;
            font-size: 14px;
            transition: .2s;
        }

        .form-group input:focus,
        .form-group select:focus {
            outline: none;
            border-color: #009688;
            box-shadow: 0 0 0 3px rgba(0,150,136,.1);
        }

        /* Readonly mã sách khi sửa */
        .form-group input[readonly] {
            background: #f5f5f5;
            color: #888;
            cursor: not-allowed;
        }

        .error-msg {
            color: #e53935;
            font-size: 12px;
            margin-top: 4px;
            display: none;
        }

        .button-group {
            margin-top: 24px;
            display: flex;
            gap: 12px;
        }

        .btn-save, .btn-back {
            height: 42px;
            padding: 0 28px;
            border: none;
            border-radius: 7px;
            font-size: 15px;
            font-weight: bold;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            transition: .25s;
        }

        .btn-save { background: #00897b; color: #fff; }
        .btn-save:hover { background: #004d40; }

        .btn-back { background: #fff; color: #555; border: 1px solid #ccc; }
        .btn-back:hover { background: #f5f5f5; }
    </style>
</head>
<body>

<jsp:include page="menu2.jsp"/>

<main class="content">

    <h1 class="title">
        <c:choose>
            <c:when test="${not empty sach}">✏ SỬA SÁCH</c:when>
            <c:otherwise>➕ THÊM SÁCH</c:otherwise>
        </c:choose>
    </h1>

    <div class="form-container">
        <form action="quanlysach" method="post" onsubmit="return validateForm()">

            <%-- action: add hoặc update --%>
            <c:choose>
                <c:when test="${not empty sach}">
                    <input type="hidden" name="action"  value="update">
                    <input type="hidden" name="maSach"  value="${sach.maSach}">
                </c:when>
                <c:otherwise>
                    <input type="hidden" name="action" value="add">
                </c:otherwise>
            </c:choose>

            <div class="form-grid">

                <%-- Mã sách (chỉ hiện khi sửa, readonly) --%>
                <c:if test="${not empty sach}">
                    <div class="form-group">
                        <label>Mã sách</label>
                        <input type="text" value="${sach.maSach}" readonly>
                    </div>
                </c:if>

                <%-- Tên sách --%>
                <div class="form-group full">
                    <label>Tên sách <span style="color:#e53935">*</span></label>
                    <input type="text" id="tenSach" name="tenSach"
                           value="${sach.tenSach}" placeholder="Nhập tên sách...">
                    <span class="error-msg" id="errTen">Vui lòng nhập tên sách</span>
                </div>

                <%-- Tác giả --%>
                <div class="form-group">
                    <label>Tác giả <span style="color:#e53935">*</span></label>
                    <input type="text" id="tacGia" name="tacGia"
                           value="${sach.tacGia}" placeholder="Nhập tên tác giả...">
                    <span class="error-msg" id="errTacGia">Vui lòng nhập tác giả</span>
                </div>

                <%-- Thể loại --%>
                <div class="form-group">
                    <label>Thể loại <span style="color:#e53935">*</span></label>
                    <select id="theLoai" name="theLoai">
                        <option value="">-- Chọn thể loại --</option>
                        <c:set var="tl" value="${sach.theLoai}"/>
                        <option value="Văn học"       ${tl == 'Văn học'       ? 'selected' : ''}>Văn học</option>
                        <option value="Kỹ năng sống"  ${tl == 'Kỹ năng sống'  ? 'selected' : ''}>Kỹ năng sống</option>
                        <option value="Công nghệ"     ${tl == 'Công nghệ'     ? 'selected' : ''}>Công nghệ</option>
                        <option value="Giáo khoa"     ${tl == 'Giáo khoa'     ? 'selected' : ''}>Giáo khoa</option>
                        <option value="Tâm lý"        ${tl == 'Tâm lý'        ? 'selected' : ''}>Tâm lý</option>
                        <option value="Kinh tế"       ${tl == 'Kinh tế'       ? 'selected' : ''}>Kinh tế</option>
                        <option value="Lịch sử"       ${tl == 'Lịch sử'       ? 'selected' : ''}>Lịch sử</option>
                        <option value="Thiếu nhi"     ${tl == 'Thiếu nhi'     ? 'selected' : ''}>Thiếu nhi</option>
                        <option value="Khác"          ${tl == 'Khác'          ? 'selected' : ''}>Khác</option>
                    </select>
                    <span class="error-msg" id="errTheLoai">Vui lòng chọn thể loại</span>
                </div>

                <%-- Đơn giá --%>
                <div class="form-group">
                    <label>Đơn giá (đ) <span style="color:#e53935">*</span></label>
                    <input type="number" id="donGia" name="donGia" min="0" step="1000"
                           value="${sach.donGia}" placeholder="VD: 120000">
                    <span class="error-msg" id="errGia">Vui lòng nhập đơn giá hợp lệ</span>
                </div>

                <%-- Tồn kho --%>
                <div class="form-group">
                    <label>Tồn kho <span style="color:#e53935">*</span></label>
                    <input type="number" id="tonKho" name="tonKho" min="0"
                           value="${sach.tonKho}" placeholder="VD: 50">
                    <span class="error-msg" id="errTonKho">Vui lòng nhập tồn kho hợp lệ</span>
                </div>

            </div>

            <div class="button-group">
                <button type="submit" class="btn-save">
                    <c:choose>
                        <c:when test="${not empty sach}">💾 Lưu thay đổi</c:when>
                        <c:otherwise>➕ Thêm sách</c:otherwise>
                    </c:choose>
                </button>
                <a href="quanlysach" class="btn-back">← Quay lại</a>
            </div>

        </form>
    </div>

</main>

<script>
    function validateForm() {
        var ok = true;

        function check(id, errId, condition) {
            var el  = document.getElementById(id);
            var err = document.getElementById(errId);
            if (condition(el.value)) {
                err.style.display = 'none';
                el.style.borderColor = '#ccc';
            } else {
                err.style.display = 'block';
                el.style.borderColor = '#e53935';
                ok = false;
            }
        }

        check('tenSach',  'errTen',     function(v){ return v.trim() !== ''; });
        check('tacGia',   'errTacGia',  function(v){ return v.trim() !== ''; });
        check('theLoai',  'errTheLoai', function(v){ return v !== ''; });
        check('donGia',   'errGia',     function(v){ return v !== '' && Number(v) >= 0; });
        check('tonKho',   'errTonKho',  function(v){ return v !== '' && Number(v) >= 0; });

        return ok;
    }
</script>

</body>
</html>
