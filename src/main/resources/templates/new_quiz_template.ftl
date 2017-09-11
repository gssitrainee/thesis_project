<#import "masterTemplate.ftl" as t>

<!doctype HTML>
<html>
    <head>
        <@t.headerMetaTags />

        <title>Capstone: Create a new Quiz</title>

        <link href="css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="css/font-awesome.min.css">
        <link rel="stylesheet" href="css/topics.css">
    </head>
    <body>
        <@t.navigationDiv />

        <div class="container">
            <div class="row sm-flex-center top-space">
                <div class="col-sm-7 column-separator">
                    <div class="panel panel-info">
                        <h4>Topic</h4>
                        <div class="panel-body" style="border-right: 1px solid #eee;">
                        <#--<form id="postquizform" class="form-horizontal" role="form" action="/postQuiz" method="POST">-->
                            <div class="form-group has-error has-feedback">
                                <label for="selClass" class="col-md-3 control-label">Class</label>
                                <div class="col-md-11">
                                    <select name="sel_class" id="selClass" class="form-control">
                                    <#if userClasses??>
                                        <ul class="list-group">
                                            <option class="list-group-item" value="">Select a Class</option>
                                            <#list userClasses as cls>
                                                <option class="list-group-item" value="${cls["_id"]}">${cls["className"]}</option>
                                            </#list>
                                        </ul>
                                    <#else>
                                        <option value="N_A">No Class Available</option>
                                    </#if>
                                    </select>
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="txtTitle" class="col-md-3 control-label">Topic</label>
                                <div class="col-md-11">
                                    <input type="text" class="form-control" id="txtTopic" name="subject" size="120" value="${subject!""}"><br />
                                </div>
                            </div>

                            <div id="divVplayer" class="form-group">
                                <iframe></iframe>
                            </div>

                            <div class="form-group right-inner-addon">
                                <div class="col-md-11">
                                    <i class="fa fa-eye" aria-hidden="true"></i>
                                    <input type="search" class="form-control" id="txtVideoUrl" name="videolink" placeholder="https://www.youtube.com/watch?v=<YoutubeVideoId>" title="Enter valid youtube video link and press ENTER key to refresh the video." value="https://www.youtube.com/watch?v=__y8vWaVGqk" />
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="txtTopicSummary" class="col-md-3 control-label">Summary</label>
                                <div class="col-md-11">
                                    <textarea class="form-control" id="txtTopicSummary" name="summary" placeholder="Topic Summary" title="Enter Content Summary" cols="30" rows="10">${contents!""}</textarea>
                                </div>
                            </div>
                        <#--</form>-->
                        </div>
                    </div>
                </div>
                <div class="col-sm-5 pull-right">
                    <div class="panel panel-info">
                        <h4>Questions</h4>
                        <div class="panel-body underlined" style="border-right: 1px solid #eee;">
                            <ol id="listQuestions">
                            </ol>
                        </div>
                        <div>
                            <button type="button" class="btn btn-info btn-md" onclick="createNewItem()">Add Question</button>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row top-space">
                <div class="form-group">
                    <!-- Button -->
                    <div class="col-md-offset-3 col-md-11">
                        <button type="button" class="btn btn-primary btn-lg" onclick="postTopic()">Post Topic</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal for Add Question -->
        <div class="modal fade" id="myModal" role="dialog">
            <div class="modal-dialog">

                <!-- Modal content-->
                <div class="modal-content">
                    <div class="modal-header">
                        <h4 class="modal-title">Question</h4>
                        <button type="button" class="close" data-dismiss="modal">&times;</button>
                    </div>
                    <div class="modal-body">
                        <input type="hidden" id="hndId" name="id" value="" />
                        <div class="form-group">
                            <label for="txtQuestion" class="control-label">Problem:</label>
                            <div>
                                <#--<input type="text" id="txtQuestion" class="form-control" name="question" placeholder="Question" title="Enter Question (Sentence)" />-->
                                <textarea class="form-control" id="txtQuestion" name="question" placeholder="Question" title="Enter Question (Sentence)"></textarea>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="selQuestionType" class="control-label">Answer Type:</label>
                            <div>
                                <select name="questionType" id="selQuestionType" class="form-control">
                                    <option value="">Select Answer Type</option>
                                    <option value="BOOLEAN">Boolean</option>
                                    <option value="SINGLE_ANSWER">Single Answer</option>
                                    <option value="MULTIPLE_ANSWERS">Multiple Answers</option>
                                </select>
                            </div>
                        </div>

                        <div id="divBooleanChoices" class="form-group">
                            <div class="radio">
                                <input type="radio" id="rdbTrue" name="bChoice" value="T" />
                                <label for="rdbTrue" class="radio-inline">True</label>
                            </div>
                            <div class="radio">
                                <input type="radio" id="rdbFalse" name="bChoice" value="F" />
                                <label for="rdbFalse" class="radio-inline">False</label>
                            </div>
                        </div>

                        <div id="divTextAnswers" class="form-group">
                            <h5>Choices</h5>
                            <div id="divChoices">
                                <p>
                                    <input type="text" class="form-control" id="txtChoiceA" name="choices" class="form-control" placeholder="a.)" title="Enter Option or Choice that the student can select in answering the question." />
                                </p>
                                <p>
                                    <input type="text" class="form-control" id="txtChoiceB" name="choices" class="form-control" placeholder="b.)" title="Enter Option or Choice that the student can select in answering the question." />
                                </p>
                                <p>
                                    <input type="text" class="form-control" id="txtChoiceC" name="choices" class="form-control" placeholder="c.)" title="Enter Option or Choice that the student can select in answering the question." />
                                </p>
                                <p>
                                    <input type="text" class="form-control" id="txtChoiceD" name="choices" class="form-control" placeholder="d.)" title="Enter Option or Choice that the student can select in answering the question." />
                                </p>
                                <p>
                                    <input type="text" class="form-control" id="txtChoiceE" name="choices" class="form-control" placeholder="e.)" title="Enter Option or Choice that the student can select in answering the question." />
                                </p>
                            </div>

                            <h5>Answer(s)</h5>
                            <div id="divSingleAnswer">
                                <p>
                                    <input type="text" class="form-control" id="txtSingleAnswer" name="sanswer" class="form-control" placeholder="[Answer]" />
                                </p>
                            </div>
                            <div id="divMultipleAnswer">
                                <p>
                                    <input type="text" class="form-control" id="txtAnswerA" name="manswer" class="form-control" placeholder="[Answer]" />
                                </p>
                                <p>
                                    <input type="text" class="form-control" id="txtAnswerB" name="manswer" class="form-control" placeholder="[Answer]" />
                                </p>
                                <p>
                                    <input type="text" class="form-control" id="txtAnswerC" name="manswer" class="form-control" placeholder="[Answer]" />
                                </p>
                                <p>
                                    <input type="text" class="form-control" id="txtAnswerD" name="manswer" class="form-control" placeholder="[Answer]" />
                                </p>
                                <p>
                                    <input type="text" class="form-control" id="txtAnswerE" name="manswer" class="form-control" placeholder="[Answer]" />
                                </p>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-info" data-dismiss="modal" onclick="saveQuestion()">Save</button>
                        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                        <button type="button" class="btn btn-warning" data-dismiss="modal" onclick="removeQuestion()">Remove</button>
                    </div>
                </div>

            </div>
        </div>
        <!-- End: Modal For Add Question -->

        <@t.bootstrapCoreJS />
        <script src="js/topics.js"></script>

    </body>
</html>

