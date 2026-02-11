<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Judge | SkillAcademy Admin</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Outfit:wght@600;700;800&display=swap" rel="stylesheet">

    <style>
        :root {
            --navy-deep: #0f172a;       
            --bg-slate: #f1f5f9;        
            --primary-blue: #2563eb;    
            --text-dark: #1e293b;
            --text-muted: #64748b;
            --border-subtle: #e2e8f0;
        }

        body {
            background-color: var(--bg-slate);
            font-family: 'Inter', sans-serif;
            color: var(--text-dark);
            margin: 0;
            min-height: 100vh;
        }

        /* --- DASHBOARD STRUCTURE --- */
        .top-nav {
            background: #ffffff;
            border-bottom: 1px solid var(--border-subtle);
            padding: 0.8rem 2.5rem;
            position: sticky;
            top: 0;
            z-index: 1000;
        }

        .brand-logo {
            font-family: 'Outfit', sans-serif;
            font-weight: 800;
            font-size: 1.3rem;
            color: var(--navy-deep);
            text-decoration: none;
            display: flex;
            align-items: center; gap: 10px;
        }

        .dashboard-container {
            max-width: 1250px;
            margin: 0 auto;
            padding: 60px 25px;
        }

        .admin-grid {
            display: grid;
            grid-template-columns: 280px 1fr;
            gap: 30px;
            align-items: stretch;
        }

        /* --- SIDEBAR --- */
        .action-sidebar {
            background: var(--navy-deep);
            border-radius: 28px;
            padding: 40px 25px;
            color: white;
            box-shadow: 0 15px 35px rgba(15, 23, 42, 0.2);
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        .nav-pill-custom {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 14px 18px;
            color: #cbd5e1;
            text-decoration: none;
            border-radius: 14px;
            margin-bottom: 10px;
            font-weight: 500;
            transition: 0.2s;
        }

        .nav-pill-custom:hover {
            background: rgba(255, 255, 255, 0.1);
            color: white;
        }

        .nav-pill-custom.active {
            background: var(--primary-blue);
            color: white;
        }

        /* --- FORM CARD --- */
        .form-card {
            background: #ffffff;
            border-radius: 28px;
            padding: 50px;
            border: 1px solid var(--border-subtle);
            box-shadow: 0 4px 20px rgba(0,0,0,0.03);
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        .section-header {
            margin-bottom: 35px;
        }

        .section-header h2 {
            font-family: 'Outfit', sans-serif;
            font-weight: 700;
            color: var(--navy-deep);
            font-size: 1.8rem;
            margin-bottom: 8px;
        }

        .section-header p {
            color: var(--text-muted);
            font-size: 0.95rem;
        }

        .input-group-custom {
            margin-bottom: 20px;
        }

        .input-group-custom label {
            display: block;
            font-size: 0.75rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: var(--text-dark);
            margin-bottom: 8px;
            padding-left: 5px;
        }

        .input-group-custom input {
            width: 100%;
            background: #f8fafc;
            border: 1px solid var(--border-subtle);
            border-radius: 12px;
            padding: 14px 18px;
            color: var(--text-dark);
            font-size: 1rem;
            transition: 0.2s;
        }

        .input-group-custom input:focus {
            outline: none;
            border-color: var(--primary-blue);
            background: #ffffff;
            box-shadow: 0 0 0 4px rgba(37, 99, 235, 0.1);
        }

        .btn-submit {
            background: var(--navy-deep);
            color: white;
            border: none;
            padding: 16px;
            border-radius: 12px;
            font-weight: 700;
            font-size: 1rem;
            width: 100%;
            margin-top: 15px;
            transition: 0.3s;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }

        .btn-submit:hover {
            background: var(--primary-blue);
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(37, 99, 235, 0.2);
        }

        /* Profile & Avatar */
        .profile-chip {
            background: #fff;
            padding: 6px 16px;
            border-radius: 50px;
            display: flex;
            align-items: center; gap: 10px;
            border: 1px solid var(--border-subtle);
        }

        .avatar {
            width: 32px; height: 32px;
            background: var(--navy-deep);
            color: white;
            border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            font-size: 0.8rem; font-weight: bold;
        }
    </style>
</head>

<body>

    <nav class="top-nav">
        <div class="container-fluid d-flex justify-content-between align-items-center">
            <a href="#" class="brand-logo">
                <i class="fa-solid fa-layer-group text-primary"></i>
                <span>SKILLACADEMY</span>
            </a>
            <div class="profile-chip">
                <span class="small fw-bold">${sessionScope.user.firstName} (${user.role})</span>
                <div class="avatar">${sessionScope.user.firstName.substring(0,1).toUpperCase()}</div>
            </div>
        </div>
    </nav>

    <div class="dashboard-container">
        <div class="admin-grid">
            
            <aside class="action-sidebar">
                <nav>
                    <a href="addHackathon" class="nav-pill-custom">
                        <i class="fa-solid fa-trophy"></i> Add Hackathon
                    </a>
                    <a href="viewAllHackathon" class="nav-pill-custom">
                        <i class="fa-solid fa-folder-tree"></i> Browse Hackathons
                    </a>
                    <a href="addJudgeForm" class="nav-pill-custom active">
                        <i class="fa-solid fa-user-check"></i> Assign Judges
                    </a>
                </nav>
                <hr class="my-5" style="border-color: rgba(255,255,255,0.1);">
                <a href="logout" class="nav-pill-custom text-danger m-0">
                    <i class="fa-solid fa-power-off"></i> Logout
                </a>
            </aside>

            <main class="form-card">
                <div class="section-header">
                    <h2><i class="fa-solid fa-user-plus text-primary me-2"></i> Register New Judge</h2>
                    <p>Enter the professional details to add a new judge to the academy panel.</p>
                </div>

                <form action="addJudge" method="post">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="input-group-custom">
                                <label>First Name</label>
                                <input type="text" name="firstName" placeholder="e.g. Rahul" required>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="input-group-custom">
                                <label>Last Name</label>
                                <input type="text" name="lastName" placeholder="e.g. Sharma" required>
                            </div>
                        </div>
                        <div class="col-12">
                            <div class="input-group-custom">
                                <label>Email Address</label>
                                <input type="email" name="email" placeholder="judge.name@skillacademy.com" required>
                            </div>
                        </div>
                    </div>

                    <button type="submit" class="btn-submit">
                        <i class="fa-solid fa-shield-check"></i> Complete Registration
                    </button>
                </form>
            </main>

        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>