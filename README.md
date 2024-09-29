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

Separating source and build files does not make sense, the image does it automatically.

Run the command to create a new Sphinx project:

```bash
docker run --rm -ti --name sphinx_1 \
    -v "$(pwd):/package" \
    kyzimaspb/sphinx \
      create --project demo --author 'Kirill Vercetti' --ext-autodoc
```

By default, a `docs` directory with the Sphinx project will be created in the mounted directory.

## Existing project

If the project already contains documentation for Sphinx,
then just mount the project directory in `/package`.
By default, a directory named docs is used for the Sphinx project:

```bash
docker run --rm -ti --name sphinx_1 \
    -p 8000:8000 \
    -v "$(pwd):/package" \
    kyzimaspb/sphinx
```

## Installing additional dependencies

If `requirements.txt`, `pyproject.toml`, `setup.cfg` or `setup.py` files
are found in the project directory,
the package with all dependencies will be automatically installed.

To install extra dependencies, use the `--extra` arguments:

```bash
docker run --rm -ti --name sphinx_1 \
    -p 8000:8000 \
    -v "$(pwd):/package" \
    kyzimaspb/sphinx
      --extra dev --extra test
```

## Docker Compose

```yaml
services:
  sphinx:
    image: kyzimaspb/sphinx
    ports:
      - "8000:8000"
    volumes:
      - ./package:/package
    command: ["--extra", "dev", "--extra", "test"]
```
