# Table of contents

`kyzimaspb/sphinx` - the image helps in developing documentation using Sphinx.

- [Creating a new project](#creating-a-new-project)
- [Existing project](#existing-project)
- [Installing additional dependencies](#installing-additional-dependencies)
- [Docker Compose](#docker-compose)

## Creating a new project

Sphinx comes with a script called **sphinx-quickstart**
that sets up a source directory and creates a default `conf.py`
with the most useful configuration values.

sphinx-quickstart’s command line options can be set
with environment variables using the format `SPHINX_<UPPER_LONG_NAME>`.
Dashes (`-`) have to be replaced with underscores (`_`).

Separating source and build files does not make sense, the image does it automatically.

Environment variable values are interpreted as JSON.
The values of the flag arguments must be specified as `true`/`false`.

If an empty docs directory does not exist in the project, it is created.
Use `SPHINX_PATH` to specify a name other than docs,
for example `SPHINX_PATH=/package/tutorial`.

Example of running a container:

```bash
docker run --rm -ti --name sphinx_1 \
    -p 8000:8000 \
    -v $(pwd):/package \
    -e SPHINX_PROJECT=demo \
    -e SPHINX_AUTHOR='Kirill Vercetti' \
    -e SPHINX_EXT_AUTODOC=true \
    kyzimaspb/sphinx
```

## Existing project

If the project already contains documentation for Sphinx,
then just mount the project directory in `/package`,
all environment variables except `SPHINX_PATH` will be ignored:

```bash
docker run --rm -ti --name sphinx_1 \
    -p 8000:8000 \
    -v $(pwd):/package \
    kyzimaspb/sphinx
```

## Installing additional dependencies

If `requirements.txt`, `pyproject.toml` or `setup.py` files
are found in the project directory,
the package with all dependencies will be automatically installed.

To install extra dependencies,
set the `EXTRA` environment variable with the names separated by spaces.

## Docker Compose

```yaml
version: "3.9"

services:
  sphinx:
    image: kyzimaspb/sphinx
    ports:
      - "8000:8000"
    environment:
      SPHINX_PROJECT: flask-uploader
      SPHINX_AUTHOR: "Kirill Vercetti"
      SPHINX_EXT_AUTODOC: true
      EXTRA: "pymongo aws"
    volumes:
      - ./package:/package
```
