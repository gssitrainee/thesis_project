<#import "masterTemplate.ftl" as t>

<!doctype HTML>
<html>
    <head>
        <@t.headerMetaTags />
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

            h4 { padding: 20px 0; }

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
        <@t.navigationDiv />

        <div class="container">
            <div class="row sm-flex-center">
                <div class="col-sm-6">
                    <div class="panel panel-info">
                        <h4>Course Details</h4>
                        <div class="panel-body" >
                            <form id="saveclassform" class="form-horizontal" role="form" action="/saveCourseDetails" method="POST">

                                <div class="form-group has-error has-feedback">
                                    <label for="txtClassCode" class="col-md-6 control-label">Class Code</label>
                                    <div class="col-md-9">
                                        <input type="text" id="txtClassCode" class="form-control" name="classCode" value="${classCode!""}" placeholder="Class or Course Code" title="Enter Class or Course Code" />
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label for="txtClassName" class="col-md-6 control-label">Class Name</label>
                                    <div class="col-md-9">
                                        <input type="text" class="form-control" id="txtClassName" name="className" value="${className!""}" placeholder="Class or Course Name" title="Enter Class or Course Name" />
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label for="txtClassDescription" class="col-md-6 control-label">Class Description</label>
                                    <div class="col-md-9">
                                        <textarea class="form-control" id="txtClassDescription" name="classDescription"  placeholder="Class or Course Description" title="Enter Class or Course Description" cols="30" rows="3">${classDescription!""}</textarea>
                                    </div>
                                </div>

                                <div class="form-group">
                                    <!-- Button -->
                                    <div class="col-md-offset-3 col-md-9">
                                        <input type="submit" id="btn-signup" class="btn btn-info" value="Save Class Details" />
                                    </div>
                                </div>

                            </form>
                        </div>
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
        </div>

        <@t.bootstrapCoreJS />
    </body>
</html>

