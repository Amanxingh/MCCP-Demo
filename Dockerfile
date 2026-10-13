# Orderly — container image.
# TODO(T5): complete this Dockerfile so the image runs the test suite by
# default. Hints:
#   1. base image: an official slim Python 3.12 image
#   2. set a working directory
#   3. copy the project in (respect .dockerignore-style hygiene: do not copy
#      .git — see the notes in TASKS.md)
#   4. install pytest from the vendored wheels with:
#        pip install --no-index --find-links=vendor pytest
#   5. default command: run pytest quietly

FROM python:3.12-slim

WORKDIR /app

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV PYTHONPATH=/app/src

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY src/ ./src/
COPY data/ ./data/

RUN mkdir -p /app/out/reports

CMD ["python", "-m", "orderly.cli", "--db", "/app/out/orderly.db", "--out", "/app/out/reports"]
