<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="com.entity.*" %>
<%@ page import="java.text.SimpleDateFormat" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Judge Dashboard | SkillAcademy</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">

    <style>
        :root {
            --navy-dark: #0f172a;       
            --navy-muted: #1e293b;
            --brand-blue: #2563eb;    
            --bg-body: #f8fafc;
            --white: #ffffff;
            --gold-gradient: linear-gradient(135deg, #f59e0b 0%, #fbbf24 100%);
            --text-main: #334155;
            --border-color: #e2e8f0;
        }

        body { 
            background-color: var(--bg-body); 
            font-family: 'Plus Jakarta Sans', sans-serif; 
            color: var(--text-main); 
            margin: 0; 
        }

        /* --- NAVIGATION --- */
        .top-nav {
            background: var(--white);
            border-bottom: 1px solid var(--border-color);
            padding: 0.75rem 2.5rem;
            position: sticky; top: 0; z-index: 1000;
        }

        .brand-logo {
            font-weight: 800; font-size: 1.3rem;
            color: var(--navy-dark); text-decoration: none; display: flex; align-items: center; gap: 10px;
        }

        /* --- HACKATHON MASTER CARD --- */
        .hackathon-card {
            background: var(--white);
            border-radius: 28px;
            overflow: hidden;
            margin-bottom: 45px;
            box-shadow: 0 15px 40px rgba(0,0,0,0.04);
            border: 1px solid var(--border-color);
        }

        .card-header-premium {
            background: var(--navy-dark);
            color: white;
            padding: 45px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        /* --- MODERN VIEW WINNERS BUTTON (ANIMATED) --- */
        .btn-winners-premium {
            background: var(--gold-gradient);
            color: var(--navy-dark) !important;
            padding: 14px 30px;
            border-radius: 16px;
            text-decoration: none;
            font-weight: 800;
            font-size: 0.9rem;
            display: flex;
            align-items: center;
            gap: 0; /* Starts with 0 gap */
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            box-shadow: 0 8px 20px rgba(245, 158, 11, 0.3);
            position: relative;
            overflow: hidden;
        }

        .btn-winners-premium i {
            width: 0;
            opacity: 0;
            transition: all 0.3s ease;
            transform: scale(0.5) rotate(-45deg);
        }

        .btn-winners-premium:hover {
            gap: 12px;
            padding-right: 35px;
            transform: translateY(-3px);
            box-shadow: 0 12px 25px rgba(245, 158, 11, 0.5);
            background: #fff;
        }

        .btn-winners-premium:hover i {
            width: auto;
            opacity: 1;
            transform: scale(1.1) rotate(0deg);
        }

        /* --- ROUNDS GRID --- */
        .rounds-grid { padding: 45px; background: #fff; }

        .round-item {
            border: 1px solid #f1f5f9;
            border-radius: 24px;
            padding: 30px;
            height: 100%;
            transition: all 0.4s ease;
            background: #fff;
            display: flex;
            flex-direction: column;
            position: relative;
        }

        .round-item:hover {
            border-color: var(--brand-blue);
            box-shadow: 0 20px 40px rgba(37, 99, 235, 0.08);
            transform: translateY(-10px);
        }

        .round-tag {
            background: #f1f5f9;
            color: var(--navy-dark);
            padding: 6px 14px;
            border-radius: 10px;
            font-size: 0.7rem;
            font-weight: 800;
            margin-bottom: 15px;
            display: inline-block;
        }

        .status-dot {
            width: 8px; height: 8px; border-radius: 50%; display: inline-block; margin-right: 6px;
        }

        .status-pill {
            font-size: 0.65rem;
            padding: 6px 12px;
            border-radius: 8px;
            font-weight: 700;
            background: #f8fafc;
            border: 1px solid #e2e8f0;
        }

        .pill-live { color: #16a34a; border-color: #bbf7d0; background: #f0fdf4; }
        .pill-done { color: #2563eb; border-color: #bfdbfe; background: #eff6ff; }

        .date-info-box {
            display: flex; align-items: center; gap: 15px;
            margin-bottom: 12px; padding: 12px;
            background: #f8fafc; border-radius: 15px;
        }

        .icon-square {
            width: 35px; height: 35px; background: #fff;
            border-radius: 10px; display: flex; align-items: center; justify-content: center;
            color: var(--brand-blue); box-shadow: 0 4px 10px rgba(0,0,0,0.03);
        }

        .btn-action {
            background: var(--navy-dark); color: white; border: none;
            padding: 14px; border-radius: 15px; font-weight: 700; width: 100%;
            transition: 0.3s; text-decoration: none; text-align: center; display: block;
        }

        .btn-action:hover { background: var(--brand-blue); color: white; }

        .profile-chip {
            background: var(--navy-dark); color: white;
            padding: 8px 20px; border-radius: 12px;
            display: flex; align-items: center; gap: 12px;
        }
    </style>
</head>
<body>

<%
    UserEntity user = (UserEntity) session.getAttribute("user");
    List<ProgramEntity> programs = (List<ProgramEntity>) request.getAttribute("programs");
    List<ProgramRoundsEntity> allRounds = (List<ProgramRoundsEntity>) request.getAttribute("allRounds");
    
    Date today = new Date();
    SimpleDateFormat sdf = new SimpleDateFormat("dd MMM, yyyy");
%>

    <nav class="top-nav">
        <div class="container-fluid d-flex justify-content-between align-items-center">
            <a href="#" class="brand-logo">
                <i class="fa-solid fa-layer-group text-primary"></i>
                <span>SKILLACADEMY <span class="text-muted fw-light" style="font-size: 1rem;">Dashboard</span></span>
            </a>
            
            <div class="d-flex align-items-center gap-3">
                <div class="profile-chip shadow-sm">
                    <span class="small fw-bold">Judge: <%= (user != null) ? user.getFirstName() : "Admin" %></span>
                    <div style="width: 25px; height: 25px; background: var(--brand-blue); border-radius: 6px; display: flex; align-items: center; justify-content: center; font-size: 0.7rem;">
                        <%= (user != null) ? user.getFirstName().substring(0,1).toUpperCase() : "J" %>
                    </div>
                </div>
                <a href="logout" class="text-danger ms-2"><i class="fa-solid fa-power-off"></i></a>
            </div>
        </div>
    </nav>

    <div class="container py-5">
        <% if (programs == null || programs.isEmpty()) { %>
            <div class="text-center py-5 bg-white rounded-5 border shadow-sm">
                <i class="fa-solid fa-hourglass-empty fa-3x text-muted mb-3 opacity-25"></i>
                <h4 class="fw-bold">No Programs Assigned</h4>
                <p class="text-muted small">Evaluations will appear here once assigned by the admin.</p>
            </div>
        <% } else { 
            for (ProgramEntity p : programs) { 
                Date resultDate = p.getWinnerPublishDate();
                boolean isWinnerLive = (resultDate != null && !today.before(resultDate));
        %>
            <div class="hackathon-card">
                <div class="card-header-premium">
                    <div>
                        <div class="d-flex align-items-center gap-2 mb-2">
                            <span class="status-pill" style="background: rgba(255,255,255,0.1); color: white; border-color: rgba(255,255,255,0.2);">
                                <i class="fa-solid fa-map-pin me-1"></i> <%= p.getLocation() %>
                            </span>
                        </div>
                        <h2 class="fw-800 m-0 text-white" style="letter-spacing: -1px; font-size: 2.2rem;"><%= p.getProgramName().toUpperCase() %></h2>
                    </div>

                    <% if (isWinnerLive) { %>
                        <a href="winnerDisplay?programId=<%= p.getProgramId() %>" class="btn-winners-premium">
                            VIEW WINNERS <i class="fa-solid fa-trophy"></i>
                        </a>
                    <% } else { %>
                        <div class="text-end text-white-50">
                            <div class="small fw-800 text-uppercase tracking-wider" style="font-size: 0.65rem;">Results Date</div>
                            <div class="text-white fw-bold"><%= (resultDate != null) ? sdf.format(resultDate) : "TBD" %></div>
                        </div>
                    <% } %>
                </div>

                <div class="rounds-grid">
                    <div class="row g-4">
                        <% 
                            boolean hasRounds = false;
                            if (allRounds != null) {
                                for (ProgramRoundsEntity r : allRounds) { 
                                    if (r.getProgram().getProgramId().equals(p.getProgramId())) {
                                        hasRounds = true;
                                        Date start = r.getStartDate();
                                        Date end = r.getEndDate();
                                        
                                        String label = "Upcoming"; String css = "pill-upcoming";
                                        if (end != null && end.before(today)) { label = "Completed"; css = "pill-done"; }
                                        else if (start != null && !start.after(today)) { label = "Live"; css = "pill-live"; }
                        %>
                            <div class="col-md-4">
                                <div class="round-item">
                                    <div class="d-flex justify-content-between align-items-center mb-3">
                                        <span class="round-tag">ROUND <%= r.getRoundNo() %></span>
                                        <span class="status-pill <%= css %>"><%= label %></span>
                                    </div>

                                    <h5 class="fw-bold text-dark mb-4" style="font-size: 1.2rem;"><%= r.getRoundName() %></h5>

                                    <div class="date-info-box">
                                        <div class="icon-square"><i class="fa-solid fa-calendar-check"></i></div>
                                        <div>
                                            <div class="text-muted" style="font-size: 0.6rem; font-weight: 700;">STARTS</div>
                                            <div class="small fw-bold text-dark"><%= (start != null) ? sdf.format(start) : "Not Set" %></div>
                                        </div>
                                    </div>

                                    <div class="date-info-box mb-4">
                                        <div class="icon-square" style="color: #ef4444;"><i class="fa-solid fa-flag-checkered"></i></div>
                                        <div>
                                            <div class="text-muted" style="font-size: 0.6rem; font-weight: 700;">ENDS</div>
                                            <div class="small fw-bold text-dark"><%= (end != null) ? sdf.format(end) : "Not Set" %></div>
                                        </div>
                                    </div>

                                    <div class="mt-auto">
                                        <% if (label.equals("Upcoming")) { %>
                                            <div class="btn-action" style="background: #f1f5f9; color: #94a3b8; cursor: not-allowed;">
                                                <i class="fa-solid fa-lock-open me-2"></i>WAITING...
                                            </div>
                                        <% } else { %>
                                            <a href="<%= label.equals("Completed") ? "viewScores?roundId=" + r.getRoundId() : "evaluateTeams?roundNo=" + r.getRoundNo() + "&programId=" + p.getProgramId() %>" 
                                               class="btn-action">
                                                <%= label.equals("Completed") ? "View Marks" : "Evaluate Now" %>
                                            </a>
                                        <% } %>
                                    </div>
                                </div>
                            </div>
                        <% 
                                    }
                                }
                            }
                            if (!hasRounds) {
                        %>
                            <div class="col-12 text-center py-4">
                                <p class="text-muted small">No evaluation rounds found.</p>
                            </div>
                        <% } %>
                    </div>
                </div>
            </div>
        <% } } %>
    </div>

</body>
</html>