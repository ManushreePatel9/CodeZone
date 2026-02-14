<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="com.entity.*"%>
<%@ page import="java.text.SimpleDateFormat" %>

<jsp:include page="toaster_logic.jsp" />

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title><%= ((ProgramEntity)request.getAttribute("h")).getProgramName() %> | SkillAcademy</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
<link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&family=JetBrains+Mono:wght@500;700&display=swap" rel="stylesheet">

<style>
    :root {
        --primary: #4f46e5; --primary-soft: #eef2ff; --secondary: #6366f1;
        --dark: #0f172a; --slate-50: #f8fafc; --slate-100: #f1f5f9;
        --slate-200: #e2e8f0; --slate-500: #64748b; --slate-900: #1e293b;
        --emerald: #10b981; --rose: #f43f5e; --amber: #f59e0b;
    }
    body { background-color: var(--slate-50); font-family: 'Plus Jakarta Sans', sans-serif; color: var(--slate-900); margin: 0; padding: 0; }
    .hero-banner { background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%); padding: 80px 0; color: white; border-bottom: 1px solid rgba(255,255,255,0.1); }
    .img-frame img { width: 100%; height: 320px; object-fit: cover; border-radius: 16px; box-shadow: 0 20px 40px rgba(0,0,0,0.3); }
    .info-section { background: white; border-radius: 20px; padding: 35px; border: 1px solid var(--slate-200); margin-bottom: 30px; }
    
    /* STICKY SIDEBAR FIX */
    .sidebar-widget { 
        background: white; 
        border: 1px solid var(--slate-200); 
        border-radius: 24px; 
        padding: 25px; 
        position: -webkit-sticky; 
        position: sticky; 
        top: 20px; /* Space from top when scrolling */
        box-shadow: 0 10px 15px -3px rgba(0,0,0,0.05); 
        z-index: 10;
    }
    
    .detail-card { background: var(--slate-50); border-radius: 12px; padding: 15px; border-left: 4px solid var(--primary); margin-bottom: 15px; }
    .reward-pill { background: #fff7ed; border: 1px solid #fed7aa; color: #9a3412; padding: 10px 15px; border-radius: 10px; margin-bottom: 10px; display: flex; align-items: center; gap: 10px; }

    /* Timer Styles */
    .timer-container { background: var(--slate-50); padding: 15px; border-radius: 16px; border: 1px solid var(--slate-200); }
    .timer-value { font-family: 'JetBrains Mono', monospace; font-size: 1.4rem; font-weight: 800; color: var(--rose); line-height: 1; }
    .timer-label { font-size: 0.6rem; font-weight: 700; color: var(--slate-500); text-transform: uppercase; margin-top: 4px; }

    /* Team Roster Styles */
    .member-pill { display: flex; align-items: center; justify-content: space-between; padding: 12px 16px; background: var(--slate-50); border: 1px solid var(--slate-100); border-radius: 12px; margin-bottom: 10px; }
    .member-pill.leader-pill { background: var(--primary-soft); border: 1px solid #c7d2fe; }
    .member-pill.pending-pill { border: 2px dashed var(--rose); background: #fff1f2; opacity: 0.9; }
    
    .btn-action { background: var(--primary); color: white; border: none; padding: 14px 24px; border-radius: 12px; font-weight: 700; width: 100%; transition: 0.3s; display: flex; align-items: center; justify-content: center; gap: 10px; text-decoration: none; cursor: pointer; }
    .btn-action:hover { background: var(--dark); color: white; transform: translateY(-2px); }
    
    /* Timeline/Rounds Styles */
    .timeline-container { position: relative; padding-left: 40px; }
    .timeline-container::before { content: ''; position: absolute; left: 15px; top: 0; width: 2px; height: 100%; background: var(--slate-200); }
    .round-item { position: relative; margin-bottom: 30px; }
    .round-dot { position: absolute; left: -33px; top: 5px; width: 18px; height: 18px; border-radius: 50%; background: white; border: 3px solid var(--slate-200); z-index: 2; }
    .round-card { background: white; border: 2px solid var(--slate-200); border-radius: 16px; padding: 20px; transition: 0.3s; }
    .round-item.completed .round-card { border-color: var(--emerald); background: #f0fdf4; }
    .round-item.completed .round-dot { background: var(--emerald); border-color: var(--emerald); }
    .round-item.active .round-card { border-color: var(--primary); box-shadow: 0 10px 15px -3px rgba(79, 70, 229, 0.1); }
    .round-item.active .round-dot { background: var(--primary); border-color: var(--primary); animation: pulse 2s infinite; }
    @keyframes pulse { 0% { box-shadow: 0 0 0 0 rgba(79, 70, 229, 0.4); } 70% { box-shadow: 0 0 0 10px rgba(79, 70, 229, 0); } 100% { box-shadow: 0 0 0 0 rgba(79, 70, 229, 0); } }
    
    .status-requested { color: var(--rose); font-weight: 800; font-size: 0.7rem; border: 1px solid var(--rose); padding: 2px 6px; border-radius: 4px; }
    .winner-box { background: linear-gradient(135deg, #fef9c3 0%, #fde68a 100%); border: 2px solid #f59e0b; border-radius: 20px; padding: 25px; text-align: center; margin-bottom: 30px; }
    
    .round-locked { opacity: 0.7; cursor: not-allowed !important; pointer-events: none; }
    .status-badge { font-size: 0.7rem; font-weight: 800; padding: 4px 12px; border-radius: 50px; text-transform: uppercase; letter-spacing: 0.5px; }
    .badge-upcoming { background: #f1f5f9; color: #64748b; border: 1px solid var(--slate-200); }
    .badge-active { background: var(--primary-soft); color: var(--primary); border: 1px solid var(--primary); }
    .badge-completed { background: #f0fdf4; color: var(--emerald); border: 1px solid var(--emerald); }
    
    .feature-card { background: #ffffff; border: 1px solid var(--slate-200); border-radius: 16px; padding: 20px; height: 100%; transition: all 0.3s ease; }
    .feature-card:hover { border-color: var(--primary); transform: translateY(-5px); box-shadow: 0 10px 20px rgba(0,0,0,0.05); }
    .icon-circle { width: 45px; height: 45px; border-radius: 12px; display: flex; align-items: center; justify-content: center; margin-bottom: 15px; font-size: 1.2rem; }

    .reward-card-new { border-radius: 20px; padding: 25px; text-align: center; position: relative; overflow: hidden; border: 2px solid transparent; height: 100%; }
    .reward-gold { background: #fffcf0; border-color: #fde68a; }
    .reward-silver { background: #f8fafc; border-color: #e2e8f0; }
    .reward-bronze { background: #fffaf5; border-color: #ffedd5; }
    .prize-amount { font-size: 1.5rem; font-weight: 800; display: block; margin-top: 10px; }
    
    
    
    /*red border*/
    
    /* Invited/Pending Member Style */
.member-pill.pending-pill {
    border: 2px dashed var(--rose) !important;
    background: #fff1f2 !important; /* Light red background */
    opacity: 0.85;
}

.status-invited {
    color: var(--rose);
    font-size: 0.65rem;
    font-weight: 800;
    text-transform: uppercase;
    background: white;
    padding: 2px 6px;
    border-radius: 4px;
    border: 1px solid var(--rose);
}

/* Button state change when invited */
.btn-invited {
    background: var(--slate-200) !important;
    color: var(--slate-500) !important;
    pointer-events: none; /* Button disable ho jayega */
    border: none;
}

/* Invited Member Style (Red Dashed) */
.member-pill.pending-pill {
    border: 2px dashed #f43f5e !important; /* var(--rose) */
    background: #fff1f2 !important;
    animation: fadeIn 0.5s ease;
}

.status-invited-tag {
    font-size: 0.6rem;
    background: #f43f5e;
    color: white;
    padding: 1px 6px;
    border-radius: 4px;
    font-weight: 700;
    text-transform: uppercase;
}

/* Action Icons */
.action-btn-group {
    display: flex;
    gap: 8px;
    align-items: center;
}

.btn-view-profile {
    color: #64748b;
    transition: 0.2s;
    font-size: 0.9rem;
}

.btn-view-profile:hover { color: #4f46e5; }

.btn-delete-req {
    color: #f43f5e;
    background: none;
    border: none;
    padding: 0;
    font-size: 1rem;
}

/* Invited Button State in List */
.btn-invited-disabled {
    background: #f1f5f9 !important;
    color: #94a3b8 !important;
    border: 1px solid #e2e8f0 !important;
    cursor: not-allowed;
    font-weight: 600;
    pointer-events: none;
}

@keyframes fadeIn {
    from { opacity: 0; transform: translateY(5px); }
    to { opacity: 1; transform: translateY(0); }
}

/* last css of invites*/
/* Attractive Invited Badge */
.btn-invited-status {
    background: #f1f5f9;
    color: #64748b;
    border: 1px solid #e2e8f0;
    padding: 5px 15px;
    border-radius: 50px;
    font-size: 0.75rem;
    font-weight: 700;
    text-transform: uppercase;
    letter-spacing: 0.5px;
    display: inline-flex;
    align-items: center;
    gap: 5px;
    cursor: default;
}

/* Profile Eye Icon (Beside Button) */
.profile-eye-link {
    width: 25px;
    height: 25px;
    display: flex;
    align-items: center;
    justify-content: center;
    border-radius: 50%;
    background: #eef2ff;
    color: #4f46e5;
    transition: all 0.3s ease;
    margin-right: 8px; /* Button se pehle gap */
}


/* User Name styling in list */
.user-name-text {
    font-size: 0.85rem;
    font-weight: 600;
    color: #1e293b;
}
</style>
</head>

<body>

<%
ProgramEntity h = (ProgramEntity)request.getAttribute("h");
List<UserEntity> participants = (List<UserEntity>) request.getAttribute("participants");
List<RequestEntity> reqReceivers = (List<RequestEntity>) request.getAttribute("reqReceivers");
List<TeamEntity> teams = (List<TeamEntity>) request.getAttribute("teams");
List<SubmissionEntity> submissions = (List<SubmissionEntity>) request.getAttribute("submissions");
UserEntity user = (UserEntity) session.getAttribute("user");

Integer curProgramId = h.getProgramId();
Integer activeTeamId = null;
String activeTeamName = "";
String leaderName = "";
boolean isLeader = false;
boolean isRegistered = false;

if(teams != null && user != null) {
    for(TeamEntity teamRow : teams) {
        if(teamRow.getProgramId().equals(curProgramId)) {
            if(teamRow.getMem1().equals(user.getUserId())) {
                activeTeamId = teamRow.getTeamId(); activeTeamName = teamRow.getTeamName();
                isRegistered = teamRow.isRegistered(); isLeader = true; break;
            }
            boolean userAccepted = false;
            if(reqReceivers != null) {
                for(RequestEntity re : reqReceivers) {
                    if(re.getTeam().getTeamId().equals(teamRow.getTeamId()) && 
                       re.getReceiver() != null && re.getReceiver().getUserId().equals(user.getUserId()) && 
                       "accepted".equalsIgnoreCase(re.getStatus())) { userAccepted = true; break; }
                }
            }
            if(userAccepted) {
                activeTeamId = teamRow.getTeamId(); activeTeamName = teamRow.getTeamName();
                isRegistered = teamRow.isRegistered(); break;
            }
        }
    }
}

Set<Integer> enrolledUserIds = new HashSet<>();
if(teams != null) {
    for(TeamEntity t : teams) { if(t.getProgramId().equals(curProgramId)) enrolledUserIds.add(t.getMem1()); }
}
if(reqReceivers != null) {
    for(RequestEntity req : reqReceivers) {
        if(req.getTeam().getProgramId().equals(curProgramId) && "accepted".equalsIgnoreCase(req.getStatus())) {
            enrolledUserIds.add(req.getReceiver().getUserId());
        }
    }
}

if(activeTeamId != null && teams != null) {
    for(TeamEntity t : teams) {
        if(t.getTeamId().equals(activeTeamId)) {
            for(UserEntity u : participants) { if(u.getUserId().equals(t.getMem1())) { leaderName = u.getFirstName() + " "+u.getLastName(); break; } }
        }
    }
}

Date today = new Date();
Date deadline = h.getRegistrationDeadline();
Date resultDate = h.getWinnerPublishDate(); 
boolean isExpired = (deadline != null) && today.after(deadline);
boolean isResultLive = (resultDate != null && !today.before(resultDate));

int currentTeamSize = 1; 
if(reqReceivers != null && activeTeamId != null) {
    for(RequestEntity req : reqReceivers) {
        if(req.getTeam().getTeamId().equals(activeTeamId) && "accepted".equalsIgnoreCase(req.getStatus())) { currentTeamSize++; }
    }
}
int minSize = (h.getMinTeamSize() != null) ? h.getMinTeamSize() : 1;
int maxSize = (h.getMaxTeamSize() != null) ? h.getMaxTeamSize() : 5;
%>

<div class="hero-banner">
    <div class="container">
        <div class="row align-items-center">
            <div class="col-lg-7">
                <h1 class="display-4 fw-800 text-white"><%= h.getProgramName() %></h1>
                <p class="text-white-50"><i class="fa-solid fa-calendar me-2 text-primary"></i>Starts: <%= h.getStartDate() %></p>
                <div class="d-flex gap-3 mt-4">
                    <span class="badge bg-primary px-3 py-2"><i class="fa-solid fa-users me-1"></i> Team Size: <%=minSize%>-<%=maxSize%></span>
                    <span class="badge bg-success px-3 py-2"><i class="fa-solid fa-location-dot me-1"></i> <%=h.getCity()%></span>
                </div>
            </div>
            <div class="col-lg-5">
                <% if(h.getPic() != null) { %> <div class="img-frame"><img src="<%= h.getPic() %>"></div> <% } %>
            </div>
        </div>
    </div>
</div>

<div class="container mt-5 pb-5">
    <div class="row g-4 align-items-start"> <div class="col-lg-8">
            <%-- RESULTS SECTION --%>
            <% if(isRegistered) { %>
                <% if(isResultLive) { %>
                    <div class="winner-box shadow-sm">
                        <h3 class="fw-800 text-dark mb-2">🎉 THE RESULTS ARE OUT! 🎉</h3>
                        <p class="text-muted mb-4">Check out the top performers and winners of <b><%= h.getProgramName() %></b>.</p>
                        <a href="winnerDisplay?programId=<%= h.getProgramId() %>" class="btn btn-dark px-5 py-3 rounded-pill fw-bold">
                           <i class="fa-solid fa-trophy text-warning me-2"></i> VIEW WINNERS LIST
                        </a>
                    </div>
                <% } else if (resultDate != null) { %>
                    <div class="alert alert-info border-0 rounded-4 p-4 mb-4 shadow-sm d-flex align-items-center">
                        <i class="fa-solid fa-hourglass-half fa-2x me-3 opacity-50"></i>
                        <div>
                            <h6 class="fw-bold mb-1">Final Result Awaited</h6>
                            <p class="small mb-0 opacity-75">Winners will be announced on <b><%= new SimpleDateFormat("dd MMM, yyyy").format(resultDate) %></b>.</p>
                        </div>
                    </div>
                <% } %>
            <% } %>

            <%-- ROUNDS SECTION --%>
            <% if(isRegistered) { %>
            <div class="info-section">
                <h4 class="fw-bold mb-4 text-dark"><i class="fa-solid fa-route text-primary me-2"></i>Program Roadmap</h4>
                <div class="timeline-container">
                    <% if(h.getRounds() != null && !h.getRounds().isEmpty()) {
                        List<ProgramRoundsEntity> sortedRounds = new ArrayList<>(h.getRounds());
                        Collections.sort(sortedRounds, Comparator.comparing(ProgramRoundsEntity::getRoundNo));
                        SimpleDateFormat dateTimeFmt = new SimpleDateFormat("dd MMM, yyyy | hh:mm a");
                        for(ProgramRoundsEntity round : sortedRounds) {
                            Date rStart = round.getStartDate(); Date rEnd = round.getEndDate();
                            String statusClass = ""; String statusLabel = ""; String badgeClass = ""; boolean isInteractable = false;
                            if (today.after(rEnd)) { statusClass = "completed"; statusLabel = "Completed"; badgeClass = "badge-completed"; }
                            else if (today.after(rStart) || today.equals(rStart)) { statusClass = "active"; statusLabel = "Active Now"; badgeClass = "badge-active"; isInteractable = true; }
                            else { statusClass = "upcoming"; statusLabel = "Upcoming"; badgeClass = "badge-upcoming"; }
                    %>
                    <div class="round-item <%= statusClass %> <%= !isInteractable ? "round-locked" : "" %>">
                        <div class="round-dot"></div>
                        <div class="round-card shadow-sm mb-4">
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <span class="status-badge <%= badgeClass %>"><%= statusLabel %></span>
                                <small class="text-muted d-block" style="font-size: 0.75rem;">ROUND <%= round.getRoundNo() %></small>
                            </div>
                            <h5 class="fw-bold text-dark mb-3"><%= round.getRoundName() %></h5>
                            <div class="row g-2 mb-3">
                                <div class="col-sm-6"><div class="p-2 rounded-3 bg-light border"><small class="text-muted d-block small">Starts</small><span class="small fw-bold"><%= dateTimeFmt.format(rStart) %></span></div></div>
                                <div class="col-sm-6"><div class="p-2 rounded-3 bg-light border"><small class="text-muted d-block small">Ends</small><span class="small fw-bold"><%= dateTimeFmt.format(rEnd) %></span></div></div>
                            </div>
                            <p class="small text-secondary mb-0"><%= round.getRoundDesc() %></p>
                            <% if(isInteractable) { %>
                                <div class="mt-4 pt-3 border-top">
                                    <% SubmissionEntity existingSub = null;
                                       if(submissions != null) { for(SubmissionEntity sub : submissions) { if(sub.getRound().getRoundId().equals(round.getRoundId()) && sub.getTeam().getTeamId().equals(activeTeamId)) { existingSub = sub; break; } } }
                                       if(existingSub == null) { if(isLeader) { %>
                                            <div class="bg-primary-soft p-3 rounded-4">
                                                <form method="post" action="saveLink">
                                                    <input type="url" name="submissionLink" class="form-control form-control-sm mb-2" placeholder="Submission Link" required>
                                                    <div class="input-group">
                                                        <input type="text" name="submissionDesc" class="form-control form-control-sm" placeholder="Notes" required>
                                                        <input type="hidden" name="roundNo" value="<%= round.getRoundNo() %>">
                                                        <input type="hidden" name="programId" value="<%= h.getProgramId() %>">
                                                        <input type="hidden" name="teamId" value="<%= activeTeamId %>">
                                                        <button type="submit" class="btn btn-primary btn-sm px-3 shadow-sm">Submit</button>
                                                    </div>
                                                </form>
                                            </div>
                                        <% } else { %>
                                            <div class="alert alert-light border small mb-0"><i class="fa-solid fa-user-tie me-2"></i> Only Team Leader can submit.</div>
                                        <% } } else { %>
                                        <div class="p-3 bg-white rounded-4 border border-emerald d-flex align-items-center justify-content-between">
                                            <div><span class="badge bg-emerald text-white mb-2">SUBMITTED</span><br><a href="<%= existingSub.getSubmissionLink() %>" target="_blank" class="small text-decoration-none"><%= existingSub.getSubmissionLink() %></a></div>
                                            <i class="fa-solid fa-file-circle-check fa-2x text-emerald opacity-25"></i>
                                        </div>
                                    <% } %>
                                </div>
                            <% } %>
                        </div>
                    </div>
                    <% } } %>
                </div>
            </div>
            <% } %>

            <%-- ABOUT SECTION --%>
            <div class="info-section">
                <div class="d-flex align-items-center mb-4">
                    <div class="icon-circle bg-primary-soft text-primary mb-0 me-3"><i class="fa-solid fa-circle-info"></i></div>
                    <h4 class="fw-800 mb-0">Program Overview</h4>
                </div>
                <div class="text-muted mb-5 ps-2 border-start border-3" style="line-height: 1.8;">
                    <%= (h.getDetails() != null) ? h.getDetails().getDetail() : "No description available." %>
                </div>
                <% if(h.getDetails() != null) { %>
                    <div class="row g-4">
                        <div class="col-md-6"><div class="feature-card"><div class="icon-circle bg-primary-soft text-primary"><i class="fa-solid fa-graduation-cap"></i></div><h6 class="fw-bold">Eligibility</h6><p class="small text-secondary mb-0"><%= h.getDetails().getEligibility() %></p></div></div>
                        <div class="col-md-6"><div class="feature-card"><div class="icon-circle bg-danger-subtle text-danger"><i class="fa-solid fa-gavel"></i></div><h6 class="fw-bold">Rules</h6><p class="small text-secondary mb-0"><%= h.getDetails().getRules() %></p></div></div>
                        <div class="col-md-6"><div class="feature-card"><div class="icon-circle bg-success-subtle text-success"><i class="fa-solid fa-brain"></i></div><h6 class="fw-bold">Skills</h6><p class="small text-secondary mb-0"><%= h.getDetails().getSkills() %></p></div></div>
                        <div class="col-md-6"><div class="feature-card"><div class="icon-circle bg-warning-subtle text-warning"><i class="fa-solid fa-building-columns"></i></div><h6 class="fw-bold">Venue</h6><p class="small text-secondary mb-0"><%= h.getDetails().getCollege() %></p></div></div>
                    </div>
                <% } %>
            </div>

            <%-- REWARDS SECTION --%>
            <% if(h.getRewards() != null) { %>
            <div class="info-section">
                <div class="d-flex align-items-center mb-4">
                    <div class="icon-circle bg-warning-subtle text-warning mb-0 me-3"><i class="fa-solid fa-gift"></i></div>
                    <h4 class="fw-800 mb-0">Rewards</h4>
                </div>
                <div class="row g-4">
                    <div class="col-md-4"><div class="reward-card-new reward-gold"><i class="fa-solid fa-trophy text-warning fa-3x mb-3"></i><h6 class="fw-bold">Winner</h6><span class="prize-amount"><%= h.getRewards().getPrize1() %></span></div></div>
                    <div class="col-md-4"><div class="reward-card-new reward-silver"><i class="fa-solid fa-medal text-secondary fa-3x mb-3"></i><h6 class="fw-bold">1st Runner Up</h6><span class="prize-amount"><%= h.getRewards().getPrize2() %></span></div></div>
                    <div class="col-md-4"><div class="reward-card-new reward-bronze"><i class="fa-solid fa-award fa-3x mb-3" style="color:#cd7f32;"></i><h6 class="fw-bold">2nd Runner Up</h6><span class="prize-amount"><%= h.getRewards().getPrize3() %></span></div></div>
                </div>
            </div>
            <% } %>
        </div>

        <%-- SIDEBAR --%>
        <div class="col-lg-4">
            <div class="sidebar-widget">
                <% if(!isExpired && deadline != null && !isRegistered) { %>
                <div class="text-center mb-4">
                    <small class="text-slate-500 fw-bold text-uppercase">Registration Ends In</small>
                    <div class="timer-container mt-2">
                        <div class="d-flex justify-content-center gap-2">
                            <div><div class="timer-value" id="days">00</div><div class="timer-label">Days</div></div>
                            <div class="timer-value">:</div>
                            <div><div class="timer-value" id="hours">00</div><div class="timer-label">Hrs</div></div>
                            <div class="timer-value">:</div>
                            <div><div class="timer-value" id="minutes">00</div><div class="timer-label">Min</div></div>
                            <div class="timer-value">:</div>
                            <div><div class="timer-value" id="seconds">00</div><div class="timer-label">Sec</div></div>
                        </div>
                    </div>
                </div>
                <% } %>









              <%-- SIDEBAR TEAM SECTION --%>
<%-- Anchor for Page Position --%>
<div id="team-anchor"></div>

<% if(activeTeamId != null) { %>
    <div class="sidebar-widget">
        <div class="mb-4">
            <div class="d-flex justify-content-between align-items-center mb-2">
                <label class="small fw-bold text-muted text-uppercase">Team Name</label>
                <span class="badge bg-primary-soft text-primary"><%= currentTeamSize %> / <%= maxSize %> Members</span>
            </div>
            <div class="input-group input-group-sm">
                <input type="text" id="tname" class="form-control fw-bold" value="<%= activeTeamName %>" <%= (isRegistered || !isLeader) ? "readonly" : "" %>>
                <% if(isLeader && !isRegistered) { %>
                    <button class="btn btn-dark" onclick="updateTeamName('<%=activeTeamId%>', '<%=curProgramId%>')">Update</button>
                <% } %>
            </div>
        </div>

        <div class="roster-list">
            <%-- LEADER --%>
            <div class="member-pill leader-pill">
                <span class="small fw-bold"><i class="fa-solid fa-crown text-warning me-2"></i><%= leaderName %></span>
                <span class="badge bg-white text-primary">Leader</span>
            </div>

            <%-- ACCEPTED MEMBERS --%>
            <% if(reqReceivers != null) { 
                for(RequestEntity req : reqReceivers) { 
                    if(req.getTeam().getTeamId().equals(activeTeamId) && "accepted".equalsIgnoreCase(req.getStatus())) { %>
                        <div class="member-pill">
                            <span class="small fw-semibold"><%= req.getReceiver().getFirstName() %></span>
                            <div class="action-btn-group">
                                <a href="viewMyProfile?userId=<%=req.getReceiver().getUserId()%>" title="View Profile" class="btn-view-profile">
                                    <i class="fa-solid fa-eye"></i>
                                </a>
                                <% if(isLeader && !isRegistered) { %>
                                    <button class="btn-delete-req" onclick="removeMember('<%=curProgramId%>', '<%=activeTeamId%>', '<%=req.getReceiver().getUserId()%>')">
                                        <i class="fa-solid fa-circle-xmark"></i>
                                    </button>
                                <% } %>
                            </div>
                        </div>
            <%      } 
                } 
            } %>

            <%-- INVITED MEMBERS (RED DASHED) --%>
            <% if(reqReceivers != null && isLeader && !isRegistered) { 
                for(RequestEntity req : reqReceivers) { 
                    if(req.getTeam().getTeamId().equals(activeTeamId) && "pending".equalsIgnoreCase(req.getStatus())) { %>
                        <div class="member-pill pending-pill">
                            <div>
                                <span class="small fw-semibold"><%= req.getReceiver().getFirstName() %> <%= req.getReceiver().getLastName() %></span>
                            </div>
                            <div class="action-btn-group">
                                <a href="viewMyProfile?userId=<%=req.getReceiver().getUserId()%>" title="View Profile" class="btn-view-profile">
                                    <i class="fa-solid fa-eye"></i>
                                </a>
                                <button class="btn-delete-req" title="Cancel Request" 
                                        onclick="cancelRequest('<%=curProgramId%>', '<%=activeTeamId%>', '<%=req.getReceiver().getUserId()%>', '<%=req.getReceiver().getEmail()%>')">
                                    <i class="fa-solid fa-trash-can"></i>
                                </button>
                            </div>
                        </div>
            <%      } 
                } 
            } %>
        </div>

        <%-- BUTTONS --%>
        <% if(!isRegistered && isLeader) { %>
            <div class="mt-4 pt-3 border-top">
                <% if(currentTeamSize >= minSize) { %>
                    <button class="btn btn-success w-100 py-3 rounded-3 fw-bold mb-3 shadow-sm" onclick="finalRegistration('<%=activeTeamId%>', '<%=curProgramId%>')">REGISTER TEAM</button>
                <% } else { %>
                    <div class="alert alert-warning py-2 small text-center">Need <%= (minSize - currentTeamSize) %> more member(s).</div>
                <% } %>
                <div class="row g-2">
                    <div class="col-6"><button class="btn-action btn-sm py-2" style="font-size: 0.8rem; background: var(--dark);" onclick="checkAndManualInvite('<%=curProgramId%>', '<%=activeTeamId%>', '<%=currentTeamSize%>', '<%=maxSize%>')">Email</button></div>
                    <div class="col-6"><button class="btn-action btn-sm py-2" style="font-size: 0.8rem;" onclick="toggleParticipants()">Find Users</button></div>
                </div>
            </div>

            <div id="participantsBox" class="mt-3" style="display:none; max-height:250px; overflow-y:auto; background:white; padding:15px; border-radius:12px; border:1px solid var(--slate-200);">
                <% if(participants != null) { 
                    for(UserEntity u : participants) { 
                        if(u.getUserId() != user.getUserId() && !enrolledUserIds.contains(u.getUserId())) { 
                            boolean isAlreadyInvited = false;
                            if(reqReceivers != null) {
                                for(RequestEntity r : reqReceivers) {
                                    if(r.getTeam().getTeamId().equals(activeTeamId) && r.getReceiver().getUserId().equals(u.getUserId())) {
                                        isAlreadyInvited = true; break;
                                    }
                                }
                            }
                %>
                   <div class="d-flex justify-content-between align-items-center mb-3 pb-2 border-bottom">
    <%-- Left Side: Name and Identity --%>
    <div class="d-flex align-items-center">
        <span class="user-name-text"><%=u.getFirstName()%> <%=u.getLastName()%></span>
    </div>

    <%-- Right Side: Profile Eye + Action Button --%>
    <div class="d-flex align-items-center">
        <a href="viewMyProfile?userId=<%=u.getUserId()%>" class="profile-eye-link" title="View Profile">
            <i class="fa-solid fa-eye"></i>
        </a>

        <% if(isAlreadyInvited) { %>
            <div class="btn-invited-status">
                <i class="fa-solid fa-paper-plane small opacity-75"></i> Invited
            </div>
        <% } else { %>
            <button class="btn btn-sm btn-primary py-1 px-3 rounded-pill fw-bold" 
                    onclick="inviteMember('<%=u.getUserId()%>', '<%=user.getUserId()%>', '<%=curProgramId%>', '<%=activeTeamId%>', '<%=currentTeamSize%>', '<%=maxSize%>')">
                Invite
            </button>
        <% } %>
    </div>
</div>
                <%      } 
                    } 
                } %>
            </div>
        <% } %>
    </div>
<% } %>

<script>
function cancelRequest(pid, tid, uid, email) {
    if(confirm("Cancel this invitation?")) {
        window.location.href = "cancelRequest?pid=" + pid + "&teamId=" + tid + "&userId=" + uid + "&email=" + encodeURIComponent(email) + "#team-anchor";
    }
}

function inviteMember(id, sid, pid, tid, curr, max) {
    if(parseInt(curr) >= parseInt(max)) {
        alert("Team is already full!");
        return;
    }
    window.location.href = "sendMakeTeamRequest?senderId=" + sid + "&receiverId=" + id + "&pid=" + pid + "&teamId=" + tid + "#team-anchor";
}

function removeMember(pid, tid, uid) {
    if(confirm("Remove this member from team?")) {
        window.location.href = "removeTeamMember?pid=" + pid + "&teamId=" + tid + "&userId=" + uid + "#team-anchor";
    }
}
    // TIMER SCRIPT WITH SECONDS
    function startTimer(deadlineStr) {
        const targetDate = new Date(deadlineStr).getTime();
        
        const timerInterval = setInterval(function() {
            const now = new Date().getTime();
            const distance = targetDate - now;
            
            if (distance < 0) {
                clearInterval(timerInterval);
                return;
            }
            
            const days = Math.floor(distance / (1000 * 60 * 60 * 24));
            const hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
            const minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
            const seconds = Math.floor((distance % (1000 * 60)) / 1000);
            
            if(document.getElementById("days")) document.getElementById("days").innerText = days.toString().padStart(2, '0');
            if(document.getElementById("hours")) document.getElementById("hours").innerText = hours.toString().padStart(2, '0');
            if(document.getElementById("minutes")) document.getElementById("minutes").innerText = minutes.toString().padStart(2, '0');
            if(document.getElementById("seconds")) document.getElementById("seconds").innerText = seconds.toString().padStart(2, '0');
        }, 1000);
    }

    <% if(deadline != null) { %>
        startTimer("<%= new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss").format(deadline) %>");
    <% } %>
    
    
    <% if(!isExpired && deadline != null && !isRegistered) { %>
    (function() {
        const dDate = new Date('<%= deadline %>').getTime();
        const timer = setInterval(function() {
            const now = new Date().getTime();
            const dist = dDate - now;
            if (dist < 0) { clearInterval(timer); location.reload(); return; }
            document.getElementById("days").innerHTML = Math.floor(dist / (1000*60*60*24)).toString().padStart(2, '0');
            document.getElementById("hours").innerHTML = Math.floor((dist % (1000*60*60*24)) / (1000*60*60)).toString().padStart(2, '0');
            document.getElementById("minutes").innerHTML = Math.floor((dist % (1000*60*60)) / (1000*60)).toString().padStart(2, '0');
            document.getElementById("seconds").innerHTML = Math.floor((dist % (1000*60)) / 1000).toString().padStart(2, '0');
        }, 1000);
    })();
    <% } %>

    window.onload = function() {
        if(sessionStorage.getItem("findUsersOpen") === "true") { document.getElementById("participantsBox").style.display = "block"; }
    };

    function toggleParticipants() {
        const box = document.getElementById("participantsBox");
        const isHidden = box.style.display === "none" || box.style.display === "";
        box.style.display = isHidden ? "block" : "none";
        sessionStorage.setItem("findUsersOpen", isHidden);
    }

    function updateTeamName(tid, pid) {
        const tName = document.getElementById("tname").value.trim();
        if(!tName) return alert("Team name empty");
        window.location.href = "updateTeamName?teamId=" + tid + "&tName=" + encodeURIComponent(tName) + "#team-section";
    }

    function finalRegistration(tid, pid) {
        if(confirm("Confirm final registration?")) window.location.href="registerTeam?teamId="+tid+"&pid="+pid;
    }

    function inviteMember(id, sid, pid, tid, curr, max) {
        if(parseInt(curr) >= parseInt(max)) return alert("Team full!");
        window.location.href="sendMakeTeamRequest?senderId="+sid+"&receiverId="+id+"&pid="+pid+"&teamId="+tid + "#team-section";
    }

    function viewProfile(userId) { window.location.href = "viewMyProfile?userId=" + userId; }
    function removeMember(pid, tid, uid) { if(confirm("Remove?")) window.location.href="removeTeamMember?pid="+pid+"&teamId="+tid+"&userId="+uid + "#team-section"; }
    function withdrawRequest(pid, tid, uid, email) { if(confirm("Cancel?")) window.location.href="cancelRequest?pid="+pid+"&teamId="+tid+"&userId="+uid+"&email="+encodeURIComponent(email) + "#team-section"; }
    function checkAndManualInvite(pid, tid, curr, max) {
        if(parseInt(curr) >= parseInt(max)) alert("Team full!");
        else window.location.href="addMemManuallyForm?pid="+pid+"&teamId="+tid;
    }
    
</script>

</body>
</html>