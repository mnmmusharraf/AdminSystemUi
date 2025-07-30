<%
    String adminUser = (String) session.getAttribute("adminUser");
    if (adminUser == null) {
        response.sendRedirect("admin-login.jsp");
        return;
    }
%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Add New Staff</title>
        <meta charset="UTF-8">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
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
    <body class="container mt-4">
        <h2 class="mb-4">Add New Staff</h2>
        <form onsubmit="addStaff(event)" class="w-50">
            <div class="mb-3">
                <label for="username" class="form-label">Username:</label>
                <input type="text" id="username" class="form-control" required>
            </div>

            <div class="mb-3">
                <label for="email" class="form-label">Email:</label>
                <input type="email" id="email" class="form-control" required>
            </div>

            <div class="mb-4">
                <label for="password" class="form-label">Password:</label>
                <input type="password" id="password" class="form-control" required>
            </div>

            <button type="submit" class="btn btn-primary">Add Staff</button>
            <a href="index.jsp" class="btn btn-secondary">Cancel</a>
        </form>
    </body>
</html>
