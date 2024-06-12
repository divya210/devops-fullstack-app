FROM ubuntu:latest
WORKDIR /code
COPY . /code
RUN apt-get update -y && apt-get install -y ca-certificates golang-go
EXPOSE 8080
