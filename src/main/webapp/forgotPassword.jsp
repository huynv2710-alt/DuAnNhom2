<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page isELIgnored="false" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Quên mật khẩu</title>

<style>
body {
    margin: 0;
    font-family: Arial;
    background: #1f3d2b; /* giống login */
    display: flex;
    justify-content: center;
    align-items: center;
    height: 100vh;
}

.box {
    width: 360px;
    background: #ffffff;
    padding: 30px;
    border-radius: 10px;
    text-align: center;
}

h2 {
    color: #1f3d2b;
}

input {
    width: 100%;
    padding: 10px;
    margin: 8px 0;
    border: 1px solid #ccc;
    border-radius: 6px;
}

button {
    width: 100%;
    padding: 10px;
    background: #1f3d2b;
    color: white;
    border: none;
    border-radius: 6px;
}

button:hover {
    background: #14532d;
}

.error {
    color: red;
    margin-top: 10px;
}

a {
    display: block;
    margin-top: 15px;
    color: #1f3d2b;
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