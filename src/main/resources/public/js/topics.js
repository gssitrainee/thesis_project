var topic = new Object();
var items = new Array();

$(document).ready(function(){

    $('#txtVideoUrl').on('keydown', function(event){
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

    //loadTestDetails();
    clearTopicFields();
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
        $('#divVplayer').show();

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
        item.id = question.replace(/[^\w\s]/gi, '').replace(/\s/gi,'_').toLowerCase();
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

var clearTopicFields = function(){
    clearItemFields();

    topic = new Object();
    items = new Array();

    $('#txtTopic, #txtTopicSummary, #selClass').val('');
    $('#txtVideoUrl').val('');
    $('#divVplayer').hide();
    $('#listQuestions').empty();
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
    var _topic = $('#txtTopic').val();
    var _classCode = $('#selClass').val();

    if( (_topic && ''!=_topic) && (_classCode && ''!=_classCode) ){
        topic._id = _topic.replace(/[^\w\s]/gi, '').replace(/\s/gi,'_').toLowerCase();
        topic.classCode = _classCode;
        topic.topic = _topic;
        topic.videoLink = $('#txtVideoUrl').val();
        topic.summary = $('#txtTopicSummary').val();
        topic.items = items;
        topic.creationDate = new Date();

        console.log(JSON.stringify(topic));

        var my_data = {
            jtopic: JSON.stringify(topic)
        };

        $.post( "/saveTopic", my_data, function( msg ) {
            bootbox.alert(msg);
            clearTopicFields();
        }, "json");
    }
    else {
        bootbox.alert("Please fill up all topic fields.");
    }

};
