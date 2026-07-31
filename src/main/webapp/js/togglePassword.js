function togglePassword(inputId, iconEl) {
    const input = document.getElementById(inputId);
    if (!input) return;

    if (input.type === "password") {
        input.type = "text";
        iconEl.classList.remove("fa-eye");
        iconEl.classList.add("fa-eye-slash");
    } else {
        input.type = "password";
        iconEl.classList.remove("fa-eye-slash");
        iconEl.classList.add("fa-eye");
    }
}

function toggleRowPassword(index) {
    const mask = document.getElementById("passMask" + index);
    const real = document.getElementById("passReal" + index);
    if (!mask || !real) return;

    const icon = event.target;
    if (real.style.display === "none") {
        mask.style.display = "none";
        real.style.display = "inline";
        icon.classList.remove("fa-eye");
        icon.classList.add("fa-eye-slash");
    } else {
        mask.style.display = "inline";
        real.style.display = "none";
        icon.classList.remove("fa-eye-slash");
        icon.classList.add("fa-eye");
    }
}