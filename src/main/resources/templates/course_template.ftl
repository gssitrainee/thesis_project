<!doctype HTML>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>Capstone: Register a Class (Course)</title>

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

/*        div.divContainer {
            border: 1px solid #ccc;
            width: 450px;
            padding: 20px 0px 20px 50px;
        }
        p > label {
            display: inline-block; width: 150px;
            font-weight: bold;
        }
        p > input[type='text'], p > textarea {
            font-family: "Courier New", Georgia, Serif;
            width: 200px;
            padding: 5px;
        }
        input[type=submit] {
            font-family: "Courier New", Georgia, Serif;
            font-weight: bolder;
            padding: 5px 20px;
        }*/
        span.status {
            font-family: "Courier New", Georgia, Serif;
            font-style: italic;
            font-size: 0.65em;
            padding: 5px;
            border: 1px solid #ddd;
            background-color: #eee;
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top">
        <div class="container">
            <a class="navbar-brand" href="#">Class Registration</a>
            <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarResponsive" aria-controls="navbarResponsive" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarResponsive">
                <ul class="navbar-nav ml-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="/">Home</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/logout">Logout</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>




    <div style="margin-top:50px" class="mainbox col-md-6 col-md-offset-3 col-sm-8 col-sm-offset-2">
        <div class="panel panel-info">
            <div class="panel-body" >
                <form id="saveclassform" class="form-horizontal" role="form" action="/save_class" method="POST">

                    <div class="form-group has-error has-feedback">
                        <label for="txtClassCode" class="col-md-3 control-label">Class Code</label>
                        <div class="col-md-9">
                            <input type="text" id="txtClassCode" class="form-control" name="classCode" value="${classCode!""}" placeholder="Class or Course Code" title="Enter Class or Course Code" />
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="txtClassName" class="col-md-3 control-label">Class Name</label>
                        <div class="col-md-9">
                            <input type="text" class="form-control" id="txtClassName" name="className" value="${className!""}" placeholder="Class or Course Name" title="Enter Class or Course Name" />
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="txtClassDescription" class="col-md-3 control-label">Class Description</label>
                        <div class="col-md-9">
                            <textarea class="form-control" id="txtClassDescription" name="classDescription"  placeholder="Class or Course Description" title="Enter Class or Course Description" cols="30" rows="3">${classDescription!""}</textarea>
                        </div>
                    </div>

                    <div class="form-group">
                        <!-- Button -->
                        <div class="col-md-offset-3 col-md-9">
                            <input type="submit" id="btn-signup" class="btn btn-info" value="Create Class" />
                        </div>
                    </div>

                </form>
            </div>
        </div>
    </div>




    <!-- Bootstrap core JavaScript -->
    <script src="js/jquery.min.js"></script>
    <script src="js/popper.min.js"></script>
    <script src="js/bootstrap.min.js"></script>

</body>
</html>

