<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Join SkillAcademy | Signup</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Outfit:wght@600;700;800&display=swap" rel="stylesheet">

    <style>
        :root {
            --navy-deep: #0f172a;       
            --bg-slate: #f1f5f9;        
            --primary-blue: #2563eb;    
            --text-dark: #0f172a;
            --text-muted: #64748b;
            --border-subtle: #e2e8f0;
        }

        body {
            background-color: var(--bg-slate);
            background-image: radial-gradient(at 100% 0%, rgba(37, 99, 235, 0.05) 0px, transparent 50%);
            font-family: 'Inter', sans-serif;
            color: var(--text-dark);
            margin: 0; padding: 60px 20px;
        }

        .signup-container {
            max-width: 900px;
            margin: 0 auto;
        }

        .signup-card {
            background: #ffffff;
            border-radius: 35px;
            padding: 50px;
            border: 1px solid var(--border-subtle);
            box-shadow: 0 20px 40px rgba(15, 23, 42, 0.08);
            position: relative;
            overflow: hidden;
        }

        /* Top Accent Line */
        .signup-card::before {
            content: ''; position: absolute; top: 0; left: 0; right: 0;
            height: 6px; background: var(--navy-deep);
        }

        h1 {
            font-family: 'Outfit', sans-serif;
            font-weight: 800; font-size: 2.2rem;
            color: var(--navy-deep); margin-bottom: 30px;
        }

        .section-header {
            font-family: 'Outfit', sans-serif;
            font-size: 0.9rem; font-weight: 700;
            text-transform: uppercase; letter-spacing: 1px;
            color: var(--primary-blue);
            margin: 25px 0 15px;
            display: flex; align-items: center; gap: 10px;
        }

        .section-header::after {
            content: ''; flex-grow: 1; height: 1px; background: var(--border-subtle);
        }

        /* Form Controls */
        .form-label {
            font-size: 0.85rem; font-weight: 600; color: var(--text-dark);
        }

        .form-control {
            border-radius: 12px; border: 1.5px solid var(--border-subtle);
            padding: 10px 15px; font-size: 0.95rem; transition: 0.3s;
            background: #f8fafc;
        }

        .form-control:focus {
            border-color: var(--primary-blue);
            background: #ffffff;
            box-shadow: 0 0 0 4px rgba(37, 99, 235, 0.05);
        }

        /* Choice Groups */
        .choice-wrapper {
            background: #f8fafc;
            border: 1px solid var(--border-subtle);
            border-radius: 16px;
            padding: 20px;
        }

        .btn-check:checked + .btn-outline-navy {
            background-color: var(--navy-deep);
            border-color: var(--navy-deep);
            color: white;
        }

        .btn-outline-navy {
            border: 1.5px solid var(--border-subtle);
            color: var(--text-muted);
            border-radius: 10px;
            font-size: 0.85rem;
            font-weight: 600;
            padding: 8px 16px;
            transition: 0.2s;
            background: white;
        }

        .btn-outline-navy:hover {
            border-color: var(--navy-deep);
            color: var(--navy-deep);
        }

        /* Submit Button */
        .btn-submit {
            background: var(--navy-deep);
            color: white; border: none; border-radius: 14px;
            padding: 15px 30px; font-weight: 700; font-size: 1rem;
            width: 100%; transition: 0.3s; margin-top: 40px;
        }

        .btn-submit:hover {
            background: var(--primary-blue);
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(37, 99, 235, 0.2);
        }

        .footer-text {
            text-align: center; margin-top: 30px;
            font-size: 0.95rem; color: var(--text-muted);
        }

        .footer-text a {
            color: var(--primary-blue); font-weight: 700; text-decoration: none;
        }

        /* Readonly style */
        input[readonly] {
            background: #edf2f7; border-color: #cbd5e1; cursor: not-allowed;
        }
    </style>
</head>
<body>

<jsp:include page="toaster_logic.jsp" />

<%
    String emailParam = request.getParameter("email");
    boolean isEmailInvited = (emailParam != null && !emailParam.trim().isEmpty());
%>

<div class="signup-container">
    <div class="signup-card">
        <h1>Create Your Account</h1>
        <p class="text-muted mb-4">Join SkillAcademy and start your journey with the best innovators.</p>

        <form action="signup" method="post">
            <div class="row g-4">
                
                <div class="col-12">
                    <div class="section-header">Basic Information</div>
                </div>

                <div class="col-12">
                    <label class="form-label">Email Address</label>
                    <input type="email" name="email" class="form-control" 
                           value="<%= isEmailInvited ? emailParam : "" %>"
                           <%= isEmailInvited ? "readonly" : "" %> required />
                    <% if(isEmailInvited) { %>
                        <small class="text-primary fw-bold" style="font-size: 11px;">
                            <i class="fa-solid fa-circle-check me-1"></i> Invitation linked to this email.
                        </small>
                    <% } %>
                </div>

                <div class="col-md-6">
                    <label class="form-label">First Name</label>
                    <input type="text" name="firstName" class="form-control" placeholder="John" required>
                </div>

                <div class="col-md-6">
                    <label class="form-label">Last Name</label>
                    <input type="text" name="lastName" class="form-control" placeholder="Doe" required>
                </div>

                <div class="col-md-6">
                    <label class="form-label">Mobile Number</label>
                    <input type="text" name="mobile" class="form-control" placeholder="9876543210" required>
                </div>

                <div class="col-md-6">
                    <label class="form-label">Password</label>
                    <input type="password" name="password" class="form-control" placeholder="••••••••" required>
                </div>

                <div class="col-12 mt-5">
                    <div class="section-header">Academic Details</div>
                </div>

                <div class="col-12">
                    <label class="form-label">College / University Name</label>
                    <input type="text" name="college" class="form-control" placeholder="Enter institution name" required>
                </div>

                <div class="col-12">
                    <label class="form-label d-block mb-3">User Category</label>
                    <div class="d-flex flex-wrap gap-2">
                        <input type="radio" class="btn-check" name="category" id="cat1" value="school" required>
                        <label class="btn btn-outline-navy" for="cat1">School</label>

                        <input type="radio" class="btn-check" name="category" id="cat2" value="college">
                        <label class="btn btn-outline-navy" for="cat2">College</label>

                        <input type="radio" class="btn-check" name="category" id="cat3" value="fresher">
                        <label class="btn btn-outline-navy" for="cat3">Fresher</label>

                        <input type="radio" class="btn-check" name="category" id="cat4" value="professional">
                        <label class="btn btn-outline-navy" for="cat4">Professional</label>
                    </div>
                </div>

                <div class="col-12 mt-5">
                    <div class="section-header">Domain & Expertise</div>
                </div>

                <div class="col-md-6">
                    <label class="form-label d-block mb-3">Preferred Domain</label>
                    <select class="form-select form-control" name="domain">
                        <option value="engineering">Engineering</option>
                        <option value="management">Management</option>
                        <option value="law">Law</option>
                        <option value="medicine">Medicine</option>
                        <option value="science">Science</option>
                    </select>
                </div>

                <div class="col-12">
                    <label class="form-label d-block mb-3">Technology Stack (Multiple)</label>
                    <div class="choice-wrapper d-flex flex-wrap gap-2">
                        <input type="checkbox" class="btn-check" name="technology" id="tech1" value="Java">
                        <label class="btn btn-outline-navy" for="tech1">Java</label>

                        <input type="checkbox" class="btn-check" name="technology" id="tech2" value="Python">
                        <label class="btn btn-outline-navy" for="tech2">Python</label>

                        <input type="checkbox" class="btn-check" name="technology" id="tech3" value="React">
                        <label class="btn btn-outline-navy" for="tech3">React</label>

                        <input type="checkbox" class="btn-check" name="technology" id="tech4" value="Spring">
                        <label class="btn btn-outline-navy" for="tech4">Spring Boot</label>

                        <input type="checkbox" class="btn-check" name="technology" id="tech5" value="Node">
                        <label class="btn btn-outline-navy" for="tech5">Node.js</label>
                    </div>
                </div>
            </div>

            <button type="submit" class="btn-submit">
                Register Account <i class="fa-solid fa-arrow-right ms-2"></i>
            </button>
        </form>

        <p class="footer-text">
            Already part of the community? <a href="login">Login here</a>
        </p>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>