FROM node:12.11.1-slim

RUN apt-get update && \
    apt-get install -y git calibre && \
    apt-get clean && \
    mkdir /build && \
    chown node:node /build && chmod 0750 /build

# Install custom gitbook version
 
WORKDIR /build
USER root
ENV PUPPETEER_SKIP_DOWNLOAD=true
RUN apt-get install -y pandoc texlive-latex-base texlive-fonts-recommended texlive-extra-utils texlive-latex-extra
COPY entrypoint.sh .
# RUN git clone "https://github.com/simonhaenisch/md-to-pdf" && cd md-to-pdf && npm link 

