<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản lý Thể Loại</title>
    <link rel="stylesheet" href="css/qlnv.css?v=2.0">
    <style>
        .modal { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); z-index: 2000; overflow-y: auto; }
        .modal-content { background: white; width: 500px; margin: 100px auto; padding: 25px; border-radius: 8px; box-shadow: 0 4px 15px rgba(0,0,0,0.2); }
        .modal-header { font-size: 22px; font-weight: bold; margin-bottom: 20px; color: #0f2820; border-bottom: 2px solid #2d6652; padding-bottom: 10px; }
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; margin-bottom: 5px; font-weight: bold; color: #333; }
        .form-group input, .form-group select { width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 4px; outline: none; box-sizing: border-box; }
        .modal-footer { text-align: right; margin-top: 25px; }
        .btn-cancel { padding: 10px 15px; background: #ccc; border: none; border-radius: 4px; cursor: pointer; margin-right: 10px; font-weight: bold; }
        .btn-save { padding: 10px 15px; background: #2d6652; color: white; border: none; border-radius: 4px; cursor: pointer; font-weight: bold; }
    </style>
</head>

<body>

<jsp:include page="menu.jsp"/>

<main class="content">
    <div class="header">
        <h1>QUẢN LÝ DANH MỤC & THỂ LOẠI SÁCH</h1>
        <button class="btn-add" onclick="openModal(0, '', '', '')"><i class="fas fa-folder-plus"></i> Thêm Danh Mục Mới</button>
    </div>

    <c:if test="${not empty sessionScope.success}">
        <div style="background-color: #d4edda; color: #155724; padding: 15px; border-radius: 4px; margin-bottom: 20px; border: 1px solid #c3e6cb;">
            ${sessionScope.success}
        </div>
        <c:remove var="success" scope="session"/>
    </c:if>
    <c:if test="${not empty sessionScope.error}">
        <div style="background-color: #f8d7da; color: #721c24; padding: 15px; border-radius: 4px; margin-bottom: 20px; border: 1px solid #f5c6cb;">
            ${sessionScope.error}
        </div>
        <c:remove var="error" scope="session"/>
    </c:if>

    <div class="category-container" style="display: flex; flex-direction: column; gap: 25px;">
        <c:forEach var="parent" items="${listTL}">
            <c:if test="${empty parent.maTheLoaiCha}">
                <div class="category-card" style="border: 1px solid #e2e8f0; border-radius: 8px; padding: 20px; background: #f8fafc; box-shadow: 0 2px 4px rgba(0,0,0,0.05);">
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px; border-bottom: 2px solid #cbd5e1; padding-bottom: 10px;">
                        <div>
                            <h2 style="margin: 0; color: #0f2820; display: flex; align-items: center; gap: 10px;">
                                <i class="fas fa-book-open" style="color: #2d6652;"></i> ${parent.tenTheLoai}
                                <span style="font-size: 14px; background: #e2e8f0; padding: 4px 10px; border-radius: 20px; color: #334155; font-weight: normal;">${parent.soLuongSach} sách</span>
                            </h2>
                            <span style="font-size: 13px; color: #64748b; margin-top: 5px; display: inline-block;">Mã: ${parent.maTheLoai} | ${parent.moTa}</span>
                        </div>
                        <div style="display: flex; gap: 10px;">
                            <button class="btn-edit" style="background: white; border: 1px solid #cbd5e1; padding: 6px 12px; border-radius: 4px; cursor: pointer; color: #334155; font-weight: 600;" 
                                onclick="openModal(${parent.maTheLoai}, '${parent.tenTheLoai}', '${parent.moTa}', '')">
                                <i class="fas fa-edit"></i> Sửa
                            </button>
                            <form action="quanlytheloai" method="post" style="display:inline;">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="maTheLoai" value="${parent.maTheLoai}">
                                <button type="submit" class="btn-edit" style="background: #fee2e2; border: 1px solid #fca5a5; padding: 6px 12px; border-radius: 4px; cursor: pointer; color: #ef4444; font-weight: 600;" onclick="return confirm('Bạn có chắc chắn muốn xóa danh mục gốc này?');">
                                    <i class="fas fa-trash-alt"></i> Xóa
                                </button>
                            </form>
                            <button class="btn-add" style="padding: 6px 12px; border-radius: 4px; font-weight: 600;" 
                                onclick="openModal(0, '', '', ${parent.maTheLoai})">
                                <i class="fas fa-plus"></i> Thêm Thể Loại Con
                            </button>
                        </div>
                    </div>
                    
                    <div style="padding-left: 20px;">
                        <table style="width: 100%; border-collapse: collapse; background: white; border-radius: 6px; overflow: hidden; box-shadow: 0 1px 3px rgba(0,0,0,0.1);">
                            <thead style="background: #e2e8f0; color: #334155; font-size: 14px;">
                                <tr>
                                    <th style="padding: 12px; text-align: left; width: 80px;">Mã</th>
                                    <th style="padding: 12px; text-align: left;">Tên Thể Loại</th>
                                    <th style="padding: 12px; text-align: left;">Số Lượng Sách</th>
                                    <th style="padding: 12px; text-align: left;">Mô Tả</th>
                                    <th style="padding: 12px; text-align: center; width: 140px;">Thao Tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:set var="hasChild" value="false"/>
                                <c:forEach var="child" items="${listTL}">
                                    <c:if test="${child.maTheLoaiCha == parent.maTheLoai}">
                                        <c:set var="hasChild" value="true"/>
                                        <tr style="border-bottom: 1px solid #f1f5f9;">
                                            <td style="padding: 12px; color: #64748b; font-weight: bold;">${child.maTheLoai}</td>
                                            <td style="padding: 12px; font-weight: 600; color: #1e293b;">${child.tenTheLoai}</td>
                                            <td style="padding: 12px; font-weight: bold; color: #2d6652;">${child.soLuongSach}</td>
                                            <td style="padding: 12px; color: #64748b; font-size: 14px;">${child.moTa}</td>
                                            <td style="padding: 12px; text-align: center;">
                                                <button title="Sửa Thể Loại" style="background: none; border: none; color: #0ea5e9; cursor: pointer; font-size: 16px; margin-right: 10px;" 
                                                    onclick="openModal(${child.maTheLoai}, '${child.tenTheLoai}', '${child.moTa}', ${parent.maTheLoai})">
                                                    <i class="fas fa-edit"></i>
                                                </button>
                                                <form action="quanlytheloai" method="post" style="display:inline;">
                                                    <input type="hidden" name="action" value="delete">
                                                    <input type="hidden" name="maTheLoai" value="${child.maTheLoai}">
                                                    <button type="submit" title="Xóa Thể Loại" style="background: none; border: none; color: #ef4444; cursor: pointer; font-size: 16px;" onclick="return confirm('Bạn có chắc chắn muốn xóa thể loại này?');">
                                                        <i class="fas fa-trash-alt"></i>
                                                    </button>
                                                </form>
                                            </td>
                                        </tr>
                                    </c:if>
                                </c:forEach>
                                <c:if test="${!hasChild}">
                                    <tr><td colspan="5" style="padding: 20px; text-align: center; color: #94a3b8; font-style: italic;">Chưa có thể loại con nào trong danh mục này</td></tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </c:if>
        </c:forEach>
        <c:if test="${empty listTL}">
            <div style="text-align:center; padding: 40px; color: #64748b; background: white; border-radius: 8px;">Chưa có dữ liệu danh mục nào!</div>
        </c:if>
    </div>
</main>

<div id="tlModal" class="modal">
    <div class="modal-content">
        <div class="modal-header" id="modalTitle">Thêm Danh Mục</div>
        <form action="quanlytheloai" method="post">
            <input type="hidden" name="action" id="action" value="add">
            <input type="hidden" name="maTheLoai" id="maTheLoai" value="0">
            <div class="form-group">
                <label>Tên Danh Mục / Thể Loại <span style="color:red">*</span></label>
                <input type="text" id="tenTheLoai" name="tenTheLoai" required>
            </div>
            <div class="form-group">
                <label>Thuộc Danh Mục Cha</label>
                <select id="maTheLoaiCha" name="maTheLoaiCha">
                    <option value="">-- Là Danh Mục Gốc (Không có cha) --</option>
                    <c:forEach var="tl" items="${listTL}">
                        <c:if test="${empty tl.maTheLoaiCha}">
                            <option value="${tl.maTheLoai}">${tl.tenTheLoai}</option>
                        </c:if>
                    </c:forEach>
                </select>
                <small style="color: #64748b; display: block; margin-top: 5px;">Chọn danh mục gốc nếu đây là Thể loại con. Để trống nếu đây là Danh mục gốc.</small>
            </div>
            <div class="form-group">
                <label>Mô Tả</label>
                <input type="text" id="moTa" name="moTa">
            </div>
            <div class="modal-footer">
                <button type="button" class="btn-cancel" onclick="closeModal()">Hủy</button>
                <button type="submit" class="btn-save">Lưu</button>
            </div>
        </form>
    </div>
</div>

<script>
    function openModal(id, name, desc, parentId) {
        let isParent = (parentId === null || parentId === '');
        document.getElementById('modalTitle').innerText = id == 0 ? (isParent ? 'Thêm Danh Mục Gốc' : 'Thêm Thể Loại Con') : (isParent ? 'Sửa Danh Mục Gốc' : 'Sửa Thể Loại Con');
        document.getElementById('action').value = id == 0 ? 'add' : 'edit';
        document.getElementById('maTheLoai').value = id;
        document.getElementById('tenTheLoai').value = name;
        document.getElementById('moTa').value = desc;
        
        let parentSelect = document.getElementById('maTheLoaiCha');
        parentSelect.value = parentId !== null ? parentId : '';
        
        // Ẩn chính nó trong danh sách cha nếu đang sửa
        let options = parentSelect.options;
        for (let i = 0; i < options.length; i++) {
            if (options[i].value == id && id != 0) {
                options[i].style.display = 'none';
            } else {
                options[i].style.display = 'block';
            }
        }

        document.getElementById('tlModal').style.display = 'block';
    }
    
    function closeModal() {
        document.getElementById('tlModal').style.display = 'none';
    }
</script>

</body>
</html>
