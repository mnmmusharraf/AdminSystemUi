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
        <title>Edit Staff</title>
        <meta charset="UTF-8">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
        <script>
            const urlParams = new URLSearchParams(window.location.search);
            const staffId = urlParams.get("id");
            let originalUsername = "";
            let originalEmail = "";

            document.addEventListener("DOMContentLoaded", async function () {
                if (!staffId) {
                    alert("No staff ID provided.");
                    window.location.href = "index.jsp";
                    return;
                }

                try {
                    const res = await fetch("http://localhost:8080/AdminStaffSystem/api/staff/" + staffId);
                    if (!res.ok) {
                        throw new Error("Failed to fetch staff details.");
                    }

                    const staff = await res.json();
                    document.getElementById("username").value = staff.username;
                    document.getElementById("email").value = staff.email;
                    originalUsername = staff.username;
                    originalEmail = staff.email;
                } catch (err) {
                    console.error("Failed to load staff:", err);
                    alert("Failed to load staff data.");
                    window.location.href = "index.jsp";
                }
            });

            async function updateStaff(event) {
                event.preventDefault();

                const username = document.getElementById("username").value.trim();
                const email = document.getElementById("email").value.trim();
                const password = document.getElementById("password").value;

                if (!username || !email) {
                    alert("Username and email are required.");
                    return;
                }

                // Check uniqueness only if changed
                if (username !== originalUsername || email !== originalEmail) {
                    try {
                        const url = new URL("http://localhost:8080/AdminStaffSystem/api/staff/check-unique");
                        url.search = new URLSearchParams({username, email}).toString();

                        const checkResponse = await fetch(url);
                        if (!checkResponse.ok) {
                            alert("Failed to validate username/email uniqueness.");
                            return;
                        }

                        const checkResult = await checkResponse.json();

                        if (checkResult.usernameExists && username !== originalUsername) {
                            alert("Username already exists. Please choose another.");
                            return;
                        }

                        if (checkResult.emailExists && email !== originalEmail) {
                            alert("Email already exists. Please use a different email.");
                            return;
                        }
                    } catch (error) {
                        console.error("Error checking uniqueness:", error);
                        alert("Error occurred while validating uniqueness.");
                        return;
                    }
                }

                const updatedStaff = {username, email};
                if (password.trim() !== "") {
                    updatedStaff.password = password;
                }

                try {
                    const updateResponse = await fetch("http://localhost:8080/AdminStaffSystem/api/staff/" + staffId, {
                        method: "PUT",
                        headers: {"Content-Type": "application/json"},
                        body: JSON.stringify(updatedStaff)
                    });

                    if (updateResponse.ok) {
                        alert("Staff updated successfully!");
                        window.location.href = "index.jsp";
                    } else {
                        alert("Failed to update staff.");
                    }
                } catch (error) {
                    console.error("Error updating staff:", error);
                    alert("Error occurred while updating staff.");
                }
            }
        </script>

    </head>
    <body class="container mt-4">
        <h2 class="mb-4">Edit Staff</h2>
        <form onsubmit="updateStaff(event)" class="w-50">
            <div class="mb-3">
                <label for="username" class="form-label">Username:</label>
                <input type="text" id="username" class="form-control" required>
            </div>

            <div class="mb-3">
                <label for="email" class="form-label">Email:</label>
                <input type="email" id="email" class="form-control" required>
            </div>

            <div class="mb-4">
                <label for="password" class="form-label">Password: (Leave blank to keep current password)</label>
                <input type="password" id="password" class="form-control">
            </div>

            <button type="submit" class="btn btn-primary">Update Staff</button>
            <a href="index.jsp" class="btn btn-secondary">Cancel</a>
        </form>
    </body>
</html>
