#!/usr/bin/python3

import os.path
import subprocess
import sys
import tarfile
import tempfile

from fastapi import FastAPI, UploadFile

app = FastAPI()

# These paths need to match sim/setup.sh
ROBOT_CODE_HOST_DIR = "/tmp/robot_code"
ROBOT_CODE_VOLUME = "/mnt/robot_code"
ROBOT_CODE_PREFIX = "project-"


@app.post("/uploadrobotcode")
def create_upload_file(package: UploadFile):
    # Extract uploaded code package
    deployed_code = tempfile.mkdtemp(
        prefix=ROBOT_CODE_PREFIX, dir=ROBOT_CODE_VOLUME
    )
    print("Extract uploaded code package to", deployed_code, file=sys.stderr)
    with tarfile.open(fileobj=package.file) as tf:
        tf.extractall(path=deployed_code)
    package.file.close()
    subprocess.check_call(["chmod", "-R", "a+rwX", deployed_code])

    # Stop previous robot code instance
    if subprocess.check_output(
        ["docker", "ps", "-q", "--filter", "name=^robot_code$"],
        universal_newlines=True,
    ).strip():
        print("Stopping previous robot code instance", file=sys.stderr)
        subprocess.check_call(["docker", "stop", "robot_code"])
    else:
        print("Previous robot code instance not found", file=sys.stderr)

    # Start new instance
    host_deployed_code = os.path.join(
        ROBOT_CODE_HOST_DIR, os.path.basename(deployed_code)
    )
    docker_cmd = [
        "docker",
        "run",
        "-d",
        "--rm",
        "--name=robot_code",
        "--log-driver", "json-file",
        "--log-opt", "max-size=10m",
        "--log-opt", "max-file=10",
        "--network=container:sim",
        "-v", f"{host_deployed_code}:/home/frc/code",
        "team766/robot-code:active",
    ]
    print("Starting robot code", file=sys.stderr)
    print(docker_cmd, file=sys.stderr)
    subprocess.check_call(docker_cmd)

    try:
        print("Cleaning old robot code", file=sys.stderr)
        subprocess.check_call([
            "find",
            ROBOT_CODE_VOLUME,
            "-maxdepth", "1",
            "-name", f"{ROBOT_CODE_PREFIX}*",
            "-mmin", "+5",
            "-exec", "rm", "-r", "{}", ";",
        ])
    except subprocess.CalledProcessError as ex:
        print(ex, file=sys.stderr)

    return {}
