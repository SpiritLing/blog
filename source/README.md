# PAGES

当前为 hexo + next 生成的静态文件

总共有两个一个 dev 一个 master 生成的
dev生成的在 Coding 网站上[https://spiritling.coding.net/p/dev/d/dev/git/tree/dev-blog](https://spiritling.coding.net/p/dev/d/dev/git/tree/dev-blog)
master生成的在 github 网站上[https://github.com/SpiritLing/blog/tree/gh-pages](https://github.com/SpiritLing/blog/tree/gh-pages)

部署服务器使用docker

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