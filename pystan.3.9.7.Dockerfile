FROM python:3.9.7-bullseye

# Install the updated gcc compiler (version 10) for Pystan 3
RUN echo 'deb http://deb.debian.org/debian testing main' >> /etc/apt/sources.list
RUN apt-get update -y && apt-get install -y gcc && rm -rf /var/lib/apt/lists/*

RUN python3 -m pip install httpstan==4.6.0
RUN python3 -m pip install pystan==3.3.0

RUN mkdir -p /work
RUN adduser --quiet --disabled-password stanuser && chown -R stanuser /work
USER stanuser

WORKDIR /work
