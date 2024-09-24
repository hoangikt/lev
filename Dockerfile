# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:979243b1af896a4ad575271f4ba5ea8405a0d0297ade156f116fb2ba3a26a9d6 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:bc5a4d6a3ea2bf1d982d000a2366f28b352702059b0cc02f58ace2b830f1aaca

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
