<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>

<style>
h1 {

    color: #00796b;
    font-family: Arial, sans-serif;
    margin-top: 20px;
    text-transform: uppercase;
    letter-spacing: 2px;
}
    *{
        margin:0;
        padding:0;
        box-sizing:border-box;
        font-family:Arial,sans-serif;
    }

    .sidebar{
        width:260px;
        min-width:260px;
        flex-shrink:0;
        background:#002d28;
        color:white;
        height:100vh;
        display:flex;
        flex-direction:column;
    }

    .sidebar-header{
        padding:20px;
        display:flex;
        align-items:center;
        gap:12px;
    }

    .logo-box{
        width:52px;
        height:52px;
        background:#009688;
        border-radius:8px;
        display:flex;
        justify-content:center;
        align-items:center;
        font-size:22px;
    }

    .brand-name{
        font-size:18px;
        font-weight:bold;
        white-space:nowrap;
    }

    .nav-links{
        list-style:none;
        flex:1;
    }

    .nav-links li a{
        display:block;
        padding:16px 25px;
        text-decoration:none;
        color:#b0bec5;
        transition:.3s;
    }

    .nav-links li.active{
        background:#004d40;
        border-left:5px solid #00e676;
    }

    .nav-links li.active a{
        color:#fff;
    }

    .nav-links li a:hover{
        background:#004d40;
        color:#fff;
    }

    .sidebar-footer{
        padding:20px;
        background:#001c18;
    }

    .user-info{
        display:flex;
        align-items:center;
        gap:10px;
        margin-bottom:15px;
    }

    .avatar{
        width:40px;
        height:40px;
        border-radius:50%;
        background:#009688;
        display:flex;
        justify-content:center;
        align-items:center;
        font-weight:bold;
    }

    .logout-btn{
        width:100%;
        padding:10px;
        border:1px solid #f44336;
        background:transparent;
        color:#ff5252;
        border-radius:5px;
        cursor:pointer;
    }

    .logout-btn:hover{
        background:#f44336;
        color:white;
    }
</style>

<nav class="sidebar">

    <div class="sidebar-header">
        <div class="logo-box">🛒</div>
        <div class="brand-name">Quản Lý Bán Hàng</div>
    </div>

    <ul class="nav-links">
        <li><a href="quanlinhanvien">Quản lý nhân viên</a></li>
        <li ><a href="index.jsp">Đơn hàng</a></li>
        <li><a href="#">Khách hàng</a></li>
        <li><a href="#">Nhập kho</a></li>
        <li><a href="#">Báo cáo</a></li>
    </ul>

    <div class="sidebar-footer">
        <div class="user-info">
            <div class="avatar">A</div>
            <div>
                <div><b>Admin</b></div>
                <div>Quản trị viên</div>
            </div>
        </div>

   <button class="logout-btn" onclick="window.location.href='index.jsp'">
       Đăng xuất
   </button>
    </div>

</nav>