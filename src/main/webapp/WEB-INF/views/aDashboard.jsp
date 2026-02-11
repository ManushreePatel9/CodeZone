<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Hub | SkillAcademy</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Outfit:wght@600;700;800&display=swap" rel="stylesheet">

    <style>
        :root {
            --navy-deep: #0f172a;       
            --bg-slate: #f1f5f9;        
            --primary-blue: #2563eb;    
            --text-dark: #0f172a;
            --text-muted: #64748b;
            --border-subtle: #e2e8f0;
        }

        body {
            background-color: var(--bg-slate);
            font-family: 'Inter', sans-serif;
            color: var(--text-dark);
            margin: 0;
            min-height: 100vh;
        }

        /* Top Navigation */
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
            align-items: center;
            gap: 10px;
        }

        .brand-logo i { color: var(--primary-blue); }

        /* Dashboard Alignment Container */
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

        /* SIDEBAR: Navy Card */
        .action-sidebar {
            background: var(--navy-deep);
            border-radius: 28px;
            padding: 40px 25px;
            color: white;
            box-shadow: 0 15px 35px rgba(15, 23, 42, 0.2);
            display: flex;
            flex-direction: column;
        }

        .menu-label {
            font-size: 0.7rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 1.5px;
            color: #94a3b8;
            margin-bottom: 25px;
            display: block;
            padding-left: 12px;
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
            font-size: 0.95rem;
            transition: all 0.2s ease;
        }

        .nav-pill-custom:hover {
            background: rgba(255, 255, 255, 0.08);
            color: white;
            transform: translateX(5px);
        }

        .nav-pill-custom.active {
            background: var(--primary-blue);
            color: white;
            box-shadow: 0 8px 20px rgba(37, 99, 235, 0.3);
        }

        /* MAIN CONTENT: White Card */
        .hero-card {
            background: #ffffff;
            border-radius: 28px;
            padding: 50px;
            border: 1px solid var(--border-subtle);
            box-shadow: 0 4px 20px rgba(0,0,0,0.03);
            height: 100%; 
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        .welcome-badge {
            background: #eff6ff;
            color: var(--primary-blue);
            padding: 6px 14px;
            border-radius: 8px;
            font-size: 0.8rem;
            font-weight: 700;
            display: inline-block;
            margin-bottom: 25px;
            width: fit-content;
            text-transform: uppercase;
        }

        .hero-card h1 {
            font-family: 'Outfit', sans-serif;
            font-weight: 700;
            font-size: 2.8rem;
            color: var(--navy-deep);
            margin-bottom: 15px;
        }

        .quote-box {
            background: #f8fafc;
            border-radius: 20px;
            padding: 35px;
            border-left: 6px solid var(--navy-deep);
            margin: 30px 0;
        }

        .quote-box p {
            font-size: 1.3rem;
            line-height: 1.6;
            color: #334155;
            font-weight: 500;
            margin: 0;
            font-style: italic;
        }

        /* Profile & Status */
        .profile-chip {
            background: #fff;
            padding: 6px 16px;
            border-radius: 50px;
            display: flex;
            align-items: center;
            gap: 10px;
            border: 1px solid var(--border-subtle);
        }

        .avatar {
            width: 32px; height: 32px;
            background: var(--navy-deep);
            color: white;
            border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            font-size: 0.8rem; font-weight: bold;
            text-transform: uppercase;
        }

        .status-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 40px;
            padding-top: 25px;
            border-top: 1px solid var(--border-subtle);
        }

        .status-text {
            display: flex;
            align-items: center;
            gap: 8px;
            font-weight: 600;
            color: #059669; 
        }

        .dot { width: 8px; height: 8px; background: #10b981; border-radius: 50%; }

        @media (max-width: 992px) {
            .admin-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>

<body>

    <jsp:include page="toaster_logic.jsp" />

    <nav class="top-nav">
        <div class="container-fluid d-flex justify-content-between align-items-center">
            <a href="adminDashboard" class="brand-logo">
                <i class="fa-solid fa-layer-group"></i>
                <span>SKILLACADEMY</span>
            </a>
            
            <div class="profile-chip">
                <span class="small fw-bold">${user.firstName} (${user.role})</span>
                <div class="avatar">${user.firstName.substring(0,1)}</div>
            </div>
        </div>
    </nav>

    <div class="dashboard-container">
        <div class="admin-grid">
            
            <aside class="action-sidebar">
                <span class="menu-label">Main Menu</span>
                <nav>
                    <a href="adminDashboard" class="nav-pill-custom active">
                        <i class="fa-solid fa-chart-pie"></i> Overview
                    </a>
                    
                    <a href="addHackathon" class="nav-pill-custom">
                        <i class="fa-solid fa-plus-circle"></i> Add Hackathon
                    </a>
                    
                    <a href="viewAllHackathon" class="nav-pill-custom">
                        <i class="fa-solid fa-folder-tree"></i> Browse Hackathons
                    </a>
                    
                    <a href="addJudgeForm" class="nav-pill-custom">
                        <i class="fa-solid fa-user-check"></i> Assign Judges
                    </a>
                </nav>

                <hr class="my-auto" style="border-color: rgba(255,255,255,0.1); margin-top: 40px; margin-bottom: 20px;">
                
                <a href="logout" class="nav-pill-custom text-danger m-0">
                    <i class="fa-solid fa-power-off"></i> Logout Session
                </a>
            </aside>

            <main class="hero-card">
                <span class="welcome-badge">${user.role} Portal</span>
                <h1>Hello, ${user.firstName}!</h1>
                <p class="text-muted fs-5">Welcome back. Your system overview and quick actions are ready.</p>

                <div class="quote-box">
                    <p>"The best way to predict the future is to invent it. Let's build something impactful today."</p>
                </div>

                <div class="row g-3">
                    <div class="col-md-4">
                        <div class="p-3 border rounded-4 bg-light">
                            <small class="text-muted fw-bold d-block mb-1">Total Hackathons</small>
                            <span class="h4 fw-bold">12 Active</span>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="p-3 border rounded-4 bg-light">
                            <small class="text-muted fw-bold d-block mb-1">Judges Panel</small>
                            <span class="h4 fw-bold">08 Members</span>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="p-3 border rounded-4 bg-light">
                            <small class="text-muted fw-bold d-block mb-1">System Health</small>
                            <span class="h4 fw-bold text-success">Optimal</span>
                        </div>
                    </div>
                </div>

                <div class="status-footer">
                    <div class="status-text">
                        <div class="dot"></div>
                        System Operational
                    </div>
                    <div class="text-muted small">
                        Last Login: Just Now
                    </div>
                </div>
            </main>

        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>