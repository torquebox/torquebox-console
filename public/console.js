$().ready( function() {
  client = Stomp.client( "ws://localhost:8675" )

  var display_message = function( message ) {
      if (message.headers['prompt']) {
          $("#console .prompt").attr( "value", message.body )
      } else {
          $("#console .content").append( message.body )
      }
  }

  var send_message = function( message ) {
    var input = $("#console .prompt").attr( "value" ) + "\n"
    $("#console .content").append( input )
    $("#console .prompt").attr( "value", "" )
    client.send( input )
    return false;
  }

  $( '#input-form' ).bind( "submit", send_message );

  client.connect( null, null, function() {
      client.subscribe("/stomplet/console", display_message)
  } );
} )

