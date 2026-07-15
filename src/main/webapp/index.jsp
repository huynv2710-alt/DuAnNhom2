<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page isELIgnored="false" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Dang nhap - Book Store</title>
    <link rel="stylesheet" href="css/tk.css">
    <script src="${pageContext.request.contextPath}/js/error.js?v=2"></script>
</head>
<body>
    <div class="container">
        <div class="login-box">
            <h1>BOOK STORE</h1>
            <h3>DANG NHAP HE THONG</h3>

            <form action="LoginServlet" method="post">
                <input type="text" name="username" placeholder="Ten dang nhap" required>
                <input type="password" name="password" placeholder="Mat khau" required>

                <c:if test="${not empty error}">
                    <div class="error-box" id="error-msg">
                    ⚠️ ${error}
                    </div>
                </c:if>

                <button type="submit">Đăng Nhập</button>
            </form>
        </div>
    </div>
</body>
</html>