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

        /* --- NAVIGATION --- */
        .top-nav {
            background: #ffffff;
            border-bottom: 1px solid var(--border-color);
            padding: 0.75rem 2.5rem;
            position: sticky; top: 0; z-index: 1000;
            margin-bottom: 2rem;
        }

        .brand-logo {
            font-weight: 800; font-size: 1.3rem;
            color: var(--navy-dark); text-decoration: none; display: flex; align-items: center; gap: 10px;
        }

        /* --- EVALUATION CARDS --- */
        .main-card { 
            border-radius: 20px; 
            border: 1px solid var(--border-color); 
            box-shadow: 0 4px 12px rgba(0,0,0,0.03); 
            margin-bottom: 1.5rem; 
            background: #fff; 
            border-left: 6px solid #e2e8f0; 
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1); 
        }
        
        .card-saved { border-left-color: var(--success) !important; background-color: #f0fdf4; }
        .card-editing { border-left-color: var(--warning) !important; background-color: #fffbeb; transform: scale(1.01); box-shadow: 0 10px 25px rgba(0,0,0,0.08); }
        
        .form-control { border-radius: 12px; border: 1.5px solid var(--border-color); padding: 10px 15px; font-size: 0.9rem; }
        .form-control:focus { border-color: var(--brand-blue); box-shadow: 0 0 0 4px rgba(37, 99, 235, 0.1); }

        /* Buttons */
        .btn-action { padding: 12px; border-radius: 14px; font-weight: 700; font-size: 0.85rem; text-transform: uppercase; border: none; transition: 0.3s; }
        .btn-edit { background-color: var(--navy-dark); color: white; }
        .btn-save { background-color: var(--success); color: white; }

        .link-box {
            background: #eff6ff;
            border: 1px dashed var(--brand-blue);
            border-radius: 12px;
            padding: 12px;
            text-align: center;
            transition: 0.3s;
        }

        .link-box:hover { background: #dbeafe; }

        .brief-box {
            background: #f8fafc;
            border-radius: 12px;
            padding: 12px;
            font-size: 0.82rem;
            color: #475569;
            border: 1px solid #f1f5f9;
            height: 100%;
        }

        .profile-chip {
            background: var(--navy-dark); color: white; padding: 8px 18px; border-radius: 50px; display: flex; align-items: center; gap: 12px;
        }
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
                <a href="judgeDashboard" class="btn btn-light btn-sm rounded-pill px-3 fw-bold border">
                    <i class="fa-solid fa-arrow-left me-1"></i> Dashboard
                </a>
            </div>
        </div>
    </nav>

    <div class="container pb-5">
        <div class="mb-4">
            <h2 class="fw-800 text-navy-dark mb-1">Evaluation Panel</h2>
            <p class="text-muted">Review team submissions, check their links, and assign scores.</p>
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
                <div class="row g-3 align-items-center">
                    
                    <div class="col-md-2">
                        <div class="text-primary small fw-800 text-uppercase mb-1">Team</div>
                        <h5 class="fw-bold mb-1"><%= s.getTeam().getTeamName() %></h5>
                        <span class="badge bg-light text-muted border rounded-pill">ID: <%= s.getSubmissionId() %></span>
                    </div>

                    <div class="col-md-3">
                        <div class="brief-box">
                            <strong class="text-dark d-block mb-1 small"><i class="fa-solid fa-info-circle me-1"></i> Project Brief</strong>
                            <%= (s.getSubmissionDesc() != null) ? s.getSubmissionDesc() : "No description provided." %>
                        </div>
                    </div>

                    <div class="col-md-2">
                        <div class="text-muted small fw-800 text-uppercase mb-2">Project Link</div>
                        <% if(s.getSubmissionLink() != null && !s.getSubmissionLink().isEmpty()) { %>
                            <div class="link-box">
                                <p class="text-muted mb-2" style="font-size: 0.65rem;">Click to review work:</p>
                                <a href="<%= s.getSubmissionLink() %>" target="_blank" class="btn btn-primary btn-sm w-100 rounded-pill fw-bold">
                                    <i class="fa-solid fa-external-link me-1"></i> View Project
                                </a>
                            </div>
                        <% } else { %>
                            <div class="p-2 text-center border rounded-3 bg-light">
                                <span class="text-muted small italic">No Link Provided</span>
                            </div>
                        <% } %>
                    </div>

                    <div class="col-md-3">
                        <div class="row g-2">
                            <div class="col-12">
                                <input type="number" id="marks-<%= s.getSubmissionId() %>" 
                                       class="form-control eval-input-<%= s.getSubmissionId() %> shadow-sm" 
                                       value="<%= isSaved ? myResult.getMarks() : "" %>" 
                                       <%= isSaved ? "disabled" : "" %> placeholder="Score (0-50)">
                            </div>
                            <div class="col-12">
                                <textarea id="feedback-<%= s.getSubmissionId() %>" 
                                          class="form-control eval-input-<%= s.getSubmissionId() %> shadow-sm" 
                                          rows="1" <%= isSaved ? "disabled" : "" %> 
                                          placeholder="Judge Feedback..."><%= isSaved ? myResult.getFeedback() : "" %></textarea>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-2">
                        <input type="hidden" id="sid-<%= s.getSubmissionId() %>" value="<%= s.getSubmissionId() %>">
                        <input type="hidden" id="tid-<%= s.getSubmissionId() %>" value="<%= s.getTeam().getTeamId() %>">
                        <input type="hidden" id="rid-<%= s.getSubmissionId() %>" value="<%= s.getRound().getRoundId() %>">
                        
                        <button type="button" id="btn-<%= s.getSubmissionId() %>" 
                                class="btn-action w-100 shadow-sm <%= isSaved ? "btn-edit" : "btn-save" %>" 
                                onclick="handleAction(<%= s.getSubmissionId() %>)">
                            <% if(isSaved) { %>
                                <i class="fa-solid fa-pen-to-square me-1"></i>Edit
                            <% } else { %>
                                <i class="fa-solid fa-floppy-disk me-1"></i>Save
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
                <i class="fa-solid fa-folder-open fa-3x text-muted mb-3 opacity-25"></i>
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
        btn.html("<i class='fa-solid fa-floppy-disk me-1'></i>Save").removeClass('btn-edit').addClass('btn-save');
        card.removeClass("card-saved").addClass("card-editing");
    } else {
        var mrk = $("#marks-" + id).val();
        if(!mrk || mrk < 0 || mrk > 50) { alert("Invalid Score!"); return; }

        btn.prop('disabled', true).html("<i class='fa-solid fa-spinner fa-spin'></i>");

        $.ajax({
            url: 'saveMarks',
            type: 'POST',
            data: {
                submissionId: $("#sid-" + id).val(),
                teamId: $("#tid-" + id).val(),
                roundId: $("#rid-" + id).val(),
                marks: mrk,
                feedback: $("#feedback-" + id).val()
            },
            success: function(res) {
                if(res.trim() === "SUCCESS") {
                    inputs.prop('disabled', true);
                    card.removeClass("card-editing").addClass("card-saved");
                    btn.html("<i class='fa-solid fa-pen-to-square me-1'></i>Edit").removeClass('btn-save').addClass('btn-edit').prop('disabled', false);
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