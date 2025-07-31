package com.pahana.adminsystemui.servlet;


import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;

public class LoginServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // Call the backend API
        URL url = new URL("http://localhost:8080/AdminStaffSystem/api/admin/login");
        HttpURLConnection con = (HttpURLConnection) url.openConnection();
        con.setRequestMethod("POST");
        con.setRequestProperty("Content-Type", "application/json");
        con.setDoOutput(true);

        String jsonInput = String.format("{\"username\":\"%s\", \"password\":\"%s\"}", username, password);
        try (OutputStream os = con.getOutputStream()) {
            byte[] input = jsonInput.getBytes("utf-8");
            os.write(input, 0, input.length);
        }

        int status = con.getResponseCode();
        if (status == 200) {
            // login success
            HttpSession session = request.getSession();
            session.setAttribute("adminUser", username);
            response.sendRedirect("index.jsp");
        } else {
            // login failed
//            request.setAttribute("error", "Invalid username or password.");
//            request.getRequestDispatcher("admin-login.jsp").forward(request, response);
              String errorMsg = URLEncoder.encode("Invalid username or password","UTF-8");
              response.sendRedirect("admin-login.jsp?error="+errorMsg);
        }
    }
}
