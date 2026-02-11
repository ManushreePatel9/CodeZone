<%@page import="com.entity.UserEntity"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile | SkillAcademy</title>
    
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
            background-image: radial-gradient(at 0% 0%, rgba(15, 23, 42, 0.05) 0px, transparent 50%);
            display: flex; justify-content: center; align-items: center;
            min-height: 100vh; padding: 20px;
        }

        .profile-container { width: 100%; max-width: 550px; }

        .profile-card {
            background: #ffffff;
            border-radius: 32px;
            padding: 40px;
            box-shadow: 0 20px 40px rgba(15, 23, 42, 0.08);
            border: 1px solid rgba(15, 23, 42, 0.05);
            position: relative;
            overflow: hidden;
        }

        .profile-card::before {
            content: ''; position: absolute; top: 0; left: 0; right: 0;
            height: 6px; background: linear-gradient(to right, var(--navy-deep), var(--primary-blue));
        }

        /* --- AUTH-STYLE FLOW ICONS --- */
        .status-flow {
            display: flex; align-items: center; justify-content: center;
            gap: 12px; margin-bottom: 30px;
        }

        .flow-icon {
            width: 45px; height: 45px; border-radius: 14px;
            background: var(--navy-deep); color: white;
            display: flex; align-items: center; justify-content: center;
            font-size: 1.2rem;
        }

        .flow-arrow {
            color: var(--primary-blue); font-size: 1rem;
            animation: flowMove 1.5s infinite;
        }

        @keyframes flowMove {
            0% { transform: translateX(-3px); opacity: 0.4; }
            50% { transform: translateX(3px); opacity: 1; }
            100% { transform: translateX(-3px); opacity: 0.4; }
        }

        /* --- PROFILE CONTENT --- */
        .profile-header { text-align: center; margin-bottom: 35px; }
        
        .avatar-circle {
            width: 80px; height: 80px; background: #f1f5f9;
            color: var(--navy-deep); border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            font-size: 2rem; font-weight: 800; font-family: 'Outfit';
            margin: 0 auto 15px; border: 3px solid white;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }

        h1 {
            font-family: 'Outfit', sans-serif; font-weight: 800;
            color: var(--navy-deep); font-size: 1.8rem; margin: 0;
        }

        .badge-domain {
            display: inline-block; padding: 6px 16px; background: rgba(37, 99, 235, 0.1);
            color: var(--primary-blue); border-radius: 50px;
            font-size: 0.85rem; font-weight: 700; margin-top: 10px;
        }

        /* --- DATA GRID --- */
        .info-grid {
            display: grid; grid-template-columns: 1fr 1fr; gap: 20px;
            margin-top: 30px; text-align: left;
        }

        .info-item {
            background: #f8fafc; padding: 15px 20px;
            border-radius: 16px; border: 1px solid #f1f5f9;
        }

        .info-label {
            font-size: 0.7rem; font-weight: 800; color: var(--text-muted);
            text-transform: uppercase; letter-spacing: 0.05rem; margin-bottom: 5px;
        }

        .info-value {
            font-size: 0.95rem; font-weight: 600; color: var(--navy-deep);
            word-break: break-word;
        }

        .full-width { grid-column: span 2; }

        .btn-action {
            width: 100%; height: 52px; background: var(--navy-deep);
            color: white; border: none; border-radius: 14px;
            font-weight: 700; font-size: 1rem; cursor: pointer;
            margin-top: 30px; transition: 0.3s;
            display: flex; align-items: center; justify-content: center; gap: 10px;
            text-decoration: none;
        }

        .btn-action:hover {
            background: var(--primary-blue); transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(37, 99, 235, 0.2);
        }

        .error-card { text-align: center; padding: 40px; color: #ef4444; }
    </style>
</head>
<body>

<%
    UserEntity curUser = (UserEntity) request.getAttribute("curUser");
%>

<div class="profile-container">
    <% if(curUser != null) { %>
        <div class="profile-card">
            
            <div class="status-flow">
                <div class="flow-icon" title="Account Status Active">
                    <i class="fa-solid fa-user-check"></i>
                </div>
                <div class="flow-arrow">
                    <i class="fa-solid fa-chevron-right"></i>
                </div>
                <div class="flow-icon" style="background: var(--primary-blue);" title="Portfolio Verified">
                    <i class="fa-solid fa-award"></i>
                </div>
            </div>

            <div class="profile-header">
                <div class="avatar-circle">
                    <%= curUser.getFirstName().substring(0,1).toUpperCase() %>
                </div>
                <h1><%= curUser.getFirstName() %> <%= curUser.getLastName() %></h1>
                <span class="badge-domain"><i class="fa-solid fa-code me-1"></i> <%= curUser.getDomain() %></span>
            </div>

            <div class="info-grid">
                <div class="info-item full-width">
                    <div class="info-label">College / University</div>
                    <div class="info-value"><%= curUser.getCollege() %></div>
                </div>

                <div class="info-item full-width">
                    <div class="info-label">Email Address</div>
                    <div class="info-value"><%= curUser.getEmail() %></div>
                </div>

                <div class="info-item">
                    <div class="info-label">Primary Skills</div>
                    <div class="info-value"><%= curUser.getTechnology() %></div>
                </div>

                <div class="info-item">
                    <div class="info-label">Experience Role</div>
                    <div class="info-value"><%= curUser.getRole() != null ? curUser.getRole() : "Participant" %></div>
                </div>
            </div>

            <a href="editProfile" class="btn-action">
                <i class="fa-solid fa-user-pen"></i> Update Information
            </a>
            
            <div style="text-align: center; margin-top: 20px;">
                <a href="javascript:history.back()" style="color: var(--text-muted); text-decoration: none; font-size: 0.85rem; font-weight: 600;">
                    <i class="fa-solid fa-arrow-left me-1"></i> Back to Dashboard
                </a>
            </div>
        </div>
    <% } else { %>
        <div class="profile-card error-card">
            <i class="fa-solid fa-circle-exclamation fa-3x mb-3"></i>
            <h3 class="fw-bold">User data not found!</h3>
            <p>We couldn't retrieve your profile. Please try logging in again.</p>
            <a href="login" class="btn-action">Go to Login</a>
        </div>
    <% } %>
</div>

</body>
</html>