ARG PYVERSION=3.11
ARG RELEASE=slim-bookworm


FROM python:$PYVERSION-$RELEASE as build

ENV DEBIAN_FRONTEND noninteractive

RUN set -ex \
    && apt update \
    && apt install -yq --no-install-recommends \
        gcc \
        libjpeg-dev \
        zlib1g-dev \
    && pip install --no-cache-dir wheel \
    && mkdir /wheels \
    && pip wheel --wheel-dir=/wheels Pillow


FROM python:$PYVERSION-$RELEASE

LABEL maintainer="Kirill Vercetti <office@kyzima-spb.com>"

STOPSIGNAL SIGINT

EXPOSE 8000

ENV DEBIAN_FRONTEND=noninteractive \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    HOME=/tmp \
    SPHINX_HTML_THEME=alabaster \
    SPHINX_SEP=false \
    SPHINX_MAKEFILE=false \
    SPHINX_BATCHFILE=false

WORKDIR /package

RUN set -ex \
    && useradd -s /usr/sbin/nologin user \
    && chown user /package

COPY --from=build /wheels /wheels

RUN set -ex \
    && apt update \
    && apt install -yq --no-install-recommends \
        git \
        graphviz \
        imagemagick \
    && pip install \
        --no-index \
        --find-links=/wheels \
        --no-cache-dir \
        --disable-pip-version-check \
            Pillow \
    && pip install \
        --no-cache-dir \
        --disable-pip-version-check \
            sphinx-autobuild \
            Sphinx \
   && apt-get clean  \
   && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /wheels

COPY ./root /

RUN set -ex \
    && packageDir="$(python -c 'from sphinx import package_dir; print(package_dir)')" \
    && templatesDir="$packageDir/templates/quickstart" \
    && sed -ri 's/(html_theme = ).+/\1{{ html_theme | repr }}/' "$templatesDir/conf.py_t" \
    && cat /usr/local/share/sphinx/conf.py_append >> "$templatesDir/conf.py_t"

USER user

ENTRYPOINT ["/entrypoint.sh"]
CMD ["serve"]
