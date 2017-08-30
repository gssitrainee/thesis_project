<#import "masterTemplate.ftl" as t>

<!DOCTYPE html>
<html lang="en">

    <head>
        <@t.headerMetaTags />
        <title>Capstone: Homepage</title>

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
        <@t.navigationDiv />

        <!-- Page Content -->
        <div class="container">
            <div class="row">
                <div class="col-lg-12 text-left">
                    <h1 class="mt-5">Capstone Project</h1>
                    <p class="lead">A Quiz Bank Web Application using Java Spark Framework, Freemarker, MongoDB</p>
                    <#if userClasses??>
                        <ul class="list-unstyled">
                        <#list userClasses as cls>
                            <li><a href="/course?code=${cls["classCode"]}">${cls["className"]}<#if cls["classCode"]??> (${cls["classCode"]})</#if></a></li>
                        </#list>
                        </ul>
                    </#if>
                </div>
            </div>
        </div>

        <@t.bootstrapCoreJS />
    </body>
</html>