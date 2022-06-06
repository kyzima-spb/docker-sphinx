## Volumes

* `/package` - directory of the package for which the documentation is being written;
* `/build` - directory for generated files.

## Run in daemon mode

Run the container named sphinx_1 in daemon mode and mount the specified volumes
to the specified directories of the host machine:

```bash
docker run -d --name sphinx_1 \
    -p 8000:8000 \
    -v $(pwd):/package \
    kyzimaspb/sphinx
```

### Default values

* `/package/docs` - current working directory;
* `8000` - public TCP port of the HTTP server.

## Environment Variables

* `USER_UID` - user ID from which the HTTP server is running (Defaults to `1000`);
* `USER_GID` - group ID for the user from which the HTTP server is running (Defaults to `1000`);
* `EXTRA` - a comma-separated list of additional dependencies.
