$().ready( function() {
  var client;
  if (torquebox3) {
    client = new Stomp.Client();
  } else {
    if (endpoint == null) {
      // endpoint should be set in index.haml
      // value provided by torquebox injection
      // but if for whatever reason that doesn't
      // work, we'll try this
      endpoint = "ws://localhost:8675" 
    } else { 
      alert( "Using: " + endpoint )
    }
    client = Stomp.client( endpoint )
  }

  var display_message = function( message ) {
      elem = $("#console .content")
      line = message.body
      line = line.replace("<", "&lt;")
      line = line.replace(">", "&gt;")
      if (message.headers['prompt']) {
        $("#console .prompt").html( line )
      } else {
        elem.append( ansispan(line) + "\n" )
        /*elem.append( line + "\n" )*/
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

  $(window).unload( function() { client.disconnect() });

  $( '#input-form' ).bind( "submit", send_message );
  $( '.button' ).bind( "click", toggle_theme );

  var connect_function = function() {
    client.subscribe( "/stomplet/console", display_message )
  };
  if (torquebox3) {
    client.connect( connect_function );
  } else {
    client.connect( null, null, connect_function );
  }
} )

