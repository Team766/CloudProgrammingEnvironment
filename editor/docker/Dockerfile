FROM ubuntu:bionic
#FROM codercom/code-server:latest

RUN apt-get update && \
  apt-get install -y curl gnupg2 apt-transport-https maven gradle openjdk-11-jdk-headless rsync git && \
  rm -rf /var/lib/apt/lists/*

SHELL ["/bin/bash", "-c"]
ENV SHELL=/bin/bash

RUN set -euo pipefail && curl -fsSL https://code-server.dev/install.sh | sh -s -- --version 3.6.1

ARG uid=1000
RUN adduser --uid $uid --disabled-password --gecos '' coder

ADD settings.json /home/coder/.local/share/code-server/User/settings.json

RUN chmod g+rw /home && \
    mkdir -p /home/project && \
    chown -R coder:coder /home/coder && \
    chown -R coder:coder /home/project

USER coder

# This needs to be run as the user
RUN /usr/bin/code-server --install-extension vscjava.vscode-java-pack

RUN git config --global credential.helper cache

COPY entrypoint.sh /home/coder/entrypoint.sh

WORKDIR /home/project
VOLUME /home/project

EXPOSE 3000

ENTRYPOINT [ "/home/coder/entrypoint.sh" ]

#RUN set -o pipefail \
# && mkdir -p wpilib/2020 \
# && curl -SL https://github.com/wpilibsuite/allwpilib/releases/download/v2020.3.2/WPILib_Linux-2020.3.2.tar.gz \
#  | tar -xzC wpilib/2020
#
#RUN cd wpilib/2020/tools && python3 ToolsUpdater.py
#
#RUN /usr/bin/code-server --install-extension wpilib/2020/vsCodeExtensions/WPILib.vsix
