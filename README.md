# MongoDB Toolbox

A collection of MongoDB scripts for automating common tasks in a Docker-centric way.

## Documentation

Documentation for each subcommand:

- [load](commands/load.md)
- [save](commands/save.md)

## General Usage

Using Docker links to `mongodb` container:
```console
docker run --rm -i -t --link myserver:mongodb docker.io/panubo/mongodb-toolbox:0.0.7-1
```
This will display the usage information.

```console
docker run --rm -i -t --link myserver:mongodb docker.io/panubo/mongodb-toolbox:0.0.7-1 <subcommand>
```
To run the subcommand.

## Configuration

Use `--link <mongodb container name>:mongodb` to automatically specify the required variables.

Or alternatively specify the variables:

| Name | Description |
| --- | --- |
| `DATABASE_HOST` | IP / hostname of MongoDB server. |
| `DATABASE_PORT` | TCP Port of MongoDB service. |
| `DATABASE_USER` | Administrative user |
| `DATABASE_PASS` | Password of administrative user. |

Some subcommands require additional environment parameters or positional arguments. See the
documentation for the subcommand for more information.

## Testing

The [Makefile](Makefile) initiates a test designed to be run in a CI/CD. It starts up a [Docker-in-Docker](https://github.com/jpetazzo/dind) container and runs the tests within a temporary container which is set up and torn down upon every invocation to ensure a clean environment.
```console
make test
```

If you are developing locally and wish to run the tests outside the Docker-in-Docker container in order to gain a better visibility into the process, you can run the following command from the repository root:
```console
./test/runner.sh
```

## Status

Works, however some features are incomplete.
