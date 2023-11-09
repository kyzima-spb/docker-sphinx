ARG PYVERSION=3.11
ARG RELEASE=slim-bookworm

FROM python:$PYVERSION-$RELEASE

LABEL maintainer="Kirill Vercetti <office@kyzima-spb.com>"

STOPSIGNAL SIGINT

WORKDIR /package

EXPOSE 8000

ENV DEBIAN_FRONTEND=noninteractive \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    HOME=/tmp

RUN set -ex \
    && useradd -s /usr/sbin/nologin user \
    && chown user /package

RUN set -ex \
    && apt update \
    && apt install -yq --no-install-recommends \
        git \
        graphviz \
        imagemagick \
    && apt-get clean  \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && pip install \
           --no-cache-dir \
           --disable-pip-version-check \
               sphinx-autobuild \
               Sphinx \
               Pillow

COPY ./root /

USER user

ENTRYPOINT ["/entrypoint.sh"]
CMD ["serve"]
