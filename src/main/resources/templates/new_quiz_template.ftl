<!doctype HTML>
<html>
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <meta name="description" content="">
        <meta name="author" content="">

        <title>Capstone: Create a new Quiz</title>

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

/*            div.divContainer {
                border: 1px solid #ccc;
                width: 370px;
                padding: 20px 0px 20px 50px;
            }
            p > label {
                display: inline-block; width: 150px;
                font-weight: bold;
            }
            p > input[type='text'], p > textarea, select {
                font-family: "Courier New", Georgia, Serif;
                width: 300px;
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
                <a class="navbar-brand" href="#">Quiz Creation</a>
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
                    <form id="postquizform" class="form-horizontal" role="form" action="/postQuiz" method="POST">

                        <div class="form-group has-error has-feedback">
                            <label for="selClass" class="col-md-3 control-label">Class</label>
                            <div class="col-md-9">
                                <select name="sel_class" id="selClass" class="form-control">
                                <#if userClasses??>
                                    <ul>
                                        <#list userClasses as cls>
                                            <option value="${cls["classCode"]}">${cls["className"]}</option>
                                        </#list>
                                    </ul>
                                <#else>
                                    <option value="N_A">No Class Available</option>
                                </#if>
                                </select>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="txtTitle" class="col-md-3 control-label">Title</label>
                            <div class="col-md-9">
                                <input type="text" class="form-control" id="txtTitle" name="subject" size="120" value="${subject!""}"><br />
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="txtVideoUrl" class="col-md-3 control-label">Video Link</label>
                            <div class="col-md-9">
                                <input type="text" class="form-control" id="txtVideoUrl" name="subject" size="120" value="${video_link!""}"><br />
                            </div>
                        </div>

<#--                        <div class="form-group">
                            <label for="txtContent" class="col-md-3 control-label">Lecture Summary</label>
                            <div class="col-md-9">
                                <textarea class="form-control" id="txtContent" name="body" cols="30" rows="3">${body!""}</textarea><br />
                            </div>
                        </div>-->

                        <div class="form-group">
                            <!-- Button -->
                            <div class="col-md-offset-3 col-md-9">
                                <input type="submit" id="btn-signup" class="btn btn-info" value="Post Quiz" />
                            </div>
                        </div>

                    </form>
                </div>
            </div>
        </div>




<#--        <div class="divContainer">
            <form action="/newpost" method="POST">

            <p>
                <label for="selClass">Class:</label>
                <select name="sel_class" id="selClass" class="form-control">
                <#if userClasses??>
                    <ul>
                        <#list userClasses as cls>
                            <option value="${cls["classCode"]}">${cls["className"]}</option>
                        </#list>
                    </ul>
                <#else>
                    <option value="N_A">No Class Available</option>
                </#if>
                </select>
            </p>

            <p>
                <label for="txtTitle">Title:</label>
                <input type="text" id="txtTitle" name="subject" size="120" value="${subject!""}"><br />
            </p>

            <p>
                <label for="txtContent">Content:</label>
                <textarea id="txtContent" name="body" cols="120" rows="20">${body!""}</textarea><br />
            </p>

            <p />
            <input type="submit" value="Submit">
            </form>
        </div>-->

        <!-- Bootstrap core JavaScript -->
        <script src="js/jquery.min.js"></script>
        <script src="js/popper.min.js"></script>
        <script src="js/bootstrap.min.js"></script>

    </body>
</html>

