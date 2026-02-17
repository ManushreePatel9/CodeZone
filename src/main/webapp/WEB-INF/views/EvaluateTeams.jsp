<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.entity.*" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Judge Evaluation Panel | SkillAcademy</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    
    <style>
        :root { 
            --navy-dark: #0f172a;       
            --brand-blue: #2563eb;    
            --bg-body: #f8fafc;
            --success: #10b981; 
            --warning: #f59e0b; 
            --border-color: #e2e8f0;
        }

        body { 
            background-color: var(--bg-body); 
            font-family: 'Plus Jakarta Sans', sans-serif; 
            color: var(--navy-dark); 
        }

        .top-nav {
            background: #ffffff; border-bottom: 1px solid var(--border-color);
            padding: 0.75rem 2.5rem; position: sticky; top: 0; z-index: 1000;
            margin-bottom: 2rem;
        }

        .brand-logo {
            font-weight: 800; font-size: 1.3rem; color: var(--navy-dark); 
            text-decoration: none; display: flex; align-items: center; gap: 10px;
        }

        .main-card { 
            border-radius: 24px; border: 1px solid var(--border-color); 
            box-shadow: 0 4px 20px rgba(0,0,0,0.02); margin-bottom: 1.5rem; 
            background: #fff; border-left: 8px solid #cbd5e1; 
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275); 
        }
        
        .card-saved { border-left-color: var(--success) !important; background-color: #f0fdf4; }
        .card-editing { border-left-color: var(--warning) !important; background-color: #fffbeb; transform: translateY(-5px); box-shadow: 0 12px 30px rgba(0,0,0,0.08); }
        
        /* Scoring Input Styling */
        .score-input-pill {
            background: #f1f5f9;
            border: 2px solid transparent;
            border-radius: 12px;
            font-weight: 700;
            color: var(--navy-dark);
            height: 45px;
            transition: all 0.2s;
            font-size: 1.1rem;
        }

        .score-input-pill:focus {
            background: #fff;
            border-color: var(--brand-blue);
            box-shadow: 0 0 0 4px rgba(37, 99, 235, 0.15);
            outline: none;
        }

        .score-input-pill:disabled {
            background: rgba(0,0,0,0.03);
            color: #94a3b8;
            border-color: transparent;
        }

        .feedback-area {
            border-radius: 12px;
            border: 1.5px solid var(--border-color);
            padding: 10px;
            font-size: 0.85rem;
            resize: none;
            margin-top: 10px;
        }

        .btn-action { 
            height: 50px;
            border-radius: 15px; 
            font-weight: 800; 
            font-size: 0.9rem; 
            text-transform: uppercase; 
            letter-spacing: 0.5px;
            border: none; 
            transition: 0.3s; 
        }
        
        .btn-edit { background-color: var(--navy-dark); color: white; }
        .btn-save { background-color: var(--success); color: white; box-shadow: 0 4px 15px rgba(16, 185, 129, 0.3); }

        .link-box .btn-review {
            background: #eff6ff;
            color: var(--brand-blue);
            border: 2px solid #dbeafe;
            border-radius: 12px;
            font-weight: 700;
            transition: 0.3s;
        }

        .link-box .btn-review:hover {
            background: var(--brand-blue);
            color: white;
        }

        .criteria-label { 
            font-size: 0.6rem; 
            font-weight: 800; 
            color: #64748b; 
            text-transform: uppercase; 
            margin-bottom: 6px; 
            display: block;
            letter-spacing: 0.5px;
        }

        .profile-chip { background: var(--navy-dark); color: white; padding: 8px 18px; border-radius: 50px; display: flex; align-items: center; gap: 12px; }

    </style>
</head>
<body>

    <nav class="top-nav">
        <div class="container-fluid d-flex justify-content-between align-items-center">
            <a href="judgeDashboard" class="brand-logo">
                <i class="fa-solid fa-shield-halved text-primary"></i>
                <span>SKILLACADEMY <span class="text-muted fw-light">| Console</span></span>
            </a>
            
            <div class="d-flex align-items-center gap-3">
                <div class="profile-chip">
                    <span class="small fw-bold">Hi, <%= ((UserEntity)session.getAttribute("user")).getFirstName() %></span>
                    <i class="fa-solid fa-circle-user text-primary"></i>
                </div>
                <a href="judgeDashboard" class="btn btn-light btn-sm rounded-pill px-4 fw-bold border">
                    <i class="fa-solid fa-arrow-left me-1"></i> Back
                </a>
            </div>
        </div>
    </nav>

    <div class="container pb-5">
        <div class="mb-5">
            <h2 class="fw-800 text-navy-dark mb-1">Evaluation Panel</h2>
            <p class="text-muted">Review team submissions and assign scores out of 10 for each criteria.</p>
        </div>

        <%
            List<SubmissionEntity> submissions = (List<SubmissionEntity>) request.getAttribute("submissionData");
            List<RoundResultEntity> results = (List<RoundResultEntity>) request.getAttribute("results");
            
            if(submissions != null && !submissions.isEmpty()) {
                for(SubmissionEntity s : submissions) {
                    RoundResultEntity myResult = null;
                    if(results != null) {
                        for(RoundResultEntity r : results) {
                            if(r.getSubmission().getSubmissionId().equals(s.getSubmissionId())) {
                                myResult = r;
                                break;
                            }
                        }
                    }
                    boolean isSaved = (myResult != null);
        %>
            <div class="card main-card p-4 <%= isSaved ? "card-saved" : "" %>" id="card-<%= s.getSubmissionId() %>">
                <div class="row g-4 align-items-center">
                    
                    <div class="col-md-2 border-end">
                        <div class="text-primary small fw-800 text-uppercase mb-1" style="font-size: 0.65rem;">Team Name</div>
                        <h5 class="fw-bold mb-1 text-navy-dark"><%= s.getTeam().getTeamName() %></h5>
                        <span class="badge bg-light text-muted border px-2">ID #<%= s.getSubmissionId() %></span>
                    </div>

                    <div class="col-md-3">
                        <div class="mb-3">
                            <p class="text-muted mb-0" style="font-size: 0.8rem; line-height: 1.4;">
                                <%= (s.getSubmissionDesc() != null) ? s.getSubmissionDesc() : "No description provided." %>
                            </p>
                        </div>
                        <% if(s.getSubmissionLink() != null && !s.getSubmissionLink().isEmpty()) { %>
                            <div class="link-box">
                                <a href="<%= s.getSubmissionLink() %>" target="_blank" class="btn btn-review btn-sm w-100 py-2">
                                    <i class="fa-solid fa-link me-1"></i> View Project
                                </a>
                            </div>
                        <% } %>
                    </div>

                    <div class="col-md-5">
                        <div class="row g-2 mb-2">
                            <% 
                                ProgramRoundsEntity round = s.getRound();
                                String[] labels = {
                                    (round.getCriteria1() != null && !round.getCriteria1().isEmpty()) ? round.getCriteria1() : "Crit 1",
                                    (round.getCriteria2() != null && !round.getCriteria2().isEmpty()) ? round.getCriteria2() : "Crit 2",
                                    (round.getCriteria3() != null && !round.getCriteria3().isEmpty()) ? round.getCriteria3() : "Crit 3",
                                    (round.getCriteria4() != null && !round.getCriteria4().isEmpty()) ? round.getCriteria4() : "Crit 4",
                                    (round.getCriteria5() != null && !round.getCriteria5().isEmpty()) ? round.getCriteria5() : "Crit 5"
                                };
                                Integer[] marks = isSaved ? new Integer[]{myResult.getM1(), myResult.getM2(), myResult.getM3(), myResult.getM4(), myResult.getM5()} : new Integer[]{0,0,0,0,0};
                                
                                for(int i=0; i<5; i++) { 
                            %>
                                <div class="col">
                                    <label class="criteria-label text-center text-truncate" title="<%= labels[i] %>"><%= labels[i] %></label>
                                    <input type="number" id="c<%= (i+1) %>-<%= s.getSubmissionId() %>" 
                                           class="form-control text-center score-input-pill eval-input-<%= s.getSubmissionId() %>" 
                                           placeholder="0" min="0" max="10"
                                           value="<%= isSaved ? (marks[i] != null ? marks[i] : "") : "" %>"
                                           <%= isSaved ? "disabled" : "" %>>
                                </div>
                            <% } %>
                        </div>
                        <textarea id="feedback-<%= s.getSubmissionId() %>" 
                                  class="form-control feedback-area eval-input-<%= s.getSubmissionId() %>" 
                                  rows="1" <%= isSaved ? "disabled" : "" %> 
                                  placeholder="Add judge's feedback..."><%= isSaved ? myResult.getFeedback() : "" %></textarea>
                    </div>

                    <div class="col-md-2">
                        <input type="hidden" id="sid-<%= s.getSubmissionId() %>" value="<%= s.getSubmissionId() %>">
                        <input type="hidden" id="tid-<%= s.getSubmissionId() %>" value="<%= s.getTeam().getTeamId() %>">
                        <input type="hidden" id="rid-<%= s.getSubmissionId() %>" value="<%= s.getRound().getRoundId() %>">
                        
                        <button type="button" id="btn-<%= s.getSubmissionId() %>" 
                                class="btn-action w-100 shadow-sm <%= isSaved ? "btn-edit" : "btn-save" %>" 
                                onclick="handleAction(<%= s.getSubmissionId() %>)">
                            <% if(isSaved) { %>
                                <i class="fa-solid fa-pen-to-square me-2"></i>Edit
                            <% } else { %>
                                <i class="fa-solid fa-check-circle me-2"></i>Save
                            <% } %>
                        </button>
                    </div>
                </div>
            </div>
        <% 
                }
            } else {
        %>
            <div class="text-center py-5 bg-white rounded-4 shadow-sm border mt-4">
                <i class="fa-solid fa-clipboard-question fa-3x text-muted mb-3 opacity-25"></i>
                <h4 class="fw-bold text-muted">No submissions found.</h4>
            </div>
        <% } %>
    </div>

<script>
function handleAction(id) {
    var btn = $("#btn-" + id);
    var inputs = $(".eval-input-" + id);
    var card = $("#card-" + id);
    
    if (btn.text().includes("Edit")) {
        inputs.prop('disabled', false).first().focus();
        btn.html("<i class='fa-solid fa-check-circle me-2'></i>Save").removeClass('btn-edit').addClass('btn-save');
        card.removeClass("card-saved").addClass("card-editing");
    } else {
        var m1 = $("#c1-" + id).val() || 0;
        var m2 = $("#c2-" + id).val() || 0;
        var m3 = $("#c3-" + id).val() || 0;
        var m4 = $("#c4-" + id).val() || 0;
        var m5 = $("#c5-" + id).val() || 0;

        btn.prop('disabled', true).html("<i class='fa-solid fa-circle-notch fa-spin'></i>");

        $.ajax({
            url: 'saveMarks',
            type: 'POST',
            data: {
                submissionId: $("#sid-" + id).val(),
                teamId: $("#tid-" + id).val(),
                roundId: $("#rid-" + id).val(),
                m1: m1, m2: m2, m3: m3, m4: m4, m5: m5,
                feedback: $("#feedback-" + id).val()
            },
            success: function(res) {
                if(res.trim() === "SUCCESS") {
                    setTimeout(function(){
                        inputs.prop('disabled', true);
                        card.removeClass("card-editing").addClass("card-saved");
                        btn.html("<i class='fa-solid fa-pen-to-square me-2'></i>Edit").removeClass('btn-save').addClass('btn-edit').prop('disabled', false);
                    }, 500);
                } else {
                    alert("Error: " + res);
                    btn.prop('disabled', false).html("Save");
                }
            }
        });
    }
}
</script>
</body>
</html>