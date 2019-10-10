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
| alpine-v1.11.1 | [Dockerfile](v1.11.1/alpine/Dockerfile) | [document](v1.11.1/alpine/README.md)  |


# build ideas

- minimum dependence
- local build test case
- auto build
- Low disk usage
- Ready to use, by use fast cli