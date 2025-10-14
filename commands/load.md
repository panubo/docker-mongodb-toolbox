# Load Database

The `load` command restores a database from a backup. It can restore a single database or all databases from the latest backup taken.

The command supports restoring from local files, as well as from S3 and Google Cloud Storage buckets.

## Usage

```bash
./load [GLOBAL_OPTIONS] [OPTIONS] [DATABASE...] DESTINATION
```

### Global Options

These options are passed to the `mongorestore` command.

*   `-h, --host`: The hostname of the MongoDB server.
*   `-P, --port`: The port of the MongoDB server.
*   `-u, --username`: The username to authenticate with.
*   `-p, --password`: The password to authenticate with.
*   `--authenticationDatabase`: The database to authenticate against.
*   `--ssl`: Use SSL to connect to the MongoDB server.

### Options

*   `--compression`: The compression used for the backup. Can be `gzip`, `lz4`, `bz2`, or `none`. If not specified, the script will try to auto-detect the compression from the file extension.
*   `--umask`: The umask to use when creating files. Defaults to `0077`.

### Arguments

*   `DATABASE`: The name of the database to restore. If not specified, all databases in the backup will be restored.
*   `DESTINATION`: The destination of the backup. This can be a local file path, an S3 URI (e.g., `s3://my-bucket/backup`), or a Google Cloud Storage URI (e.g., `gs://my-bucket/backup`).

### Environment Variables

The following environment variables can be used to configure the `load` command:

*   `DATABASE_HOST`: The hostname of the MongoDB server.
*   `DATABASE_PORT`: The port of the MongoDB server.
*   `DATABASE_USERNAME`: The username to authenticate with.
*   `DATABASE_PASSWORD`: The password to authenticate with.
*   `DATABASE_PASSWORD_FILE`: A file containing the password to authenticate with.
*   `DATABASE_AUTHENTICATIONDATABASE`: The database to authenticate against.
*   `DATABASE_SSL`: Use SSL to connect to the MongoDB server.

*   `SAVE_COMPRESSION`: The compression to use for the backup.
*   `SAVE_UMASK`: The umask to use when creating files.

## Example

To restore the `my-database` database from the latest backup in the `s3://my-bucket/backup` bucket:

```bash
./load s3://my-bucket/backup my-database
```