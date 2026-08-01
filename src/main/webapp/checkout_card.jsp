<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Thanh Toán Thẻ POS</title>
    <link rel="stylesheet" href="css/qlnv.css?v=2.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body { background: #f8fafc; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        .qr-card { background: white; width: 450px; border-radius: 16px; box-shadow: 0 10px 25px rgba(0,0,0,0.1); overflow: hidden; display: flex; flex-direction: column; text-align: center; }
        .qr-header { background: #2d6652; color: white; padding: 20px; font-size: 20px; font-weight: 700; }
        .qr-body { padding: 30px 20px; }
        .amount-text { font-size: 28px; font-weight: 800; color: #ef4444; margin: 15px 0; }
        .waiting-text { display: flex; align-items: center; justify-content: center; gap: 10px; color: #64748b; font-weight: 600; font-size: 15px; margin-bottom: 20px; }
        .spinner { border: 3px solid rgba(0,0,0,0.1); width: 20px; height: 20px; border-radius: 50%; border-left-color: #2d6652; animation: spin 1s linear infinite; }
        @keyframes spin { 0% { transform: rotate(0deg); } 100% { transform: rotate(360deg); } }
        .btn-test { background: #2d6652; color: white; border: none; padding: 12px 15px; border-radius: 6px; cursor: pointer; font-weight: 600; font-size: 15px; width: 100%; transition: 0.2s; }
        .btn-test:hover { background: #204c3d; }
        .btn-test:disabled { background: #94a3b8; cursor: not-allowed; }
        .back-link { display: inline-block; margin-top: 15px; color: #64748b; text-decoration: none; font-size: 14px; font-weight: 600; }
        .back-link:hover { color: #1e293b; text-decoration: underline; }
        .card-icon-container { padding: 20px; }
        .card-icon { font-size: 60px; color: #cbd5e1; }
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
%>

<div class="qr-card">
    <div class="qr-header">
        <i class="fas fa-credit-card"></i> THANH TOÁN THẺ POS
    </div>
    <div class="qr-body">
        <div style="color: #475569; font-size: 15px;">Mã Hóa Đơn: <strong>#<%= id %></strong></div>
        <div class="amount-text"><fmt:formatNumber value="<%= amount %>" type="currency" currencySymbol="đ" maxFractionDigits="0"/></div>
        
        <div class="card-icon-container">
            <i class="fas fa-credit-card card-icon"></i>
        </div>
        
        <div class="waiting-text" id="statusText">
            <div class="spinner"></div> Vui lòng quẹt thẻ vào thiết bị mPOS...
        </div>
        
        <button class="btn-test" id="btnConfirm" onclick="simulatePayment()"><i class="fas fa-check"></i> Xác nhận đã quẹt thẻ</button>
        <br>
        <a href="banhang" class="back-link"><i class="fas fa-arrow-left"></i> Quay lại bán hàng (Bỏ qua)</a>
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

    // Hàm mô phỏng quẹt thẻ thành công
    function simulatePayment() {
        const btn = document.getElementById('btnConfirm');
        const statusText = document.getElementById('statusText');
        
        btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang xử lý...';
        btn.disabled = true;
        statusText.innerHTML = '<div class="spinner"></div> Đang giao tiếp với ngân hàng...';
        
        let formData = new FormData();
        formData.append("maHD", maHD);
        
        // Mô phỏng độ trễ quẹt thẻ
        setTimeout(() => {
            fetch('api/simulate-payment', {
                method: 'POST',
                body: new URLSearchParams(formData)
            })
            .then(res => res.json())
            .then(data => {
                statusText.innerHTML = '<i class="fas fa-check-circle" style="color:#22c55e;"></i> Giao dịch thành công!';
                btn.innerHTML = 'Đang chuyển hướng...';
            })
            .catch(err => {
                btn.innerHTML = 'Lỗi kết nối!';
                btn.disabled = false;
            });
        }, 1500);
    }
</script>

</body>
</html>
