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

            .top-space { margin-top: 30px; }

            .column-separator { border-right: 1px solid #eee; }
            input[type='text'] { width: 91.5%; }
            textarea { width: 91.5%; }

            span.status {
                font-family: "Courier New", Georgia, Serif;
                font-style: italic;
                font-size: 0.65em;
                padding: 5px;
                border: 1px solid #ddd;
                background-color: #eee;
            }

            span.details, p.details { margin-left: 10px; }
        </style>
    </head>
    <body>
        <@t.navigationDiv />

        <div class="container">
            <div class="row sm-flex-center top-space">
                <div class="col-sm-4 column-separator">
                    <div class="panel panel-info">
                        <h4>Course Details</h4>
                        <div class="panel-body" >
                            <div class="form-group has-error has-feedback">
                                <label class="control-label"><b>Class Code:</b><span class="details">${classCode!""}</span></label>
                            </div>

                            <div class="form-group">
                                <label class="control-label"><b>Class Name:</b><span class="details">${className!""}</span></label>
                            </div>

                            <div class="form-group">
                                <label class="control-label"><b>Class Description:</b><p class="details">${classDescription!""}</p></label>
                            </div>

                            <div class="form-group">
                                <!-- Button -->
                                <div class="col-md-offset-3 col-md-9">
                                    <input type="submit" id="btn-signup" class="btn btn-info" data-toggle="modal" data-target="#myModal" value="Course Details" />
                                </div>
                            </div>
                        </div>
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

            <hr />

            <div class="row top-space">
                <div class="col-sm-12">
                    <h4>Class List</h4>
                    <table id="tblClassList" class="table table-hover">
                        <thead>
                        <tr>
                            <th>First Name</th>
                            <th>Last Name</th>
                            <th>Email Address</th>
                            <th>Score</th>
                        </tr>
                        </thead>
                        <tbody>
                        <#if classList??>
                            <#list classList as student>
                            <tr>
                                <td>${student["firstName"]}</td>
                                <td>${student["lastName"]}</td>
                                <td>${student["email"]}</td>
                                <td>N/A</td>
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

        <!-- Modal for Add Question -->
        <div class="modal fade" id="myModal" role="dialog">
            <div class="modal-dialog">

                <!-- Modal content-->
                <div class="modal-content">
                    <div class="modal-header">
                        <h4 class="modal-title">Course Details</h4>
                        <button type="button" class="close" data-dismiss="modal">&times;</button>
                    </div>
                    <div class="modal-body">
                        <div class="form-group has-error has-feedback">
                            <label for="txtClassCode" class="control-label">Class Code</label>
                            <div>
                                <input type="text" id="txtClassCode" class="form-control" name="classCode" value="${classCode!""}" placeholder="Class or Course Code" title="Enter Class or Course Code" />
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="txtClassName" class="control-label">Class Name</label>
                            <div>
                                <input type="text" class="form-control" id="txtClassName" name="className" value="${className!""}" placeholder="Class or Course Name" title="Enter Class or Course Name" />
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="txtClassDescription" class="control-label">Class Description</label>
                            <div>
                                <textarea class="form-control" id="txtClassDescription" name="classDescription" placeholder="Class or Course Description" title="Enter Class or Course Description" cols="30" rows="3" style="width: 91.5%">${classDescription!""}</textarea>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-info" data-dismiss="modal" onclick="updateCourseDetails()">Save</button>
                        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                    </div>
                </div>

            </div>
        </div>
        <!-- End: Modal For Add Question -->

        <@t.bootstrapCoreJS />
        <script src="js/course.js"></script>

    </body>
</html>

