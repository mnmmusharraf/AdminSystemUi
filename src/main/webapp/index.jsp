<%@ page session="true" %>
<%
    String username = (String) session.getAttribute("adminUser");
    if (username == null) {
        response.sendRedirect("admin-login.jsp");
        return; 
    }
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Pahana Edu Admin Dashboard</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet" />
    <style>
        :root {
            --main-blue: #3478f6;
            --main-blue-dark: #1e50a2;
            --main-blue-light: #eaf1fb;
            --danger: #ed5565;
            --danger-soft: #fbe3e5;
            --edit-blue: #eaf1fb;
            --edit-blue-hover: #d4e8fd;
        }
        body, html {
            height: 100%;
            background: linear-gradient(135deg, var(--main-blue-light) 0%, #f8faff 100%);
        }
        .dashboard-container {
            padding-top: 2.5rem;
            padding-bottom: 2.5rem;
        }
        .search-bar {
            max-width: 350px;
            border-radius: 1rem;
            border: 1px solid #e3e6ea;
            background-color: #f7fafd;
        }
        .table-responsive {
            background: #fff;
            border-radius: 1.2rem;
            box-shadow: 0 4px 16px rgba(52,120,246,0.07);
            border: 1px solid #f3f4f7;
            padding: 1.5rem 1rem;
        }
        .table th {
            background: var(--main-blue) !important;
            color: #fff !important;
            border: none;
            font-weight: 600;
        }
        .btn-blue {
            background: linear-gradient(90deg, var(--main-blue) 70%, var(--main-blue-dark) 100%);
            color: #fff;
            border: none;
            border-radius: 1rem;
            font-weight: 500;
            box-shadow: 0 2px 8px rgba(52,120,246,0.09);
            transition: background 0.2s;
        }
        .btn-blue:hover, .btn-blue:focus {
            background: linear-gradient(90deg, var(--main-blue-dark) 80%, var(--main-blue) 100%);
            color: #fff;
        }
        .btn-edit {
            background: var(--edit-blue);
            color: var(--main-blue-dark);
            border: none;
            border-radius: 1rem;
            font-weight: 500;
            transition: background 0.2s, color 0.2s;
        }
        .btn-edit:hover, .btn-edit:focus {
            background: var(--edit-blue-hover);
            color: var(--main-blue);
        }
        .btn-delete {
            background: var(--danger-soft);
            color: var(--danger);
            border: none;
            border-radius: 1rem;
            font-weight: 500;
            transition: background 0.2s, color 0.2s;
        }
        .btn-delete:hover, .btn-delete:focus {
            background: var(--danger);
            color: #fff;
        }
        .table-striped>tbody>tr:nth-of-type(odd)>* {
            background-color: #f7fafd;
        }
        @media (max-width: 575px) {
            .table-responsive {
                padding: 1rem 0.3rem;
                border-radius: 0.7rem;
            }
            .search-bar {
                max-width: 100%;
            }
        }
    </style>
</head>
<body>
    <%@ include file="navbar.jsp" %>
    <div class="container dashboard-container">
        <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-2">
            <div>
                <a href="add-staff.jsp" class="btn btn-blue"><i class="bi bi-person-plus-fill me-1"></i> Add New Staff</a>
            </div>
            <div class="d-flex align-items-center gap-2">
                <input type="text" id="searchInput" class="form-control search-bar" placeholder="Search by username or email" />
            </div>
        </div>
        <div class="table-responsive">
            <!-- Staff Table -->
            <table class="table table-bordered table-hover table-striped align-middle mb-0">
                <thead>
                    <tr>
                        <th scope="col">Staff ID</th>
                        <th scope="col">Username</th>
                        <th scope="col">Email</th>
                        <th scope="col">Actions</th>
                    </tr>
                </thead>
                <tbody id="staff-table-body">
                    <!-- JavaScript will load rows -->
                </tbody>
            </table>
        </div>
    </div>
    <script>
        let allStaff = [];
        document.addEventListener("DOMContentLoaded", () => {
            fetchStaff();
            document.getElementById("searchInput").addEventListener("input", function () {
                const query = this.value.toLowerCase();
                const filtered = allStaff.filter(staff =>
                    staff.username.toLowerCase().includes(query) ||
                            staff.email.toLowerCase().includes(query)
                );
                renderTable(filtered);
            });
        });
        async function fetchStaff() {
            try {
                const response = await fetch("http://localhost:8080/AdminStaffSystem/api/staff/");
                if (!response.ok)
                    throw new Error("HTTP error " + response.status);
                const data = await response.json();
                allStaff = data;
                renderTable(allStaff);
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
                editBtn.innerHTML = '<i class="bi bi-pencil-square"></i> Edit';
                editBtn.className = "btn btn-edit btn-sm me-2";
                editBtn.onclick = function () {
                    window.location.href = "edit-staff.jsp?id=" + staff.staff_id;
                };
                // Delete Button
                const deleteBtn = document.createElement("button");
                deleteBtn.innerHTML = '<i class="bi bi-trash3"></i> Delete';
                deleteBtn.className = "btn btn-delete btn-sm";
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
                return;
            try {
                const url = "http://localhost:8080/AdminStaffSystem/api/staff/" + id;
                const response = await fetch(url, {
                    method: "DELETE"
                });
                if (response.ok) {
                    alert("Staff deleted successfully!");
                    fetchStaff();
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