require './dependencies.rb'
require './console'
require 'torquebox-stomp'

use TorqueBox::Stomp::StompJavascriptClientProvider
run Sinatra::Application
