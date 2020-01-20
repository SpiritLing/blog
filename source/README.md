# Pages And Docker

当前为 hexo + next 生成的静态文件

- dev静态文件：[https://spiritling.coding.net/p/website/d/website/git/tree/blog/dev](https://spiritling.coding.net/p/website/d/website/git/tree/blog/dev)
- master静态文件：[https://spiritling.coding.net/p/website/d/website/git/tree/blog/master](https://spiritling.coding.net/p/website/d/website/git/tree/blog/master)

## 部署服务器

### 使用Docker直接部署，命令如下

```
# dev-blog-pages镜像部署
docker run \
-u root \
--name=dev-blog \
-d \
--restart=on-failure:10 \
-p 80:80 \
spiritling/dev-blog
```
[dev-blog镜像](https://hub.docker.com/repository/docker/spiritling/dev-blog)
```
# blog-pages镜像部署
docker run \
-u root \
--name=master-blog \
-d \
--restart=on-failure:10 \
-p 80:80 \
spiritling/master-blog
```
[master-blog镜像](https://hub.docker.com/repository/docker/spiritling/master-blog)

### 修改端口
修改 `80:80` 为 `8080:80` 则可以使用外部的 `8080` 端口访问