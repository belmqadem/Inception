FROM debian:bullseye

RUN apt update -y && apt upgrade -y && \
    apt install -y curl php7.4 php-fpm php-mysql mariadb-client && \
    apt clean && rm -rf /var/lib/apt/lists/*

COPY conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf

COPY tools/wordpress.sh /usr/local/bin/wordpress.sh
RUN chmod +x /usr/local/bin/wordpress.sh

CMD ["/usr/local/bin/wordpress.sh"]