<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page isELIgnored="false" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Quên mật khẩu</title>
<link rel="stylesheet" href="css/forgotpass.css">
<script src="js/error.js"></script>
</head>

<body>
<div class="box">
<h2>QUÊN MẬT KHẨU</h2>
<form action="ForgotPasswordServlet" method="post">
    <input type="text" name="username" placeholder="Tên đăng nhập">
    <input type="email" name="email" placeholder="Email">

    <c:if test="${not empty error}">
        <div class="error" id="error-msg">${error}</div>
    </c:if>

    <button type="submit">Lấy mật khẩu</button>
</form>

<a href="index.jsp">← Quay lại đăng nhập</a>

</div>
</body>
</html>