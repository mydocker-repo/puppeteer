# 第一阶段构建基础puppeteer
FROM node:20-alpine AS builder
RUN apk add --no-cache python3 make g++
RUN npm config set registry https://registry.npmmirror.com/  && \
    npm cache clean --force
WORKDIR /app
RUN npm install puppeteer@latest --production --legacy-peer-deps

# 第二阶段打包镜像安装所需软件
FROM node:20-alpine
RUN apk add --no-cache \
    chromium  nss freetype harfbuzz ca-certificates ttf-freefont font-noto-cjk \
    openssh-client sshpass curl bash
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser \
    PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
COPY --from=builder /app/node_modules /root/node_modules

RUN echo "alias ll='ls -la'" > /root/.bashrc && \
    echo "PS1='\[\e[1;32m\][\W]\$\[\e[0m\] '" >> /root/.bashrc
WORKDIR /root
COPY package.json ./
COPY index.js ./
COPY entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh

# 最终命令：启动 cron 并给 shell
ENTRYPOINT ["/entrypoint.sh"]
CMD ["crond", "-f", "-l", "4"]
