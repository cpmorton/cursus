# The build contract: same fonts + LibreOffice everywhere => identical pagination.
# Bump the base deliberately; Liberation metric changes can move line breaks.
FROM ubuntu:24.04
ENV DEBIAN_FRONTEND=noninteractive PIP_BREAK_SYSTEM_PACKAGES=1
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      python3 python3-pip libreoffice-writer-nogui fonts-liberation poppler-utils \
 && pip3 install --no-cache-dir python-docx==1.2.0 \
 && rm -rf /var/lib/apt/lists/*
COPY build build.py /opt/cursus/
ENV PATH=/opt/cursus:$PATH
WORKDIR /work
ENTRYPOINT []
CMD ["build", "--help"]
