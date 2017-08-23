<!DOCTYPE html>
<html lang="en">

  <head>

    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>Thesis: Homepage</title>

    <!-- Bootstrap core CSS -->
    <link href="css/bootstrap.min.css" rel="stylesheet">

    <!-- Custom styles for this template -->
    <style>
      body {
        padding-top: 54px;
      }
      @media (min-width: 992px) {
        body {
          padding-top: 56px;
        }
      }
    </style>

  </head>

  <body>

    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top">
      <div class="container">

        <#if username??>
            <a class="navbar-brand" href="#">Welcome ${username}</a>
        <#else>
            <a class="navbar-brand" href="#">Welcome guest</a>
        </#if>

        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarResponsive" aria-controls="navbarResponsive" aria-expanded="false" aria-label="Toggle navigation">
          <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarResponsive">
          <ul class="navbar-nav ml-auto">
            <#if username??>
                <li class="nav-item">
                    <a class="nav-link" href="/newcourse">Register Class</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/newpost">Post a Quiz</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/logout">Logout</a>
                </li>
            <#else>
                <li class="nav-item">
                    <a class="nav-link" href="/signup">Sign up</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/login">Log in</a>
                </li>
            </#if>
          </ul>
        </div>
      </div>
    </nav>


    <!-- Page Content -->
    <div class="container">
      <div class="row">
        <div class="col-lg-12 text-left">
          <h1 class="mt-5">Capstone Project</h1>
          <p class="lead">A Quiz Bank Web Application using Java Spark Framework, Freemarker, MongoDB</p>
          <#if userClasses??>
            <ul class="list-unstyled">
              <#list userClasses as cls>
                <li><a href="/class?code=${cls["classCode"]}">${cls["className"]}<#if cls["classCode"]??> (${cls["classCode"]})</#if></a></li>
              </#list>
            </ul>
          </#if>
        </div>
      </div>
    </div>


    <!-- Bootstrap core JavaScript -->
    <script src="js/jquery.min.js"></script>
    <script src="js/popper.min.js"></script>
    <script src="js/bootstrap.min.js"></script>

  </body>

</html>