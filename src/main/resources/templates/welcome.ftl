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

            h4 { padding: 20px 0; }

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
                        <h4>Classes</h4>
                        <div class="list">
                            <#if userClasses??>
                                <ul class="list-group">
                                    <#list userClasses as cls>
                                        <li class="list-group-item"><a href="/course?code=${cls["classCode"]}">${cls["className"]}<#if cls["classCode"]??> (${cls["classCode"]})</#if></a></li>
                                    </#list>
                                </ul>
                            </#if>
                        </div>
                    </div>
                    <div class="col-sm-6 pull-right">
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
                                        <td><a href="/approveEnrollment?cc=${apv["class"]}&su=${apv["student"]}" class="btn btn-primary" role="button">OK</a></td>
                                        <td><a href="/disapproveEnrollment?cc=${apv["class"]}&su=${apv["student"]}" class="btn btn-secondary" role="button">X</a></td>
                                    </tr>
                                    </#list>
                                <#else>
                                <td colspan="4">No Data Available</td>
                                </#if>
                            </tbody>
                        </table>
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
