<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Grand Finale Results | SkillAcademy</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    
    <script src="https://cdn.jsdelivr.net/npm/canvas-confetti@1.6.0/dist/confetti.browser.min.js"></script>

    <style>
        :root {
            --gold-glow: 0 0 30px rgba(251, 191, 36, 0.4);
            --silver-glow: 0 0 30px rgba(148, 163, 184, 0.3);
            --bronze-glow: 0 0 30px rgba(180, 83, 9, 0.3);
            --navy-deep: #020617;
        }

        body {
            background-color: var(--navy-deep);
            background-image: 
                radial-gradient(at 0% 0%, rgba(37, 99, 235, 0.15) 0px, transparent 50%),
                radial-gradient(at 100% 100%, rgba(251, 191, 36, 0.1) 0px, transparent 50%);
            font-family: 'Plus Jakarta Sans', sans-serif;
            color: #fff;
            min-height: 100vh;
            overflow-x: hidden;
            scrollbar-width: none;
        }
        body::-webkit-scrollbar { display: none; }

        /* --- Header Styling --- */
        .celebration-header {
            padding: 80px 0 150px;
            text-align: center;
        }

        .title-main {
            font-weight: 800;
            font-size: 4rem;
            background: linear-gradient(to bottom, #ffffff 30%, #94a3b8 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 10px;
        }

        /* --- Podium Logic --- */
        .podium-section { margin-top: -100px; padding-bottom: 100px; }

        .winner-card {
            background: rgba(255, 255, 255, 0.03);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 40px;
            padding: 50px 25px;
            text-align: center;
            transition: all 0.5s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            height: 100%;
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .winner-card:hover {
            transform: translateY(-25px) scale(1.02);
            background: rgba(255, 255, 255, 0.07);
            border-color: rgba(255, 255, 255, 0.3);
        }

        .rank-1 { box-shadow: var(--gold-glow); transform: scale(1.1); z-index: 5; border-top: 4px solid #fbbf24; }
        .rank-1:hover { transform: translateY(-25px) scale(1.15); }
        .rank-2 { box-shadow: var(--silver-glow); border-top: 4px solid #94a3b8; }
        .rank-3 { box-shadow: var(--bronze-glow); border-top: 4px solid #b45309; }

        /* --- Trophy Animations --- */
        .medal-icon {
            font-size: 5.5rem;
            margin-bottom: 25px;
            filter: drop-shadow(0 10px 15px rgba(0,0,0,0.5));
            animation: bounce 4s ease-in-out infinite;
        }

        @keyframes bounce {
            0%, 100% { transform: translateY(0) rotate(0deg); }
            50% { transform: translateY(-15px) rotate(5deg); }
        }

        .team-title {
            font-size: 2rem;
            font-weight: 800;
            margin-bottom: 20px;
            color: #fff;
        }

        /* --- Beautiful Member Name Tags --- */
        .member-box {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            gap: 12px;
            margin: 25px 0;
            padding: 20px;
            background: rgba(0, 0, 0, 0.2);
            border-radius: 25px;
            width: 100%;
        }

        .name-pill {
            background: linear-gradient(135deg, rgba(59, 130, 246, 0.2), rgba(37, 99, 235, 0.1));
            color: #dbeafe;
            padding: 8px 20px;
            border-radius: 100px;
            font-size: 0.85rem;
            font-weight: 700;
            border: 1px solid rgba(59, 130, 246, 0.3);
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
            transition: 0.3s;
        }

        .name-pill:hover {
            background: #2563eb;
            color: white;
            transform: translateY(-3px);
        }

        .score-box {
            margin-top: auto;
            background: #fff;
            color: var(--navy-deep);
            padding: 14px 35px;
            border-radius: 100px;
            font-weight: 900;
            font-size: 1.3rem;
            box-shadow: 0 10px 25px rgba(0,0,0,0.3);
        }

        .btn-return {
            background: rgba(255, 255, 255, 0.05);
            color: #fff;
            padding: 16px 45px;
            border-radius: 20px;
            font-weight: 700;
            text-decoration: none;
            border: 1px solid rgba(255, 255, 255, 0.2);
            transition: 0.3s;
        }
        .btn-return:hover { background: #fff; color: var(--navy-deep); }

    </style>
</head>
<body onload="fireworks()">

    <div class="celebration-header">
        <div class="container">
            <div class="badge bg-primary px-3 py-2 rounded-pill mb-3" style="letter-spacing: 2px;">THE GRAND FINALE</div>
            <h1 class="title-main text-uppercase">The Victory Hall</h1>
            <p class="lead text-white-50">Honoring the ultimate champions of <b>${pName}</b></p>
        </div>
    </div>

    <div class="container podium-section">
        <div class="row g-5 align-items-end justify-content-center">
            <%
                List<Map<String, Object>> winners = (List<Map<String, Object>>) request.getAttribute("winners");
                if(winners != null && !winners.isEmpty()) {
                    int[] posArray = {1, 0, 2}; 
                    for(int i : posArray) {
                        if(i < winners.size()) {
                            Map<String, Object> team = winners.get(i);
                            int rank = i + 1;
                            String iconColor = (rank == 1) ? "#fbbf24" : (rank == 2) ? "#94a3b8" : "#b45309";
                            String iconType = (rank == 1) ? "fa-trophy" : "fa-medal";
            %>
                <div class="col-lg-4">
                    <div class="winner-card rank-<%= rank %>">
                        <div class="medal-icon" style="color: <%= iconColor %>">
                            <i class="fa-solid <%= iconType %>"></i>
                        </div>
                        <h6 class="text-uppercase fw-bold text-white-50 small mb-2">Rank <%= rank %></h6>
                        <h2 class="team-title"><%= team.get("teamName") %></h2>
                        
                        <div class="member-box">
                            <% 
                                List<String> members = (List<String>) team.get("members");
                                if(members != null) {
                                    for(String name : members) {
                            %>
                                <div class="name-pill">
                                    <i class="fa-solid fa-star-of-life me-2 small text-warning"></i> <%= name %>
                                </div>
                            <% 
                                    }
                                } 
                            %>
                        </div>

                        <div class="score-box">
                            <%= team.get("score") %> <span style="font-size: 0.8rem; font-weight: 400; opacity: 0.7;">PTS</span>
                        </div>
                    </div>
                </div>
            <% 
                        }
                    }
                }
            %>
        </div>

        <div class="text-center mt-5 pt-5">
            <a href="judgeDashboard" class="btn-return">
                <i class="fa-solid fa-arrow-left me-2"></i> RETURN TO DASHBOARD
            </a>
        </div>
    </div>

    

    <script>
        function fireworks() {
            var duration = 15 * 1000;
            var animationEnd = Date.now() + duration;
            var defaults = { startVelocity: 30, spread: 360, ticks: 60, zIndex: 0 };

            function randomInRange(min, max) {
                return Math.random() * (max - min) + min;
            }

            var interval = setInterval(function() {
                var timeLeft = animationEnd - Date.now();

                if (timeLeft <= 0) {
                    return clearInterval(interval);
                }

                var particleCount = 50 * (timeLeft / duration);
                
                confetti(Object.assign({}, defaults, { particleCount, origin: { x: randomInRange(0.1, 0.3), y: Math.random() - 0.2 } }));
                confetti(Object.assign({}, defaults, { particleCount, origin: { x: randomInRange(0.7, 0.9), y: Math.random() - 0.2 } }));
                confetti(Object.assign({}, defaults, { particleCount, origin: { x: 0.5, y: 0.5 } }));
            }, 250);

            confetti({
                particleCount: 200,
                spread: 100,
                origin: { y: 0.6, x: 0.5 },
                colors: ['#fbbf24', '#ffffff', '#2563eb']
            });
        }
    </script>
</body>
</html>