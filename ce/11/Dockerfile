FROM ghcr.io/graalvm/graalvm-ce:ol9-java11-22

LABEL author="lingyu-ily"

RUN useradd -d /home/container -m container

USER container
ENV USER=container HOME=/home/container
WORKDIR /home/container

COPY ../../entrypoint.sh /entrypoint.sh
CMD [ "/bin/bash", "/entrypoint.sh" ]
