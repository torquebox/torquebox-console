$().ready( function() {
  client = Stomp.client( "ws://localhost:8675" )

  var display_message = function( message ) {
      $("#console .content").append( "\n" + message.body )
  }

  var send_message = function( message ) {
      var input = $("#console .prompt").attr( "value" ) + "\n"
      $("#console .prompt").attr( "value", "" )
      $("#console .content").append( input )
      client.send( "/stomplet/console", {}, input )
      return false;
  }

  $( '#input-form' ).bind( "submit", send_message );

  client.connect( null, null, function() {
      client.subscribe("/stomplet/console", display_message)
  } );
} )

