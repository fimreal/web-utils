FROM openresty/openresty:alpine

# Copy supervisord bin command
COPY --from=ochinchina/supervisord:latest /usr/local/bin/supervisord /usr/local/bin/supervisord
CMD ["/usr/local/bin/supervisord"]

# Motify timezone as needed
ENV TZ="Asia/Shanghai"

# Apk mirrors proxy in China
# RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories

# default: php83
RUN apk add --no-cache php-fpm php-pdo_mysql php-tokenizer \
    php-xml php-pdo php-phar php-openssl php-pdo_pgsql\
    php-json php-pdo_mysql php-mysqli php-session \
    php-pdo_sqlite php-sqlite3 php-exif php-intl \
    php-gd php-iconv php-gmp php-zip \
    php-curl php-opcache php-ctype php-apcu \
    php-intl php-bcmath php-dom php-mbstring php-xmlreader \
    php-pecl-memcache php-pecl-redis php-ftp \
    curl openssl tzdata &&\
    sed -i 's/expose_php = On/expose_php = Off/g;s/post_max_size = 8M/post_max_size = 0/g;s/upload_max_filesize = 2M/upload_max_filesize = 100M/g' /etc/php83/php.ini 

VOLUME ["/wwwroot"]

ADD ./nginx.conf /etc/nginx/conf.d/nginx.conf
ADD ./supervisord.conf /etc/supervisord.conf

EXPOSE 80

ADD --chown=65534:65534 . /wwwroot 
