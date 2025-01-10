# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:30d982e0c170a1147e54cda7c2ec5ccf6cb92571d879465700385b0ca6757302 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:be8b29da444bc888f920593b21978b70ec49facfe2ffd24a91c8c3c7084100f5

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
