require 'torquebox'
require 'torquebox-stomp'
require 'sinatra'
require 'haml'

class Sinatra::Application
  include TorqueBox::Injectors
end

helpers do
  def endpoint
    unless @endpoint
      @endpoint = fetch('stomp-endpoint')
      # Workaround for https://issues.jboss.org/browse/TORQUE-957
      if @endpoint =~ /default-host/
        @endpoint.gsub!(/default-host/, "localhost")
        @endpoint.gsub!(/\/console\/console/, "")
      elsif torquebox_3?
        @endpoint = "#{@endpoint.host}:#{@endpoint.port}"
        @endpoint.gsub!(/default-host/, "localhost")
      end
      @endpoint
    end
    @endpoint
  end

  def torquebox_3?
    TorqueBox.respond_to?(:fetch)
  end
end

get '/' do
  haml :index, :format => :html5
end

