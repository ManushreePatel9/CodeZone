<%@page import="com.entity.ProgramEntity"%>
<%@page import="com.entity.RequestEntity"%>
<%@page import="java.util.List"%>
<%@page import="com.entity.UserEntity"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Participant Hub | SkillAcademy</title>

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

        /* --- TOP NAV --- */
        .top-nav {
            background: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(10px);
            border-bottom: 1px solid var(--border-subtle);
            padding: 0.8rem 2.5rem;
            position: sticky; top: 0; z-index: 1000;
        }

        .brand-logo {
            font-family: 'Outfit', sans-serif;
            font-weight: 800; font-size: 1.3rem;
            color: var(--navy-deep); text-decoration: none;
            display: flex; align-items: center; gap: 10px;
        }

        .brand-logo i { color: var(--primary-blue); }

        /* --- DASHBOARD LAYOUT --- */
        .dashboard-container {
            max-width: 1300px;
            margin: 0 auto;
            padding: 40px 25px;
        }

        .layout-grid {
            display: grid;
            grid-template-columns: 280px 1fr;
            gap: 30px;
            align-items: start;
        }

        /* --- SIDEBAR: Navy Floating Card --- */
        .action-sidebar {
            background: var(--navy-deep);
            border-radius: 28px;
            padding: 35px 20px;
            color: white;
            box-shadow: 0 15px 35px rgba(15, 23, 42, 0.2);
            position: sticky; top: 100px;
        }

        .menu-label {
            font-size: 0.7rem; font-weight: 700;
            text-transform: uppercase; letter-spacing: 1.5px;
            color: #94a3b8; margin-bottom: 25px;
            display: block; padding-left: 12px;
        }

        .nav-pill-custom {
            display: flex; align-items: center; gap: 12px;
            padding: 14px 18px; color: #cbd5e1;
            text-decoration: none; border-radius: 14px;
            margin-bottom: 8px; font-weight: 500; font-size: 0.9rem;
            transition: all 0.2s ease;
        }

        .nav-pill-custom:hover {
            background: rgba(255, 255, 255, 0.08); color: white;
            transform: translateX(5px);
        }

        /* YAHAN ACTIVE STATE DESIGN HAI */
        .nav-pill-custom.active {
            background: var(--primary-blue) !important;
            color: white !important;
            box-shadow: 0 8px 20px rgba(37, 99, 235, 0.3);
        }

        /* --- CONTENT CARDS --- */
        .content-card {
            background: #ffffff;
            border-radius: 28px;
            padding: 40px;
            border: 1px solid var(--border-subtle);
            box-shadow: 0 4px 20px rgba(0,0,0,0.02);
            margin-bottom: 30px;
        }

        .welcome-section h1 {
            font-family: 'Outfit', sans-serif;
            font-weight: 800; font-size: 2.2rem;
            color: var(--navy-deep); margin-bottom: 10px;
        }

        .section-title {
            font-family: 'Outfit', sans-serif;
            font-weight: 700; font-size: 1.1rem;
            margin-bottom: 20px; color: var(--navy-deep);
            display: flex; align-items: center; gap: 10px;
        }

        .invite-box {
            background: #f8fafc;
            border: 1px solid var(--border-subtle);
            border-radius: 20px;
            padding: 20px; margin-bottom: 15px;
            transition: 0.3s;
        }
        
        .invite-box:hover { border-color: var(--primary-blue); background: #fff; }

        .btn-navy {
            background: var(--navy-deep); color: white;
            border-radius: 12px; font-weight: 600; padding: 10px 20px;
            text-decoration: none; font-size: 0.85rem; transition: 0.3s;
            border: none;
        }

        .btn-navy:hover { background: var(--primary-blue); transform: translateY(-2px); }

        .btn-outline-custom {
            border: 1px solid var(--border-subtle); color: var(--text-dark);
            border-radius: 12px; padding: 10px 15px;
            text-decoration: none; font-size: 0.85rem; transition: 0.2s;
        }
        
        .btn-outline-custom:hover { background: #fff; border-color: var(--navy-deep); }

        .profile-chip {
            background: #fff; padding: 6px 16px; border-radius: 50px;
            display: flex; align-items: center; gap: 10px;
            border: 1px solid var(--border-subtle);
        }

        .avatar {
            width: 32px; height: 32px; background: var(--navy-deep);
            color: white; border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            font-size: 0.8rem; font-weight: bold; text-transform: uppercase;
        }

        @media (max-width: 992px) {
            .layout-grid { grid-template-columns: 1fr; }
            .action-sidebar { position: static; margin-bottom: 30px; }
        }
    </style>
</head>
<body>

    <jsp:include page="toaster_logic.jsp" />

    <nav class="top-nav">
        <div class="container-fluid d-flex justify-content-between align-items-center">
            <a href="participantDashboard" class="brand-logo">
                <i class="fa-solid fa-cube"></i>
                <span>SKILLACADEMY</span>
            </a>
            <div class="profile-chip">
                <span class="small fw-bold">${user.firstName} </span>
                <div class="avatar">${user.firstName.substring(0,1)}</div>
            </div>
        </div>
    </nav>

    <div class="dashboard-container">
        <div class="layout-grid">
            
            <aside class="action-sidebar">
                <span class="menu-label">Navigation Menu</span>
                <nav id="sidebar-nav">
                    <a href="pDashboard" class="nav-pill-custom">
                        <i class="fa-solid fa-house"></i> Overview Hub
                    </a>
                    
                    <a href="viewAllHackathon" class="nav-pill-custom">
                        <i class="fa-solid fa-globe"></i> Browse Hackathons
                    </a>
                    
                    <a href="viewRequests" class="nav-pill-custom">
                        <i class="fa-solid fa-rotate"></i> Sync Requests
                    </a>
                    
                    <a href="dashboard" class="nav-pill-custom">
                        <i class="fa-solid fa-people-group"></i> Manage My Teams
                    </a>
                    
                    <a href="viewMyProfile?userId=${user.userId}" class="nav-pill-custom">
                        <i class="fa-solid fa-id-card"></i> My Professional Profile
                    </a>
                </nav>

                <hr style="border-color: rgba(255,255,255,0.1); margin: 30px 0;">
                
                <a href="logout" class="nav-pill-custom text-danger">
                    <i class="fa-solid fa-arrow-right-from-bracket"></i> Logout Session
                </a>
            </aside>

            <main>
                <div class="content-card welcome-section">
                    <h1>Welcome, ${user.firstName}! 👋</h1>
                    <p class="text-muted">Stay updated with your latest team invitations and hackathon progress.</p>
                </div>

                <%
                    List<RequestEntity> requestsList = (List<RequestEntity>) request.getAttribute("requests");
                    if(requestsList != null && !requestsList.isEmpty()) {
                %>
                <div class="content-card">
                    <div class="section-title">
                        <i class="fa-solid fa-paper-plane text-primary"></i> Pending Invitations
                    </div>
                    <% for(RequestEntity req : requestsList) { 
                        if("pending".equalsIgnoreCase(req.getStatus())) { %>
                        <div class="invite-box">
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <div>
                                    <h6 class="fw-bold m-0" style="font-size: 1.1rem;"><%= req.getTeam().getTeamName() %></h6>
                                    <small class="text-muted">Hackathon: <b><%= req.getProgram().getProgramName() %></b></small>
                                </div>
                                <a href="viewMyProfile?userId=<%= req.getSender().getUserId() %>" class="text-primary" title="View Sender Profile">
                                    <i class="fa-solid fa-user-tag fa-lg"></i>
                                </a>
                            </div>
                            <div class="d-flex gap-2">
                                <a href="acceptRequest?requestId=<%= req.getRequestId() %>&programId=<%= req.getProgram().getProgramId() %>" class="btn-navy">Accept Invite</a>
                                <a href="viewHackathon?pid=<%= req.getProgram().getProgramId() %>" class="btn-outline-custom">Program Info</a>
                                <a href="rejectRequest?requestId=<%= req.getRequestId() %>" class="btn-outline-custom text-danger border-danger">Decline</a>
                            </div>
                        </div>
                    <% } } %>
                </div>
                <% } %>

                <div class="content-card">
                    <div class="section-title">
                        <i class="fa-solid fa-award text-warning"></i> My Active Engagements
                    </div>
                    <div class="row g-3">
                        <%
                            List<ProgramEntity> myHackathons = (List<ProgramEntity>) request.getAttribute("myHackathons");
                            if(myHackathons != null && !myHackathons.isEmpty()) {
                                for(ProgramEntity p : myHackathons) {
                        %>
                        <div class="col-md-6">
                            <a href="viewHackathon?pid=<%= p.getProgramId() %>" class="nav-pill-custom" style="background:#f8fafc; border:1px solid #e2e8f0; color:var(--navy-deep); margin-bottom:0;">
                                <i class="fa-solid fa-microchip text-primary"></i>
                                <span class="fw-bold"><%= p.getProgramName() %></span>
                                <i class="fa-solid fa-arrow-right-long ms-auto opacity-50"></i>
                            </a>
                        </div>
                        <% } } else { %>
                            <div class="col-12 text-center py-5">
                                <div class="opacity-25 mb-3"><i class="fa-solid fa-box-open fa-3x"></i></div>
                                <p class="text-muted small">No active hackathon enrollments found.</p>
                                <a href="viewAllHackathon" class="btn btn-sm btn-outline-primary">Browse Events</a>
                            </div>
                        <% } %>
                    </div>
                </div>
            </main>

        </div>
    </div>

    <script>
        document.addEventListener("DOMContentLoaded", function() {
            const currentUrl = window.location.href;
            const navLinks = document.querySelectorAll(".nav-pill-custom");

            navLinks.forEach(link => {
                if (currentUrl.includes(link.getAttribute("href"))) {
                    link.classList.add("active");
                }
            });
            
            if (currentUrl.endsWith("participantDashboard") || currentUrl.endsWith("participantDashboard.jsp")) {
                document.querySelector('a[href="participantDashboard"]').classList.add("active");
            }
        });
    </script>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>