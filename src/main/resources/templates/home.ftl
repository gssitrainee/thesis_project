<#import "masterTemplate.ftl" as t>

<!DOCTYPE html>
<html lang="en">

    <head>
        <@t.headerMetaTags />
        <title>Capstone: Homepage</title>

        <!-- Bootstrap core CSS -->
        <link href="css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="css/home.css">
        <@t.headerFavicons />
    </head>

    <body>
        <@t.navigationDiv />

        <!-- Page Content -->
        <div id="divMainContainer" class="container">
            <#if userType?? && 'T'==userType>
                <div class="row sm-flex-center">
                    <div class="col-sm-4">
                        <h4>Classes</h4>
                        <div class="list">
                            <#if userClasses??>
                                <ul class="list-group">
                                    <#list userClasses as cls>
                                        <li class="list-group-item"><a href="/course?code=${cls["_id"]}">${cls["className"]}<#if cls["_id"]??> (${cls["_id"]})</#if></a></li>
                                    </#list>
                                </ul>
                            </#if>
                        </div>
                    </div>
                    <div class="col-sm-8 pull-right">
                        <h4>Student Registration to Class for Approval</h4>
                        <table id="tblEnrollmentForApproval" class="table table-hover">
                            <thead>
                            <tr>
                                <th>Class</th>
                                <th>Student</th>
                                <th>Accept</th>
                                <th>Deny</th>
                            </tr>
                            </thead>
                            <tbody>
                                <#if forApproval??>
                                    <#list forApproval as apv>
                                        <tr>
                                            <td>${apv["className"]} (${apv["class"]})</td>
                                            <td>${apv["studentName"]}</td>
                                            <td><a href='javascript:void(0);' onclick="approveStudentClassEnrollment('${apv["student"]}','${apv["class"]}')" class="btn btn-primary" role="button">Approve</a></td>
                                            <td><a href='javascript:void(0);' onclick="denyStudentClassEnrollment('${apv["student"]}','${apv["class"]}')" class="btn btn-primary" role="button">Deny</a></td>
                                        </tr>
                                    </#list>
                                <#else>
                                <td colspan="4">No Data Available</td>
                                </#if>
                            </tbody>
                        </table>
                    </div>
                </div>
            <#elseif userType?? && 'S'==userType>
                <div class="row sm-flex-center">
                    <div class="col-sm-6">
                        <p>Enrolled Courses (Subjects)</p>
                        <div class="list">
                            <#if userClasses??>
                                <ul class="list-group">
                                    <#list userClasses as cls>
                                        <li class="list-group-item">${cls["className"]}<#if cls["_id"]??> (${cls["_id"]})</#if></li>
                                    </#list>
                                </ul>
                            </#if>
                        </div>
                    </div>
                    <div class="col-sm-6 pull-right">
                        <p>Active Topics</p>
                        <#if topics??>
                            <ul class="list-group">
                                <#list topics as t>
                                    <li class="list-group-item" onclick="window.location='/viewTopic?tid=${t["_id"]}'">(${t["classCode"]}) : ${t["topic"]}</li>
                                </#list>
                            </ul>
                        </#if>
                    </div>
                </div>
            <#else>
                <div class="row sm-flex-center">
                    <div class="col-sm-12">
                        <h1>Capstone Project: Quiz Bank</h1>
                        <p>A simple web application created using Java Spark 2.5, Freemarker, MongoDB, jQuery</p>
                    </div>
                </div>
            </#if>
        </div>

        <@t.bootstrapCoreJS />
        <script src="js/home.js"></script>

    </body>
</html>