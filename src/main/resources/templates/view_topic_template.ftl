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
                                <ol class="list-group" type="1.">
                                    <#list items as i>
                                        <li><span>${i.question}</span>
                                            <section>
                                                <input type="hidden" value="${i.id}" />
                                                <p>
                                                    <ul>
                                                        <#if i.choiceA??>
                                                            <li>${i.choiceA}</li>
                                                        </#if>
                                                        <#if i.choiceB??>
                                                            <li>${i.choiceB}</li>
                                                        </#if>
                                                        <#if i.choiceC??>
                                                            <li>${i.choiceC}</li>
                                                        </#if>
                                                        <#if i.choiceD??>
                                                            <li>${i.choiceD}</li>
                                                        </#if>
                                                        <#if i.choiceE??>
                                                            <li>${i.choiceE}</li>
                                                        </#if>
                                                    </ul>
                                                </p>
                                                <p>
                                                    <label for="txtSAnswer"><strong>Answer:</strong></label>
                                                    <input type="text" id="txtSAnswer" name="answer" />
                                                </p>
                                            </section>
                                        </li>
                                    </#list>
                                </ol>
                            </#if>

                        </div>

                    </div>
                </div>
            </div>

        </div>

        <@t.bootstrapCoreJS />
        <script src="js/viewTopic.js"></script>
    </body>
</html>

