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
        </style>
    </head>
    <body>
        <@t.navigationDiv />

        <div class="container">
            <div class="row sm-flex-center top-space">
                <div class="col-sm-7 column-separator">
                    <div class="panel panel-info">
                        <h4>Post a Topic & Quiz</h4>
                        <div class="panel-body" style="border-right: 1px solid #eee;">
                        <#--<form id="postquizform" class="form-horizontal" role="form" action="/postQuiz" method="POST">-->
                            <div class="form-group has-error has-feedback">
                                <label for="selClass" class="col-md-3 control-label">Class</label>
                                <div class="col-md-11">
                                    <select name="sel_class" id="selClass" class="form-control">
                                    <#if userClasses??>
                                        <ul>
                                            <#list userClasses as cls>
                                                <option value="${cls["classCode"]}">${cls["className"]}</option>
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
                                <iframe id="ytplayer" type="text/html" width="560" height="315"
                                        src="https://www.youtube.com/embed/FUqZpQX8F5Y?autoplay=1&origin=http://example.com"
                                        frameborder="0"
                                        allowfullscreen></iframe>
                            </div>

                            <div class="form-group right-inner-addon">
                                <div class="col-md-11">
                                    <i class="fa fa-eye" aria-hidden="true"></i>
                                    <input type="search" class="form-control" id="txtVideoUrl" name="videolink" placeholder="https://www.youtube.com/watch?v=<YoutubeVideoId>" title="Enter valid youtube video link and press ENTER key to refresh the video." />
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
                        <h4>Post a Topic & Quiz</h4>
                        <div class="panel-body" style="border-right: 1px solid #eee;">
                            //Form for entering quiz questions and answers.
                        </div>
                    </div>
                </div>
            </div>
            <div class="row top-space">
                <div class="form-group">
                    <!-- Button -->
                    <div class="col-md-offset-3 col-md-11">
                        <input type="submit" id="btn-signup" class="btn btn-info" value="Post Quiz" />
                    </div>
                </div>
            </div>
        </div>

        <@t.bootstrapCoreJS />

        <script>
            $(document).ready(function(e){
                $('#txtVideoUrl').on('keydown', function(){
                    var keyCode = (event.keyCode ? event.keyCode : event.which);
                    if (keyCode == 13) {
                        reloadVideo(this.value);
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
        </script>
    </body>
</html>

