# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:9e7d10b641a219baa71afd8fec83ab8622a0486f7d8bdab4ed5536c361b1add1 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:b9328fd1f02d7836c7a75b0423ea9b0098e1cc10f6d3b9398bac5ebb4410f316

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
