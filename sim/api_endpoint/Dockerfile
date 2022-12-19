FROM tiangolo/uvicorn-gunicorn-fastapi:python3.11

RUN apt update && apt install -y docker.io && apt clean

ENV PORT=4000

COPY ./app /app
