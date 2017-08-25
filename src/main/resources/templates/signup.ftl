<!DOCTYPE html>

<html>
    <head>

        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <meta name="description" content="">
        <meta name="author" content="">

        <title>Capstone: Sign Up</title>

        <!-- Bootstrap core CSS -->
        <link href="css/bootstrap.min.css" rel="stylesheet">

        <style type="text/css">
            body {
                padding-top: 54px;
            }
            @media (min-width: 992px) {
                body {
                    padding-top: 56px;
                }
            }

            .label {text-align: right}
            .error {color: red}
        </style>
    </head>

  <body>

      <!-- Navigation -->
      <nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top">
          <div class="container">
              <a class="navbar-brand" href="/login">Already a user?</a>
              <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarResponsive" aria-controls="navbarResponsive" aria-expanded="false" aria-label="Toggle navigation">
                  <span class="navbar-toggler-icon"></span>
              </button>
              <div class="collapse navbar-collapse" id="navbarResponsive">
                  <ul class="navbar-nav ml-auto">
                      <li class="nav-item">
                          <a class="nav-link" href="/login">Log in</a>
                      </li>
                  </ul>
              </div>
          </div>
      </nav>

      <div id="signupbox" style="margin-top:50px" class="mainbox col-md-6 col-md-offset-3 col-sm-8 col-sm-offset-2">
          <div class="panel panel-info">
              <div class="panel-body" >
                  <form id="signupform" class="form-horizontal" role="form" action="/signup" method="post">

                      <div id="signupalert" style="display:none" class="alert alert-danger">
                          <p>Error:</p>
                          <span></span>
                      </div>

                      <div class="form-group has-error has-feedback">
                          <label for="username" class="col-md-3 control-label">Username</label>
                          <div class="col-md-9">
                              <input type="text" class="form-control" name="username" placeholder="Username" />
                              <span class="glyphicon glyphicon-remove form-control-feedback"></span>
                          </div>
                      </div>

                      <div class="form-group">
                          <label for="password" class="col-md-3 control-label">Password</label>
                          <div class="col-md-9">
                              <input type="password" class="form-control" name="password" placeholder="Password">
                          </div>
                      </div>

                      <div class="form-group">
                          <label for="verify" class="col-md-3 control-label">Verify Password</label>
                          <div class="col-md-9">
                              <input type="password" class="form-control" name="verify" placeholder="Verify Password">
                          </div>
                      </div>

                      <div class="form-group">
                          <label for="email" class="col-md-3 control-label">Email (Optional)</label>
                          <div class="col-md-9">
                              <input type="text" class="form-control" name="email" placeholder="Email Address (Optional)">
                          </div>
                      </div>

                      <div class="form-group">
                          <label class="radio-inline"><input type="radio" name="userType" value="T">Teacher</label>
                          <label class="radio-inline"><input type="radio" name="userType" value="S">Student</label>
                      </div>

                      <div class="form-group">
                          <!-- Button -->
                          <div class="col-md-offset-3 col-md-9">
                              <!--
                              <button id="btn-signup" type="button" class="btn btn-info"><i class="icon-hand-right"></i> &nbsp Sign Up</button>
                              -->
                              <input type="submit" id="btn-signup" class="btn btn-info" value="&nbsp Sign Up" />
                          </div>
                      </div>

                  </form>
              </div>
          </div>
      </div>


<#--
    Already a user? <a href="/login">Login</a><p>
    <h2>Signup</h2>
    <form method="post">
      <table>
        <tr>
          <td class="label">
            Username
          </td>
          <td>
            <input type="text" name="username" value="${username}">
          </td>
          <td class="error">
              ${username_error!""}
          </td>
        </tr>
        <tr>
          <td class="label">
            Password
          </td>
          <td>
              <input type="password" name="password" value="">
          </td>
          <td class="error">
              ${password_error!""}
          </td>
        </tr>

        <tr>
          <td class="label">
            Verify Password
          </td>
          <td>
              <input type="password" name="verify" value="">
          </td>
          <td class="error">
              ${verify_error!""}
          </td>
        </tr>

        <tr>
          <td class="label">
            Email (optional)
          </td>
          <td>
            <input type="text" name="email" value="${email}">
          </td>
          <td class="error">
            ${email_error!""}
          </td>
        </tr>

        <tr>
          <td class="label">
            User Type
          </td>
          <td>
              <input type="radio" name="userType" value="T"> Teacher<br>
              <input type="radio" name="userType" value="S"> Student<br>
          </td>
          <td class="error">
            ${userType_error!""}
          </td>
        </tr>
      </table>

      <input type="submit">
    </form>-->

        <!-- Bootstrap core JavaScript -->
        <script src="js/jquery.min.js"></script>
        <script src="js/popper.min.js"></script>
        <script src="js/bootstrap.min.js"></script>

    </body>

</html>
