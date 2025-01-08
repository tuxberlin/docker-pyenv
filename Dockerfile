FROM alpine:3.21.0

ARG PYVERSION=3.13.1


RUN apk add --no-cache \
    bash \
    build-base \
    bzip2-dev \
    curl \
    git \
    libffi-dev \
    ncurses-dev \
    openssl-dev \
    pipx \
    readline-dev \
    sqlite-dev \
    xz-dev \
    zlib-dev \
    ;


ENV HOME="/root"

WORKDIR /app

SHELL ["/bin/bash", "-c"]


# pyenv
ENV PYENV_ROOT="$HOME/.pyenv"
ENV PATH="$PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH"
ENV PYENV_SHELL="bash"

RUN curl https://pyenv.run | bash \
    && pyenv install $PYVERSION \
    && pyenv rehash \
    && pyenv virtualenv $PYVERSION app \
    && pyenv local app \
    ;

ENV PIPX_DEFAULT_PYTHON="$PYENV_ROOT/versions/$PYVERSION/bin/python"


# pdm
ENV PATH="$HOME/.local/bin:$PATH"

RUN curl -sSL https://pdm-project.org/install-pdm.py | python3 - \
    && pdm completion bash > $HOME/.bash_completion \
    ;


# pip-tools
RUN pipx install pip-tools


CMD ["/bin/bash"]
