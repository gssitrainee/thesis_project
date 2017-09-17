<#import "masterTemplate.ftl" as t>

<!DOCTYPE html>
<html>
    <head>
        <@t.headerMetaTags />
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

            div#divMainContainer { padding: 25px; }
            h4 { padding: 20px 0; }

            .label {text-align: right}
            .error {color: red}
        </style>
    </head>
    <body>
        <!-- Navigation -->
        <@t.navigationDiv />

        <!-- Page Content -->
        <div id="divMainContainer" class="container">
            <#if 'T'==userType>
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
                                    <li class="list-group-item" onclick="window.location='/viewTopic?tid=${t["_id"]}'">(${t["classCode"]}) : ${t["topic"]} <#if t["taken"]?? && t["taken"]><strong> - Taken</strong></#if></li>
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


        <script>
            $(document).ready(function(){
                //Put initializations here
            });

            var reloadEnrollmentList = function(){
                var my_url = "/courseRegistrations";
                $.getJSON(my_url, function(json) {
                    $('table#tblEnrollmentForApproval tbody').empty();
                    $.each(json, function(idx, doc) {
                        $('table#tblEnrollmentForApproval tbody').append("<tr><td>" + doc.className + " (" + doc.class + ")</td><td>" + doc.studentName + "</td><td><a href='javascript:void(0);' onclick=\"approveStudentClassEnrollment('" + doc.student + "','" + doc.class + "')\" class=\"btn btn-primary\" role=\"button\">Approve</a></td><td><a href='javascript:void(0);' onclick=\"denyStudentClassEnrollment('" + doc.student + "','" + doc.class + "')\" class=\"btn btn-primary\" role=\"button\">Deny</a></td></tr>");
                    });
                });
            }

            var approveStudentClassEnrollment = function(student, classCode){
                var my_url = "/approveEnrollment?cc=" + classCode + "&su=" + student;
                $.post(my_url, function(msg){
                    bootbox.alert(msg);
                    reloadEnrollmentList();
                });
            };

            var denyStudentClassEnrollment = function(student, classCode){
                var my_url = "/denyEnrollment?cc=" + classCode + "&su=" + student;
                $.post(my_url, function(msg){
                    bootbox.alert(msg);
                    reloadEnrollmentList();
                });
            };
        </script>

    </body>
</html>
