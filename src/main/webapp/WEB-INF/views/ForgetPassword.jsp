<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Verify Email | SkillAcademy</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Outfit:wght@600;700;800&display=swap" rel="stylesheet">

    <style>
        :root {
            --navy-deep: #0f172a;       
            --bg-slate: #f1f5f9;        
            --primary-blue: #2563eb;    
            --text-dark: #1e293b;
            --border-subtle: #e2e8f0;
        }

        body {
            background: var(--bg-slate);
            /* Soft gradient background for auth pages */
            background-image: 
                radial-gradient(at 0% 0%, rgba(37, 99, 235, 0.05) 0px, transparent 50%),
                radial-gradient(at 100% 100%, rgba(15, 23, 42, 0.05) 0px, transparent 50%);
            font-family: 'Inter', sans-serif;
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0;
        }

        .auth-card {
            background: #ffffff;
            width: 100%;
            max-width: 450px;
            padding: 50px;
            border-radius: 30px;
            border: 1px solid var(--border-subtle);
            box-shadow: 0 20px 40px rgba(0,0,0,0.05);
            text-align: center;
        }

        .brand-logo {
            font-family: 'Outfit', sans-serif;
            font-weight: 800;
            font-size: 1.5rem;
            color: var(--navy-deep);
            text-decoration: none;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 12px;
            margin-bottom: 35px;
        }

        .icon-circle {
            width: 70px;
            height: 70px;
            background: rgba(37, 99, 235, 0.1);
            color: var(--primary-blue);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.8rem;
            margin: 0 auto 25px;
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0% { transform: scale(1); box-shadow: 0 0 0 0 rgba(37, 99, 235, 0.4); }
            70% { transform: scale(1.05); box-shadow: 0 0 0 15px rgba(37, 99, 235, 0); }
            100% { transform: scale(1); box-shadow: 0 0 0 0 rgba(37, 99, 235, 0); }
        }

        h2 {
            font-family: 'Outfit', sans-serif;
            font-weight: 700;
            color: var(--navy-deep);
            margin-bottom: 10px;
        }

        p {
            color: #64748b;
            font-size: 0.95rem;
            margin-bottom: 35px;
            line-height: 1.5;
        }

        .form-group {
            text-align: left;
            margin-bottom: 25px;
        }

        label {
            font-size: 0.75rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 1px;
            color: var(--text-dark);
            margin-bottom: 10px;
            display: block;
            padding-left: 5px;
        }

        .input-wrapper {
            position: relative;
        }

        .input-wrapper i {
            position: absolute;
            left: 18px;
            top: 50%;
            transform: translateY(-50%);
            color: #94a3b8;
        }

        input[type="email"], input[type="text"] {
            width: 100%;
            background: #f8fafc;
            border: 1px solid var(--border-subtle);
            border-radius: 15px;
            padding: 14px 15px 14px 48px;
            color: var(--text-dark);
            font-size: 1rem;
            transition: 0.2s;
        }

        input:focus {
            outline: none;
            border-color: var(--primary-blue);
            background: #fff;
            box-shadow: 0 0 0 4px rgba(37, 99, 235, 0.1);
        }

        .btn-submit {
            width: 100%;
            background: var(--navy-deep);
            color: white;
            border: none;
            padding: 16px;
            border-radius: 15px;
            font-weight: 700;
            font-size: 1rem;
            transition: 0.3s;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            cursor: pointer;
        }

        .btn-submit:hover {
            background: var(--primary-blue);
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(37, 99, 235, 0.2);
        }

        .back-link {
            display: block;
            margin-top: 25px;
            color: #64748b;
            text-decoration: none;
            font-size: 0.9rem;
            font-weight: 500;
            transition: 0.2s;
        }

        .back-link:hover {
            color: var(--primary-blue);
        }
    </style>
</head>
<body>

<jsp:include page="toaster_logic.jsp" />

<div class="auth-card">
    <a href="index" class="brand-logo">
        <i class="fa-solid fa-layer-group text-primary"></i>
        <span>SKILLACADEMY</span>
    </a>

    <div class="icon-circle">
        <i class="fa-solid fa-paper-plane"></i>
    </div>

    <h2>Verification</h2>
    <p>We'll send a 6-digit one-time password (OTP) to your email to verify your identity.</p>

    <form action="generateOTP" method="post">
        <div class="form-group">
            <label>Email Address</label>
            <div class="input-wrapper">
                <i class="fa-solid fa-envelope"></i>
                <input type="email" name="email" placeholder="name@company.com" required>
            </div>
        </div>

        <button type="submit" class="btn-submit">
            <span>Get OTP Code</span>
            <i class="fa-solid fa-arrow-right-long"></i>
        </button>
    </form>

    <a href="login" class="back-link">
        <i class="fa-solid fa-chevron-left me-1"></i> Back to Login
    </a>
</div>

</body>
</html>