<%@page import="java.awt.Color"%>
<%@page import="java.util.List"%>
<%@page import="com.entity.UserEntity"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Launch Program | SkillAcademy Admin</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Outfit:wght@600;700;800&display=swap" rel="stylesheet">

    <style>
        :root {
            --navy-deep: #0f172a; --bg-slate: #f1f5f9; --primary-blue: #2563eb;    
            --text-dark: #1e293b; --text-muted: #64748b; --border-subtle: #e2e8f0;
        }
        body { background-color: var(--bg-slate); font-family: 'Inter', sans-serif; color: var(--text-dark); margin: 0; }
        .top-nav { background: #ffffff; border-bottom: 1px solid var(--border-subtle); padding: 0.8rem 2.5rem; position: sticky; top: 0; z-index: 1000; }
        .brand-logo { font-family: 'Outfit', sans-serif; font-weight: 800; font-size: 1.3rem; color: var(--navy-deep); text-decoration: none; display: flex; align-items: center; gap: 10px; }
        .dashboard-container { max-width: 1400px; margin: 0 auto; padding: 40px 25px; }
        .admin-grid { display: grid; grid-template-columns: 280px 1fr; gap: 30px; }
        .action-sidebar { background: var(--navy-deep); border-radius: 28px; padding: 40px 25px; color: white; position: sticky; top: 110px; height: fit-content; }
        .nav-pill-custom { display: flex; align-items: center; gap: 12px; padding: 14px 18px; color: #cbd5e1; text-decoration: none; border-radius: 14px; margin-bottom: 10px; font-weight: 500; }
        .nav-pill-custom.active { background: var(--primary-blue); color: white; }
        .form-card { background: #ffffff; border-radius: 28px; padding: 40px; border: 1px solid var(--border-subtle); box-shadow: 0 4px 20px rgba(0,0,0,0.03); }
        .form-section-title { font-family: 'Outfit', sans-serif; font-weight: 700; font-size: 1.8rem; margin-bottom: 30px; color: var(--navy-deep); display: flex; align-items: center; gap: 12px; }
        .grid-form { display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; }
        .input-group { display: flex; flex-direction: column; margin-bottom: 5px; }
        label { font-size: 0.75rem; font-weight: 700; color: var(--text-dark); margin-bottom: 8px; text-transform: uppercase; letter-spacing: 0.5px; }
        input, select, textarea { background: #f8fafc; border: 1px solid var(--border-subtle); border-radius: 12px; padding: 10px 15px; color: var(--text-dark); font-size: 0.9rem; }
        .full-width { grid-column: span 3; }
        .span-2 { grid-column: span 2; }
        .sub-card { background: #f8fafc; border: 1px solid var(--border-subtle); border-radius: 20px; padding: 25px; grid-column: span 3; margin-top: 10px; }
        .round-card { background: white; border: 1px solid var(--border-subtle); border-radius: 16px; padding: 20px; margin-top: 15px; }
        .btn-publish { grid-column: span 3; background: var(--navy-deep); color: white; padding: 18px; border-radius: 15px; font-weight: 700; border: none; margin-top: 20px; transition: 0.3s; font-size: 1.1rem; cursor: pointer; }
        .btn-publish:hover { background: var(--primary-blue); transform: translateY(-2px); }
        .radio-box { display: flex; gap: 20px; padding: 10px; background: #f8fafc; border-radius: 12px; border: 1px solid var(--border-subtle); }
        .section-divider { grid-column: span 3; padding-bottom: 10px; border-bottom: 2px solid var(--bg-slate); margin: 20px 0 10px 0; font-weight: 800; font-size: 1rem; color: var(--primary-blue); display: flex; align-items: center; gap: 10px; }

        /* Judge UI Styles */
        .judge-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(220px, 1fr)); gap: 15px; margin-top: 10px; }
        .judge-item { background: white; border: 1px solid var(--border-subtle); padding: 12px; border-radius: 12px; display: flex; align-items: center; gap: 12px; cursor: pointer; transition: 0.2s; }
        .judge-item:hover { border-color: var(--primary-blue); background: #eff6ff; }
        .judge-checkbox { width: 18px; height: 18px; cursor: pointer; }
        .judge-meta { display: flex; flex-direction: column; line-height: 1.2; }
        .j-name { font-weight: 600; font-size: 0.85rem; color: var(--navy-deep); }
        .j-email { font-size: 0.7rem; color: var(--text-muted); }
    </style>
</head>

<body>
    <nav class="top-nav">
        <div class="container-fluid d-flex justify-content-between align-items-center">
            <a href="#" class="brand-logo"><i class="fa-solid fa-layer-group text-primary"></i><span>SKILLACADEMY</span></a>
        </div>
    </nav>

    <div class="dashboard-container">
        <div class="admin-grid">
            <aside class="action-sidebar">
                <nav>
                    <a href="#" class="nav-pill-custom active"><i class="fa-solid fa-trophy"></i> Add Hackathon</a>
                    <a href="viewAllHackathon" class="nav-pill-custom"><i class="fa-solid fa-folder-tree"></i> Browse Hackathons</a>
                </nav>
            </aside>

            <main class="form-card">
                <div class="form-section-title"><i class="fa-solid fa-rocket text-primary"></i> Launch New Program</div>

                <form action="addHackathon" method="post" class="grid-form">
                    <input type="hidden" name="userId" value="${sessionScope.user.userId}" />

                    <div class="section-divider"><i class="fa-solid fa-circle-info"></i> Basic Information</div>
                    
                    <div class="input-group span-2">
                        <label>Program Name</label>
                        <input type="text" name="programName" placeholder="e.g. Winter Code Storm 2024" required />
                    </div>
                    <div class="input-group">
                        <label>Organizer Name</label>
                        <input type="text" name="organizerName" placeholder="Organization/Company" />
                    </div>
                    <div class="input-group">
                        <label>City</label>
                        <input type="text" name="city" placeholder="City Name" />
                    </div>
                    <div class="input-group">
                        <label>Location / Venue</label>
                        <input type="text" name="location" placeholder="Specific Venue Address" />
                    </div>
                    <div class="input-group">
                        <label>Status</label>
                        <select name="status">
                            <option value="Upcoming">Upcoming</option>
                            <option value="Live">Live</option>
                            <option value="Recent">Recent</option>
                        </select>
                    </div>

                    <div class="section-divider"><i class="fa-solid fa-calendar-days"></i> Important Dates</div>
                    
                    <div class="input-group">
                        <label>Registration Start Date</label>
                        <input type="datetime-local" name="registrationStartDate" />
                    </div>
                    <div class="input-group">
                        <label>Registration Deadline</label>
                        <input type="datetime-local" name="registrationDeadline" />
                    </div>
                    <div class="input-group">
                        <label>Winner Publish Date</label>
                        <input type="datetime-local" name="winnerPublishDate" />
                    </div>
                    <div class="input-group">
                        <label>Program Start Date</label>
                        <input type="datetime-local" name="startDate" />
                    </div>
                    <div class="input-group">
                        <label>Program Due/End Date</label>
                        <input type="datetime-local" name="dueDate" />
                    </div>

                    <div class="section-divider"><i class="fa-solid fa-file-lines"></i> Specific Details</div>
                    
                    <div class="input-group">
                        <label>Program Type</label>
                        <select name="details.programType">
                            <option value="Hackathon">Hackathon</option>
                            <option value="Internship">Internship</option>
                            <option value="Competition">Competition</option>
                        </select>
                    </div>
                    <div class="input-group">
                        <label>Category</label>
                        <input type="text" name="details.category" placeholder="e.g. Web Dev, AI, Cloud" />
                    </div>
                    <div class="input-group">
                        <label>Target College/Org</label>
                        <input type="text" name="details.college" placeholder="Leave empty for open to all" />
                    </div>
                    <div class="input-group">
                        <label>Mode</label>
                        <div class="radio-box">
                            <label class="small"><input type="radio" name="details.mode" value="Online" checked> Online</label>
                            <label class="small"><input type="radio" name="details.mode" value="Offline"> Offline</label>
                        </div>
                    </div>
                    <div class="input-group">
                        <label>Payment Status</label>
                        <div class="radio-box">
                            <label class="small"><input type="radio" name="details.payment" value="Free" checked> Free</label>
                            <label class="small"><input type="radio" name="details.payment" value="Paid"> Paid</label>
                        </div>
                    </div>
                    <div class="input-group">
                        <label>Fees (₹)</label>
                        <input type="number" name="details.fees" value="0" />
                    </div>
                    <div class="input-group span-2">
                        <label>Required Skills</label>
                        <input type="text" name="details.skills" placeholder="Java, Python, Spring Boot, etc." />
                    </div>
                    <div class="input-group">
                        <label>Eligibility</label>
                        <input type="text" name="details.eligibility" placeholder="e.g. B.Tech Students, Graduates" />
                    </div>

                    <div class="section-divider"><i class="fa-solid fa-user-shield"></i> Assign Program Judges</div>
                    <div class="sub-card">
                        <div class="judge-grid">
                            <% 
                                List<UserEntity> judges = (List<UserEntity>) request.getAttribute("judges");
                                if(judges != null && !judges.isEmpty()) {
                                    for(int i=0; i < judges.size(); i++) {
                                        UserEntity j = judges.get(i);
                            %>
                                <label class="judge-item">
<input type="checkbox" class="judge-checkbox" name="judgeIds" value="<%= j.getUserId() %>">                                    <div class="judge-meta">
                                        <span class="j-name"><%= j.getFirstName() %></span>
                                        <span class="j-email"><%= j.getEmail() %></span>
                                    </div>
                                </label>
                            <% 
                                    }
                                } else {
                            %>
                                <div class="p-3 text-muted small"><i class="fa-solid fa-circle-exclamation"></i> No judges available to assign.</div>
                            <% } %>
                        </div>
                    </div>
                    <div class="section-divider"><i class="fa-solid fa-trophy"></i> Team & Rewards</div>
                    
                    <div class="input-group">
                        <label>Min Team Size</label>
                        <input type="number" name="minTeamSize" value="1" />
                    </div>
                    <div class="input-group">
                        <label>Max Team Size</label>
                        <input type="number" name="maxTeamSize" value="4" />
                    </div>
                    <div class="input-group">
                        <label>Top Rankers Limit</label>
                        <input type="number" name="rewards.topRankerLimit" placeholder="e.g. 10" />
                    </div>
                    
                    <div class="input-group full-width">
                        <label>🥇 1st Prize</label>
                        <input type="text" name="rewards.prize1" placeholder="Cash prize, Gadgets, etc." />
                    </div>
                    <div class="input-group full-width">
                        <label>🥈 2nd Prize</label>
                        <input type="text" name="rewards.prize2" />
                    </div>
                    <div class="input-group full-width">
                        <label>🥉 3rd Prize</label>
                        <input type="text" name="rewards.prize3" />
                    </div>
                    <div class="input-group full-width">
                        <label>Other Rewards Description</label>
                        <textarea name="rewards.rewardAndPrizeDesc" rows="2" placeholder="Mention certificates, goodies, etc."></textarea>
                    </div>

                    <div class="section-divider"><i class="fa-solid fa-pen-nib"></i> Content & Guidelines</div>
                    
                    <div class="input-group full-width">
                        <label>Detailed Program Overview</label>
                        <textarea name="details.detail" rows="4" placeholder="Tell users what this program is about..."></textarea>
                    </div>
                    <div class="input-group full-width">
                        <label>Rules & Guidelines</label>
                        <textarea name="details.rules" rows="4" placeholder="Mention rules, submission criteria, etc."></textarea>
                    </div>
                    <div class="input-group full-width">
                        <label>Banner Image URL</label>
                        <input type="text" name="pic" placeholder="https://image-link.com/banner.jpg" />
                    </div>

                    <div class="section-divider"><i class="fa-solid fa-list-check"></i> Rounds Configuration</div>
                    <div class="sub-card" style="border: 2px dashed var(--border-subtle);">
                        <div class="row align-items-center">
                            <div class="col-md-4"><input type="number" id="numRounds" class="form-control" min="0" max="10" placeholder="Number of Rounds" oninput="generateRounds()" /></div>
                            <div class="col-md-8 text-muted small">Specify stages like Ideation, Coding, Interview, etc.</div>
                        </div>
                        <div id="roundsContainer"></div>
                    </div>

                    <button type="submit" class="btn-publish">🚀 PUBLISH PROGRAM</button>
                </form>
            </main>
        </div>
    </div>

    <script>
    function generateRounds() {
        const container = document.getElementById('roundsContainer');
        const num = document.getElementById('numRounds').value;
        container.innerHTML = ''; 

        for (let i = 0; i < num; i++) {
            const roundDiv = document.createElement('div');
            roundDiv.className = 'round-card shadow-sm';
            roundDiv.innerHTML = `
                <div class="fw-bold mb-3 text-primary">🏆 Round \${i + 1}</div>
                <div class="row g-3">
                    <div class="col-md-4">
                        <label class="small fw-bold">Round Name</label>
                        <input type="text" name="rounds[\${i}].roundName" class="form-control" placeholder="e.g. Preliminary Test" required />
                    </div>
                    <div class="col-md-4">
                        <label class="small fw-bold">Start Date</label>
                        <input type="datetime-local" name="rounds[\${i}].startDate" class="form-control" required />
                    </div>
                    <div class="col-md-4">
                        <label class="small fw-bold">End Date</label>
                        <input type="datetime-local" name="rounds[\${i}].endDate" class="form-control" required />
                    </div>
                    <div class="col-12">
                        <label class="small fw-bold">Round Description / Task</label>
                        <textarea name="rounds[\${i}].roundDesc" class="form-control" rows="2"></textarea>
                    </div>
                    <input type="hidden" name="rounds[\${i}].roundNo" value="\${i + 1}" />
                </div>
            `;
            container.appendChild(roundDiv);
        }
    }
    </script>
</body>
</html>