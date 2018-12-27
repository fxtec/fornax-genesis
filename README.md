# watchdog

## Testes
- etcd singlenode
```bash
docker network create --attachable teste
docker run -d -p 2379:2379 --name etcd --network teste lfkeitel/etcd:latest

docker run -it --rm --network teste -v /var/run/docker.sock:/var/run/docker.sock fxtec/watchdog-genesis

export DOCKER_HOST=tcp://192.168.15.18:8080

```

#### Anotações
- backup: https://www.mirantis.com/blog/everything-you-ever-wanted-to-know-about-using-etcd-with-kubernetes-v1-6-but-were-afraid-to-ask/
- etcd doc: https://coreos.com/etcd/docs/latest/v2/api.html#setting-the-value-of-a-key
- dockerfile: https://docs.docker.com/engine/reference/builder/#healthcheck
