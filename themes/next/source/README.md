```
docker run \
-u root \
--name=dev-blog \
-d \
--restart=on-failure:10 \
-p 80:80 \
dev-blog
```
修改 `80:80` 为 `8080:80` 则会使用外部的 `8080` 端口访问