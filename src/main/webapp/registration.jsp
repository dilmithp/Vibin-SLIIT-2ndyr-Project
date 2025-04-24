<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta http-equiv="X-UA-Compatible" content="ie=edge">
  <title>Vibin - Sign Up</title>

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
      min-height: 100vh;
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
    
    .signup-content {
      display: flex;
    }
    
    .signup-form, .signup-image {
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
    .form-group input[type="email"],
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
    
    .signup-image figure {
      position: relative;
      overflow: hidden;
      border-radius: 15px;
      margin-bottom: 20px;
    }
    
    .signup-image figure img {
      width: 100%;
      transition: transform 0.5s ease;
      filter: brightness(0.9) contrast(1.1);
    }
    
    .signup-image figure:hover img {
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
    
    .term-service {
      color: #ff9068;
      text-decoration: none;
      font-weight: 600;
      margin-left: 5px;
    }
    
    @media (max-width: 768px) {
      .signup-content {
        flex-direction: column-reverse;
      }
      
      .signup-form, .signup-image {
        padding: 30px;
      }
    }
  </style>
</head>

<body>
  <input type="hidden" id="status" value="<%= request.getAttribute("status") %>">

  <div class="main">
    <!-- Sign up form -->
    <section class="signup">
      <div class="container">
        <div class="signup-content">
          <div class="signup-form">
            <h2 class="form-title">Join Vibin Today</h2>

            <form method="post" action="Registration" class="register-form" id="register-form">
              <div class="form-group">
                <label for="name"><i class="zmdi zmdi-account material-icons-name"></i></label> 
                <input type="text" name="name" id="name" placeholder="Your Name" />
              </div>
              <div class="form-group">
                <label for="email"><i class="zmdi zmdi-email"></i></label> 
                <input type="email" name="email" id="email" placeholder="Your Email" />
              </div>
              <div class="form-group">
                <label for="pass"><i class="zmdi zmdi-lock"></i></label> 
                <input type="password" name="pass" id="pass" placeholder="Password" />
              </div>
              <div class="form-group">
                <label for="re-pass"><i class="zmdi zmdi-lock-outline"></i></label>
                <input type="password" name="re_pass" id="re_pass" placeholder="Repeat your password" />
              </div>
              <div class="form-group">
                <label for="contact"><i class="zmdi zmdi-phone"></i></label>
                <input type="text" name="contact" id="contact" placeholder="Contact no" />
              </div>
              <div class="form-group form-button">
                <input type="submit" name="signup" id="signup" class="form-submit" value="Register" />
              </div>
            </form>
          </div>
          <div class="signup-image">
            <figure>
              <img src="images/signup-image.jpg" alt="sing up image">
            </figure>
            <a href="login.jsp" class="signup-image-link">I am already a member</a>
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
      if (status == "success") {
        swal("Success", "Account created successfully!", "success").then((value) => {
          window.location = "login.jsp";
        });
      } else if (status == "failed") {
        swal("Error", "Something went wrong. Please try again.", "error");
      }
    }
  </script>
</body>

</html>
