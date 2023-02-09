# On Docker

## Server

[guidance](https://docs.gitlab.com/ee/install/docker.html)

```shell
# 准备持久目录
export GITLAB_HOME=/srv/gitlab
```

```yaml
version: '3.6'
services:
  web:
    image: 'gitlab/gitlab-ee:latest'
    restart: always
    hostname: 'gitlab.example.com'
    environment:
      GITLAB_OMNIBUS_CONFIG: |
        external_url 'http://gitlab.example.com:8929'
        gitlab_rails['gitlab_shell_ssh_port'] = 2224
    ports:
      - '8929:8929'
      - '2224:22'
    volumes:
      - '$GITLAB_HOME/config:/etc/gitlab'
      - '$GITLAB_HOME/logs:/var/log/gitlab'
      - '$GITLAB_HOME/data:/var/opt/gitlab'
    shm_size: '256m'
```

访问 gitlab 前端
- 不要使用 `localhost`

```
http://<HostIP>:8929/
```

默认用户名是 `root`, 

```shell
# 获得密码
sudo docker exec -it gitlab-web-1 grep 'Password:' /etc/gitlab/initial_root_password
```

## Runner

```yaml
version: '3.6'
services:
  runner:
    image: 'gitlab/gitlab-runner:latest'
    restart: always
    volumes:
      - './srv/gitlab-runner/config:/etc/gitlab-runner'
      - '/var/run/docker.sock:/var/run/docker.sock'
```

注册一个 runner, 此处指定的 docker-image 将作为执行时, 第一个或缺省的镜像, 可以被 ci 中指定的全局 image 覆盖, 但环境准备仍然在此镜像中

```shell
GITLAB_URL="http://172.16.31.36:23456"
REGISTER_TOKEN="WG8Boxdsdba_kAWaJbDt"
RUNNER_TAGS="docker,1038"
DESC="1038-docker-runner"

docker exec gitlab-runner_runner_1 gitlab-runner register -n \
  --url $GITLAB_URL \
  --registration-token $REGISTER_TOKEN \
  --tag-list $RUNNER_TAGS \
  --executor docker \
  --locked="false" \
  --docker-pull-policy if-not-present \
  --docker-image docker:rc-git \
  --docker-volumes $HOME/.docker/config.json:/root/.docker/config.json \
  --docker-volumes /var/run/docker.sock:/var/run/docker.sock \
  --description $DESC
```

unregister a runner

```
docker run --rm -v $PWD/srv/gitlab-runner/config:/etc/gitlab-runner gitlab/gitlab-runner:latest unregister --url "http://172.16.100.102:25688/" --token "u-hXycxk5FQKZj-1LP1W"

```

## CICD

[all-docs](https://docs.gitlab.com/)

[docker-cicd](https://docs.gitlab.com/ee/ci/docker/using_docker_images.html)


```yml
image:
  name: linuxserver/docker-compose:2.12.2-v2
  pull_policy: if-not-present
  entrypoint: [""]

stages:
  - build
  - push

build-job:
  stage: build
  tags:
    - docker
  script:
    - docker build -t gluenet/glueui:v0.2 .
    - docker image prune -f

push-job:
  stage: build
  tags:
    - docker
  script:
    - echo "docker push gluenet/glueui:v0.2"
```

```yml
stages:
  - build
  - push

build-job:
  stage: build
  tags:
    - docker
    - "1038"
  script:
    - docker build -t gluenet/glueui:v0.2 .
    - docker image prune -f

push-job:
  stage: build
  tags:
    - docker
    - "1038"
  script:
    - docker push gluenet/glueui:v0.2
```