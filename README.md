PokerPlanning
=============
[![Build Status](https://drone.io/github.com/ArcBees/poker-planning/status.png)](https://drone.io/github.com/ArcBees/poker-planning/latest)

##Getting Started

### Config files
To launch the project you first need a file named `config.yaml` to setup the hostname and a port to listen to (in both client and server).
A sample is available under `config.yaml.sample`. Simply rename it to `config.yaml`.

It needs the following entries for client-side:

```
hostname: server-ip-or-hostname
port: server-port
restPort: server-restPort
```

And the following entries for server-side:

```
hostname: ip-to-listen-on (probably localhost or 0.0.0.0)
port: port-to-listen-on
restPort: restPort-to-listen-on
jira.authorizationHeader: authenticationHeaderString
```

See [this](http://en.wikipedia.org/wiki/Basic_access_authentication#Client_side) for `jira.authorizationHeader`.

Use whatever port you'd like (e.g.: 4040) and use it on both projects

###Launching the server
To launch the server, cd into the server directory and type `dart main.dart`

If you want the checked mode type `dart -c main.dart`

The client must be launched with another port number (e.g.: not 4040)
In another terminal you can launch the client with the following command : `pub serve --port=<another port>`

###Notes
Don't forget to `pub upgrade` in each project (client, server) to fetch the necessary packages

##Thanks to
[![Arcbees.com](http://i.imgur.com/HDf1qfq.png)](http://arcbees.com)

[![IntelliJ](https://lh6.googleusercontent.com/--QIIJfKrjSk/UJJ6X-UohII/AAAAAAAAAVM/cOW7EjnH778/s800/banner_IDEA.png)](http://www.jetbrains.com/idea/index.html)
