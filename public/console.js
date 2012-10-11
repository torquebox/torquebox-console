$().ready( function() {
  client = Stomp.client( "ws://localhost:8675" )

  var display_message = function( message ) {
      elem = $("#console .content")
      line = message.body
      line = line.replace("<", "&lt;")
      line = line.replace(">", "&gt;")
      elem.append( "\n" + line )
      $(window).scrollTop($("body").height())
      $("#console .prompt").focus();
  }

  var send_message = function( message ) {
      var input = $("#console .prompt").attr( "value" ) + "\n"
      $("#console .prompt").attr( "value", "" )
      $("#console .content").append( input )
      client.send( "/stomplet/console", {}, input )
      return false;
  }

  $(window).unload( function() {
      client.disconnect() });

  $( '#input-form' ).bind( "submit", send_message );

  client.connect( null, null, function() {
      client.subscribe("/stomplet/console", display_message)
  } );

  $("#console .prompt").focus();
} )

