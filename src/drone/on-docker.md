# On Docker
## Server

`DRONE_GITEE_CLIENT_ID` 与 `DRONE_GITEE_CLIENT_SECRET` 通过在 gitee 中创建第三方软件来获得，是 Server 与用户仓库建立联系的凭证，完成之后，Server 会获取用户所有的仓库信息

`DRONE_USER_CREATE` 用来设置用户权限，如为gitee用户 `gitee_rubbish` 赋予 `admin` 权限，从而允许在 `drone.yaml` 脚本中挂载主机目录

`DRONE_RPC_SECRET` 在Server与Runner之间相互鉴别，可以通过命令 `openssl rand -hex 16` 生成

`data` 用来存放 drone 启动后存储的用户/用户仓库信息

[更多Server配置](https://docs.drone.io/server/overview/)

```yaml
# docker-compose.yaml
version: "3"
services:
  drone:
    image: drone/drone:2
    container_name: drone
    volumes:
      - ./data:/data
    environment:
      - DRONE_GITEE_CLIENT_ID=de7cc4e88b554a04709c1dd526397e876d588c18cdeb0fe09a3ecbd65e92a830
      - DRONE_GITEE_CLIENT_SECRET=a6bc15901e3259ed0aa72f956aec05d25f813f609d636fde83b076a8ebb09244
      - DRONE_RPC_SECRET=36d7fe78a51c82e1ce275cede62a5ff0
      - DRONE_SERVER_HOST=124.222.198.37:10115
      - DRONE_SERVER_PROTO=http
      - DRONE_USER_CREATE=username:gitee_rubbish,admin:true
    ports:
      - 10116:80
    restart: always
```

## Runner

`DRONE_RPC_PROTO` `DRONE_RPC_HOST` `DRONE_RPC_SECRET` 根据要连接的 Server 填写， [更多Docker Runner配置](https://docs.drone.io/runner/docker/installation/linux/)

```yaml
version: "3"
services:
  drone-runner:
    image: drone/drone-runner-docker:1
    container_name: runner
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    environment:
      - DRONE_RPC_PROTO=http
      - DRONE_RPC_HOST=124.222.198.37:10115
      - DRONE_RPC_SECRET=36d7fe78a51c82e1ce275cede62a5ff0
      - DRONE_RUNNER_CAPACITY=2
      - DRONE_RUNNER_NAME=my-first-runner
    ports:
      - 3000:3000
    restart: always
```

## 初始化

Server 与 Runner 启动之后，首先访问 Server 的地址，其会跳转至 gitee 来进行授权，完成之后 gitee 会重定向到第三方应用中设置的地址，即drone入口，然后再初始化一个drone帐号，进入 dashboard 页面，页面中可以看到用户所有的仓库,

初始时所有仓库默认不激活，drone 不会对其进行管理，需要用户手动选择一个仓库之后，点击 `ACTIVATE REPOSITORY` 让drone进行接管，drone会在本地为该仓库创建记录，并在远端为此仓库添加webhook。随后用户每次提交，都会触发webhook然后通知drone, drone会自动触发build过程，前提是此分支的根目录下包含文件 `drone.yml`, 用户也可以使用 `NEW BUILD` 手动为此仓库创建一个Build过程，如果仓库目录下没有 `.drone.yml` 此操作???

## 设置CI

CI由多个 `step` 组成，Docker Runner中每个Step都是一个容器，默认第一个 step 是从远端clone代码到文件夹 `src` 中，并将其作为一个公共目录挂载到随后所有的step，并设置这些 workdir 为 `src`，[更多docker runner piplines configure](https://docs.drone.io/pipeline/docker/syntax/)

```yaml
kind: pipeline
type: docker
name: default

steps:
- name: compose
  image: alpinelinux/docker-compose:latest
  pull: if-not-exists
  environment:
    BOOK_NAME: cicddoc
    BOOK_PORT: 10102
  volumes:
  - name: docker
    path: /var/run/docker.sock
  commands:
  - printenv
  - docker-compose down --rmi all
  - docker-compose up --build -d

volumes:
- name: docker
  host:
    path: /var/run/docker.sock
```

