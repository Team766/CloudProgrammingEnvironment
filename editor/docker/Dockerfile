FROM ubuntu:bionic

RUN apt-get update && \
  apt-get install -y curl gnupg2 apt-transport-https maven gradle openjdk-11-jdk-headless rsync git && \
  curl -sL https://deb.nodesource.com/setup_12.x | bash - && \
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
  apt-get update && apt-get install -y yarn build-essential && \
  rm -rf /var/lib/apt/lists/*
# See : https://github.com/theia-ide/theia-apps/issues/34
ARG uid=1000
RUN adduser --uid $uid --disabled-password --gecos '' theia
RUN chmod g+rw /home && \
    mkdir -p /home/project && \
    chown -R theia:theia /home/theia && \
    chown -R theia:theia /home/project;
WORKDIR /home/theia
USER theia

ADD package.json ./package.json
RUN yarn --cache-folder ./ycache && rm -rf ./ycache && \
    NODE_OPTIONS="--max_old_space_size=4096" yarn theia build && \
    yarn theia download:plugins
EXPOSE 3000
ENV SHELL=/bin/bash \
    THEIA_DEFAULT_PLUGINS=local-dir:/home/theia/plugins
ENTRYPOINT [ "yarn", "theia", "start", "/home/project", "--hostname=0.0.0.0" ]

#RUN set -o pipefail \
# && mkdir -p wpilib/2020 \
# && curl -SL https://github.com/wpilibsuite/allwpilib/releases/download/v2020.3.2/WPILib_Linux-2020.3.2.tar.gz \
#  | tar -xzC wpilib/2020
#
#RUN cd wpilib/2020/tools && python3 ToolsUpdater.py

VOLUME /home/project
