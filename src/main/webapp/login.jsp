<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta http-equiv="X-UA-Compatible" content="ie=edge">
  <title>Vibin - Login</title>

  <!-- Font Icon -->
  <link rel="stylesheet" href="fonts/material-icon/css/material-design-iconic-font.min.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <script src="https://cdn.tailwindcss.com"></script>
  <script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>

  <style>
    body {
      background: linear-gradient(135deg, #1a2a6c, #b21f1f, #fdbb2d);
      background-size: 400% 400%;
      animation: gradient 15s ease infinite;
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      margin: 0;
      padding: 0;
      height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
      color: white;
    }
    
    @keyframes gradient {
      0% { background-position: 0% 50%; }
      50% { background-position: 100% 50%; }
      100% { background-position: 0% 50%; }
    }
    
    .main {
      width: 100%;
      max-width: 900px;
      padding: 20px;
    }
    
    .container {
      backdrop-filter: blur(10px);
      background-color: rgba(255, 255, 255, 0.15);
      border-radius: 20px;
      box-shadow: 0 15px 35px rgba(0, 0, 0, 0.2);
      overflow: hidden;
    }
    
    .signin-content {
      display: flex;
      flex-direction: row-reverse;
    }
    
    .signin-form, .signin-image {
      flex: 1;
      padding: 40px;
    }
    
    .form-title {
      font-size: 32px;
      background: linear-gradient(45deg, #ff4b1f, #ff9068);
      -webkit-background-clip: text;
      background-clip: text;
      color: transparent;
      margin-bottom: 30px;
      text-align: center;
      letter-spacing: 2px;
      font-weight: 700;
    }
    
    .form-group {
      position: relative;
      margin-bottom: 25px;
      overflow: hidden;
    }
    
    .form-group label {
      position: absolute;
      top: 50%;
      transform: translateY(-50%);
      left: 10px;
      color: #6c63ff;
      font-size: 18px;
      z-index: 10;
    }
    
    .form-group input[type="text"],
    .form-group input[type="password"] {
      width: 100%;
      padding: 15px 15px 15px 40px;
      border: none;
      border-radius: 50px;
      background: rgba(255, 255, 255, 0.9);
      box-shadow: inset 0 2px 10px rgba(0, 0, 0, 0.1);
      transition: all 0.3s ease;
      color: #333;
    }
    
    .form-group input:focus {
      outline: none;
      box-shadow: 0 0 0 2px #6c63ff, inset 0 2px 10px rgba(0, 0, 0, 0.1);
      transform: scale(1.02);
    }
    
    .form-submit {
      background: linear-gradient(45deg, #6c63ff, #3b82f6);
      color: white;
      border: none;
      border-radius: 50px;
      padding: 15px 40px;
      font-size: 16px;
      font-weight: 600;
      cursor: pointer;
      transition: all 0.3s ease;
      width: 100%;
      text-transform: uppercase;
      letter-spacing: 1px;
    }
    
    .form-submit:hover {
      transform: translateY(-3px);
      box-shadow: 0 10px 20px rgba(108, 99, 255, 0.4);
    }
    
    .signin-image figure {
      position: relative;
      overflow: hidden;
      border-radius: 15px;
      margin-bottom: 20px;
    }
    
    .signin-image figure img {
      width: 100%;
      transition: transform 0.5s ease;
      filter: brightness(0.9) contrast(1.1);
    }
    
    .signin-image figure:hover img {
      transform: scale(1.05);
    }
    
    .signup-image-link {
      display: inline-block;
      color: white;
      text-decoration: none;
      font-weight: 500;
      position: relative;
      padding: 5px 0;
      transition: all 0.3s ease;
    }
    
    .signup-image-link::after {
      content: '';
      position: absolute;
      width: 100%;
      height: 2px;
      bottom: 0;
      left: 0;
      background: linear-gradient(90deg, #6c63ff, transparent);
      transform-origin: right;
      transform: scaleX(0);
      transition: transform 0.3s ease;
    }
    
    .signup-image-link:hover::after {
      transform-origin: left;
      transform: scaleX(1);
    }
    
    .agree-term {
      appearance: none;
      width: 20px;
      height: 20px;
      border: 2px solid #6c63ff;
      border-radius: 5px;
      margin-right: 10px;
      position: relative;
      cursor: pointer;
    }
    
    .agree-term:checked::before {
      content: '✓';
      position: absolute;
      top: 50%;
      left: 50%;
      transform: translate(-50%, -50%);
      color: #6c63ff;
      font-size: 14px;
    }
    
    .label-agree-term {
      display: flex;
      align-items: center;
      color: white;
      font-size: 14px;
    }
    
    .social-login {
      margin-top: 30px;
      text-align: center;
    }
    
    .social-label {
      display: block;
      color: white;
      margin-bottom: 15px;
    }
    
    .socials {
      list-style: none;
      padding: 0;
      display: flex;
      justify-content: center;
      gap: 15px;
    }
    
    .socials li a {
      display: flex;
      align-items: center;
      justify-content: center;
      width: 40px;
      height: 40px;
      border-radius: 50%;
      background: rgba(255, 255, 255, 0.2);
      color: white;
      transition: all 0.3s ease;
    }
    
    .socials li a:hover {
      background: #6c63ff;
      transform: translateY(-3px);
    }
    
    @media (max-width: 768px) {
      .signin-content {
        flex-direction: column;
      }
      
      .signin-form, .signin-image {
        padding: 30px;
      }
    }
  </style>
</head>

<body>
  <input type="hidden" id="status" value="<%= request.getAttribute("status") %>">

  <div class="main">
    <!-- Sign in Form -->
    <section class="sign-in">
      <div class="container">
        <div class="signin-content">
          <div class="signin-image">
            <figure>
              <img src="images/signin-image.jpg" alt="sing up image">
            </figure>
            <a href="admin-login.jsp" class="signup-image-link">Admin Login</a><br>
            <a href="registration.jsp" class="signup-image-link">Create New Account</a>
          </div>

          <div class="signin-form">
            <h2 class="form-title">Welcome to Vibin</h2>
            <form method="post" action="Login" class="register-form" id="login-form">
              <div class="form-group">
                <label for="username"><i class="zmdi zmdi-account material-icons-name"></i></label> 
                <input type="text" name="username" id="username" placeholder="Your Email" />
              </div>
              <div class="form-group">
                <label for="password"><i class="zmdi zmdi-lock"></i></label> 
                <input type="password" name="password" id="password" placeholder="Password" />
              </div>
              <div class="form-group form-button">
                <input type="submit" name="signin" id="signin" class="form-submit" value="Log in" />
              </div>
            </form>
            <div class="social-login">
              <span class="social-label">Or login with</span>
              <ul class="socials">
                <li><a href="#"><i class="zmdi zmdi-facebook"></i></a></li>
                <li><a href="#"><i class="zmdi zmdi-twitter"></i></a></li>
                <li><a href="#"><i class="zmdi zmdi-google"></i></a></li>
              </ul>
            </div>
          </div>
        </div>
      </div>
    </section>
  </div>

  <!-- JS -->
  <script src="vendor/jquery/jquery.min.js"></script>
  <script src="js/main.js"></script>
  <script type="text/javascript">
    window.onload = function() {
      var status = document.getElementById("status").value;
      if (status == "fail") {
        swal("Error", "Wrong Email or Password", "error");
      } else if (status == "deleted") {
        swal("Success", "Your account has been deleted successfully", "success");
      }
    }
  </script>
</body>

</html>
