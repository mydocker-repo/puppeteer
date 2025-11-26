FROM node:20-alpine

# 安装所有依赖（构建 + 运行时）
RUN apk add --no-cache \
    chromium \
    nss \
    freetype \
    harfbuzz \
    ca-certificates \
    ttf-freefont \
    font-noto-cjk \
    python3 \
    make \
    g++

# npm 配置（加速 + 清理）
RUN npm config set registry https://registry.npmmirror.com/ && \
    npm cache clean --force

ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

WORKDIR /app
COPY package.json ./
RUN npm install --production --verbose --legacy-peer-deps
COPY index.js ./
COPY entrypoint.sh /entrypoint.sh
COPY crontab ./

# 创建 crontab（保留你之前的定时任务）
RUN mkdir -p /var/spool/cron/crontabs && \
    echo "# */2 * * * * /usr/bin/node /app/0.js >> /var/log/cron.log 2>&1" > /var/spool/cron/crontabs/root && \
    chmod 600 /var/spool/cron/crontabs/root && \
    touch /var/log/cron.log

# 最终命令：启动 cron 并给 shell
ENTRYPOINT ["/entrypoint.sh"]
CMD ["crond -f -l 4 && echo '定时任务已启动！直接敲 node xxx.js 运行脚本' && exec sh"]
