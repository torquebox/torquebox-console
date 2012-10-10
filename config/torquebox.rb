TorqueBox.configure do
  ruby do
    version "1.9"
  end

  web do
    context '/console'
    static  'public'
  end

  stomplet TorqueBoxConsole do
    route '/stomplet/console'
  end

end

