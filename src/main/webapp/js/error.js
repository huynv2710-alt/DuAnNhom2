console.log("error.js loaded");

document.addEventListener("DOMContentLoaded", function () {
    console.log("DOM loaded");

    const errorMsg = document.getElementById("error-msg");
    console.log(errorMsg);

    document.querySelectorAll("input").forEach(input => {
        input.addEventListener("input", () => {
            console.log("typing...");
            errorMsg.style.display = "none";
        });
    });
});