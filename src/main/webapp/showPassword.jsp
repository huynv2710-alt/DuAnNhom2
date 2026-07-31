<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Kết quả tài khoản</title>
<link rel="stylesheet" href="css/forgotpass.css">
</head>

<body>

<div class="box">

    <h2>THÔNG TIN TÀI KHOẢN</h2>

    <c:if test="${not empty message}">
        <div class="msg">
            ${message}
        </div>
    </c:if>

    <a href="index.jsp">← Quay lại đăng nhập</a>

</div>

</body>
</html>