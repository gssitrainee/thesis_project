<#import "masterTemplate.ftl" as t>

<!doctype HTML>
<html>
    <head>
        <@t.headerMetaTags />

        <title>Capstone: Create a new Quiz</title>

        <link href="css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="css/font-awesome.min.css">
        <link rel="stylesheet" href="css/topics.css">

        <style>
            input[type='radio'], input[type='checkbox'] {
                margin-right: 10px;
            }
        </style>
    </head>
    <body>
        <@t.navigationDiv />

        <div class="container">
            <div class="row sm-flex-center top-space">
                <div class="col-sm-7 column-separator">
                    <div class="panel panel-info">
                        <h4>Topic</h4>
                        <div class="panel-body" style="border-right: 1px solid #eee;">
                            <input type="hidden" id="hndTopicId" name="topicId" value="${topicId}" />
                            <input type="hidden" id="hndCourseCode" name="courseCode" value="${courseCode}" />
                            <input type="hidden" id="hndStudent" name="student" value="${student}" />
                            <input type="hidden" id="hndStudentName" name="studentName" value="${studentName}" />

                            <div class="form-group has-error has-feedback">
                                <label for="txtClass" class="col-md-3 control-label">Course</label>
                                <div class="col-md-11">
                                    <input type="text" id="txtClass" class="form-control" value='${course!""}' readonly />
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="txtTitle" class="col-md-3 control-label">Topic</label>
                                <div class="col-md-11">
                                    <input type="text" class="form-control" id="txtTopic" name="subject" size="120" value='${topic!""}'><br />
                                </div>
                            </div>

                            <div id="divVplayer" class="form-group">
                                <iframe></iframe>
                            </div>

                            <div class="form-group right-inner-addon">
                                <div class="col-md-11">
                                    <i class="fa fa-eye" aria-hidden="true"></i>
                                    <input type="search" class="form-control" id="txtVideoUrl" name="videolink" placeholder="https://www.youtube.com/watch?v=<YoutubeVideoId>" title="Enter valid youtube video link and press ENTER key to refresh the video." value='${videoLink!""}' />
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="txtTopicSummary" class="col-md-3 control-label">Summary</label>
                                <div class="col-md-11">
                                    <textarea class="form-control" id="txtTopicSummary" name="summary" placeholder="Topic Summary" title="Enter Content Summary" cols="30" rows="10">${summary!""}</textarea>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-sm-5 pull-right">
                    <div class="panel panel-info">
                        <h4>Questions</h4>
                        <div class="panel-body underlined" style="border-right: 1px solid #eee;">
                            <#if items??>
                                <ol id="lstQuestions" class="list-group" type="1.">
                                    <#list items as i>
                                        <li>
                                            <span>${i.question}</span>
                                            <input type="hidden" class="itemId" value="${i.id}" />
                                            <input type="hidden" class="answerType" value="${i.answer_type}" />
                                            <section>
                                                <p>
                                                    <#if i.answer_type?? && 'SINGLE_ANSWER'==i.answer_type>
                                                        <ul style="list-style: none;">
                                                            <#if i.choices??>
                                                                <#list i.choices as c>
                                                                    <li><label><input type="radio" name="${i.id}" value="${c}">${c}</label></li>
                                                                </#list>
                                                            </#if>
                                                        </ul>
                                                    <#elseif i.answer_type?? && 'MULTIPLE_ANSWERS'==i.answer_type>
                                                        <ul style="list-style: none;">
                                                            <#if i.answers??>
                                                                <#list i.choices as c>
                                                                    <li><label><input type="checkbox" name="${i.id}" value="${c}">${c}</label></li>
                                                                </#list>
                                                            </#if>
                                                        </ul>
                                                    <#elseif i.answer_type?? && 'BOOLEAN'==i.answer_type>
                                                        <ul style="list-style: none;">
                                                            <#if i.choices??>
                                                                <#list i.choices as c>
                                                                    <li><label><input type="radio" name="${i.id}" value="${c}">${c}</label></li>
                                                                </#list>
                                                            </#if>
                                                        </ul>
                                                    </#if>
                                                </p>
                                            </section>
                                        </li>
                                    </#list>
                                </ol>
                            </#if>

                        </div>

                    </div>
                </div>

                <div class="row top-space">
                    <div class="form-group">
                        <!-- Button -->
                        <div class="col-md-offset-3 col-md-11">
                            <button type="button" class="btn btn-primary btn-lg" onclick="submitTopicQuiz()">Submit Answers</button>
                        </div>
                    </div>
                </div>

            </div>

        </div>

        <@t.bootstrapCoreJS />
        <script src="js/viewTopic.js"></script>
    </body>
</html>

