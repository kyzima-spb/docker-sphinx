ARG PYVERSION=3.11
ARG RELEASE=slim-bookworm

FROM python:$PYVERSION-$RELEASE

LABEL maintainer="Kirill Vercetti <office@kyzima-spb.com>"

STOPSIGNAL SIGINT

EXPOSE 8000

WORKDIR /package

ENV DEBIAN_FRONTEND=noninteractive \
    PIP_DISABLE_PIP_VERSION_CHECK=1

ARG TARGETARCH

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    --mount=type=cache,target=/root/.cache/pip \
    set -ex; \
        rm -f /etc/apt/apt.conf.d/docker-clean; \
        echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache; \
        \
        apt update; \
        apt install -yq --no-install-recommends \
            git \
            graphviz \
            imagemagick \
        ; \
        savedAptMark="$(apt-mark showmanual)"; \
        [ "$TARGETARCH" = 'arm' ] && apt install -yq --no-install-recommends \
            gcc \
            libjpeg-dev \
            zlib1g-dev \
        ; \
        pip install --disable-pip-version-check \
            Pillow \
            sphinx-autobuild \
            Sphinx \
        ; \
        apt-mark auto '.*' > /dev/null; \
        apt-mark manual $savedAptMark; \
        apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
        \
        useradd -s /usr/sbin/nologin user; \
        chown -R user:user . \
        ; \
        packageDir="$(python -c 'from sphinx import package_dir; print(package_dir)')"; \
        conffile="$(find "$packageDir/templates" -name 'conf.py*')"; \
        templatesDir='/usr/local/share/sphinx/templates'; \
        mkdir -p "$templatesDir"; \
        cd "$templatesDir"; \
            ln -s "$conffile" conf.base.jinja; \
            ln -s conf.py.jinja conf.py_t;

COPY ./ /

USER user

ENTRYPOINT ["/entrypoint.sh"]
CMD ["serve", "--project-dir", "./docs"]
