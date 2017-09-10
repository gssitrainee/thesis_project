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
<#--                                <li onclick="displayItemDetails('abc123')">Unsa ang pangalan sa File System gamit sa Linux?</li>
                                <li onclick="displayItemDetails('bdc234')">Unsa ang pangalan sa File System gamit sa Windows na latest?</li>
                                <li onclick="displayItemDetails('cde345')">Unsa ang pangalan sa File System sa karaan na Windows?</li>-->
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

        <script>
            var topic = new Object();
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

                loadTestDetails();
                refreshAnswerFieldsByType('init');
            });

            var loadTestDetails = function(){
                $('#txtTopic').val('Test Driven Development vs Behaviour Driven Development');
                $('#txtVideoUrl').val('https://www.youtube.com/watch?v=4QFYTQy47yA');
                $('#txtTopicSummary').val('I tried to hang this shelf on this wall. I made a mess of it. The shelf was wonky. Could Test Driven Development - or even Behaviour Driven Development - have saved the day Shelving ----- A couple of episodes ago, I went through the process of hanging a shelf in what looked suspiciously like a Waterfall process: I did all of the measuring all of the transferring all of the drilling popped in all of the wall plugs and brute-forced the screws in. Alas, the end result was not good: the shelf was not level. But it got me thinking. Could tests have saved the day Is it possible to hang a shelf in a test-driven way Is it possible to hang a shelf in a behaviour-driven way I think we should find out. Test Driven Development (TDD) ---- Here\'s me hanging a shelf in my waterfall-like style. Let\'s stop it... there. Here\'s an opportunity for a test: I could come back at any time and check that the line really is level. That could be the first unit test. More marking and measuring. Stop there. Lots of opportunities for unit tests here: one for each of these measurements. What happened next  Oh yes... I drilled all the holes. I popped in all the wall plugs. Stop. This is certainly a point where the unit tests could - and should - be performed. But it\'s actually a few steps too late. I\'ve done far too much work between tests. Lets rewind a bit. Drill one hole (only). And perform the  "unit  tests" to ensure the hole went in in the right place. If the test fails -  if the hole has gone in the wrong place - now\'s the time to fix it: there\'s no point  in continuing until all the tests pass. Once the tests are passing, we can move on. Drill another hole. Run the tests. Correct as necessary. And so on until we have all four holes drilled - and tested. In with the four plugs. No harm in repeating the "unit tests"... but it\'s most likely that all would pass. And we\'re now in a position to finish the job. In go the screws. Unfortunately, it\'s no longer trivial to run our unit tests. But there is another test we can run: we can check for level. And given that we\'ve had "green lights" up to this point, the chances are that this test will pass too. And it does. The shelf is perfectly flat. Behaviour Driven Development (BDD) --- So much for Test Driven Development; what about Behaviour Driven Development A shelf is a bit passive. It doesn\'t have have much in the way of behaviours. But if we are generous with our definitions, we could say that a desirable behaviour is that anything that are put on it should not slide off. Or put it another way, the shelf should be level. It can be argued, then, that testing the shelf for level is not only a unit test; it\'s also a behavioural test. In the sequence we\'ve been through, this "behavioural  test" was the last thing that we did. AFTER all the work had been done. The very opposite of "behaviour driven". Is behaviour driven development even possible in this case Turns out that the method my dad used to hang a shelf looks a lot like a behaviour-driven process: First step is marking the centre of the shelf. We could have a test for that - to verify that the mark really is in the centre of the shelf. That would be a unit test. (It\'s the first and last time we\'ll come across a unit test in the sequence.) Moving on... Check for level. That\'s the behavioural test. There it is again. This time it fails. Again, no point in continuing until "all the tests are passing". A quick tap with a mallet. Run the tests again  - this time passing. Which means we can move on. There\'s the behavioural test again. And again one final time. Success! --- Would you believe it: It is possible to hang a shelf in a test-driven development way. AND its also possible to hang a shelf in a behaviour-driven way.');
                reloadVideo('https://www.youtube.com/watch?v=4QFYTQy47yA');

                $('#txtQuestion').val('What does TDD stands for?');
                $('#selQuestionType').val('SINGLE_ANSWER');
                $('#txtChoiceA').val('Test Driven Deficiency');
                $('#txtChoiceB').val('Test Driven Development');
                $('#txtChoiceC').val('Test Deficiency Development');
                $('#txtChoiceD').val('Test Drive Development');
                $('#txtChoiceE').val('Non of the Above');

                $('#txtSingleAnswer').val('Test Driven Development');
            }


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
                var id = $('#hndId').val();

                var index = -1;
                var item = null;
                if(id && ''!=id){
                    $.each( items, function( idx, obj ) {
                        if(id == obj.id){
                            item = obj;
                            index = idx;
                            return false;
                        }
                    });
                }
                else{
                    item = new Object();
                }


                var question = $('#txtQuestion').val();
                var qType = $('#selQuestionType').val();

                var choiceA = $('#txtChoiceA').val();
                var choiceB = $('#txtChoiceB').val();
                var choiceC = $('#txtChoiceC').val();
                var choiceD = $('#txtChoiceD').val();
                var choiceE = $('#txtChoiceE').val();

                var booleanValue = $( 'input[name=bChoice]:checked' ).val();
                var singleAnswer = $('#txtSingleAnswer').val();
                var answerA = $('#txtAnswerA').val();
                var answerB = $('#txtAnswerB').val();
                var answerC = $('#txtAnswerC').val();
                var answerD = $('#txtAnswerD').val();
                var answerE = $('#txtAnswerE').val();

                if(question){
                    item.id = question.replace(/[^\w\s]/gi, '').replace(/\s/gi,'_').toLowerCase()
                    item.question = question;
                }

                if(qType) item.answer_type = qType;

                if(choiceA) item.choiceA = choiceA;
                if(choiceB) item.choiceB = choiceB;
                if(choiceC) item.choiceC = choiceC;
                if(choiceD) item.choiceD = choiceD;
                if(choiceE) item.choiceE = choiceE;

                if(booleanValue) item.booleanValue = booleanValue;
                if(singleAnswer && ''!=singleAnswer.trim()) item.singleAnswer = singleAnswer;
                if(answerA && ''!=answerA.trim()) item.answerA = answerA;
                if(answerB && ''!=answerB.trim()) item.answerB = answerB;
                if(answerC && ''!=answerC.trim()) item.answerC = answerC;
                if(answerD && ''!=answerD.trim()) item.answerD = answerD;
                if(answerE && ''!=answerE.trim()) item.answerE = answerE;

                bootbox.alert("Item Successfully Saved!");
                console.log(JSON.stringify(item))

                if(0 <= index)
                    items[index] = item;
                else
                    items.push(item);

                clearItemFields();
                reloadItemList();
            };

            var removeQuestion = function(){
                var message = "This will be permanently removed. Do you want to proceed?";
                bootbox.confirm(message, function(result){
                    if(result){
                        var id = $('#hndId').val();
                        var index = -1;
                        if(id && ''!=id){
                            $.each( items, function( idx, obj ) {
                                if(id == obj.id){
                                    index = idx;
                                    return false;
                                }
                            });
                            items.splice(index, 1);
                            reloadItemList();
                        }
                    }
                });
            };

            var findItem = function(id){
                var item = null;
                $.each( items, function( idx, obj ) {
                    if(id == obj.id){
                        item = obj;
                        return false;
                    }
                });
                return item;
            }

            var createNewItem = function(){
                clearItemFields();
                $('#myModal').modal('show');
                refreshAnswerFieldsByType('init');
            };

            var displayItemDetails = function(id){
                var item = findItem(id);
                if(item){
                    $('#hndId').val(item.id);
                    $('#txtQuestion').val(item.question);
                    $('#selQuestionType').val(item.answer_type);
                    $('#txtChoiceA').val(item.choiceA);
                    $('#txtChoiceB').val(item.choiceB);
                    $('#txtChoiceC').val(item.choiceC);
                    $('#txtChoiceD').val(item.choiceD);
                    $('#txtChoiceE').val(item.choiceE);

                    $("input[name=bChoice][value='" + item.booleanValue + "']").prop("checked",true);

                    $('#txtSingleAnswer').val(item.singleAnswer);
                    $('#txtAnswerA').val(item.answerA);
                    $('#txtAnswerB').val(item.answerB);
                    $('#txtAnswerC').val(item.answerC);
                    $('#txtAnswerD').val(item.answerD);
                    $('#txtAnswerE').val(item.answerE);

                    $('#myModal').modal('show');

                    refreshAnswerFieldsByType(item.answer_type);
                }
            };

            var clearItemFields = function(){
                $('#hndId').val("");
                $('#txtQuestion').val("");
                $('#selQuestionType').val("");
                $('#txtChoiceA').val("");
                $('#txtChoiceB').val("");
                $('#txtChoiceC').val("");
                $('#txtChoiceD').val("");
                $('#txtChoiceE').val("");

                $("input[name=bChoice]").prop("checked",false);

                $('#txtSingleAnswer').val("");
                $('#txtAnswerA').val("");
                $('#txtAnswerB').val("");
                $('#txtAnswerC').val("");
                $('#txtAnswerD').val("");
                $('#txtAnswerE').val("");
            };

            var reloadItemList = function(){
                $('#listQuestions').empty();
                $.each( items, function( key, item ) {
                    $('#listQuestions').append("<li onclick=\"displayItemDetails('" + item.id +"')\">" + item.question + "</li>")
                });
            };

            var refreshAnswerFieldsByType = function(answerType){
                console.log("answerType: " + answerType);

                switch (answerType) {
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
            }

            var postTopic = function(){
                topic.class = $('#selClass').val();
                topic.topic = $('#txtTopic').val();
                topic.videolink = $('#txtVideoUrl').val();
                topic.summary = $('#txtTopicSummary').val();
                topic.items = items;

                console.log(JSON.stringify(topic));

                //TODO submit via ajax post()
            };
        </script>
    </body>
</html>

