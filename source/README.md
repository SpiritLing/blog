# Pages And Docker

当前为 hexo + next 生成的静态文件

- dev静态文件：[https://spiritling.coding.net/p/dev/d/dev/git/tree/dev-blog](https://spiritling.coding.net/p/dev/d/dev/git/tree/dev-blog)
- master静态文件：[https://github.com/SpiritLing/blog/tree/gh-pages](https://github.com/SpiritLing/blog/tree/gh-pages)

## 部署服务器

### 使用Docker直接部署，命令如下

```
# dev-blog-pages镜像部署
docker run \
-u root \
--name=dev-blog-pages \
-d \
--restart=on-failure:10 \
-p 80:80 \
spiritling/dev-blog-pages
```
[dev-blog-pages镜像](https://hub.docker.com/repository/docker/spiritling/dev-blog-pages)
```
# blog-pages镜像部署
docker run \
-u root \
--name=blog-pages \
-d \
--restart=on-failure:10 \
-p 80:80 \
spiritling/blog-pages
```
[blog-pages镜像](https://hub.docker.com/repository/docker/spiritling/blog-pages)

### 修改端口
修改 `80:80` 为 `8080:80` 则可以使用外部的 `8080` 端口访问