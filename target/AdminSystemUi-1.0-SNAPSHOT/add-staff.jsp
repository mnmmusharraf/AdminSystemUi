<%
    String adminUser = (String) session.getAttribute("adminUser");
    if (adminUser == null) {
        response.sendRedirect("admin-login.jsp");
        return;
    }
%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Add New Staff | Pahana Edu Admin Dashboard</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet" />
    <style>
        body, html {
            min-height: 100vh;
            background: linear-gradient(135deg, #eaf1fb 0%, #f8faff 100%);
        }
        .staff-form-container {
            max-width: 430px;
            margin: 48px auto;
        }
        .staff-form-card {
            background: #fff;
            border-radius: 1.5rem;
            box-shadow: 0 4px 32px rgba(52,120,246,0.08);
            border: 1px solid #f3f4f7;
            padding: 2.2rem 2rem 2rem 2rem;
        }
        .form-label {
            color: #3478f6;
            font-weight: 500;
        }
        .form-control {
            border-radius: 1rem;
            background-color: #f7fafd;
            font-size: 1.1rem;
        }
        .form-control:focus {
            border-color: #3478f6;
            box-shadow: 0 0 0 0.15rem rgba(52,120,246,.10);
            background-color: #f4f8ff;
        }
        .btn-primary {
            background: linear-gradient(90deg, #3478f6 70%, #1e50a2 100%);
            border: none;
            border-radius: 1rem;
            font-weight: 600;
            font-size: 1.08rem;
            box-shadow: 0 2px 8px rgba(52,120,246,0.09);
        }
        .btn-primary:hover, .btn-primary:focus {
            background: linear-gradient(90deg, #1e50a2 80%, #3478f6 100%);
        }
        .btn-secondary {
            border-radius: 1rem;
            font-weight: 600;
            font-size: 1.08rem;
            margin-left: 0.6rem;
        }
        .form-icon {
            font-size: 2.5rem;
            color: #3478f6;
            margin-bottom: 1.5rem;
            display: block;
            text-align: center;
        }
        @media (max-width: 600px) {
            .staff-form-container {
                max-width: 100%;
                padding: 0 0.5rem;
            }
            .staff-form-card {
                padding: 1.2rem 0.5rem 1rem 0.5rem;
            }
        }
    </style>
    <script>
        async function addStaff(event) {
            event.preventDefault();

            const username = document.getElementById("username").value.trim();
            const email = document.getElementById("email").value.trim();
            const password = document.getElementById("password").value;

            try {
                const url = new URL("http://localhost:8080/AdminStaffSystem/api/staff/check-unique");
                url.search = new URLSearchParams({username, email}).toString();

                const checkResponse = await fetch(url);
                if (!checkResponse.ok) {
                    alert("Failed to validate username/email uniqueness.");
                    return;
                }

                const checkResult = await checkResponse.json();

                if (checkResult.usernameExists) {
                    alert("Username already exists. Please choose another.");
                    return;
                }

                if (checkResult.emailExists) {
                    alert("Email already exists. Please use a different email.");
                    return;
                }

                const staff = {username, email, password};

                const response = await fetch("http://localhost:8080/AdminStaffSystem/api/staff", {
                    method: "POST",
                    headers: {"Content-Type": "application/json"},
                    body: JSON.stringify(staff)
                });

                if (response.ok) {
                    alert("Staff added successfully!");
                    window.location.href = "index.jsp";
                } else {
                    alert("Failed to add staff.");
                }
            } catch (error) {
                console.error("Error:", error);
                alert("Error occurred while adding staff.");
            }
        }
    </script>
</head>
<body>
    <%@ include file="navbar.jsp" %>
    <div class="staff-form-container">
        <div class="staff-form-card">
            <span class="form-icon"><i class="bi bi-person-plus-fill"></i></span>
            <h3 class="mb-4 fw-bold text-center" style="color:#3478f6;">Add New Staff</h3>
            <form onsubmit="addStaff(event)">
                <div class="mb-3">
                    <label for="username" class="form-label">Username:</label>
                    <input type="text" id="username" class="form-control" required autocomplete="off">
                </div>
                <div class="mb-3">
                    <label for="email" class="form-label">Email:</label>
                    <input type="email" id="email" class="form-control" required autocomplete="off">
                </div>
                <div class="mb-4">
                    <label for="password" class="form-label">Password:</label>
                    <input type="password" id="password" class="form-control" required autocomplete="off">
                </div>
                <button type="submit" class="btn btn-primary">Add Staff</button>
                <a href="index.jsp" class="btn btn-secondary">Cancel</a>
            </form>
        </div>
    </div>
</body>
</html>