<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Judge Evaluation Panel | SkillAcademy</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">

    <style>
        body { 
            background-color: #f4f7fa; 
            font-family: 'Plus Jakarta Sans', sans-serif;
            color: #334155;
        }
        .eval-container { max-width: 1400px; margin: 40px auto; padding: 0 20px; }
        
        /* Heading Section */
        .page-header { margin-bottom: 30px; }
        .round-info-pill {
            background: #e0e7ff; color: #4338ca;
            padding: 6px 16px; border-radius: 50px; font-weight: 700; font-size: 0.8rem;
        }

        /* The Horizontal Evaluation Row */
        .eval-row {
            background: white;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 15px;
            border: 1px solid #e2e8f0;
            display: flex;
            align-items: center;
            gap: 20px;
            transition: transform 0.2s, box-shadow 0.2s;
        }
        .eval-row:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.05);
            border-color: #6366f1;
        }

        /* Column Specifics */
        .col-team { flex: 2; min-width: 200px; }
        .col-link { flex: 1.5; text-align: center; }
        .col-marks { flex: 1; min-width: 120px; }
        .col-feedback { flex: 3; }
        .col-action { flex: 0.8; text-align: right; }

        .team-title { font-weight: 700; font-size: 1.05rem; margin-bottom: 2px; display: block; }
        .team-id { color: #94a3b8; font-size: 0.8rem; font-weight: 600; }

        .link-btn {
            background: #f8fafc; border: 1px solid #cbd5e1;
            padding: 10px 15px; border-radius: 8px; color: #2563eb;
            font-weight: 600; text-decoration: none; display: inline-flex;
            align-items: center; gap: 8px; transition: 0.2s;
        }
        .link-btn:hover { background: #eff6ff; border-color: #2563eb; }

        /* Inputs */
        .input-score {
            width: 100%; border: 2px solid #e2e8f0; border-radius: 8px;
            padding: 10px; font-weight: 700; text-align: center; font-size: 1.1rem;
            color: #6366f1; outline: none;
        }
        .input-score:focus { border-color: #6366f1; background: #f5f7ff; }

        .input-feedback {
            width: 100%; border: 1px solid #e2e8f0; border-radius: 8px;
            padding: 10px; font-size: 0.9rem; min-height: 45px; outline: none;
        }
        .input-feedback:focus { border-color: #6366f1; }

        .btn-save-row {
            background: #0f172a; color: white; border: none;
            padding: 12px 20px; border-radius: 8px; font-weight: 700;
            transition: 0.3s; width: 100%;
        }
        .btn-save-row:hover { background: #1e293b; }

        .label-small { 
            display: block; font-size: 0.7rem; font-weight: 800; 
            color: #94a3b8; margin-bottom: 5px; text-transform: uppercase; 
        }
    </style>
</head>
<body>

<div class="eval-container">
    <div class="page-header d-flex justify-content-between align-items-end">
        <div>
            <span class="round-info-pill mb-2 d-inline-block">ROUND 02: PROTOTYPE EVALUATION</span>
            <h2 class="fw-bold m-0">Evaluation Console</h2>
        </div>
        <div class="text-end">
            <p class="text-muted small mb-0">Criteria: Innovation & Performance</p>
            <p class="fw-bold mb-0">Total Weightage: 50 Marks</p>
        </div>
    </div>

    <div class="eval-row">
        <div class="col-team">
            <span class="label-small">Team Information</span>
            <span class="team-title">Binary Wizards</span>
            <span class="team-id">ID: #HK-1024</span>
        </div>

        <div class="col-link">
            <span class="label-small">Submission Link</span>
            <a href="https://github.com/project" target="_blank" class="link-btn">
                <i class="fa-brands fa-github"></i> View Work
            </a>
        </div>

        <div class="col-marks">
            <span class="label-small">Score (Out of 50)</span>
            <input type="number" class="input-score" placeholder="00">
        </div>

        <div class="col-feedback">
            <span class="label-small">Judge's Feedback</span>
            <textarea class="input-feedback" placeholder="Write internal notes..."></textarea>
        </div>

        <div class="col-action">
            <span class="label-small">Action</span>
            <button class="btn-save-row">SAVE</button>
        </div>
    </div>

    <div class="eval-row">
        <div class="col-team">
            <span class="label-small">Team Information</span>
            <span class="team-title">Cyber Junkies</span>
            <span class="team-id">ID: #HK-1025</span>
        </div>

        <div class="col-link">
            <span class="label-small">Submission Link</span>
            <a href="#" class="link-btn">
                <i class="fa-solid fa-link"></i> Open Demo
            </a>
        </div>

        <div class="col-marks">
            <span class="label-small">Score (Out of 50)</span>
            <input type="number" class="input-score" placeholder="00">
        </div>

        <div class="col-feedback">
            <span class="label-small">Judge's Feedback</span>
            <textarea class="input-feedback" placeholder="Write internal notes..."></textarea>
        </div>

        <div class="col-action">
            <span class="label-small">Action</span>
            <button class="btn-save-row">SAVE</button>
        </div>
    </div>

    <% for(int i=1; i<=5; i++) { %>
    <div class="eval-row">
        <div class="col-team">
            <span class="label-small">Team Information</span>
            <span class="team-title">Alpha Squad <%=i%></span>
            <span class="team-id">ID: #HK-200<%=i%></span>
        </div>
        <div class="col-link">
            <span class="label-small">Submission Link</span>
            <button class="link-btn text-muted" disabled><i class="fa-solid fa-clock"></i> Not Submitted</button>
        </div>
        <div class="col-marks">
            <span class="label-small">Score (50)</span>
            <input type="number" class="input-score" disabled>
        </div>
        <div class="col-feedback">
            <span class="label-small">Judge's Feedback</span>
            <textarea class="input-feedback" placeholder="Waiting for submission..." disabled></textarea>
        </div>
        <div class="col-action">
            <span class="label-small">Action</span>
            <button class="btn btn-light w-100 py-2 fw-bold text-muted border" disabled>LOCKED</button>
        </div>
    </div>
    <% } %>

</div>

</body>
</html>