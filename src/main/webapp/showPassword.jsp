<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page isELIgnored="false" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Kết quả tài khoản</title>
<style>
    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
    }

    body {
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        background: linear-gradient(135deg, #1e3a2f 0%, #2e5c4a 100%);
        height: 100vh;
        display: flex;
        align-items: center;
        justify-content: center;
        overflow: hidden;
    }

    .box {
        width: 100%;
        max-width: 460px;
        background: white;
        padding: 45px 40px;
        border-radius: 16px;
        box-shadow: 0 15px 35px rgba(0, 0, 0, 0.25);
        text-align: center;
        color: #1e3a2f;
    }

    h2 {
        color: #1e3a2f;
        font-size: 2.3rem;
        margin-bottom: 30px;
        font-weight: 700;
    }

    .msg {
        margin: 20px 0;
        padding: 20px;
        background: #f0f9f4;
        border: 2px solid #1e3a2f;
        border-radius: 10px;
        color: #1e3a2f;
        font-size: 1.08rem;
        line-height: 1.6;
    }

    a {
        color: #2e5c4a;
        text-decoration: none;
        font-size: 1rem;
        display: inline-block;
        margin-top: 20px;
    }

    a:hover {
        color: #1e3a2f;
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