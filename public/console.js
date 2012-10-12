$().ready( function() {
  client = Stomp.client( "ws://localhost:8675" )

  var display_message = function( message ) {
      elem = $("#console .content")
      line = message.body
      line = line.replace("<", "&lt;")
      line = line.replace(">", "&gt;")
      if (message.headers['prompt']) {
        $("#console .prompt").html( line )
      } else {
        elem.append( line + "\n" )
      }
      $(window).scrollTop($("body").height())
      $("#console input").focus();
  }

  var send_message = function( message ) {
      var input = $("#console input").attr( "value" ) + "\n"
      $("#console .content").append( $("#console .prompt").text() )
      $("#console .content").append( input )
      $("#console input").attr( "value", "" )
      client.send( "/stomplet/console", {}, input )
      return false;
  }

  var toggle_theme = function() {
    if ($("body").hasClass("light")) {
      $("body").removeClass("light");
      $("body").addClass("dark");
    } else {
      $("body").addClass("light");
      $("body").removeClass("dark");
    }
  }

  $(window).unload( function() {
      client.disconnect() });

  $( '#input-form' ).bind( "submit", send_message );
  $( '.button' ).bind( "click", toggle_theme );

  client.connect( null, null, function() {
      client.subscribe("/stomplet/console", display_message)
  } );
} )

