console.log("error.js loaded");

document.addEventListener("DOMContentLoaded", function () {
    console.log("DOM loaded");

    const errorMsg = document.getElementById("error-msg");
    console.log(errorMsg);

    document.querySelectorAll("input").forEach(input => {
        input.addEventListener("input", () => {
            console.log("typing...");
            if (errorMsg) errorMsg.style.display = "none";
        });
    });

    // Hiệu ứng chuyển cảnh khi submit form đăng nhập
    const loginForm = document.querySelector("form");
    const container = document.querySelector(".container");

    if (loginForm && container) {
        loginForm.addEventListener("submit", function (e) {
            e.preventDefault();

            const submitBtn = loginForm.querySelector("button[type='submit']");
            if (submitBtn) submitBtn.classList.add("loading");

            container.classList.add("fade-out");

            // Đợi animation fade-out chạy xong rồi mới submit form thật
            setTimeout(() => {
                loginForm.submit();
            }, 350);
        });
    }
});