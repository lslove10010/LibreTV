FROM fabiocicerchia/nginx-lua:1.27.5-alpine3.21.3
LABEL maintainer="LibreTV Team"
LABEL description="LibreTV - 免费在线视频搜索与观看平台"

# 复制应用文件
COPY . /usr/share/nginx/html

# 复制Nginx配置文件
COPY nginx.conf /etc/nginx/conf.d/default.conf

# 添加执行权限并设置为入口点脚本
COPY docker-entrypoint.sh /

RUN apt-get update &&\
    apt install --only-upgrade linux-libc-dev &&\
    apt-get install -y iproute2 vim netcat-openbsd &&\
    addgroup --gid 10014 choreo &&\
    adduser --disabled-password  --no-create-home --uid 10008 --ingroup choreo choreouser &&\
    usermod -aG sudo choreouser &&\
    chmod +x /docker-entrypoint.sh

# 暴露端口
EXPOSE 8080

# 设置入口点
ENTRYPOINT ["/docker-entrypoint.sh"]

# 启动nginx
CMD ["nginx", "-g", "daemon off;"]

# 健康检查
HEALTHCHECK --interval=30s --timeout=3s CMD wget --quiet --tries=1 --spider http://localhost/ || exit 1
USER 10014
