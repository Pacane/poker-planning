PokerPlanning
=============
[![Build Status](https://drone.io/github.com/ArcBees/poker-planning/status.png)](https://drone.io/github.com/ArcBees/poker-planning/latest)

##Getting Started
To launch the project you first have to create a file named `config.yaml` to setup the hostname and a port to listen to.

On linux systems do:
(In both sub-projects (client/web and server)

`touch config.yaml`

And create the following entries for local development for client-side:

```
hostname: localhost
port: whateverYouWant
restPort: somethingElse
```

And create the following entries for local development for server-side:

```
hostname: localhost
port: whateverYouWant
restPort: somethingElse
jira.authorizationHeader: authenticationHeaderString)
```

See [this](http://en.wikipedia.org/wiki/Basic_access_authentication#Client_side) for `jira.authorizationHeader`.

Use whatever port you'd like (e.g.: 4040) and use it on both projects

This is what I use for developing on client-side:

```
hostname: localhost
port: 4040
restPort: 3010
```

This is what I use for developing on server-side:

```
hostname: localhost
port: 4040
restPort: 3010
jira.authorizationHeader: Basic dXNlcm5hbWU6cGFzc3dvcmQ=
```

Then to launch the server, cd into the server directory and type `dart main.dart`

if you want the checked mode type `dart -c main.dart`

The client must be launched with another port number (e.g.: not 4040)
In another terminal you can launch the client with the following command : `pub serve --port=<another port>`

###Notes
Don't forget to `pub upgrade` in each project (client, server) to fetch the necessary packages

## Want to see a [live demo](http://pokerplanning.stacktrace.ca)?

##Thanks to
[![Arcbees.com](http://i.imgur.com/HDf1qfq.png)](http://arcbees.com)

[![IntelliJ](https://lh6.googleusercontent.com/--QIIJfKrjSk/UJJ6X-UohII/AAAAAAAAAVM/cOW7EjnH778/s800/banner_IDEA.png)](http://www.jetbrains.com/idea/index.html)
