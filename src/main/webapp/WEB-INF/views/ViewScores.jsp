<%@page import="com.entity.*"%>
<%@page import="java.util.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Scoring Matrix | SkillAcademy</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">

    <style>
        :root {
            --navy-dark: #0f172a;       
            --brand-blue: #2563eb;    
            --bg-body: #f8fafc;
            --white: #ffffff;
            --border-color: #e2e8f0;
        }

        /* --- HIDE SCROLLBAR --- */
        html, body {
            overflow: -moz-scrollbars-none; /* Firefox */
            -ms-overflow-style: none;  /* IE and Edge */
            scrollbar-width: none; /* Firefox */
        }
        body::-webkit-scrollbar {
            display: none; /* Chrome, Safari, Opera */
        }

        body { 
            background-color: var(--bg-body); 
            font-family: 'Plus Jakarta Sans', sans-serif; 
            color: var(--navy-dark); 
            min-height: 100vh;
        }

        /* --- NAVIGATION --- */
        .top-nav {
            background: var(--white);
            border-bottom: 1px solid var(--border-color);
            padding: 0.8rem 2.5rem;
            position: sticky; top: 0; z-index: 1000;
        }

        .brand-logo {
            font-weight: 800; font-size: 1.3rem;
            color: var(--navy-dark); text-decoration: none; display: flex; align-items: center; gap: 10px;
        }

        .profile-chip {
            background: var(--navy-dark); color: white;
            padding: 8px 18px; border-radius: 50px;
            display: flex; align-items: center; gap: 12px;
        }

        /* --- HEADER --- */
        .matrix-header {
            padding: 35px 0;
            background: var(--white);
            border-bottom: 1px solid var(--border-color);
            margin-bottom: 30px;
        }

        /* --- MATRIX CARD --- */
        .matrix-card { 
            background: white; 
            border-radius: 20px; 
            box-shadow: 0 10px 30px rgba(0,0,0,0.03); 
            border: 1px solid var(--border-color);
            overflow: hidden;
        }

        .custom-table { margin-bottom: 0; }
        
        .custom-table thead th { 
            background: #f8fafc; 
            color: #64748b; 
            font-weight: 800; 
            text-transform: uppercase; 
            font-size: 0.7rem; 
            letter-spacing: 1px; 
            padding: 20px 10px; 
            border-bottom: 1px solid var(--border-color);
            text-align: center;
        }

        .judge-header {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 5px;
        }

        .judge-icon-box {
            width: 35px; height: 35px;
            background: #eff6ff;
            color: var(--brand-blue);
            border-radius: 10px;
            display: flex; align-items: center; justify-content: center;
            margin-bottom: 5px;
            font-size: 1rem;
        }

        .team-cell { 
            padding-left: 25px !important;
            font-weight: 700;
            color: var(--navy-dark);
            text-align: left !important;
        }

        .score-cell { 
            font-weight: 700; 
            font-size: 1rem; 
            text-align: center;
            color: #475569;
        }

        .total-col { 
            background: #f0f7ff; 
            font-weight: 800; 
            color: var(--brand-blue); 
            text-align: center;
            font-size: 1.1rem;
            border-left: 1px solid #e0efff;
        }

        .pending-text { color: #cbd5e1; font-weight: 400; font-size: 0.9rem; }

        /* Hover Effect */
        .custom-table tbody tr:hover { background-color: #fcfdfe; }
    </style>
</head>
<body>

    <nav class="top-nav">
        <div class="container-fluid d-flex justify-content-between align-items-center">
            <a href="judgeDashboard" class="brand-logo">
                <i class="fa-solid fa-shield-halved text-primary"></i>
                <span>SKILLACADEMY</span>
            </a>
            
            <div class="d-flex align-items-center gap-3">
                <div class="profile-chip">
                    <% UserEntity user = (UserEntity) session.getAttribute("user"); %>
                    <span class="small fw-bold">Hi, <%= (user != null) ? user.getFirstName() : "Judge" %></span>
                    <i class="fa-solid fa-circle-user text-primary"></i>
                </div>
                <a href="logout" class="btn btn-outline-danger btn-sm rounded-circle" style="width: 35px; height: 35px; display: flex; align-items: center; justify-content: center; border-width: 2px;">
                    <i class="fa-solid fa-power-off"></i>
                </a>
            </div>
        </div>
    </nav>

    <%
        List<RoundResultEntity> results = (List<RoundResultEntity>) request.getAttribute("results");
        if(results != null && !results.isEmpty()) {
            ProgramEntity program = results.get(0).getRounds().getProgram();
            int roundNum = results.get(0).getRounds().getRoundNo();
            List<ProgramJudgesEntity> assignments = program.getAssignedJudges();
            
            Set<TeamEntity> uniqueTeams = new LinkedHashSet<>();
            Map<String, Integer> scoreLookup = new HashMap<>();

            for(RoundResultEntity r : results) {
                uniqueTeams.add(r.getTeams());
                scoreLookup.put(r.getTeams().getTeamId() + "_" + r.getJudge().getUserId(), r.getMarks());
            }
    %>

    <div class="matrix-header">
        <div class="container">
            <div class="d-flex justify-content-between align-items-end">
                <div>
                    <span class="badge bg-primary rounded-pill px-3 py-2 mb-2 fw-bold" style="font-size: 0.65rem; letter-spacing: 1px;">ROUND <%= roundNum %> RESULTS</span>
                    <h2 class="fw-800 m-0 text-uppercase"><%= program.getProgramName() %></h2>
                    <p class="text-muted mb-0">Live Evaluation Matrix & Scoring Leaderboard</p>
                </div>
                <a href="judgeDashboard" class="btn btn-light border fw-bold rounded-pill px-4 shadow-sm">
                    <i class="fa-solid fa-chevron-left me-2"></i>Dashboard
                </a>
            </div>
        </div>
    </div>

    <div class="container pb-5">
        <div class="matrix-card">
            <div class="table-responsive">
                <table class="table custom-table align-middle">
                    <thead>
                        <tr>
                            <th class="team-cell" style="width: 250px;">Participating Team</th>
                            <% for(ProgramJudgesEntity pje : assignments) { %>
                                <th>
                                    <div class="judge-header">
                                        <div class="judge-icon-box"><i class="fa-solid fa-gavel"></i></div>
                                        <span><%= (pje.getJudge() != null) ? pje.getJudge().getFirstName() : "Judge" %></span>
                                    </div>
                                </th>
                            <% } %>
                            <th class="total-col">Cumulative Score</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for(TeamEntity team : uniqueTeams) { 
                            int rowTotal = 0;
                        %>
                            <tr style="border-bottom: 1px solid #f1f5f9;">
                                <td class="team-cell">
                                    <div class="d-flex align-items-center py-2">
                                        <div class="me-3 bg-light rounded-circle d-flex align-items-center justify-content-center" style="width:32px; height:32px;">
                                            <i class="fa-solid fa-users text-muted small"></i>
                                        </div>
                                        <%= team.getTeamName() %>
                                    </div>
                                </td>
                                
                                <% for(ProgramJudgesEntity pje : assignments) { 
                                    Integer currentJudgeId = (pje.getJudge() != null) ? pje.getJudge().getUserId() : 0;
                                    Integer marks = scoreLookup.get(team.getTeamId() + "_" + currentJudgeId);
                                    
                                    if(marks != null) {
                                        rowTotal += marks;
                                %>
                                    <td class="score-cell"><%= marks %></td>
                                <% } else { %>
                                    <td class="score-cell"><span class="pending-text">--</span></td>
                                <% } } %>

                                <td class="total-col">
                                    <span class="fw-800"><%= rowTotal %></span>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
        
        <div class="mt-4 text-center">
            <p class="text-muted small">
                <i class="fa-solid fa-circle-info text-primary me-1"></i> 
                The matrix is locked for editing. Scores update automatically upon judge submission.
            </p>
        </div>
    </div>

    <% } else { %>
        <div class="container text-center py-5 mt-5">
            <div class="matrix-card p-5 shadow-lg">
                <div class="mb-4 text-muted opacity-25">
                    <i class="fa-solid fa-chart-bar fa-5x"></i>
                </div>
                <h4 class="fw-800">No Scoring Data Available</h4>
                <p class="text-muted">Teams have not been graded yet. Start evaluating from the dashboard.</p>
                <a href="judgeDashboard" class="btn btn-primary rounded-pill px-5 py-2 mt-3 fw-bold">Return Home</a>
            </div>
        </div>
    <% } %>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>