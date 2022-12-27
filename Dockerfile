FROM dart:stable AS build

WORKDIR /app
COPY pubspec.* ./
RUN dart pub get

COPY fib.dart .

ENTRYPOINT  ["dart", "run", "fib.dart"]