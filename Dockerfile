FROM eclipse-temurin:21-jdk

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        bash \
        curl \
        git \
        maven \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace

CMD ["bash"]
