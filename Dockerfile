FROM dart:stable AS build

WORKDIR /app

COPY fib.dart .

ENTRYPOINT  ["dart", "run", "fib.dart"]