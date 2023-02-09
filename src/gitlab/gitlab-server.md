# Gitlab Server

## 关联其他仓库

### 手动同步

**git设置多个远程仓库**

``` shell
# 查看当前远程仓库信息
$ git remove -v
```

为远程仓库增加额外的URL, 此后, git pull 仍然从初始的远程仓库拉取, 本地分支依然追踪初始的远程仓库, 只是在进行 push 同步远程时, 会额外地同步 `addtion_url` 所在的仓库

```shell
$ git remote set-url --add origin <addtion_url>

$ git remote -v
origin  <origin_url> (fetch)
origin  <origin_url> (push)
origin  <addtion_url> (push)
```

push 全部分支

```shell
$ git push --all origin

$ git pull --all origin
```

- [ ] 无法响应web端的合并, 需要手动同步

**mirror**

- [ ] 同步周期较长, 无法及时更新