$(document).ready(function(e){
    var videoLink = $('#txtVideoUrl').val();
    reloadVideo(videoLink);
});

var reloadVideo = function(youtubeId){
    if(youtubeId && 0 < youtubeId.length){
        var video_id = youtubeId.split("v=")[1];
        var youtubeUrl = "https://www.youtube.com/embed/" + video_id;
        $('#divVplayer iframe').remove();

        var iframeHTML = "<iframe id='ytplayer' type='text/html' width='560' height='315' src='" + youtubeUrl + "' frameborder='0' allowfullscreen></iframe>";

        $('#divVplayer').append(iframeHTML);
        $('#divVplayer').show();
    }
};