$(document).ready(function() {
    var pusher = new Pusher('3568c8046d9171a5f8ee');
    var channel = pusher.subscribe('test_channel');
    channel.bind('new_idea', function(data) {
      console.log( data.idea )
      var idea = 'idea_' + data.idea.id;
      $(idea).child('.title').append("<div class=\"message\">" + data.idea + "</div>");
    });
    Pusher.log = function(message) {
      if (window.console && window.console.log) window.console.log(message);
    };
    $("#message_form").submit(function(e) {
        e.preventDefault();
        $.post('/messages', $(this).serialize(), function() {
            $("#message_form input").val('');
        });
    });
});

