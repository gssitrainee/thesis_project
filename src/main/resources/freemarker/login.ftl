<!DOCTYPE html>

<html>
  <head>
    <title>Login</title>
      <link rel="stylesheet" type="text/css" href="../css/login.css">
    <style type="text/css">
      .label {text-align: right}
      .error {color: red}
    </style>
  </head>

  <body>
    Need to Create an account? <a href="/signup">Signup</a><p>
    <div class="loginContainer">
      <h2>Login</h2>
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
               ${login_error}
            </td>
          </tr>
        </table>
        <input type="submit">
      </form>
    </div>
  </body>

</html>
