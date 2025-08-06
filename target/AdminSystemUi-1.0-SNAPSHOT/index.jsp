<%@ page session="true" %>
<%
    String username = (String) session.getAttribute("adminUser");
    if (username == null) {
        response.sendRedirect("admin-login.jsp");
        return; 
    }

    // Prevent caching
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
%>


<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Admin Staff Dashboard</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    </head>
    <body class="bg-light">

        <div class="container py-5">
            <div class="mb-4 text-center">
                <h2>Admin Staff Dashboard</h2>
            </div>

            <div class="d-flex justify-content-between align-items-center mb-3">
                <div>
                    <a href="add-staff.jsp" class="btn btn-outline-success">Add New Staff</a>
                </div>

                <div class="d-flex align-items-center gap-2">
                    <input type="text" id="searchInput" class="form-control" placeholder="Search by username or email" style="width: 250px;" />
                    <a href="logout" class="btn btn-outline-danger">Logout</a>
                </div>
            </div>


            <!-- Staff Table -->
            <table class="table table-bordered table-hover table-striped">
                <thead class="table-dark">
                    <tr>
                        <th>Staff ID</th>
                        <th>Username</th>
                        <th>Email</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody id="staff-table-body">
                    <!-- JavaScript will load rows -->
                </tbody>
            </table>
        </div>

        <script>
            let allStaff = []; // Global array to store all staff

            document.addEventListener("DOMContentLoaded", () => {
                fetchStaff();

                // Add search functionality
                document.getElementById("searchInput").addEventListener("input", function () {
                    const query = this.value.toLowerCase();
                    const filtered = allStaff.filter(staff =>
                        staff.username.toLowerCase().includes(query) ||
                                staff.email.toLowerCase().includes(query)
                    );
                    renderTable(filtered); // Re-render with filtered staff
                });
            });

            async function fetchStaff() {
                try {
                    const response = await fetch("http://localhost:8080/AdminStaffSystem/api/staff/");
                    if (!response.ok)
                        throw new Error("HTTP error " + response.status);

                    const data = await response.json();
                    console.log("Fetched staff data:", data);

                    allStaff = data;        // Store in global variable
                    renderTable(allStaff);  // Initial render with all data
                } catch (err) {
                    console.error("Failed to fetch staff:", err);
                    alert("Could not load staff data. Check console for error.");
                }
            }

            function renderTable(data) {
                const tableBody = document.getElementById("staff-table-body");
                tableBody.innerHTML = "";

                data.forEach(staff => {
                    const row = document.createElement("tr");

                    const idCell = document.createElement("td");
                    idCell.textContent = staff.staff_id;

                    const nameCell = document.createElement("td");
                    nameCell.textContent = staff.username;

                    const emailCell = document.createElement("td");
                    emailCell.textContent = staff.email;

                    const actionCell = document.createElement("td");

                    // Edit Button
                    const editBtn = document.createElement("button");
                    editBtn.textContent = "Edit";
                    editBtn.className = "btn btn-warning btn-sm me-2";
                    editBtn.onclick = function () {
                        window.location.href = "edit-staff.jsp?id=" + staff.staff_id;
                    };

                    // Delete Button
                    const deleteBtn = document.createElement("button");
                    deleteBtn.textContent = "Delete";
                    deleteBtn.className = "btn btn-danger btn-sm";
                    deleteBtn.onclick = () => {
                        deleteStaff(staff.staff_id);
                    };

                    actionCell.appendChild(editBtn);
                    actionCell.appendChild(deleteBtn);

                    row.appendChild(idCell);
                    row.appendChild(nameCell);
                    row.appendChild(emailCell);
                    row.appendChild(actionCell);

                    tableBody.appendChild(row);
                });
            }

            async function deleteStaff(id) {
                const confirmed = window.confirm("Are you sure you want to delete this staff member?");
                if (!confirmed)
                    return; // Exit if user cancels

                try {
                    const url = "http://localhost:8080/AdminStaffSystem/api/staff/" + id;
                    const response = await fetch(url, {
                        method: "DELETE"
                    });

                    if (response.ok) {
                        alert("Staff deleted successfully!");
                        fetchStaff(); // Refresh full list
                    } else {
                        alert("Failed to delete staff.");
                    }
                } catch (err) {
                    console.error("Error deleting staff:", err);
                    alert("An error occurred while deleting.");
                }
            }

        </script>


    </body>
</html>
