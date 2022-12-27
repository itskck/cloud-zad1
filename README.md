# cloud\zad1

## Zadanie 1: Stworzenie programu oraz przesłanie go na repo

Działający program oraz wynik dzialania

```
void main() {
  print('Juliusz Piskor, IMST 2.3');
  print('fib.exe');
  print('-----------');
  int n;
  print('Wprowadź numer > 0  i  < 20');
  String? inTemp = stdin.readLineSync();

  try {
    n = int.parse(inTemp!);
    if (n > 20) {
      print('Numer jest za duży!');
      return;
    }
  } catch (e) {
    log(e.toString());
    return;
  }
  print(fib(n));
}

int fib(int n) {
  if (n < 2) {
    return n;
  }
  return fib(n - 2) + fib(n - 1);
}
```

![Działający program](screens/scr0.png)

Dodanie do lokalnego repo, commit oraz push na gh repo

![Dodanie do lokalnego repo, commit oraz push na gh repo](screens/scr1.png)

## Zadanie 2: Dodanie dockerfile oraz zbudowanie kontenera

### A:
Treść wykorzystywanego dockerfile

![](screens/scr2.png)

### B:
Budowanie obrazu:

![](screens/scr3.png)

### C:
Uruchomienie kontenera i przetestowanie programu:

![](screens/scr4.png)

## Zadanie 3: GH Actions

Przygotowany plik fib.yml
```
name: GitHub Action for zad1 (fib)

on:
  push:
    branches: [main]
    tags: [v*]

jobs:
  build-push-images:
    name: build and push
    runs-on: ubuntu-20.04
    steps:
      - name: Checkout code
        uses: actions/checkout@v3

      - name: Buildx
        uses: docker/setup-buildx-action@v2

      - name: QEMU
        uses: docker/setup-qemu-action@v2

      - name: DockerHub
        uses: docker/login-action@v2
        with:
          username: ${{ secrets.DOCKER_HUB_USERNAME }}
          password: ${{ secrets.DOCKER_HUB_ACCESS_TOKEN }}

      - name: GitHub
        uses: docker/login-action@v2
        with:
          registry: ghcr.io
          username: ${{ github.actor }}
          password: ${{ secrets.PAT }}

      - name: Docker meta
        id: meta
        uses: docker/metadata-action@v4
        with:
          images: |
            itskck/cloud-zad1
            ghcr.io/${{ github.repository }}
          tags: |
            type=ref,event=branch
            type=ref,event=pr
            type=semver,pattern={{version}}
            type=semver,pattern={{major}}.{{minor}}
      - name: Build and push
        uses: docker/build-push-action@v3
        with:
          context: .
          file: ./Dockerfile
          platforms: linux/amd64, linux/arm64
          push: true
          tags: ${{ steps.meta.outputs.tags }}
          labels: ${{ steps.meta.outputs.labels }}
          cache-from: type=registry,ref=docker.io/itskck/cloud-zad1:cache
          cache-to: type=registry,ref=docker.io/itskck/cloud-zad1:cache,mode=max
```
Na początku wykonywane są akcje buildx oraz quemu, dzięki czemu obraz zbudowac sie może na dwie (lub więcej) architektury. Następnie wykonują sie wymagane do wykonania zadanie logowania: do dockerhuba oraz ghcr, przy pomocy secretsów umieszczonych w repo. Na końcu następuje zbudowanie i spushowanie.

Obrazy dostępne są na dwóch platformach, co widoczne jest na GitHub packages:
![](screens/scr9.png)

oraz na DockerHubie:
![](screens/scr10.png)

Za cachowanie odpowiadają flagi cache-from oraz cache-to. Cache jest wysyłany do registry.

Tagowanie:
![](screens/scr5.png)

Tagi zostały dodane zgodnie z nazewnictwej SEMVER na GitHubie oraz DockerHubie. Dodany został tag o początku 'v', więc workflow włącza się automatycznie. Odpowiada za to nastepująca linia Dockerfila:

```
push:
    branches: [main]
    tags: [v*]
```

Workflowy przechodzą poprawnie:
![](screens/scr6.png)

Wynik działania widoczny jest na packages: 
![](screens/scr7.png)

oraz na DockerHubie:

![](screens/scr8.png)

## Zadanie 4

Komenda 
```
gh workflow list
```
![](screens/scr11.png)

Workflowy oraz ich status dostępnę są w zakładce Actions na repo. Ostatni workflow dla maina i dla wczesniej utworzonego taga przeszedł poprawnie.

![](screens/scr12.png)

Poprawność wykonania kroków jest widoczna na screenach w zadaniu 3.

Żeby pobrać obrazu z repozytorium wykorzystana była komenda widoczna na ghcr:
```
docker pull ghcr.io/itskck/cloud-zad1:latest@sha256:9344ac5689278f340d4a14dc6c7d934be103d6a4ddc53f688ab4d6b3169f5e50
```
![](screens/scr13.png)

Uruchomienie obrazu:

![](screens/scr14.png)


