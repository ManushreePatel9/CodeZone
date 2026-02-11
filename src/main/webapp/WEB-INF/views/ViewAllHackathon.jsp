<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="com.entity.ProgramEntity"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Discover Hackathons | SkillAcademy</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Outfit:wght@600;700;800&display=swap" rel="stylesheet">

    <style>
        :root {
            --navy-deep: #0f172a;       
            --bg-slate: #f8fafc;        
            --primary-blue: #2563eb;    
            --text-dark: #1e293b;
            --text-muted: #64748b;
            --border-subtle: #e2e8f0;
        }

        body {
            background-color: var(--bg-slate);
            font-family: 'Inter', sans-serif;
            color: var(--text-dark);
            margin: 0; min-height: 100vh;
        }

        /* --- TOP NAV --- */
        .top-nav {
            background: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(10px);
            border-bottom: 1px solid var(--border-subtle);
            padding: 0.8rem 2rem;
            position: sticky; top: 0; z-index: 1000;
        }

        .brand-logo {
            font-family: 'Outfit', sans-serif; font-weight: 800; font-size: 1.3rem;
            color: var(--navy-deep); text-decoration: none; display: flex; align-items: center; gap: 10px;
        }

        /* --- DASHBOARD GRID --- */
        .dashboard-container {
            max-width: 1400px; margin: 0 auto; padding: 30px 20px;
        }

        .layout-grid {
            display: grid;
            grid-template-columns: 280px 1fr;
            gap: 30px; align-items: start;
        }

        /* --- SIDEBAR: Navy Floating --- */
        .action-sidebar {
            background: var(--navy-deep);
            border-radius: 24px; padding: 30px 15px;
            color: white; box-shadow: 0 10px 25px rgba(15, 23, 42, 0.15);
            position: sticky; top: 100px;
        }

        .menu-label {
            font-size: 0.65rem; font-weight: 700; text-transform: uppercase;
            letter-spacing: 1.2px; color: #94a3b8; margin-bottom: 20px;
            display: block; padding-left: 15px;
        }

        .nav-pill-custom {
            display: flex; align-items: center; gap: 12px;
            padding: 12px 18px; color: #cbd5e1;
            text-decoration: none; border-radius: 12px;
            margin-bottom: 5px; font-weight: 500; font-size: 0.9rem;
            transition: 0.2s;
        }

        .nav-pill-custom:hover { background: rgba(255, 255, 255, 0.05); color: white; }

        .nav-pill-custom.active {
            background: var(--primary-blue) !important; color: white !important;
            box-shadow: 0 4px 12px rgba(37, 99, 235, 0.2);
        }

        /* --- HACKATHON CARDS --- */
        .hack-card {
            background: #ffffff; border: 1px solid var(--border-subtle);
            border-radius: 24px; overflow: hidden; transition: 0.3s;
            height: 100%; display: flex; flex-direction: column;
        }

        .hack-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 24px rgba(15, 23, 42, 0.08);
            border-color: var(--primary-blue);
        }

        .card-banner {
            height: 150px; background-size: cover; background-position: center;
            position: relative;
        }

        .mode-badge {
            position: absolute; top: 15px; left: 15px;
            background: white; color: var(--navy-deep);
            font-size: 10px; font-weight: 800; padding: 4px 12px;
            border-radius: 8px; text-transform: uppercase;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        }

        .card-body-content { padding: 25px; flex-grow: 1; }

        .hack-title {
            font-family: 'Outfit', sans-serif; font-size: 1.2rem;
            font-weight: 700; color: var(--navy-deep);
            text-decoration: none; margin-bottom: 8px; display: block;
        }

        .college-tag {
            color: var(--text-muted); font-size: 0.85rem;
            display: flex; align-items: center; gap: 6px; margin-bottom: 15px;
        }

        .meta-grid {
            display: grid; grid-template-columns: 1fr 1fr;
            gap: 15px; padding-top: 15px; border-top: 1px solid var(--border-subtle);
        }

        .meta-box b {
            display: block; font-size: 10px; text-transform: uppercase;
            color: var(--primary-blue); margin-bottom: 2px;
        }

        .meta-box span { font-size: 0.85rem; font-weight: 600; color: var(--navy-deep); }

        .btn-view {
            background: var(--navy-deep); color: white;
            border-radius: 12px; font-weight: 700; font-size: 0.8rem;
            padding: 12px; width: 100%; margin-top: 20px;
            border: none; transition: 0.3s;
        }

        .btn-view:hover { background: var(--primary-blue); }

        .price-free { color: #10b981 !important; }

        @media (max-width: 992px) {
            .layout-grid { grid-template-columns: 1fr; }
            .action-sidebar { position: static; margin-bottom: 20px; }
        }
    </style>
</head>
<body>

    <nav class="top-nav">
        <div class="container-fluid d-flex justify-content-between align-items-center">
            <a href="pDashboard" class="brand-logo">
                <i class="fa-solid fa-cube text-primary"></i>
                <span>SKILLACADEMY</span>
            </a>
            <div class="d-flex align-items-center gap-3">
                <span class="small fw-bold text-muted">${user.firstName}</span>
                <div class="bg-navy-deep text-white rounded-circle d-flex align-items-center justify-content-center" 
                     style="width:35px; height:35px; background:var(--navy-deep); font-size: 0.8rem; font-weight: 700;">
                    ${user.firstName.substring(0,1).toUpperCase()}
                </div>
            </div>
        </div>
    </nav>

    <div class="dashboard-container">
        <div class="layout-grid">
            
            <aside class="action-sidebar">
                <span class="menu-label">Explorer Menu</span>
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
                        <i class="fa-solid fa-id-card"></i> My Profile
                    </a>
                </nav>
                <hr style="border-color: rgba(255,255,255,0.1); margin: 25px 0;">
                <a href="logout" class="nav-pill-custom text-danger">
                    <i class="fa-solid fa-power-off"></i> Sign Out
                </a>
            </aside>

            <main>
                <div class="mb-4">
                    <h2 class="fw-bold m-0" style="font-family: 'Outfit';">Live Opportunities</h2>
                    <p class="text-muted">Find the perfect hackathon to showcase your skills.</p>
                </div>

                <div class="mb-4">
                    <jsp:include page="FilterSection.jsp"></jsp:include>
                </div>

                <div class="row g-4">
                    <%
                    List<ProgramEntity> list = (List<ProgramEntity>)request.getAttribute("hackathons");
                    if(list != null && !list.isEmpty()){
                        for(ProgramEntity h : list){
                            String mode = (h.getDetails() != null) ? h.getDetails().getMode() : "N/A";
                            String college = (h.getDetails() != null) ? h.getDetails().getCollege() : "N/A";
                            Integer fees = (h.getDetails() != null) ? h.getDetails().getFees() : 0;
                    %>
                    <div class="col-lg-4 col-md-6">
                        <div class="hack-card">
                            <div class="card-banner" style="background-image: url('<%= (h.getPic() != null && !h.getPic().isEmpty()) ? h.getPic() : "https://images.unsplash.com/photo-1517245386807-bb43f82c33c4?q=80&w=400&h=150&fit=crop" %>')">
                                <span class="mode-badge"><%= mode %></span>
                            </div>

                            <div class="card-body-content">
                                <a href="viewHackathon?pid=<%=h.getProgramId()%>" class="hack-title"><%=h.getProgramName()%></a>
                                <div class="college-tag">
                                    <i class="fa-solid fa-building-columns"></i> <%= college %>
                                </div>

                                <div class="meta-grid">
                                    <div class="meta-box">
                                        <b>Location</b>
                                        <span><%=h.getCity()%></span>
                                    </div>
                                    <div class="meta-box">
                                        <b>Entry Fee</b>
                                        <span class="<%= (fees == 0) ? "price-free" : "" %>">
                                            <%= (fees != null && fees > 0 ? "₹" + fees : "FREE") %>
                                        </span>
                                    </div>
                                </div>
                                
                                <a href="viewHackathon?pid=<%=h.getProgramId()%>" class="btn btn-view">
                                    View Details
                                </a>
                            </div>
                        </div>
                    </div>
                    <% }} else { %>
                    <div class="col-12 text-center py-5">
                        <i class="fa-solid fa-folder-open fa-3x text-muted mb-3"></i>
                        <h5>No hackathons found matching your filters.</h5>
                        <a href="viewAllHackathon" class="btn btn-primary mt-2">Reset Filters</a>
                    </div>
                    <% } %>
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
        });
    </script>
</body>
</html>