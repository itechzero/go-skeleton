
.PHONY: all
all: tidy build

.PHONY: tidy
tidy:
	go mod tidy

.PHONY: build
build:
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -o go-first ./cmd/main.go

.PHONY: run
run: tidy
	go run cmd/main.go

.PHONY: docker_build
docker_build:
	docker build --force-rm -t go-first -f Dockerfile .

.PHONY: docker_run
docker_run:
	docker run -it -d -p 8080:8080 --name go-tmp go-first