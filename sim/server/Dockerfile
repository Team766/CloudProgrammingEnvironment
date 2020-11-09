FROM ubuntu:bionic

RUN adduser --disabled-password --gecos '' frc

USER frc

COPY ./server /home/frc/sim

WORKDIR /home/frc/sim

ENTRYPOINT ["./server.x86_64"]
