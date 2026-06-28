<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page isELIgnored="false" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Kết quả tài khoản</title>

<style>
body {
    margin: 0;
    font-family: Arial;
    background: #052e16;
    display: flex;
    justify-content: center;
    align-items: center;
    height: 100vh;
}

.box {
    width: 420px;
    background: #0f3d1f;
    padding: 30px;
    border-radius: 12px;
    box-shadow: 0 0 20px rgba(0,0,0,0.5);
    text-align: center;
    color: white;
}

h2 {
    color: #22c55e;
}

.msg {
    margin-top: 15px;
    padding: 12px;
    background: #14532d;
    border-radius: 8px;
    color: #bbf7d0;
}

a {
    display: inline-block;
    margin-top: 20px;
    color: #86efac;
    text-decoration: none;
}

a:hover {
    text-decoration: underline;
}
</style>

</head>

<body>

<div class="box">

    <h2>THÔNG TIN TÀI KHOẢN</h2>


    <div class="msg">
        ${message}
    </div>

    <a href="index.jsp">← Quay lại đăng nhập</a>

</div>

</body>
</html>