# A Pry-based Console for TorqueBox

TorqueBox::Console allows you to connect to a ruby runtime running inside of
the TorqueBox server, giving you a Pry interface to work with.

## Installation

    $ gem install torquebox-console

## Usage

Make sure you have a running TorqueBox server where you installed
torquebox-console, then issue the following command.

  $ tbconsole connect

This will deploy torquebox-console as an application into the running TorqueBox
server, if it hasn't already been installed, and present you with an enhanced
pry console into your TorqueBox server. Once you have connected on the command
line, and you know the torquebox-console server is working, then you can
connect with a web browser at `http://<servername>:<portnumber>/console`.

To list and connect to other running applications, use the commands:

    list_applications
    list_runtimes
    switch_application(app)
    switch_runtime(app, runtime)

The `switch_application` command is just a shortcut for
`switch_runtime(app, 'web')` since the web runtime is the most
commonly used.

The console, especially runtime switching, is still pretty
experimental so don't go doing anything crazy with it in a production
environment.
