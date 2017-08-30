<#import "masterTemplate.ftl" as t>

<!DOCTYPE html>
<html>
    <head>
        <@t.headerMetaTags />
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
        <@t.navigationDiv />

        <div id="signupbox" style="margin-top:50px" class="mainbox col-md-6 col-md-offset-3 col-sm-8 col-sm-offset-2">
          <div class="panel panel-info">
              <div class="panel-body" >
                  <form id="signupform" class="form-horizontal" role="form" action="/signup" method="post">

                      <#if signup_error??>
                          <div id="signupalert" style="display:none" class="alert alert-danger">
                              <p>Error: <span>${signup_error}</span></p>
                          </div>
                      </#if>

                      <div class="form-group has-error has-feedback">
                          <label for="txtFirstName" class="col-md-3 control-label">First Name</label>
                          <div class="col-md-9">
                              <input type="text" id="txtFirstName" class="form-control" name="firstName" placeholder="First Name" />
                          </div>
                      </div>

                      <div class="form-group has-error has-feedback">
                          <label for="txtLastName" class="col-md-3 control-label">Last Name</label>
                          <div class="col-md-9">
                              <input type="text" id="txtLastName" class="form-control" name="lastName" placeholder="Last Name" />
                          </div>
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
                              <input type="submit" id="btn-signup" class="btn btn-info" value="&nbsp Sign Up" />
                          </div>
                      </div>

                  </form>
              </div>
          </div>
      </div>

        <@t.bootstrapCoreJS />
    </body>
</html>
