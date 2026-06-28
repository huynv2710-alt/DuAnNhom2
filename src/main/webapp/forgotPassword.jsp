<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page isELIgnored="false" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Quên mật khẩu</title>

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
        max-width: 420px;
        background: white;
        padding: 40px 35px;
        border-radius: 12px;
        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
        text-align: center;
        border: 1px solid #e0e0e0;
    }

    h2 {
        color: #1e3a2f;
        font-size: 2.2rem;
        margin-bottom: 25px;
        font-weight: 700;
    }

    input {
        width: 100%;
        padding: 14px 16px;
        margin: 12px 0;
        border: 2px solid #ddd;
        border-radius: 8px;
        font-size: 1rem;
        transition: all 0.3s;
    }

    input:focus {
        outline: none;
        border-color: #1e3a2f;
        box-shadow: 0 0 0 3px rgba(30, 58, 47, 0.1);
    }

    button {
        width: 100%;
        padding: 14px;
        background: #1e3a2f;
        color: white;
        border: none;
        border-radius: 8px;
        font-size: 1.1rem;
        font-weight: 600;
        margin-top: 10px;
        cursor: pointer;
        transition: all 0.3s;
    }

    button:hover {
        background: #2e5c4a;
        transform: translateY(-2px);
    }

    .error {
        color: #d32f2f;
        margin: 10px 0;
        font-size: 0.95rem;
        min-height: 20px;
    }

    a {
        color: #2e5c4a;
        text-decoration: none;
        font-size: 0.95rem;
        display: inline-block;
        margin-top: 20px;
    }

    a:hover {
        text-decoration: underline;
        color: #1e3a2f;
    }
</style>
</head>

<body>
<div class="box">
<h2>QUÊN MẬT KHẨU</h2>
<form action="ForgotPasswordServlet" method="post">
    <input type="text" name="username" placeholder="Tên đăng nhập">
    <input type="email" name="email" placeholder="Email">

    <c:if test="${not empty error}">
        <div class="error">${error}</div>
    </c:if>

    <button type="submit">Lấy mật khẩu</button>
</form>

<a href="index.jsp">← Quay lại đăng nhập</a>

</div>
</body>
</html>