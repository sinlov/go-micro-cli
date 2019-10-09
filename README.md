# What is go-micro-cli

docker hub see https://hub.docker.com/r/sinlov/go-micro-cli
this is fast way to run https://github.com/micro/micro cli under micro

# fast use

```sh
docker run --rm \
  --name micro-alpine \
  -it sinlov/go-micro-cli:latest \
  --help
```

# use as local cli

- version v1.11.1

```sh
$ sudo curl -s -L --fail https://raw.githubusercontent.com/sinlov/go-micro-cli/master/v1.11.1/alpine/run.sh -o /usr/local/bin/micro
$ sudo chmod +x /usr/local/bin/micro
```

# micro

source https://github.com/micro/micro
document https://micro.mu/docs/
