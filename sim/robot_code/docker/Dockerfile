FROM eclipse-temurin:17-jre-focal

RUN adduser --disabled-password --gecos '' frc

USER frc

RUN mkdir -p /home/frc/code

WORKDIR /home/frc/code

ENTRYPOINT ["java", "-cp", "project.jar", "com.team766.hal.simulator.RobotMain"]

CMD ["-vr_connector"]
