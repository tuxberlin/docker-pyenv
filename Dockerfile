FROM alpine:3.21.0


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


# no root but normal user
RUN adduser --uid 2001 appuser --disabled-password

USER appuser
ENV HOME="/home/appuser"

WORKDIR /app

SHELL ["/bin/bash", "-c"]


# pyenv
ENV PYENV_ROOT="$HOME/.pyenv"
ENV PATH="$PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH"
ENV PYENV_SHELL="bash"

RUN curl https://pyenv.run | bash \
    && pyenv install 3.13.1 \
    && pyenv rehash \
    ;

ENV PIPX_DEFAULT_PYTHON="$PYENV_ROOT/versions/3.13.1/bin/python"


# pdm
ENV PATH="$HOME/.local/bin:$PATH"

RUN curl -sSL https://pdm-project.org/install-pdm.py | python3 - \
    && pdm completion bash > ~/.bash_completion \
    ;


# pip-tools
RUN pipx install pip-tools


CMD ["/bin/bash"]
