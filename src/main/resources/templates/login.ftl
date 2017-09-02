<#import "masterTemplate.ftl" as t>

<!DOCTYPE html>

<html>
    <head>
        <@t.headerMetaTags />
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
        <@t.navigationDiv />

        <div class="container">
          <div id="loginbox" style="margin-top:50px;" class="mainbox col-md-6 col-md-offset-3 col-sm-8 col-sm-offset-2">
              <div class="panel panel-info" >
                  <div class="panel-heading">
                      <div class="panel-title">Sign In</div>
                  </div>

                  <div style="padding-top:30px" class="panel-body" >
                      <br />
                      <#if login_error??>
                          <div id="login-alert" class="alert alert-danger">
                              <p style="margin-bottom: 0px;"><span>${login_error}</span></p>
                          </div>
                      </#if>

                      <form id="loginform" class="form-horizontal" role="form" action="/login" method="post">
                          <div style="margin-bottom: 25px" class="input-group">
                              <span class="input-group-addon"><i class="glyphicon glyphicon-user"></i></span>
                              <input id="login-username" type="text" class="form-control" name="username" value="${(username)!''}" placeholder="username or email">
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

        <@t.bootstrapCoreJS />
    </body>
</html>
