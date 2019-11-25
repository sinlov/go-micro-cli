# What is go-micro-cli

- docker hub see https://hub.docker.com/r/sinlov/go-micro-cli
- this is fast way to run https://github.com/micro/micro cli under micro

micro/micro document

source https://github.com/micro/micro
document https://micro.mu/docs/

# fast use

```sh
docker run --rm \
  --name micro-alpine \
  -it sinlov/go-micro-cli:latest \
  --help
```

## use as local cli

- version latest micro

```sh
$ sudo curl -s -L --fail https://raw.githubusercontent.com/sinlov/go-micro-cli/master/run.sh -o /usr/local/bin/micro
$ sudo chmod +x /usr/local/bin/micro
```

# build tag list

| tag            | Dockerfile                              | document                              |
| -------------- | --------------------------------------- | ------------------------------------- |
| latest         | [latest Dockerfile](Dockerfile)         | [document](README.md)                 |
| alpine-v1.14.0 | [Dockerfile](https://github.com/sinlov/go-micro-cli/blob/alpine-v1.14.0/alpine/Dockerfile) | [document](https://github.com/sinlov/go-micro-cli/blob/alpine-v1.14.0/alpine/README.md) |
| alpine-v1.13.2 | [Dockerfile](https://github.com/sinlov/go-micro-cli/blob/alpine-v1.13.2/alpine/Dockerfile) | [document](https://github.com/sinlov/go-micro-cli/blob/alpine-v1.13.2/alpine/README.md) |
| alpine-v1.13.1 | [Dockerfile](https://github.com/sinlov/go-micro-cli/blob/alpine-v1.13.1/alpine/Dockerfile) | [document](https://github.com/sinlov/go-micro-cli/blob/alpine-v1.13.1/alpine/README.md) |
| alpine-v1.13.0 | [Dockerfile](https://github.com/sinlov/go-micro-cli/blob/alpine-v1.13.0/alpine/Dockerfile) | [document](https://github.com/sinlov/go-micro-cli/blob/alpine-v1.13.0/alpine/README.md) |
| alpine-v1.12.0 | [Dockerfile](https://github.com/sinlov/go-micro-cli/blob/alpine-v1.12.0/alpine/Dockerfile) | [document](https://github.com/sinlov/go-micro-cli/blob/alpine-v1.12.0/alpine/README.md) |
| alpine-v1.11.3 | [Dockerfile](https://github.com/sinlov/go-micro-cli/blob/alpine-v1.11.3/alpine/Dockerfile) | [document](https://github.com/sinlov/go-micro-cli/blob/alpine-v1.11.3/alpine/README.md) |


# build ideas

- minimum dependence
- local build test case
- auto build
- Low disk usage
- Ready to use, by use fast cli
