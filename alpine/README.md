# What is go-micro-cli

- docker hub see https://hub.docker.com/r/sinlov/go-micro-cli
- this is fast way to run https://github.com/micro/micro cli under micro

# fast use

```sh
docker run --rm \
  --name micro-alpine \
  -it sinlov/go-micro-cli:v1.11.3 \
  --help
```

# use as local cli

- version v1.11.3

```sh
$ sudo curl -s -L --fail https://raw.githubusercontent.com/sinlov/go-micro-cli/master/dist/v1.11.3/run.sh -o /usr/local/bin/micro
$ sudo chmod +x /usr/local/bin/micro
```

# micro

source https://github.com/micro/micro
document https://micro.mu/docs/

