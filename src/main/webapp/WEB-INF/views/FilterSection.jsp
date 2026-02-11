<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&family=Outfit:wght@600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<style>
    :root {
        --navy-deep: #0f172a;       
        --primary-blue: #2563eb;    
        --text-dark: #1e293b;
        --text-muted: #64748b;
        --border-subtle: #e2e8f0;
    }

    /* Clean Filter Container */
    .filter-wrapper {
        background: #ffffff;
        border: 1px solid var(--border-subtle);
        border-radius: 24px;
        padding: 25px 30px;
        box-shadow: 0 4px 20px rgba(0,0,0,0.03);
        margin-bottom: 30px;
    }

    .filter-grid {
        display: flex;
        flex-wrap: wrap;
        gap: 40px;
        align-items: flex-start;
    }

    .filter-group-header {
        font-family: 'Outfit', sans-serif;
        font-size: 0.85rem;
        font-weight: 700;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        color: var(--navy-deep);
        margin-bottom: 15px;
        display: flex;
        align-items: center;
        gap: 8px;
    }

    /* Modern Radio Chip Style */
    .radio-container {
        display: flex;
        gap: 10px;
    }

    .custom-radio {
        cursor: pointer;
        position: relative;
    }

    .custom-radio input {
        display: none; /* Hide default radio */
    }

    .radio-tile {
        display: flex;
        align-items: center;
        justify-content: center;
        padding: 8px 20px;
        border: 1.5px solid var(--border-subtle);
        border-radius: 12px;
        font-size: 0.9rem;
        font-weight: 600;
        color: var(--text-muted);
        transition: 0.2s all ease;
        background: #f8fafc;
    }

    .custom-radio:hover .radio-tile {
        border-color: var(--primary-blue);
        color: var(--primary-blue);
    }

    /* Checked State */
    .custom-radio input:checked + .radio-tile {
        background-color: var(--navy-deep);
        border-color: var(--navy-deep);
        color: white;
        box-shadow: 0 4px 10px rgba(15, 23, 42, 0.15);
    }

    /* Actions Styling */
    .filter-actions {
        display: flex;
        align-items: center;
        gap: 15px;
        margin-top: 25px;
        padding-top: 20px;
        border-top: 1px solid var(--border-subtle);
    }

    .btn-apply {
        background: var(--primary-blue);
        color: white;
        border: none;
        padding: 10px 25px;
        border-radius: 12px;
        font-weight: 700;
        font-size: 0.9rem;
        cursor: pointer;
        transition: 0.3s;
        display: flex;
        align-items: center;
        gap: 8px;
    }

    .btn-apply:hover {
        background: var(--navy-deep);
        transform: translateY(-1px);
    }

    .btn-reset {
        color: var(--text-muted);
        text-decoration: none;
        font-size: 0.9rem;
        font-weight: 600;
        padding: 10px 15px;
        transition: 0.2s;
    }

    .btn-reset:hover {
        color: #ef4444;
    }

    @media (max-width: 600px) {
        .filter-grid { flex-direction: column; gap: 20px; }
        .radio-container { width: 100%; }
    }
</style>
</head>

<body>

<div class="filter-wrapper">
    <form action="viewAllHackathon" method="get">
        
        <div class="filter-grid">
            <div class="filter-group">
                <div class="filter-group-header">
                    <i class="fa-solid fa-laptop-code text-primary"></i> Event Mode
                </div>
                <div class="radio-container">
                    <label class="custom-radio">
                        <input type="radio" name="mode" value="online" 
                        <%= "online".equals(request.getParameter("mode")) ? "checked" : "" %>>
                        <span class="radio-tile">Online</span>
                    </label>

                    <label class="custom-radio">
                        <input type="radio" name="mode" value="offline"
                        <%= "offline".equals(request.getParameter("mode")) ? "checked" : "" %>>
                        <span class="radio-tile">Offline</span>
                    </label>
                </div>
            </div>

            <div class="filter-group">
                <div class="filter-group-header">
                    <i class="fa-solid fa-ticket text-primary"></i> Participation
                </div>
                <div class="radio-container">
                    <label class="custom-radio">
                        <input type="radio" name="payment" value="free"
                        <%= "free".equals(request.getParameter("payment")) ? "checked" : "" %>>
                        <span class="radio-tile">Free</span>
                    </label>

                    <label class="custom-radio">
                        <input type="radio" name="payment" value="paid"
                        <%= "paid".equals(request.getParameter("payment")) ? "checked" : "" %>>
                        <span class="radio-tile">Paid</span>
                    </label>
                </div>
            </div>
        </div>

        <div class="filter-actions">
            <button type="submit" class="btn-apply">
                <i class="fa-solid fa-filter"></i> Apply Filters
            </button>
            <a href="viewAllHackathon" class="btn-reset">
                <i class="fa-solid fa-rotate-left"></i> Reset
            </a>
        </div>

    </form>
</div>

</body>
</html>