<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page isELIgnored="false" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quên mật khẩu - Book Store</title>
    <link rel="stylesheet" href="css/tk.css">
</head>
<body>
    <div class="container">
        <div class="login-box">
            <h1>BOOK STORE</h1>
            <h3>KHÔI PHỤC MẬT KHẨU</h3>

            <form action="ForgotPasswordServlet" method="post">
                <input type="text" name="username" placeholder="Tên đăng nhập" required>
                <input type="email" name="email" placeholder="Email đăng ký" required>

                <c:if test="${not empty error}">
                    <div class="error-box">
                    ⚠️ ${error}
                    </div>
                </c:if>
                <c:if test="${not empty message}">
                    <div class="error-box" style="background:#d4edda; color:#155724; border-color:#c3e6cb;">
                    ✅ ${message}
                    </div>
                </c:if>

                <button type="submit">Lấy lại mật khẩu</button>
            </form>
            
            <a href="index.jsp">← Quay lại đăng nhập</a>
        </div>
    </div>
</body>
</html>