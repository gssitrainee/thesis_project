<!DOCTYPE html>

<html>
  <head>

      <meta charset="utf-8">
      <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
      <meta name="description" content="">
      <meta name="author" content="">

      <title>Capstone: Login</title>

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
              <a class="navbar-brand" href="/signup">Need to Create an account?</a>
              <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarResponsive" aria-controls="navbarResponsive" aria-expanded="false" aria-label="Toggle navigation">
                  <span class="navbar-toggler-icon"></span>
              </button>
              <div class="collapse navbar-collapse" id="navbarResponsive">
                  <ul class="navbar-nav ml-auto">
                      <li class="nav-item">
                          <a class="nav-link" href="/signup">Sign up</a>
                      </li>
                      <li class="nav-item">
                          <a class="nav-link" href="/login">Log in</a>
                      </li>
                  </ul>
              </div>
          </div>
      </nav>

      <div class="container">
          <div id="loginbox" style="margin-top:50px;" class="mainbox col-md-6 col-md-offset-3 col-sm-8 col-sm-offset-2">
              <div class="panel panel-info" >
                  <div class="panel-heading">
                      <div class="panel-title">Sign In</div>
                  </div>

                  <div style="padding-top:30px" class="panel-body" >

                      <div style="display:none" id="login-alert" class="alert alert-danger col-sm-12"></div>

                      <form id="loginform" class="form-horizontal" role="form" action="/login" method="post">

                          <#if login_error??>
                              <div id="signupalert" style="display:none" class="alert alert-danger">
                                  <p>Error:</p>
                                  <span>${login_error}</span>
                              </div>
                          </#if>

                          <div style="margin-bottom: 25px" class="input-group">
                              <span class="input-group-addon"><i class="glyphicon glyphicon-user"></i></span>
                              <input id="login-username" type="text" class="form-control" name="username" value="${username}" placeholder="username or email">
                          </div>

                          <div style="margin-bottom: 25px" class="input-group">
                              <span class="input-group-addon"><i class="glyphicon glyphicon-lock"></i></span>
                              <input id="login-password" type="password" class="form-control" name="password" placeholder="password">
                          </div>

                          <div style="margin-top:10px" class="form-group">
                              <div class="col-sm-12 controls">
                                  <input type="submit" id="btn-login" class="btn btn-success" value="Login" />
                              </div>
                          </div>
                      </form>
                  </div>
              </div>
          </div>

      </div>

      <!-- Bootstrap core JavaScript -->
      <script src="js/jquery.min.js"></script>
      <script src="js/popper.min.js"></script>
      <script src="js/bootstrap.min.js"></script>

  </body>

</html>
