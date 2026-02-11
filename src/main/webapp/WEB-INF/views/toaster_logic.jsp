<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/toastify-js/src/toastify.min.css">
<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/toastify-js"></script>

<style>
    .toastify {
        font-family: 'Plus Jakarta Sans', sans-serif !important;
        padding: 0 !important;
        border-radius: 14px !important;
        box-shadow: 0 20px 40px rgba(0, 0, 0, 0.4) !important;
        border: 1px solid rgba(255, 255, 255, 0.1) !important;
        max-width: 380px !important;
        overflow: hidden !important;
        opacity: 0;
    }
    .toast-content-wrapper {
        display: flex;
        align-items: center;
        gap: 14px;
        padding: 16px 20px;
        position: relative;
        z-index: 1;
    }
    .toast-progress-bar {
        position: absolute;
        bottom: 0;
        left: 0;
        height: 3px;
        width: 100%;
        transform-origin: left;
    }
    .toast-premium-success {
        background: rgba(10, 25, 20, 0.95) !important;
        backdrop-filter: blur(15px) !important;
    }
    .toast-premium-success .toast-progress-bar {
        background: #10b981;
        animation: toast-progress-anim 4s linear forwards;
    }
    .toast-premium-error {
        background: rgba(30, 10, 10, 0.95) !important;
        backdrop-filter: blur(15px) !important;
    }
    .toast-premium-error .toast-progress-bar {
        background: #ef4444;
        animation: toast-progress-anim 4s linear forwards;
    }
    .toastify.on {
        animation: toast-fly-in 0.6s cubic-bezier(0.22, 1, 0.36, 1) forwards !important;
    }
    @keyframes toast-fly-in {
        0% { transform: translateX(100%) scale(0.9); opacity: 0; }
        100% { transform: translateX(0) scale(1); opacity: 1; }
    }
    @keyframes toast-progress-anim {
        from { transform: scaleX(1); }
        to { transform: scaleX(0); }
    }
    .toast-text {
        color: #ffffff !important;
        font-size: 14px;
        font-weight: 600;
        letter-spacing: 0.3px;
    }
    .icon-box {
        display: flex;
        align-items: center;
        justify-content: center;
        width: 32px;
        height: 32px;
        border-radius: 10px;
        flex-shrink: 0;
    }
</style>

<script>
    const Alert = {
        success: function(message) {
            const html = `
                <div class="toast-content-wrapper">
                    <div class="icon-box" style="background: rgba(16, 185, 129, 0.15);">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#10b981" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"></polyline></svg>
                    </div>
                    <div class="toast-text">\${message}</div>
                    <div class="toast-progress-bar"></div>
                </div>`;
            this.show(html, "toast-premium-success");
        },
        error: function(message) {
            const html = `
                <div class="toast-content-wrapper">
                    <div class="icon-box" style="background: rgba(239, 68, 68, 0.15);">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#ef4444" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><line x1="15" y1="9" x2="9" y2="15"></line><line x1="9" y1="9" x2="15" y2="15"></line></svg>
                    </div>
                    <div class="toast-text">\${message}</div>
                    <div class="toast-progress-bar"></div>
                </div>`;
            this.show(html, "toast-premium-error");
        },
        show: function(html, className) {
            Toastify({
                text: html,
                duration: 4000,
                gravity: "top",
                position: "right",
                className: className,
                escapeMarkup: false,
                close: false
            }).showToast();
        }
    };

    document.addEventListener('DOMContentLoaded', function() {
        // --- 1. Model / Request Attributes (Forward) ---
        let successMsg = "<%= (request.getAttribute("m") != null) ? request.getAttribute("m") : "" %>";
        let errorMsg = "<%= (request.getAttribute("e") != null) ? request.getAttribute("e") : "" %>";

        // --- 2. URL Parameters (Redirect) ---
        const urlParams = new URLSearchParams(window.location.search);
        const msgParam = urlParams.get('msg');

        if (msgParam === "success") {
            successMsg = "Action completed successfully!";
        } else if (msgParam === "error") {
            errorMsg = "An error occurred. Please try again.";
        } else if (msgParam === "regSuccess") {
            successMsg = "Team Registered successfully!";
        }

        // --- 3. Execute Alerts ---
        if (successMsg.trim() !== "") Alert.success(successMsg);
        if (errorMsg.trim() !== "") Alert.error(errorMsg);
    });
</script>