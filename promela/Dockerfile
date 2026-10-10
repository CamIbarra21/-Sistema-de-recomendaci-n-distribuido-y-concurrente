# Entorno mínimo para verificar los modelos Promela sin instalar Spin en el sistema.
# Construir:  docker build -t spin-verif promela/
FROM ubuntu:24.04
RUN apt-get update \
    && apt-get install -y --no-install-recommends spin gcc libc6-dev \
    && rm -rf /var/lib/apt/lists/*
