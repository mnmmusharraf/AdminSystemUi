<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Admin Login</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet" />
    <style>
        body, html {
            height: 100%;
            background: linear-gradient(135deg, #eaf1fb 0%, #f8faff 100%);
        }
        .login-container {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .login-form {
            width: 100%;
            max-width: 390px;
            padding: 2.5rem 2rem;
            background-color: #fff;
            border-radius: 2rem;
            box-shadow: 0 8px 32px rgba(51,71,105,0.09);
            border: 1px solid #f3f4f7;
        }
        .logo {
            display: flex;
            justify-content: center;
            align-items: center;
            margin-bottom: 2rem;
        }
        .logo i {
            font-size: 2.8rem;
            color: #3478f6;
            filter: drop-shadow(0 2px 4px rgba(52,120,246,0.10));
        }
        .form-label {
            font-weight: 500;
            color: #3478f6;
        }
        .form-control {
            border-radius: 1rem;
            font-size: 1.1rem;
            border: 1px solid #e3e6ea;
            background-color: #f7fafd;
        }
        .form-control:focus {
            border-color: #3478f6;
            box-shadow: 0 0 0 0.15rem rgba(52,120,246,.10);
            background-color: #f4f8ff;
        }
        .input-group-text {
            background: transparent;
            border: none;
            color: #b4b9c3;
        }
        .toggle-password {
            cursor: pointer;
            color: #b4b9c3;
        }
        .btn-primary {
            background: linear-gradient(90deg, #3478f6 60%, #1e50a2 100%);
            border: none;
            border-radius: 1.2rem;
            font-weight: 600;
            font-size: 1.1rem;
            box-shadow: 0 2px 8px rgba(52,120,246,0.09);
        }
        .btn-primary:hover, .btn-primary:focus {
            background: linear-gradient(90deg, #2464c5 60%, #183b73 100%);
        }
        .alert-danger {
            border-radius: 1rem;
            font-size: 1rem;
        }
        @media (max-width: 500px) {
            .login-form {
                padding: 1.2rem 0.5rem;
                border-radius: 1rem;
            }
        }
    </style>
</head>
<body>
    <div class="login-container">
        <form class="login-form position-relative" method="POST" action="login" autocomplete="off">
            <div class="logo">
                <i class="bi bi-person-circle"></i>
            </div>
            <h3 class="mb-4 text-center fw-bold" style="color: #3478f6;">Admin Login</h3>
            <div class="mb-3">
                <label for="username" class="form-label">Username</label>
                <input 
                    type="text" 
                    class="form-control" 
                    id="username" 
                    name="username" 
                    placeholder="Enter username" 
                    required 
                    autofocus 
                />
            </div>
            <div class="mb-3">
                <label for="password" class="form-label">Password</label>
                <div class="input-group">
                    <input 
                        type="password" 
                        class="form-control" 
                        id="password" 
                        name="password" 
                        placeholder="Enter password" 
                        required 
                    />
                    <span class="input-group-text toggle-password" onclick="togglePassword()">
                        <i id="eyeIcon" class="bi bi-eye-slash"></i>
                    </span>
                </div>
            </div>
            <% String error = request.getParameter("error");
                if(error != null && !error.isEmpty()){
            %>
            <div class="alert alert-danger mb-3 text-center" role="alert"><%= error %></div>
            <%
                }
            %>
            <button type="submit" class="btn btn-primary w-100 py-2 mt-2">Login</button>
        </form>
    </div>
    <script>
        function togglePassword() {
            const pwd = document.getElementById('password');
            const eye = document.getElementById('eyeIcon');
            if (pwd.type === 'password') {
                pwd.type = 'text';
                eye.classList.remove('bi-eye-slash');
                eye.classList.add('bi-eye');
            } else {
                pwd.type = 'password';
                eye.classList.remove('bi-eye');
                eye.classList.add('bi-eye-slash');
            }
        }
    </script>
</body>
</html>