# Getting Started

Sphinx comes with a script called **sphinx-quickstart**
that sets up a source directory and creates a default conf.py
with the most useful configuration values from a few questions it asks you.
To use this, run:

```bash
docker run --rm -ti -v $(pwd):/package kyzimaspb/sphinx sphinx-quickstart
```

Separating source and build files does not make sense, the image does it automatically.

## Run HTTP Server

Run the container named `sphinx_1` in daemon mode and mount the specified volumes
to the specified directories of the host machine:

```bash
docker run -d --name sphinx_1 \
    -p 8000:8000 \
    -v $(pwd):/package \
    kyzimaspb/sphinx
```

By default, the public TCP port of the HTTP server `8000`.

The configuration file must be in the current working directory, by default `/packages/docs`.
If you use a different path, you must explicitly specify the current working directory
in the `-w` argument of the `run` command.

```bash
docker run -d --name sphinx_1 \
    -p 8000:8000 \
    -v $(pwd):/package \
    -w /package/docs/source \
    kyzimaspb/sphinx
```

## Volumes

* `/package` - directory of the package for which the documentation is being written;
* `/build` - directory for generated files.

## Environment Variables

* `USER_UID` - user ID from which the HTTP server is running (Defaults to `1000`);
* `USER_GID` - group ID for the user from which the HTTP server is running (Defaults to `1000`);
* `EXTRA` - a comma-separated list of additional dependencies.

## docker-compose

File example:

```yaml
version: "3.7"

services:
  sphinx:
    image: kyzimaspb/sphinx
    environment:
      EXTRA: extras_1 extras_2 extras_3
    working_dir: /package/docs/source  # if need change
    restart: unless-stopped
    ports:
      - 8000:8000
    volumes:
      - .:/package
```