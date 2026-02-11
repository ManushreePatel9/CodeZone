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
    .sidebar-widget { background: white; border: 1px solid var(--slate-200); border-radius: 24px; padding: 25px; position: sticky; top: 30px; box-shadow: 0 10px 15px -3px rgba(0,0,0,0.05); }
    
    .reward-card-mini { background: #fff; border: 1px solid var(--slate-200); border-radius: 16px; padding: 20px; text-align: center; transition: 0.3s; height: 100%; }
    .reward-card-mini:hover { transform: translateY(-5px); border-color: var(--amber); }
    .rank-icon { font-size: 2rem; margin-bottom: 10px; }
    .rank-1 { color: #ffd700; } .rank-2 { color: #c0c0c0; } .rank-3 { color: #cd7f32; }

    .timer-value { font-family: 'JetBrains Mono', monospace; font-size: 1.5rem; font-weight: 700; color: var(--rose); }
    .member-pill { display: flex; align-items: center; justify-content: space-between; padding: 12px 16px; background: var(--slate-50); border: 1px solid var(--slate-100); border-radius: 12px; margin-bottom: 10px; }
    .member-pill.pending { border: 2px dashed var(--rose); background: rgba(244, 63, 94, 0.05); }
    
    .btn-action { background: var(--primary); color: white; border: none; padding: 14px 24px; border-radius: 12px; font-weight: 700; width: 100%; transition: 0.3s; display: flex; align-items: center; justify-content: center; gap: 10px; text-decoration: none; }
    .btn-action:hover { background: var(--dark); color: white; transform: translateY(-2px); }
    .btn-outline-custom { border: 1px solid var(--slate-200); background: white; color: var(--slate-900); padding: 10px; border-radius: 10px; font-size: 0.85rem; font-weight: 600; transition: 0.2s; }
    
    .timeline-container { position: relative; padding-left: 40px; }
    .timeline-container::before { content: ''; position: absolute; left: 15px; top: 0; width: 2px; height: 100%; background: var(--slate-200); }
    .round-item { position: relative; margin-bottom: 30px; }
    .round-dot { position: absolute; left: -33px; top: 5px; width: 18px; height: 18px; border-radius: 50%; background: white; border: 3px solid var(--slate-200); z-index: 2; }
    .round-card { background: white; border: 2px solid var(--slate-200); border-radius: 16px; padding: 20px; transition: 0.3s; }
    
    /* State Specific Styles */
    .round-item.completed .round-card { border-color: var(--emerald); background: #f0fdf4; }
    .round-item.active .round-card { border-color: var(--primary); box-shadow: 0 10px 15px -3px rgba(79, 70, 229, 0.1); }
    .round-item.active .round-dot { background: var(--primary); border-color: var(--primary); animation: pulse 2s infinite; }
    
    /* Locked Round Logic */
    .round-item.locked { cursor: not-allowed; opacity: 0.7; }
    .round-item.locked .round-card { background: var(--slate-50); border-style: dashed; }

    .info-tag { background: var(--slate-100); color: var(--slate-900); padding: 6px 14px; border-radius: 8px; font-size: 0.85rem; font-weight: 600; display: inline-block; margin-right: 8px; margin-bottom: 8px; }
    @keyframes pulse { 0% { box-shadow: 0 0 0 0 rgba(79, 70, 229, 0.4); } 70% { box-shadow: 0 0 0 10px rgba(79, 70, 229, 0); } 100% { box-shadow: 0 0 0 0 rgba(79, 70, 229, 0); } }
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

ProgramDetailsEntity details = h.getDetails();
ProgramRewardsEntity rewards = h.getRewards();
SimpleDateFormat fullDateFormat = new SimpleDateFormat("dd MMM, yyyy | hh:mm a");

Integer curProgramId = h.getProgramId();
Integer activeTeamId = null;
String activeTeamName = "";
String leaderName = "";
boolean isLeader = false;
boolean isRegistered = false;

Set<Integer> enrolledUserIds = new HashSet<>();
if(teams != null) {
    for(TeamEntity t : teams) {
        if(t.getProgramId().equals(curProgramId)) {
            enrolledUserIds.add(t.getMem1());
            if(user != null && t.getMem1().equals(user.getUserId())) {
                activeTeamId = t.getTeamId(); activeTeamName = t.getTeamName(); isRegistered = t.isRegistered(); isLeader = true;
            }
        }
    }
}
if(reqReceivers != null) {
    for(RequestEntity req : reqReceivers) {
        if(req.getTeam().getProgramId().equals(curProgramId) && "accepted".equalsIgnoreCase(req.getStatus())) {
            enrolledUserIds.add(req.getReceiver().getUserId());
            if(user != null && req.getReceiver().getUserId().equals(user.getUserId())) {
                activeTeamId = req.getTeam().getTeamId(); activeTeamName = req.getTeam().getTeamName(); isRegistered = req.getTeam().isRegistered();
            }
        }
    }
}

if(activeTeamId != null && participants != null) {
    for(TeamEntity t : teams) {
        if(t.getTeamId().equals(activeTeamId)) {
            for(UserEntity u : participants) {
                if(u.getUserId().equals(t.getMem1())) { leaderName = u.getFirstName() + " " + u.getLastName(); break; }
            }
        }
    }
}

Date today = new Date();
Date deadline = h.getRegistrationDeadline();
boolean isExpired = (deadline != null) && today.after(deadline);

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
                <div class="mt-3">
                    <span class="info-tag bg-primary text-white"><i class="fa-solid fa-building me-1"></i> <%= h.getOrganizerName() %></span>
                    <% if(details != null) { %>
                        <span class="info-tag bg-info text-white"><i class="fa-solid fa-laptop me-1"></i> <%= details.getMode() %></span>
                        <span class="info-tag bg-warning text-dark"><i class="fa-solid fa-ticket me-1"></i> <%= details.getFees() == 0 ? "Free" : "₹" + details.getFees() %></span>
                        <span class="info-tag bg-secondary text-white"><i class="fa-solid fa-layer-group me-1"></i> <%= details.getCategory() %></span>
                        <% if(h.getCity() != null) { %><span class="info-tag bg-dark text-white"><i class="fa-solid fa-location-dot me-1"></i> <%= h.getCity() %></span><% } %>
                    <% } %>
                </div>
            </div>
            <div class="col-lg-5">
                <% if(h.getPic() != null) { %> <div class="img-frame"><img src="<%= h.getPic() %>"></div> <% } %>
            </div>
        </div>
    </div>
</div>

<div class="container mt-5 pb-5">
    <div class="row g-4">
        <div class="col-lg-8">
            
            <%-- REWARDS SECTION --%>
            <% if(rewards != null) { %>
            <div class="info-section">
                <h4 class="fw-bold mb-4 text-dark"><i class="fa-solid fa-trophy text-amber me-2"></i>Prizes & Rewards</h4>
                <div class="row g-3 mb-4">
                    <div class="col-md-4"><div class="reward-card-mini"><div class="rank-icon rank-1"><i class="fa-solid fa-crown"></i></div><h6 class="fw-bold">1st Prize</h6><p class="small text-muted mb-0"><%= rewards.getPrize1() %></p></div></div>
                    <div class="col-md-4"><div class="reward-card-mini"><div class="rank-icon rank-2"><i class="fa-solid fa-medal"></i></div><h6 class="fw-bold">2nd Prize</h6><p class="small text-muted mb-0"><%= rewards.getPrize2() %></p></div></div>
                    <div class="col-md-4"><div class="reward-card-mini"><div class="rank-icon rank-3"><i class="fa-solid fa-award"></i></div><h6 class="fw-bold">3rd Prize</h6><p class="small text-muted mb-0"><%= rewards.getPrize3() %></p></div></div>
                </div>
            </div>
            <% } %>

            <%-- ROADMAP & SUBMISSION --%>
            <% if(isRegistered) { %>
            <div class="info-section">
                <h4 class="fw-bold mb-4 text-dark"><i class="fa-solid fa-route text-primary me-2"></i>Program Roadmap</h4>
                <div class="timeline-container">
                    <% if(h.getRounds() != null) { for(ProgramRoundsEntity round : h.getRounds()) { 
                        Date rStart = round.getStartDate(); Date rEnd = round.getEndDate();
                        boolean isActive = (today.after(rStart) || today.equals(rStart)) && !today.after(rEnd);
                        boolean isFinished = today.after(rEnd);
                        boolean isLocked = today.before(rStart);
                        
                        SubmissionEntity existingSub = null;
                        if(submissions != null) {
                            for(SubmissionEntity sub : submissions) {
                                if(sub.getRound().getRoundId().equals(round.getRoundId()) && sub.getTeam().getTeamId().equals(activeTeamId)) { existingSub = sub; break; }
                            }
                        }
                    %>
                    <div class="round-item <%= isFinished ? "completed" : (isActive ? "active" : "locked") %>">
                        <div class="round-dot"></div>
                        <div class="round-card shadow-sm">
                            <div class="d-flex justify-content-between align-items-start mb-2">
                                <div>
                                    <h5 class="fw-bold mb-1"><%= round.getRoundName() %></h5>
                                    <% if(isFinished) { %>
                                        <span class="badge bg-emerald text-white"><i class="fa-solid fa-check-double me-1"></i> Completed</span>
                                    <% } else if(isActive) { %>
                                        <span class="badge bg-primary"><i class="fa-solid fa-bolt-lightning me-1"></i> Active Now</span>
                                    <% } else { %>
                                        <span class="badge bg-secondary"><i class="fa-solid fa-lock me-1"></i> Locked</span>
                                    <% } %>
                                </div>
                                <div class="text-end">
                                    <small class="d-block fw-bold text-slate-500" style="font-size: 0.7rem;"><i class="fa-solid fa-flag-checkered me-1"></i>START: <%= fullDateFormat.format(rStart) %></small>
                                    <small class="d-block fw-bold text-rose" style="font-size: 0.7rem;"><i class="fa-solid fa-hourglass-end me-1"></i>END: <%= fullDateFormat.format(rEnd) %></small>
                                </div>
                            </div>
                            <p class="small text-muted mb-3"><%= round.getRoundDesc() %></p>
                            
                            <% if(isActive) { %>
                                <div class="bg-light p-3 rounded-3 border">
                                    <% if(existingSub == null) { 
                                        if(isLeader) { %>
                                        <form method="post" action="saveLink">
                                            <input type="text" name="submissionLink" class="form-control mb-2" placeholder="Project URL (GitHub/Drive)" required>
                                            <input type="text" name="submissionDesc" class="form-control mb-2" placeholder="Submission Notes" required>
                                            <input type="hidden" name="roundNo" value="<%= round.getRoundNo() %>">
                                            <input type="hidden" name="programId" value="<%= h.getProgramId() %>">
                                            <input type="hidden" name="teamId" value="<%= activeTeamId %>">
                                            <button type="submit" class="btn btn-primary btn-sm w-100">Submit Work</button>
                                        </form>
                                        <% } else { %>
                                            <p class="small text-muted mb-0 text-center"><i class="fa-solid fa-user-tie me-2"></i>Waiting for Team Leader to submit.</p>
                                        <% } 
                                    } else { %>
                                        <div class="alert alert-success py-2 mb-0 small text-center border-0">
                                            <i class="fa-solid fa-circle-check me-2"></i><b>Successfully Submitted</b><br>
                                            <a href="<%= existingSub.getSubmissionLink() %>" target="_blank" class="btn btn-sm btn-outline-success mt-2">View My Submission</a>
                                        </div>
                                    <% } %>
                                </div>
                            <% } else if(isFinished && existingSub != null) { %>
                                <div class="mt-2 border-top pt-2">
                                    <small class="text-muted"><i class="fa-solid fa-link me-1"></i> Submission: <a href="<%= existingSub.getSubmissionLink() %>" target="_blank" class="text-primary fw-bold">Link</a></small>
                                </div>
                            <% } %>
                        </div>
                    </div>
                    <% } } %>
                </div>
            </div>
            <% } %>

            <div class="info-section">
                <div class="row">
                    <div class="col-md-12 mb-4">
                        <h4 class="fw-bold mb-3">About Program</h4>
                        <p class="text-muted"><%= (details != null && details.getDetail() != null) ? details.getDetail() : "No details provided." %></p>
                    </div>
                    <% if(details != null) { %>
                    <div class="col-md-6 mb-4">
                        <h6 class="fw-bold text-primary text-uppercase"><i class="fa-solid fa-user-check me-2"></i>Eligibility</h6>
                        <p class="text-muted small"><%= details.getEligibility() %></p>
                    </div>
                    <div class="col-md-6 mb-4">
                        <h6 class="fw-bold text-primary text-uppercase"><i class="fa-solid fa-gavel me-2"></i>Rules</h6>
                        <p class="text-muted small"><%= details.getRules() %></p>
                    </div>
                    <div class="col-md-12">
                        <h6 class="fw-bold text-primary text-uppercase mb-2"><i class="fa-solid fa-code me-2"></i>Skills Required</h6>
                        <div>
                            <% if(details.getSkills() != null) { 
                                String[] skillsArr = details.getSkills().split(",");
                                for(String skill : skillsArr) { %> <span class="badge bg-primary-soft text-primary me-2 p-2 px-3"><%= skill.trim() %></span> <% } 
                            } %>
                        </div>
                    </div>
                    <% } %>
                </div>
            </div>
        </div>

        <div class="col-lg-4" id="team-section">
            <div class="sidebar-widget">
                <% if(!isExpired && !isRegistered) { %>
                <div class="text-center mb-4 pb-3 border-bottom">
                    <small class="text-slate-500 fw-bold">REGISTRATION ENDS IN</small>
                    <div class="d-flex justify-content-center gap-2 mt-1">
                        <div><span class="timer-value" id="days">00</span><br><small>D</small></div>
                        <div class="timer-value">:</div>
                        <div><span class="timer-value" id="hours">00</span><br><small>H</small></div>
                        <div class="timer-value">:</div>
                        <div><span class="timer-value" id="minutes">00</span><br><small>M</small></div>
                    </div>
                </div>
                <% } %>

                <% if(activeTeamId == null) { %>
                    <a href="makeTeam?pid=<%=h.getProgramId()%>" class="btn-action">Create My Team</a>
                <% } else { %>
                    <div class="mb-4">
                        <label class="small fw-bold text-slate-500 mb-2">Team Name</label>
                        <div class="input-group">
                            <input type="text" id="tname" class="form-control" value="<%= activeTeamName %>" <%= (isRegistered || !isLeader) ? "readonly" : "" %>>
                            <% if(isLeader && !isRegistered) { %>
                                <button class="btn btn-dark btn-sm" onclick="updateTeamName('<%=activeTeamId%>')"><i class="fa-solid fa-save"></i></button>
                            <% } %>
                        </div>
                    </div>

                    <div class="roster">
                        <label class="small fw-bold text-slate-500 mb-2">Members (<%=currentTeamSize%>/<%=maxSize%>)</label>
                        <div class="member-pill">
                            <span class="small fw-bold"><i class="fa-solid fa-crown text-amber me-2"></i><%= leaderName %></span>
                            <span class="badge bg-primary-soft text-primary">Leader</span>
                        </div>
                        <% if(reqReceivers != null) { for(RequestEntity req : reqReceivers) { 
                            if(req.getTeam().getTeamId().equals(activeTeamId) && "accepted".equalsIgnoreCase(req.getStatus())) { %>
                            <div class="member-pill">
                                <span class="small fw-medium"><%= req.getReceiver().getFirstName() %> <%= req.getReceiver().getLastName() %></span>
                                <% if(isLeader && !isRegistered) { %>
                                    <button class="btn btn-sm text-rose p-0" onclick="removeMember('<%=curProgramId%>', '<%=activeTeamId%>', '<%=req.getReceiver().getUserId()%>')"><i class="fa-solid fa-trash-can"></i></button>
                                <% } %>
                            </div>
                        <% } else if(req.getTeam().getTeamId().equals(activeTeamId) && "pending".equalsIgnoreCase(req.getStatus())) { %>
                            <div class="member-pill pending">
                                <span class="small text-muted"><%= req.getReceiver() != null ? req.getReceiver().getFirstName() : req.getReceiverEmail() %></span>
                                <button class="btn btn-sm text-rose p-0" onclick="withdrawRequest('<%=curProgramId%>', '<%=activeTeamId%>', '<%=req.getReceiver() != null ? req.getReceiver().getUserId() : 0%>', '<%=req.getReceiverEmail()%>')"><i class="fa-solid fa-circle-xmark"></i></button>
                            </div>
                        <% } } } %>
                    </div>

                    <% if(!isRegistered && isLeader) { %>
                        <div class="mt-4 pt-3 border-top">
                            <% if(currentTeamSize >= minSize) { %>
                                <button class="btn btn-success w-100 py-3 fw-bold mb-3 shadow" onclick="finalRegistration('<%=activeTeamId%>', '<%=curProgramId%>')">SUBMIT REGISTRATION</button>
                            <% } else { %>
                                <div class="alert alert-warning py-2 small mb-3">Add at least <%= minSize - currentTeamSize %> more member(s) to register.</div>
                            <% } %>
                            <div class="row g-2">
                                <div class="col-6"><button class="btn-outline-custom w-100" onclick="window.location.href='addMemManuallyForm?pid=<%=curProgramId%>&teamId=<%=activeTeamId%>'">Invite Email</button></div>
                                <div class="col-6"><button class="btn-outline-custom w-100" onclick="toggleParticipants()">Find Users</button></div>
                            </div>
                        </div>
                        
                        <div id="participantsBox" class="mt-3" style="display:none; max-height:250px; overflow-y:auto; border:1px solid #eee; border-radius:12px; padding:10px; background: #fff;">
                            <% if(participants != null) { for(UserEntity u : participants) {
                               if(u.getUserId() != user.getUserId() && !enrolledUserIds.contains(u.getUserId())) { %>
                                <div class="d-flex justify-content-between align-items-center mb-2 pb-2 border-bottom">
                                    <span class="small fw-semibold"><%=u.getFirstName()%></span>
                                    <div class="d-flex gap-1">
                                        <button class="btn btn-sm btn-light border p-1" onclick="window.location.href='viewMyProfile?userId=<%=u.getUserId()%>'"><i class="fa-solid fa-eye" style="font-size: 10px;"></i></button>
                                        <button class="btn btn-sm btn-primary py-0 px-2" style="font-size: 10px;" onclick="inviteMember('<%=u.getUserId()%>', '<%=user.getUserId()%>', '<%=curProgramId%>', '<%=activeTeamId%>')">Invite</button>
                                    </div>
                                </div>
                            <% } } } %>
                        </div>
                    <% } else if(isRegistered) { %>
                        <div class="alert alert-success text-center mt-3 py-2"><i class="fa-solid fa-check-circle me-1"></i> Successfully Registered</div>
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
        const now = new Date().getTime();
        const dist = dDate - now;
        if (dist < 0) return;
        document.getElementById("days").innerHTML = Math.floor(dist / (1000*60*60*24)).toString().padStart(2, '0');
        document.getElementById("hours").innerHTML = Math.floor((dist % (1000*60*60*24)) / (1000*60*60)).toString().padStart(2, '0');
        document.getElementById("minutes").innerHTML = Math.floor((dist % (1000*60*60)) / (1000*60)).toString().padStart(2, '0');
    }, 1000);
})();
<% } %>

function toggleParticipants() {
    const box = document.getElementById("participantsBox");
    box.style.display = box.style.display === "none" ? "block" : "none";
}

function updateTeamName(tid) {
    const tName = document.getElementById("tname").value.trim();
    if(tName) window.location.href = "updateTeamName?teamId=" + tid + "&tName=" + encodeURIComponent(tName) + "#team-section";
}

function finalRegistration(tid, pid) {
    if(confirm("Confirm final registration? After this, you cannot change your team.")) window.location.href="registerTeam?teamId="+tid+"&pid="+pid;
}

function inviteMember(id, sid, pid, tid) {
    window.location.href="sendMakeTeamRequest?senderId="+sid+"&receiverId="+id+"&pid="+pid+"&teamId="+tid + "#team-section";
}
function removeMember(pid, tid, uid) { if(confirm("Remove this member?")) window.location.href="removeTeamMember?pid="+pid+"&teamId="+tid+"&userId="+uid + "#team-section"; }
function withdrawRequest(pid, tid, uid, email) { if(confirm("Cancel invitation?")) window.location.href="cancelRequest?pid="+pid+"&teamId="+tid+"&userId="+uid+"&email="+encodeURIComponent(email) + "#team-section"; }
</script>
</body>
</html>