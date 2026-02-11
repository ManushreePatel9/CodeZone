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
        --gold-gradient: linear-gradient(135deg, #fbbf24 0%, #d97706 100%);
    }
    body { background-color: var(--slate-50); font-family: 'Plus Jakarta Sans', sans-serif; color: var(--slate-900); }

    /* --- Attractive Hero Banner --- */
    .hero-banner { 
        background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%); 
        padding: 100px 0; color: white; position: relative; overflow: hidden;
    }
    .hero-banner::after {
        content: ''; position: absolute; top: -50%; right: -10%; width: 500px; height: 500px;
        background: radial-gradient(circle, rgba(79, 70, 229, 0.2) 0%, transparent 70%);
    }
    .img-frame img { width: 100%; height: 350px; object-fit: cover; border-radius: 24px; box-shadow: 0 25px 50px -12px rgba(0,0,0,0.5); border: 1px solid rgba(255,255,255,0.1); }
    
    .banner-chip {
        background: rgba(255, 255, 255, 0.05); backdrop-filter: blur(10px);
        border: 1px solid rgba(255, 255, 255, 0.1); padding: 12px 25px;
        border-radius: 16px; display: flex; align-items: center; gap: 15px;
        transition: 0.3s;
    }
    .banner-chip:hover { background: rgba(255, 255, 255, 0.1); transform: translateY(-5px); }
    .banner-chip i { font-size: 1.5rem; color: #fbbf24; }

    /* --- Info Sections --- */
    .info-section { background: white; border-radius: 24px; padding: 35px; border: 1px solid var(--slate-200); margin-bottom: 30px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.02); }
    .sidebar-widget { background: white; border: 1px solid var(--slate-200); border-radius: 24px; padding: 25px; position: sticky; top: 30px; box-shadow: 0 20px 25px -5px rgba(0,0,0,0.05); }

    /* --- Attractive Rewards --- */
    .reward-card-premium {
        background: white; border-radius: 20px; padding: 20px;
        border: 1px solid #fde68a; position: relative; overflow: hidden;
        transition: 0.3s; margin-bottom: 15px; display: flex; align-items: center; gap: 15px;
    }
    .reward-card-premium:hover { transform: scale(1.03); box-shadow: 0 10px 20px rgba(251, 191, 36, 0.1); }
    .reward-icon-box {
        width: 50px; height: 50px; border-radius: 12px; background: #fffbeb;
        display: flex; align-items: center; justify-content: center; font-size: 1.5rem; color: #fbbf24;
    }
    .reward-1 { border-left: 5px solid #fbbf24; }
    .reward-2 { border-left: 5px solid #94a3b8; }
    .reward-3 { border-left: 5px solid #b45309; }

    /* --- Blinking Roadmap --- */
    .round-item.active .round-card { 
        border: 2px solid var(--primary); 
        background: linear-gradient(to right, #fff, #f5f3ff);
        animation: borderBlink 1.5s infinite alternate;
    }
    @keyframes borderBlink {
        from { border-color: var(--primary); box-shadow: 0 0 5px rgba(79, 70, 229, 0.2); }
        to { border-color: var(--rose); box-shadow: 0 0 20px rgba(244, 63, 94, 0.3); }
    }
    .blink-dot {
        width: 10px; height: 10px; background: var(--rose); border-radius: 50%;
        display: inline-block; margin-right: 8px; animation: pulseRed 1s infinite;
    }
    @keyframes pulseRed { 0% { transform: scale(0.9); opacity: 1; } 100% { transform: scale(2); opacity: 0; } }

    /* --- General Utilities --- */
    .dossier-label { font-size: 0.75rem; font-weight: 800; color: var(--slate-500); text-uppercase; margin-bottom: 5px; display: block; }
    .dossier-value { font-weight: 700; color: var(--slate-900); }
    .member-pill { padding: 12px; background: var(--slate-50); border-radius: 12px; margin-bottom: 8px; display: flex; justify-content: space-between; align-items: center; }
    .timer-value { font-family: 'JetBrains Mono'; font-size: 1.6rem; font-weight: 800; color: var(--rose); }
    .btn-action { background: var(--primary); color: white; padding: 15px; border-radius: 15px; font-weight: 700; width: 100%; display: block; text-align: center; text-decoration: none; transition: 0.3s; }
    .btn-action:hover { background: var(--dark); transform: translateY(-3px); color: white; }
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
            if(reqReceivers != null) {
                for(RequestEntity re : reqReceivers) {
                    if(re.getTeam().getTeamId().equals(teamRow.getTeamId()) && 
                       re.getReceiver() != null && re.getReceiver().getUserId().equals(user.getUserId()) && 
                       "accepted".equalsIgnoreCase(re.getStatus())) {
                        activeTeamId = teamRow.getTeamId(); activeTeamName = teamRow.getTeamName();
                        isRegistered = teamRow.isRegistered(); break;
                    }
                }
            }
        }
    }
}

Set<Integer> enrolledUserIds = new HashSet<>();
if(teams != null) { for(TeamEntity t : teams) if(t.getProgramId().equals(curProgramId)) enrolledUserIds.add(t.getMem1()); }
if(reqReceivers != null) { for(RequestEntity req : reqReceivers) if(req.getTeam().getProgramId().equals(curProgramId) && "accepted".equalsIgnoreCase(req.getStatus())) enrolledUserIds.add(req.getReceiver().getUserId()); }

if(activeTeamId != null && teams != null) {
    for(TeamEntity t : teams) if(t.getTeamId().equals(activeTeamId)) {
        for(UserEntity u : participants) if(u.getUserId().equals(t.getMem1())) { leaderName = u.getFirstName(); break; }
    }
}

Date today = new Date();
Date deadline = h.getRegistrationDeadline();
Date resultDate = h.getWinnerPublishDate(); 
boolean isExpired = (deadline != null) && today.after(deadline);
boolean isResultLive = (resultDate != null && !today.before(resultDate));
int currentTeamSize = 1; 
if(reqReceivers != null && activeTeamId != null) { for(RequestEntity req : reqReceivers) if(req.getTeam().getTeamId().equals(activeTeamId) && "accepted".equalsIgnoreCase(req.getStatus())) currentTeamSize++; }
int minSize = (h.getMinTeamSize() != null) ? h.getMinTeamSize() : 1;
int maxSize = (h.getMaxTeamSize() != null) ? h.getMaxTeamSize() : 5;
%>

<div class="hero-banner">
    <div class="container">
        <div class="row align-items-center">
            <div class="col-lg-7">
                <span class="badge bg-primary px-3 py-2 mb-3 text-uppercase fw-bold" style="letter-spacing: 1px;">
                    <i class="fa-solid fa-fire-flame-curved me-1"></i> <%= (h.getDetails() != null) ? h.getDetails().getProgramType() : "Event" %>
                </span>
                <h1 class="display-3 fw-800 text-white mb-4"><%= h.getProgramName() %></h1>
                
                <div class="d-flex flex-wrap gap-3">
                    <div class="banner-chip">
                        <i class="fa-solid fa-building-user"></i>
                        <div><small class="d-block text-white-50">Organizer</small><strong><%= h.getOrganizerName() %></strong></div>
                    </div>
                    <div class="banner-chip">
                        <i class="fa-solid fa-ticket"></i>
                        <div><small class="d-block text-white-50">Entry Fee</small><strong><%= (h.getDetails() != null && h.getDetails().getFees() > 0) ? "₹" + h.getDetails().getFees() : "FREE" %></strong></div>
                    </div>
                    <div class="banner-chip">
                        <i class="fa-solid fa-map-pin"></i>
                        <div><small class="d-block text-white-50">Location</small><strong><%= h.getCity() %></strong></div>
                    </div>
                </div>
            </div>
            <div class="col-lg-5 text-center">
                <% if(h.getPic() != null) { %> <div class="img-frame"><img src="<%= h.getPic() %>"></div> <% } %>
            </div>
        </div>
    </div>
</div>

<div class="container mt-5 pb-5">
    <div class="row g-4">
        <div class="col-lg-8">
            
            <%-- Winners Link --%>
            <% if(isRegistered && isResultLive) { %>
                <div class="winner-box shadow-sm mb-4">
                    <h3 class="fw-800 text-dark">🏆 WINNERS ANNOUNCED!</h3>
                    <a href="winnerDisplay?programId=<%= h.getProgramId() %>" class="btn btn-dark px-5 py-3 rounded-pill fw-bold mt-2">VIEW RESULTS</a>
                </div>
            <% } %>

            <% if(isRegistered) { %>
            <div class="info-section">
                <h4 class="fw-bold mb-4"><i class="fa-solid fa-map text-primary me-2"></i>Roadmap</h4>
                <div class="timeline-container">
                    <% if(h.getRounds() != null) { for(ProgramRoundsEntity round : h.getRounds()) {
                        Date rStart = round.getStartDate(); Date rEnd = round.getEndDate();
                        boolean isActive = (today.after(rStart) || today.equals(rStart)) && !today.after(rEnd);
                        boolean isPast = today.after(rEnd);
                        
                        SubmissionEntity existingSub = null;
                        if(submissions != null) { for(SubmissionEntity sub : submissions) if(sub.getRound().getRoundId().equals(round.getRoundId()) && sub.getTeam().getTeamId().equals(activeTeamId)) { existingSub = sub; break; } }
                    %>
                    <div class="round-item <%= isPast ? "completed" : (isActive ? "active" : "round-locked") %>">
                        <div class="round-dot"></div>
                        <div class="round-card">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <% if(isActive) { %><span class="blink-dot"></span><% } %>
                                    <span class="small fw-bold text-muted">ROUND <%= round.getRoundNo() %></span>
                                    <h5 class="fw-bold my-1"><%= round.getRoundName() %></h5>
                                </div>
                                <span class="badge <%= isPast ? "bg-success" : (isActive ? "bg-danger" : "bg-secondary") %>">
                                    <%= isPast ? "Done" : (isActive ? "LIVE" : "Locked") %>
                                </span>
                            </div>
                            
                            <% if(isActive) { %>
                                <div class="mt-3 p-3 bg-white rounded border">
                                    <% if(existingSub == null) { %>
                                        <% if(isLeader) { %>
                                            <form method="post" action="saveLink">
                                                <input type="text" name="submissionLink" class="form-control mb-2" placeholder="Submission URL" required>
                                                <input type="text" name="submissionDesc" class="form-control mb-2" placeholder="Brief Description" required>
                                                <input type="hidden" name="roundNo" value="<%= round.getRoundNo() %>">
                                                <input type="hidden" name="programId" value="<%= h.getProgramId() %>">
                                                <input type="hidden" name="teamId" value="<%= activeTeamId %>">
                                                <button type="submit" class="btn btn-primary w-100">Submit Now</button>
                                            </form>
                                        <% } else { %><p class="small text-muted mb-0 italic">Waiting for leader submission...</p><% } %>
                                    <% } else { %>
                                        <div class="text-success small fw-bold"><i class="fa-solid fa-check-double"></i> Submitted: <a href="<%= existingSub.getSubmissionLink() %>" target="_blank">View Link</a></div>
                                    <% } %>
                                </div>
                            <% } %>
                        </div>
                    </div>
                    <% } } %>
                </div>
            </div>
            <% } %>

            <div class="info-section">
                <h4 class="fw-bold mb-4"><i class="fa-solid fa-trophy text-warning me-2"></i>Prizes & Rewards</h4>
                <div class="row">
                    <div class="col-md-4">
                        <div class="reward-card-premium reward-1">
                            <div class="reward-icon-box"><i class="fa-solid fa-crown"></i></div>
                            <div><span class="d-block small fw-bold text-muted">1ST PRIZE</span><strong class="text-dark"><%= (h.getRewards()!=null)?h.getRewards().getPrize1():"TBA" %></strong></div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="reward-card-premium reward-2">
                            <div class="reward-icon-box" style="color:#94a3b8;"><i class="fa-solid fa-medal"></i></div>
                            <div><span class="d-block small fw-bold text-muted">2ND PRIZE</span><strong class="text-dark"><%= (h.getRewards()!=null)?h.getRewards().getPrize2():"TBA" %></strong></div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="reward-card-premium reward-3">
                            <div class="reward-icon-box" style="color:#b45309;"><i class="fa-solid fa-award"></i></div>
                            <div><span class="d-block small fw-bold text-muted">3RD PRIZE</span><strong class="text-dark"><%= (h.getRewards()!=null)?h.getRewards().getPrize3():"TBA" %></strong></div>
                        </div>
                    </div>
                </div>
                <p class="mt-3 text-muted small"><%= (h.getRewards()!=null)?h.getRewards().getRewardAndPrizeDesc():"" %></p>
            </div>

            <div class="info-section">
                <div class="row g-4 mb-4">
                    <div class="col-6 col-md-3">
                        <span class="dossier-label">Mode</span>
                        <span class="dossier-value"><%= (h.getDetails()!=null)?h.getDetails().getMode():"Online" %></span>
                    </div>
                    <div class="col-6 col-md-3">
                        <span class="dossier-label">Category</span>
                        <span class="dossier-value"><%= (h.getDetails()!=null)?h.getDetails().getCategory():"General" %></span>
                    </div>
                    <div class="col-6 col-md-3">
                        <span class="dossier-label">Skills</span>
                        <span class="dossier-value"><%= (h.getDetails()!=null)?h.getDetails().getSkills():"All" %></span>
                    </div>
                    <div class="col-6 col-md-3">
                        <span class="dossier-label">Payment</span>
                        <span class="dossier-value"><%= (h.getDetails()!=null)?h.getDetails().getPayment():"Pre-paid" %></span>
                    </div>
                </div>
                <h5 class="fw-bold mb-3">About Program</h5>
                <div class="text-muted" style="line-height: 1.8;"><%= (h.getDetails()!=null)?h.getDetails().getDetail():"" %></div>
                <h5 class="fw-bold mt-4 mb-3">Rules</h5>
                <p class="small text-muted" style="white-space: pre-line;"><%= (h.getDetails()!=null)?h.getDetails().getRules():"" %></p>
            </div>
        </div>

        <div class="col-lg-4">
            <div class="sidebar-widget">
                <%-- Timer --%>
                <% if(!isExpired && deadline != null && !isRegistered) { %>
                <div class="text-center mb-4 pb-3 border-bottom">
                    <small class="text-slate-500 fw-bold text-uppercase">Closing In</small>
                    <div class="d-flex justify-content-center gap-2 mt-2">
                        <div><span class="timer-value" id="days">00</span><br><small>D</small></div>
                        <div class="timer-value">:</div>
                        <div><span class="timer-value" id="hours">00</span><br><small>H</small></div>
                        <div class="timer-value">:</div>
                        <div><span class="timer-value" id="minutes">00</span><br><small>M</small></div>
                        <div class="timer-value">:</div>
                        <div><span class="timer-value" id="seconds">00</span><br><small>S</small></div>
                    </div>
                </div>
                <% } %>

                <% if(activeTeamId == null) { %>
                    <div class="text-center py-4">
                        <% if(isExpired) { %><div class="alert alert-danger fw-bold">Registration Closed</div>
                        <% } else { %><a href="makeTeam?pid=<%=h.getProgramId()%>" class="btn-action">Create Team</a><% } %>
                    </div>
                <% } else { %>
                    <h6 class="fw-bold mb-3">Team Management</h6>
                    <div class="mb-4">
                        <label class="dossier-label">Team Name</label>
                        <div class="input-group">
                            <input type="text" id="tname" class="form-control" value="<%= activeTeamName %>" <%= (isRegistered || !isLeader) ? "readonly" : "" %>>
                            <% if(isLeader && !isRegistered) { %>
                                <button class="btn btn-dark" onclick="updateTeamName('<%=activeTeamId%>', '<%=curProgramId%>')"><i class="fa-solid fa-check"></i></button>
                            <% } %>
                        </div>
                    </div>

                    <div class="roster-list mb-4">
                        <label class="dossier-label">Members (<%=currentTeamSize%>/<%=maxSize%>)</label>
                        <div class="member-pill leader-pill border-primary">
                            <span class="fw-bold text-primary"><i class="fa-solid fa-crown me-2"></i><%= leaderName %></span>
                            <span class="badge bg-primary">Leader</span>
                        </div>
                        <% if(reqReceivers != null) { for(RequestEntity req : reqReceivers) { 
                                if(req.getTeam().getTeamId().equals(activeTeamId) && "accepted".equalsIgnoreCase(req.getStatus())) { %>
                            <div class="member-pill">
                                <span><%= req.getReceiver().getFirstName() %></span>
                                <% if(isLeader && !isRegistered) { %><button class="btn btn-sm text-danger" onclick="removeMember('<%=curProgramId%>', '<%=activeTeamId%>', '<%=req.getReceiver().getUserId()%>')"><i class="fa-solid fa-xmark"></i></button><% } %>
                            </div>
                        <% } } } %>
                    </div>

                    <% if(!isRegistered && isLeader) { %>
                        <div class="border-top pt-3">
                            <% if(currentTeamSize >= minSize) { %>
                                <button class="btn btn-success w-100 py-3 fw-bold mb-3 shadow-sm" onclick="finalRegistration('<%=activeTeamId%>', '<%=curProgramId%>')">SUBMIT TEAM</button>
                            <% } %>
                            <div class="row g-2">
                                <div class="col-6"><button class="btn btn-outline-secondary w-100 btn-sm" onclick="checkAndManualInvite('<%=curProgramId%>', '<%=activeTeamId%>', '<%=currentTeamSize%>', '<%=maxSize%>')">Invite Email</button></div>
                                <div class="col-6"><button class="btn btn-outline-primary w-100 btn-sm" onclick="toggleParticipants()">Find Users</button></div>
                            </div>
                        </div>
                        <div id="participantsBox" class="mt-3 p-3 border rounded-4" style="display:none; max-height:200px; overflow-y:auto;">
                            <% if(participants != null) { for(UserEntity u : participants) {
                               if(u.getUserId() != user.getUserId() && !enrolledUserIds.contains(u.getUserId())) { %>
                                <div class="d-flex justify-content-between align-items-center mb-2 pb-2 border-bottom">
                                    <span class="small fw-bold"><%=u.getFirstName()%></span>
                                    <button class="btn btn-sm btn-primary py-0 px-2" onclick="inviteMember('<%=u.getUserId()%>', '<%=user.getUserId()%>', '<%=curProgramId%>', '<%=activeTeamId%>', '<%=currentTeamSize%>', '<%=maxSize%>')">Invite</button>
                                </div>
                            <% } } } %>
                        </div>
                    <% } %>
                <% } %>
            </div>
        </div>
    </div>
</div>

<script>
<% if(!isExpired && deadline != null && !isRegistered) { %>
(function() {
    const dDate = new Date('<%= deadline %>').getTime();
    setInterval(function() {
        const now = new Date().getTime(); const dist = dDate - now;
        if (dist < 0) return;
        document.getElementById("days").innerHTML = Math.floor(dist / (1000*60*60*24)).toString().padStart(2, '0');
        document.getElementById("hours").innerHTML = Math.floor((dist % (1000*60*60*24)) / (1000*60*60)).toString().padStart(2, '0');
        document.getElementById("minutes").innerHTML = Math.floor((dist % (1000*60*60)) / (1000*60)).toString().padStart(2, '0');
        document.getElementById("seconds").innerHTML = Math.floor((dist % (1000*60)) / 1000).toString().padStart(2, '0');
    }, 1000);
})();
<% } %>

function toggleParticipants() { const box = document.getElementById("participantsBox"); box.style.display = (box.style.display === "none") ? "block" : "none"; }
function updateTeamName(tid, pid) { window.location.href = "updateTeamName?teamId=" + tid + "&tName=" + encodeURIComponent(document.getElementById("tname").value) + "#team-section"; }
function finalRegistration(tid, pid) { if(confirm("Submit team?")) window.location.href="registerTeam?teamId="+tid+"&pid="+pid; }
function inviteMember(id, sid, pid, tid, curr, max) { if(parseInt(curr) >= parseInt(max)) return alert("Full!"); window.location.href="sendMakeTeamRequest?senderId="+sid+"&receiverId="+id+"&pid="+pid+"&teamId="+tid; }
function removeMember(pid, tid, uid) { if(confirm("Remove member?")) window.location.href="removeTeamMember?pid="+pid+"&teamId="+tid+"&userId="+uid; }
function checkAndManualInvite(pid, tid, curr, max) { window.location.href="addMemManuallyForm?pid="+pid+"&teamId="+tid; }
</script>
</body>
</html>