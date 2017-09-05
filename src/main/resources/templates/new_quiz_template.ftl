<#import "masterTemplate.ftl" as t>

<!doctype HTML>
<html>
    <head>
        <@t.headerMetaTags />

        <title>Capstone: Create a new Quiz</title>

        <!-- Bootstrap core CSS -->
        <link href="css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="css/font-awesome.min.css">

        <style type="text/css">
            body {
                padding-top: 54px;
            }
            @media (min-width: 992px) {
                body {
                    padding-top: 56px;
                }
            }

            div.radio { display: inline-block; padding: 10px; margin-left: 30px; }

            div#divVideoUrlContainer { width: 73%; }
            .top-space { margin-top: 30px; }

            .right-inner-addon {
                position: relative;
            }
            .right-inner-addon input {
                padding-right: 30px;
            }
            .right-inner-addon i {
                position: absolute;
                right: 15px;
                padding: 10px 12px;
                pointer-events: none;
            }

            span.status {
                font-family: "Courier New", Georgia, Serif;
                font-style: italic;
                font-size: 0.65em;
                padding: 5px;
                border: 1px solid #ddd;
                background-color: #eee;
            }



            /* -------------------------------------- */
            /* underlined list stle                   */

            .underlined ol
            {
                counter-reset:li; /* Initiate a counter */
                margin-left:0; /* Remove the default left margin */
                padding-left:0; /* Remove the default left padding */
            }

            .underlined	ol > li
            {
                position:relative; /* Create a positioning context */
                margin:0 0 6px 2em; /* Give each list item a left margin to make room for the numbers */
                padding:4px 8px; /* Add some spacing around the content */
                list-style:none; /* Disable the normal item numbering */
                border-top:2px solid #666;
                background:#f6f6f6;
            }

            .underlined ol > li:before
            {
                content:counter(li); /* Use the counter as content */
                counter-increment:li; /* Increment the counter by 1 */
                /* Position and style the number */
                position:absolute;
                top:-2px;
                left:-2em;
                -moz-box-sizing:border-box;
                -webkit-box-sizing:border-box;
                box-sizing:border-box;
                width:2em;
                /* Some space between the number and the content in browsers that support
                generated content but not positioning it */
                margin-right:8px;
                padding:4px;
                border-top:2px solid #666;
                color:#fff;
                background:#666;
                font-weight:bold;
                font-family:"Helvetica Neue", Arial, sans-serif;
                text-align:center;
            }

            .underlined li ol,
            .underlined li ul
            {
                margin-top:6px;
            }

            .underlined ol ol li:last-child
            {
                margin-bottom:0;
            }

            .disabledbutton {
                pointer-events: none;
                opacity: 0.4;
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
                        <#--<form id="postquizform" class="form-horizontal" role="form" action="/postQuiz" method="POST">-->
                            <div class="form-group has-error has-feedback">
                                <label for="selClass" class="col-md-3 control-label">Class</label>
                                <div class="col-md-11">
                                    <select name="sel_class" id="selClass" class="form-control">
                                    <#if userClasses??>
                                        <ul class="list-group">
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
                                    <textarea class="form-control" id="txtTopicSummary" name="topicSummary" placeholder="Topic Summary" title="Enter Content Summary" cols="30" rows="10">${contents!""}</textarea>
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
                            <ol>
                                <li onclick="displayQuizForm('abc123')">Unsa ang pangalan sa File System gamit sa Linux?</li>
                                <li onclick="displayQuizForm('bdc234')">Unsa ang pangalan sa File System gamit sa Windows na latest?</li>
                                <li onclick="displayQuizForm('cde345')">Unsa ang pangalan sa File System sa karaan na Windows?</li>
                            </ol>
                        </div>
                        <div>
                            <button type="button" class="btn btn-info btn-md" data-toggle="modal" data-target="#myModal">Add Question</button>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row top-space">
                <div class="form-group">
                    <!-- Button -->
                    <div class="col-md-offset-3 col-md-11">
                        <button type="button" class="btn btn-primary btn-lg">Post Topic</button>
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

                        <div id="divBooleanChoices" class="form-group" style="display:none">
                            <div class="radio">
                                <input type="radio" id="rdbTrue" name="bChoice" value="T" />
                                <label for="rdbTrue" class="radio-inline">True</label>
                            </div>
                            <div class="radio">
                                <input type="radio" id="rdbFalse" name="bChoice" value="F" />
                                <label for="rdbFalse" class="radio-inline">False</label>
                            </div>
                        </div>

                        <div id="divTextAnswers" class="form-group" style="display:none">
                            <h5>Choices</h5>
                            <div id="divChoices">
                                <p>
                                    <input type="text" class="form-control" name="choices" class="form-control" placeholder="a.)" title="Enter Option or Choice that the student can select in answering the question." />
                                </p>
                                <p>
                                    <input type="text" class="form-control" name="choices" class="form-control" placeholder="b.)" title="Enter Option or Choice that the student can select in answering the question." />
                                </p>
                                <p>
                                    <input type="text" class="form-control" name="choices" class="form-control" placeholder="c.)" title="Enter Option or Choice that the student can select in answering the question." />
                                </p>
                                <p>
                                    <input type="text" class="form-control" name="choices" class="form-control" placeholder="d.)" title="Enter Option or Choice that the student can select in answering the question." />
                                </p>
                                <p>
                                    <input type="text" class="form-control" name="choices" class="form-control" placeholder="e.)" title="Enter Option or Choice that the student can select in answering the question." />
                                </p>
                            </div>

                            <h5>Answer(s)</h5>
                            <div id="divSingleAnswer" style="display:none">
                                <p>
                                    <input type="text" class="form-control" name="sanswer" class="form-control" placeholder="[Answer]" />
                                </p>
                            </div>
                            <div id="divMultipleAnswer" style="display:none">
                                <p>
                                    <input type="text" class="form-control" name="manswer" class="form-control" placeholder="[Answer]" />
                                </p>
                                <p>
                                    <input type="text" class="form-control" name="manswer" class="form-control" placeholder="[Answer]" />
                                </p>
                                <p>
                                    <input type="text" class="form-control" name="manswer" class="form-control" placeholder="[Answer]" />
                                </p>
                                <p>
                                    <input type="text" class="form-control" name="manswer" class="form-control" placeholder="[Answer]" />
                                </p>
                                <p>
                                    <input type="text" class="form-control" name="manswer" class="form-control" placeholder="[Answer]" />
                                </p>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-info" data-dismiss="modal">Save</button>
                        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                    </div>
                </div>

            </div>
        </div>
        <!-- End: Modal For Add Question -->

        <@t.bootstrapCoreJS />

        <script>
            var items = new Array();

            $(document).ready(function(e){
                $('#txtVideoUrl').on('keydown', function(){
                    var keyCode = (event.keyCode ? event.keyCode : event.which);
                    if (keyCode == 13) {
                        reloadVideo(this.value);
                    }
                });

                $('#selQuestionType').on('change', function(){
                    switch (this.value) {
                        case 'BOOLEAN':
                            $('#divBooleanChoices').show();
                            $('#divTextAnswers').hide();
                            $('#divSingleAnswer').hide();
                            $('#divMultipleAnswer').hide();
                            break;
                        case 'SINGLE_ANSWER':
                            $('#divBooleanChoices').hide();
                            $('#divTextAnswers').show();
                            $('#divSingleAnswer').show();
                            $('#divMultipleAnswer').hide();
                            break;
                        case 'MULTIPLE_ANSWERS':
                            $('#divBooleanChoices').hide();
                            $('#divTextAnswers').show();
                            $('#divSingleAnswer').hide();
                            $('#divMultipleAnswer').show();
                            break;
                        default:
                            $('#divBooleanChoices').hide();
                            $('#divTextAnswers').hide();
                            $('#divSingleAnswer').hide();
                            $('#divMultipleAnswer').hide();
                    }
                });
            });

            var reloadVideo = function(youtubeId){
                if(youtubeId && 0 < youtubeId.length){
                    //Cleanup
                    var video_id = youtubeId.split("v=")[1];
                    var youtubeUrl = "https://www.youtube.com/embed/" + video_id;

                    $('#divVplayer iframe').remove();

                    var iframeHTML = "<iframe id='ytplayer' type='text/html' width='560' height='315' src='" + youtubeUrl + "' frameborder='0' allowfullscreen></iframe>";
                    //https://www.youtube.com/watch?v=__y8vWaVGqk
                    //https://www.youtube.com/embed/__y8vWaVGqk
                    //https://www.youtube.com/watch?v=__y8vWaVGqk?autoplay=1&origin=http://example.com

                    $('#divVplayer').append(iframeHTML);

                }
            };

            var saveQuestion = function(){
                var question = new Object();
                //TODO: store all fields on this object, then add this object to the items array.
            };
        </script>
    </body>
</html>

