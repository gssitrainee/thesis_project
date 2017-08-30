<#import "masterTemplate.ftl" as t>

<!DOCTYPE html>
<html>
    <head>

        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <meta name="description" content="">
        <meta name="author" content="">

        <title>Capstone: Welcome</title>

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
        <@t.navigationDiv />

        <!-- Page Content -->
        <div class="container">
            <#if 'T'==userType>
                <div class="row sm-flex-center">
                    <div class="col-sm-6">
                        <p>Classes</p>
                        <div class="list">
                            <#if userClasses??>
                                <ul class="list-unstyled">
                                    <#list userClasses as cls>
                                        <li><a href="/course?code=${cls["classCode"]}">${cls["className"]}<#if cls["classCode"]??> (${cls["classCode"]})</#if></a></li>
                                    </#list>
                                </ul>
                            </#if>
                        </div>
                    </div>
                    <div class="col-sm-6 pull-right">
                        <p>Student Registration to Class for Approval</p>
                        <div class="list">
                            <ul class="list-unstyled">
                                <li>Andress Bonifacio </li>
                                <li>Emilio Aguinaldo </li>
                                <li>Juan Luna </li>
                            </ul>
                        </div>
                    </div>
                </div>
            <#else>
                <div class="row sm-flex-center">
                    <div class="col-sm-6">
                        <p>Enrolled Courses (Subjects)</p>
                        <div class="list">
                            <ul class="list-unstyled">
                                <li>Andress Bonifacio </li>
                                <li>Emilio Aguinaldo </li>
                                <li>Juan Luna </li>
                            </ul>
                        </div>
                    </div>
                    <div class="col-sm-6 pull-right">
                        <p>Active Class Quiz</p>
                        <div class="list">
                            <ul class="list-unstyled">
                                <li>Andress Bonifacio </li>
                                <li>Emilio Aguinaldo </li>
                                <li>Juan Luna </li>
                            </ul>
                        </div>
                    </div>
                </div>
            </#if>
        </div>

        <@t.bootstrapCoreJS />
    </body>
</html>
