<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page isELIgnored="false" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đăng nhập - Book Store</title>
    <link rel="stylesheet" href="css/tk.css">
</head>
<body>
    <div class="container">
        <div class="login-box">
            <h1>BOOK STORE</h1>
            <h3>ĐĂNG NHẬP HỆ THỐNG</h3>

            <form action="LoginServlet" method="post">
                <input type="text" name="username" placeholder="Tên đăng nhập" required>
                <input type="password" name="password" placeholder="Mật khẩu" required>

                <c:if test="${not empty error}">
                    <div class="error-box">
                    ⚠️ ${error}
                    </div>
                </c:if>

                <button type="submit">Đăng nhập</button>
            </form>

            <a href="forgotPassword.jsp">Quên mật khẩu?</a>
        </div>
    </div>
</body>
</html>