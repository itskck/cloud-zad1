FROM dart:stable AS build

WORKDIR /app

COPY pubspec.* ./

RUN dart pub get

COPY fib.dart /app

ENTRYPOINT [ "dart","run","/app/fib.dart"]