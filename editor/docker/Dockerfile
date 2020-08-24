FROM theiaide/theia-java

SHELL ["/bin/bash", "-c"]

RUN set -o pipefail \
 && mkdir -p wpilib/2020 \
 && curl -SL https://github.com/wpilibsuite/allwpilib/releases/download/v2020.3.2/WPILib_Linux-2020.3.2.tar.gz \
  | tar -xzC wpilib/2020

USER root

RUN apt-get update \
 && apt-get install -y jq

RUN base_package="$(cat package.json)" && jq ".theiaPlugins += {\"vscode-wpilib\": \"$PWD/wpilib/2020/vsCodeExtensions/WPILib.vsix\"}" <(echo "$base_package") > package.json

USER theia

RUN cd wpilib/2020/tools && python3 ToolsUpdater.py

RUN git clone https://github.com/Team766/MaroonFramework.git /home/project
