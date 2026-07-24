<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Thanh Toán QR Code</title>
    <link rel="stylesheet" href="css/qlnv.css?v=2.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body { background: #f8fafc; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        .qr-card { background: white; width: 450px; border-radius: 16px; box-shadow: 0 10px 25px rgba(0,0,0,0.1); overflow: hidden; display: flex; flex-direction: column; text-align: center; }
        .qr-header { background: #2d6652; color: white; padding: 20px; font-size: 20px; font-weight: 700; }
        .qr-body { padding: 30px 20px; }
        .amount-text { font-size: 28px; font-weight: 800; color: #ef4444; margin: 15px 0; }
        .qr-image-container { border: 2px dashed #cbd5e1; padding: 15px; border-radius: 12px; display: inline-block; margin-bottom: 20px; }
        .qr-image-container img { width: 250px; border-radius: 8px; }
        .waiting-text { display: flex; align-items: center; justify-content: center; gap: 10px; color: #64748b; font-weight: 600; font-size: 15px; }
        .spinner { border: 3px solid rgba(0,0,0,0.1); width: 20px; height: 20px; border-radius: 50%; border-left-color: #2d6652; animation: spin 1s linear infinite; }
        @keyframes spin { 0% { transform: rotate(0deg); } 100% { transform: rotate(360deg); } }
        .btn-test { background: #f1f5f9; color: #334155; border: 1px solid #cbd5e1; padding: 10px 15px; border-radius: 6px; cursor: pointer; font-weight: 600; margin-top: 20px; transition: 0.2s; }
        .btn-test:hover { background: #e2e8f0; }
        .back-link { display: inline-block; margin-top: 15px; color: #64748b; text-decoration: none; font-size: 14px; font-weight: 600; }
        .back-link:hover { color: #1e293b; text-decoration: underline; }
    </style>
</head>
<body>

<%
    String id = request.getParameter("id");
    String amountStr = request.getParameter("amount");
    long amount = 0;
    try {
        amount = (long) Double.parseDouble(amountStr);
    } catch(Exception e){}
    
    // Sử dụng API VietQR để tạo mã QR Ngân hàng thật
    // Định dạng: https://img.vietqr.io/image/<BANK_ID>-<ACCOUNT_NO>-<TEMPLATE>.png?amount=<AMOUNT>&addInfo=<CONTENT>&accountName=<ACCOUNT_NAME>
    // Ở đây dùng ngân hàng MBBank, số tài khoản ảo/mặc định làm demo.
    String bankId = "mb"; 
    String accountNo = "0349448259"; // Số tài khoản demo
    String accountName = java.net.URLEncoder.encode("CUA HANG SACH", "UTF-8");
    String addInfo = java.net.URLEncoder.encode("Thanh toan HD " + id, "UTF-8");
    String qrUrl = "https://img.vietqr.io/image/" + bankId + "-" + accountNo + "-compact2.png?amount=" + amount + "&addInfo=" + addInfo + "&accountName=" + accountName;
%>

<div class="qr-card">
    <div class="qr-header">
        <i class="fas fa-qrcode"></i> QUÉT MÃ XÁC NHẬN (DEMO)
    </div>
    <div class="qr-body">
        <div style="color: #475569; font-size: 15px;">Mã Hóa Đơn: <strong>#<%= id %></strong></div>
        <div class="amount-text"><fmt:formatNumber value="<%= amount %>" type="currency" currencySymbol="đ" maxFractionDigits="0"/></div>
        
        <div class="qr-image-container">
            <img src="<%= qrUrl %>" alt="QR Code Ngân Hàng" style="width: 250px;">
        </div>
        
        <div class="waiting-text">
            <div class="spinner"></div> Đang chờ khách quét mã thanh toán...
        </div>
        
        <button class="btn-test" onclick="simulatePayment()"><i class="fas fa-bolt"></i> (Test) Mô Phỏng Khách Đã Quét Xong</button>
        <br>
        <a href="banhang" class="back-link"><i class="fas fa-arrow-left"></i> Quay lại bán hàng</a>
    </div>
</div>

<script>
    const maHD = <%= id %>;
    
    // Polling API mỗi 2 giây
    let pollInterval = setInterval(() => {
        fetch('api/check-payment?maHD=' + maHD)
            .then(res => res.json())
            .then(data => {
                if(data.status === 1) { // 1 = Đã thanh toán
                    clearInterval(pollInterval);
                    window.location.href = 'quanlyhoadon?action=viewDetail&id=' + maHD + '&fromPOS=1';
                }
            })
            .catch(err => console.log(err));
    }, 2000);

    // Tự động báo thành công sau 5 giây (Mô phỏng Webhook ngân hàng đổ về)
    setTimeout(() => {
        simulatePayment();
    }, 5000);
    
    // Hàm mô phỏng webhook
    function simulatePayment() {
        const btn = document.querySelector('.btn-test');
        btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang xử lý...';
        btn.disabled = true;
        
        let formData = new FormData();
        formData.append("maHD", maHD);
        
        fetch('api/simulate-payment', {
            method: 'POST',
            body: new URLSearchParams(formData)
        })
        .then(res => res.json())
        .then(data => {
            // Khi webhook xử lý xong, DB cập nhật status = 1.
            // Lần polling tiếp theo sẽ tự động nhận diện và redirect.
            btn.innerHTML = '<i class="fas fa-check"></i> Chờ vài giây...';
        })
        .catch(err => {
            btn.innerHTML = 'Lỗi!';
        });
    }
</script>

</body>
</html>
