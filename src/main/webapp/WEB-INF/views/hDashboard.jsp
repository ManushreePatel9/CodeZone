<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Host Dashboard | SkillAcademy</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Outfit:wght@600;700;800&display=swap" rel="stylesheet">

    <style>
        :root {
            --navy-deep: #0f172a;       
            --bg-slate: #f1f5f9;        
            --primary-blue: #2563eb;    
            --text-dark: #1e293b;
            --text-muted: #64748b;
            --border-subtle: #e2e8f0;
            --accent-neon: #00f2fe;
        }

        body {
            background-color: var(--bg-slate);
            font-family: 'Inter', sans-serif;
            color: var(--text-dark);
            margin: 0;
            min-height: 100vh;
        }

        /* --- DASHBOARD STRUCTURE --- */
        .top-nav {
            background: #ffffff;
            border-bottom: 1px solid var(--border-subtle);
            padding: 0.8rem 2.5rem;
            position: sticky;
            top: 0;
            z-index: 1000;
        }

        .brand-logo {
            font-family: 'Outfit', sans-serif;
            font-weight: 800;
            font-size: 1.3rem;
            color: var(--navy-deep);
            text-decoration: none;
            display: flex;
            align-items: center; gap: 10px;
        }

        .dashboard-container {
            max-width: 1250px;
            margin: 0 auto;
            padding: 60px 25px;
        }

        .admin-grid {
            display: grid;
            grid-template-columns: 280px 1fr;
            gap: 30px;
            align-items: stretch;
        }

        /* --- SIDEBAR --- */
        .action-sidebar {
            background: var(--navy-deep);
            border-radius: 28px;
            padding: 40px 25px;
            color: white;
            box-shadow: 0 15px 35px rgba(15, 23, 42, 0.2);
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        .nav-pill-custom {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 14px 18px;
            color: #cbd5e1;
            text-decoration: none;
            border-radius: 14px;
            margin-bottom: 10px;
            font-weight: 500;
            transition: 0.2s;
        }

        .nav-pill-custom:hover {
            background: rgba(255, 255, 255, 0.1);
            color: white;
        }

        .nav-pill-custom.active {
            background: var(--primary-blue);
            color: white;
        }

        /* --- WELCOME CARD --- */
        .welcome-card {
            background: #ffffff;
            border-radius: 28px;
            padding: 60px;
            border: 1px solid var(--border-subtle);
            box-shadow: 0 4px 20px rgba(0,0,0,0.03);
            display: flex;
            flex-direction: column;
            justify-content: center;
            text-align: center;
        }

        .badge-host {
            background: rgba(37, 99, 235, 0.1);
            color: var(--primary-blue);
            padding: 6px 16px;
            border-radius: 50px;
            font-size: 0.75rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 1.5px;
            display: inline-block;
            margin: 0 auto 20px;
        }

        h1 {
            font-family: 'Outfit', sans-serif;
            font-weight: 800;
            font-size: 2.5rem;
            color: var(--navy-deep);
            margin-bottom: 15px;
        }

        .lead-text {
            color: var(--text-muted);
            font-size: 1.1rem;
            max-width: 500px;
            margin: 0 auto 40px;
        }

        /* Sleek Dashboard Links */
        .nav-box {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            max-width: 600px;
            margin: 0 auto;
        }

        .dashboard-link {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            gap: 15px;
            text-decoration: none;
            background: #f8fafc;
            border: 1px solid var(--border-subtle);
            padding: 30px 20px;
            border-radius: 20px;
            transition: 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }

        .dashboard-link i {
            font-size: 2rem;
            color: var(--primary-blue);
        }

        .dashboard-link span {
            font-weight: 600;
            color: var(--navy-deep);
            font-size: 1rem;
        }

        .dashboard-link:hover {
            background: #ffffff;
            border-color: var(--primary-blue);
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(37, 99, 235, 0.1);
        }

        .profile-chip {
            background: #fff;
            padding: 6px 16px;
            border-radius: 50px;
            display: flex;
            align-items: center; gap: 10px;
            border: 1px solid var(--border-subtle);
        }

        .avatar {
            width: 32px; height: 32px;
            background: var(--navy-deep);
            color: white;
            border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            font-size: 0.8rem; font-weight: bold;
        }
    </style>
</head>

<body>

    <jsp:include page="toaster_logic.jsp" />

    <nav class="top-nav">
        <div class="container-fluid d-flex justify-content-between align-items-center">
            <a href="#" class="brand-logo">
                <i class="fa-solid fa-layer-group text-primary"></i>
                <span>SKILLACADEMY</span>
            </a>
            <div class="profile-chip">
                <span class="small fw-bold">${user.firstName} (Host)</span>
                <div class="avatar">${user.firstName.substring(0,1).toUpperCase()}</div>
            </div>
        </div>
    </nav>

    <div class="dashboard-container">
        <div class="admin-grid">
            
            <aside class="action-sidebar">
                <nav>
                    <a href="hostDashboard" class="nav-pill-custom active">
                        <i class="fa-solid fa-house"></i> Overview
                    </a>
                    <a href="addHackathon" class="nav-pill-custom">
                        <i class="fa-solid fa-plus-circle"></i> Create New
                    </a>
                    <a href="viewAllHackathon" class="nav-pill-custom">
                        <i class="fa-solid fa-list-check"></i> My Events
                    </a>
                </nav>
                <hr class="my-5" style="border-color: rgba(255,255,255,0.1);">
                <a href="logout" class="nav-pill-custom text-danger">
                    <i class="fa-solid fa-power-off"></i> Logout
                </a>
            </aside>

            <main class="welcome-card">
                <span class="badge-host">Partner Portal</span>
                <h1>Welcome, ${user.firstName}!</h1>
                <p class="lead-text">Manage your events, track registrations, and reach thousands of talented participants through our platform.</p>
                
                <div class="nav-box">
                    <a href="addHackathon" class="dashboard-link">
                        <i class="fa-solid fa-rocket"></i>
                        <span>Create New Hackathon</span>
                    </a>
                    <a href="viewAllHackathon" class="dashboard-link">
                        <i class="fa-solid fa-gears"></i>
                        <span>Manage Events</span>
                    </a>
                </div>

                <div style="margin-top: 50px; color: var(--text-muted); font-size: 0.8rem; letter-spacing: 0.5px;">
                    SKILLACADEMY HOST PANEL V2.0 • ENTERPRISE EDITION
                </div>
            </main>

        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>