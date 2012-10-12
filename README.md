# A Pry-based Console for TorqueBox

TorqueBox::Console allows you to connect to a ruby runtime running inside of
the TorqueBox server, giving you a Pry interface to work with.

## Installation

    gem install torquebox-console

## Usage

First deploy to a TorqueBox server.

    tbconsole deploy

Then you can connect with a web browser at
`http://<servername>:<portnumber>/console`, or on the command line with
`tbconsole connect`.
