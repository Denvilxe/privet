FROM python:3-slim-buster

RUN apt update && apt upgrade -y && \
    apt install --no-install-recommends -y \
        bash \
        curl \
        ffmpeg \
        git \
        gcc \
        libjpeg62-turbo-dev \
        libwebp-dev \
        musl-dev \
        atomicparsley \
        neofetch \
        && rm -rf /var/lib/apt/lists /var/cache/apt/archives /tmp

COPY . /Maximus/
WORKDIR /Maximus/

# "Dirty Fix" for Heroku Dynos to track updates via 'git'.
# Fork/Clone maintainers may change the clone URL to match
# the location of their repository. [#ThatsHerokuForYa!]
RUN if [ ! -d /Maximus/.git ] ; then \
    git clone "https://github.com/Denvilxe/Maximus.git" /tmp/dirty/Maximus/ && \
    mv -v -u /tmp/dirty/Maximus/.git /Maximus/ && \
    rm -rf /tmp/dirty/Maximus/; \
    fi

# Install PIP packages
RUN python3 -m pip install --no-warn-script-location --no-cache-dir --upgrade -r requirements.txt

# Cleanup
RUN rm -rf /var/lib/apt/lists /var/cache/apt/archives /tmp

ENTRYPOINT ["python", "-m", "userbot"]
