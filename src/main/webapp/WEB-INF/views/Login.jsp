<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Login | SkillAcademy</title>

<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600&family=Outfit:wght@600;700;800&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<style>
    :root {
        --navy-deep: #0f172a;       
        --primary-blue: #2563eb;    
        --bg-slate: #f1f5f9;        
        --text-muted: #64748b;
    }

    body {
        margin: 0; padding: 0;
        font-family: 'Inter', sans-serif;
        background-color: var(--bg-slate);
        background-image: 
            radial-gradient(at 0% 0%, rgba(15, 23, 42, 0.05) 0px, transparent 50%),
            radial-gradient(at 100% 100%, rgba(37, 99, 235, 0.05) 0px, transparent 50%);
        display: flex; justify-content: center; align-items: center;
        height: 100vh;
    }

    .login-container { width: 100%; max-width: 440px; padding: 20px; }

    .login-card {
        background: #ffffff;
        border-radius: 32px;
        padding: 45px;
        box-shadow: 0 20px 40px rgba(15, 23, 42, 0.08);
        border: 1px solid rgba(15, 23, 42, 0.05);
        position: relative;
        overflow: hidden;
    }

    .login-card::before {
        content: ''; position: absolute; top: 0; left: 0; right: 0;
        height: 5px; background: linear-gradient(to right, var(--navy-deep), var(--primary-blue));
    }

    /* --- AUTHENTICATION FLOW ICONS --- */
    .auth-flow {
        display: flex; align-items: center; justify-content: center;
        gap: 12px; margin-bottom: 25px;
    }

    .flow-icon {
        width: 42px; height: 42px; border-radius: 12px;
        background: #f1f5f9; color: var(--navy-deep);
        display: flex; align-items: center; justify-content: center;
        font-size: 1.1rem; border: 1px solid #e2e8f0;
    }

    .flow-icon.active {
        background: var(--navy-deep); color: white; border-color: var(--navy-deep);
    }

    .flow-arrow {
        color: var(--primary-blue); font-size: 0.9rem;
        animation: flowMove 1.5s infinite;
    }

    @keyframes flowMove {
        0% { transform: translateX(-3px); opacity: 0.4; }
        50% { transform: translateX(3px); opacity: 1; }
        100% { transform: translateX(-3px); opacity: 0.4; }
    }

    .header-section { text-align: center; margin-bottom: 35px; }

    h1 {
        font-family: 'Outfit', sans-serif; font-weight: 800;
        color: var(--navy-deep); font-size: 1.8rem; margin: 0;
    }

    .subtitle { color: var(--text-muted); font-size: 0.9rem; margin-top: 5px; }

    .form-group { margin-bottom: 22px; }

    .form-group label {
        display: block; font-size: 0.75rem; font-weight: 700;
        text-transform: uppercase; letter-spacing: 0.05rem;
        color: var(--navy-deep); margin-bottom: 10px; padding-left: 4px;
    }

    .input-wrapper { position: relative; display: flex; align-items: center; }

    .input-wrapper i {
        position: absolute; left: 18px; color: var(--primary-blue); font-size: 1rem;
    }

    input[type="text"], input[type="password"] {
        width: 100%; height: 54px;
        background: #f8fafc; border: 2px solid #f1f5f9;
        border-radius: 16px; padding: 0 16px 0 52px;
        color: var(--navy-deep); font-size: 1rem;
        transition: 0.3s; box-sizing: border-box;
    }

    input:focus {
        outline: none; border-color: var(--primary-blue);
        background: #ffffff; box-shadow: 0 0 0 5px rgba(37, 99, 235, 0.08);
    }

    .login-btn {
        width: 100%; height: 54px;
        background: var(--navy-deep); color: white;
        border: none; border-radius: 16px;
        font-weight: 700; font-size: 1rem;
        cursor: pointer; margin-top: 10px;
        transition: 0.3s; display: flex;
        align-items: center; justify-content: center; gap: 12px;
    }

    .login-btn:hover {
        background: var(--primary-blue);
        transform: translateY(-2px);
        box-shadow: 0 10px 20px rgba(37, 99, 235, 0.2);
    }

    .footer-links {
        margin-top: 30px; display: flex;
        flex-direction: column; gap: 12px; text-align: center;
    }

    .link-item {
        color: var(--text-muted); text-decoration: none;
        font-size: 0.85rem; font-weight: 500; transition: 0.2s;
    }

    .link-item:hover { color: var(--navy-deep); }
    .link-item b { color: var(--primary-blue); }

</style>
</head>
<body>

<jsp:include page="toaster_logic.jsp" />

<div class="login-container">
    <div class="login-card">
        
        <div class="auth-flow">
            <div class="flow-icon active" title="Login Credentials">
                <i class="fa-solid fa-user-shield"></i>
            </div>
            <div class="flow-arrow">
                <i class="fa-solid fa-chevron-right"></i>
            </div>
            <div class="flow-icon" title="Dashboard Access">
                <i class="fa-solid fa-rocket"></i>
            </div>
        </div>

        <div class="header-section">
            <h1>Authentication</h1>
            <p class="subtitle">Secure access to SkillAcademy portal</p>
        </div>

        <form action="login" method="post">
            <div class="form-group">
                <label>Institutional Email</label>
                <div class="input-wrapper">
                    <i class="fa-regular fa-envelope"></i>
                    <input type="text" name="email" placeholder="name@example.com" required>
                </div>
            </div>

            <div class="form-group">
                <label>Security Password</label>
                <div class="input-wrapper">
                    <i class="fa-solid fa-lock-open"></i>
                    <input type="password" name="password" placeholder="••••••••" required>
                </div>
            </div>

            <button type="submit" class="login-btn">
                Sign In to Account
                <i class="fa-solid fa-arrow-right-long"></i>
            </button>
        </form>

        <div class="footer-links">
            <a href="forgetPassword" class="link-item">Trouble signing in? <b>Recover Password</b></a>
            <a href="/" class="link-item">New here? <b>Request Access / Signup</b></a>
        </div>
    </div>
</div>

</body>
</html>