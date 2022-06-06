FROM python:3.9-slim

LABEL maintainer="Kirill Vercetti <office@kyzima-spb.com>"

STOPSIGNAL SIGINT

VOLUME /build
VOLUME /package
WORKDIR /package/docs

EXPOSE 8000

ENV DEBIAN_FRONTEND noninteractive
ENV USER_UID 1000
ENV USER_GID 1000

RUN set -x \
    && groupadd -g 1000 user \
    && useradd -u 1000 -g user -s /bin/bash -m user

RUN apt update

RUN set -x \
    && apt install -yq --no-install-recommends \
        git \
        gosu \
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

ADD ./root /

ENTRYPOINT ["/entrypoint.sh"]
CMD ["sphinx-autobuild", "--host", "0.0.0.0", "source", "/build/html"]
