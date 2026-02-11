<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reset Password | SkillAcademy</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Outfit:wght@600;700;800&display=swap" rel="stylesheet">

    <style>
        :root {
            --navy-deep: #0f172a;       
            --bg-slate: #f1f5f9;        
            --primary-blue: #2563eb;    
            --text-dark: #0f172a;
            --border-subtle: #e2e8f0;
        }

        body {
            background-color: var(--bg-slate);
            background-image: radial-gradient(at 0% 0%, rgba(15, 23, 42, 0.05) 0px, transparent 50%);
            font-family: 'Inter', sans-serif;
            display: flex; justify-content: center; align-items: center;
            min-height: 100vh; margin: 0; padding: 20px;
        }

        .reset-container {
            width: 100%; max-width: 450px;
        }

        .reset-card {
            background: #ffffff;
            border-radius: 32px;
            padding: 45px 35px;
            box-shadow: 0 25px 50px -12px rgba(15, 23, 42, 0.1);
            border: 1px solid rgba(15, 23, 42, 0.05);
            position: relative;
            overflow: hidden;
            text-align: center;
        }

        /* Top Accent Line */
        .reset-card::before {
            content: ''; position: absolute; top: 0; left: 0; right: 0;
            height: 6px; background: linear-gradient(to right, var(--navy-deep), var(--primary-blue));
        }

        .icon-circle {
            width: 70px; height: 70px; background: #eff6ff;
            color: var(--primary-blue); border-radius: 20px;
            display: flex; align-items: center; justify-content: center;
            font-size: 1.8rem; margin: 0 auto 25px;
            box-shadow: 0 10px 20px rgba(37, 99, 235, 0.1);
        }

        h2 {
            font-family: 'Outfit', sans-serif; font-weight: 800;
            color: var(--navy-deep); font-size: 1.8rem; margin-bottom: 10px;
        }

        p.subtitle { color: #64748b; font-size: 0.95rem; margin-bottom: 35px; }

        .form-floating > label { font-size: 0.85rem; font-weight: 600; color: #94a3b8; }

        .form-control {
            border-radius: 14px; border: 1.5px solid var(--border-subtle);
            padding: 12px 15px; height: 58px; font-weight: 500;
        }

        .form-control:focus {
            border-color: var(--primary-blue); box-shadow: 0 0 0 4px rgba(37, 99, 235, 0.05);
        }

        .btn-reset {
            width: 100%; height: 55px; background: var(--navy-deep);
            color: white; border: none; border-radius: 14px;
            font-weight: 700; font-size: 1rem; margin-top: 15px;
            transition: 0.3s;
        }

        .btn-reset:hover {
            background: var(--primary-blue); transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(37, 99, 235, 0.2);
        }

        .back-link {
            display: inline-block; margin-top: 25px;
            color: #64748b; text-decoration: none;
            font-size: 0.9rem; font-weight: 600;
        }

        .back-link:hover { color: var(--navy-deep); }
    </style>
</head>
<body>

<jsp:include page="toaster_logic.jsp" />

<div class="reset-container">
    <div class="reset-card">
        
        <div class="icon-circle">
            <i class="fa-solid fa-shield-halved"></i>
        </div>

        <h2>Create New Password</h2>
        <p class="subtitle">Enter the OTP sent to your email and choose a strong password.</p>

        <form action="saveNewPassword" method="post">
            
            <div class="form-floating mb-3">
                <input type="text" class="form-control" name="otp" id="otp" placeholder="Enter OTP" required autocomplete="off">
                <label for="otp"><i class="fa-solid fa-key me-2"></i> Verification OTP</label>
            </div>

            <div class="form-floating mb-4">
                <input type="password" class="form-control" name="newPassword" id="newPass" placeholder="New Password" required>
                <label for="newPass"><i class="fa-solid fa-lock me-2"></i> New Password</label>
            </div>

            <button type="submit" class="btn-reset">
                Update Password <i class="fa-solid fa-arrow-right ms-2"></i>
            </button>
        </form>

        <a href="login.jsp" class="back-link">
            <i class="fa-solid fa-chevron-left me-1"></i> Back to Login
        </a>

    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>