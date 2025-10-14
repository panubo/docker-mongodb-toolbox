# Save databases

The `save` command creates a backup of one or more databases. It can save the backup to a local file, an S3 bucket, or a Google Cloud Storage bucket.

## Usage

```bash
./save [GLOBAL_OPTIONS] [OPTIONS] [DATABASE...] DESTINATION
```

### Global Options

These options are passed to the `mongodump` command.

*   `-h, --host`: The hostname of the MongoDB server.
*   `-P, --port`: The port of the MongoDB server.
*   `-u, --username`: The username to authenticate with.
*   `-D, --database`: The database to connect to.
*   `-p, --password`: The password to authenticate with.
*   `--authenticationDatabase`: The database to authenticate against.
*   `--ssl`: Use SSL to connect to the MongoDB server.

### Options

*   `--compression`: The compression to use for the backup. Can be `gzip`, `lz4`, `bz2`, or `none`. Defaults to `gzip`.
*   `--umask`: The umask to use when creating files. Defaults to `0077`.

### Arguments

*   `DATABASE`: The name of the database to save. If not specified, all databases will be saved.
*   `DESTINATION`: The destination of the backup. This can be a local file path, an S3 URI (e.g., `s3://my-bucket/backup`), or a Google Cloud Storage URI (e.g., `gs://my-bucket/backup`).

### Environment Variables

The following environment variables can be used to configure the `save` command:

*   `DATABASE_HOST`: The hostname of the MongoDB server.
*   `DATABASE_PORT`: The port of the MongoDB server.
*   `DATABASE_USERNAME`: The username to authenticate with.
*   `DATABASE_PASSWORD`: The password to authenticate with.
*   `DATABASE_PASSWORD_FILE`: A file containing the password to authenticate with.
*   `DATABASE_AUTHENTICATIONDATABASE`: The database to authenticate against.
*   `DATABASE_SSL`: Use SSL to connect to the MongoDB server.

*   `SAVE_COMPRESSION`: The compression to use for the backup.
*   `SAVE_UMASK`: The umask to use when creating files.
*   `SAVE_SKIP_DATABASES`: A comma-separated list of databases to skip.

## Example

To save the `my-database` database to the `s3://my-bucket/backup` bucket:

```bash
./save s3://my-bucket/backup my-database
```