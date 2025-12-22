# ---------- Stage 1: Builder ----------
FROM python:3.12-slim AS builder

WORKDIR /app

# Install build dependencies (cryptography needs these)
RUN apt-get update && \
    apt-get install -y build-essential default-libmysqlclient-dev pkg-config \
    libssl-dev libffi-dev && \
    rm -rf /var/lib/apt/lists/*

COPY requirements.txt .

RUN pip install --upgrade pip
RUN pip install --prefix=/install -r requirements.txt

# ---------- Stage 2: Final ----------
FROM python:3.12-slim

WORKDIR /app

COPY --from=builder /install /usr/local

COPY . .

RUN chmod +x /app/entrypoint.sh

EXPOSE 5000
ENTRYPOINT ["./entrypoint.sh"]

