# MongoDB Toolbox

A collection of MongoDB scripts for automating common tasks in a Docker-centric way.

## Documentation

Documentation for each subcommand:

- [load](commands/load.md)
- [save](commands/save.md)

## General Usage

Using Docker links to `mongodb` container:

```
docker run --rm -i -t --link myserver:mongodb docker.io/panubo/mongodb-toolbox:0.0.4
```

This will display the usage information.

```
docker run --rm -i -t --link myserver:mongodb docker.io/panubo/mongodb-toolbox:0.0.4 <subcommand>
```

To run the subcommand.

## Configuration

Use `--link <mongodb container name>:mongodb` to automatically specify the required variables.

Or alternatively specify the variables:

- `DATABASE_HOST` = IP / hostname of MongoDB server.
- `DATABASE_PORT` = TCP Port of MongoDB service.
- `DATABASE_USER` = Administrative user
- `DATABASE_PASS` = Password of administrative user.

Some subcommands require additional environment parameters or positional arguments. See the
documentation for the subcommand for more information.

## Status

Works, however some features are incomplete.
