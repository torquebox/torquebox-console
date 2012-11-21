# A Pry-based Console for TorqueBox

TorqueBox::Console allows you to connect to a ruby runtime running inside of
the TorqueBox server, giving you a Pry interface to work with.

## Installation

    gem install torquebox-console

## Usage

First deploy to a TorqueBox server.

    tbconsole deploy --dir=/some/path

Then you can connect with a web browser at
`http://<servername>:<portnumber>/console`, or on the command line with
`tbconsole connect`.

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