# cloud\zad1

# Zadanie 1

## Krok 1: Stworzenie programu oraz przesłanie go na repo

Działający program

![Działający program](screens/scr0.png)

Dodanie do lokalnego repo, commit oraz push na gh repo

![Dodanie do lokalnego repo, commit oraz push na gh repo](screens/scr1.png)

## Krok 2: Dodanie dockerfile oraz zbudowanie kontenera

### A:
Treść wykorzystywanego dockerfile

![](screens/scr2.png)

### B:
Budowanie obrazu:

![](screens/scr3.png)

### C:
Uruchomienie kontenera i przetestowanie programu:

![](screens/scr4.png)

## Krok 3: Stworzenie GH Actions

### A: 

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