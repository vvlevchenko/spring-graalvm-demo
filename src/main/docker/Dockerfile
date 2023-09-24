FROM docker.io/library/spring-graalvm-demo:0.0.1-SNAPSHOT as original

FROM ubuntu
RUN apt-get update
RUN apt-get install -y gdbserver
RUN apt-get install -y libc6-dev
RUN apt-get install -y libc6-dbg
RUN apt-get install -y zlib1g-dev
WORKDIR /workspace
COPY --from=original /workspace/* ./
