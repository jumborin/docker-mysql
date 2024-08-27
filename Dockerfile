FROM ubuntu:noble-20240605

LABEL maintainer="jumborin"

ENV MYSQL_USER=mysql \
    MYSQL_VERSION=8.0.39 \
    MYSQL_DATA_DIR=/var/lib/mysql \
    MYSQL_RUN_DIR=/run/mysqld \
    MYSQL_LOG_DIR=/var/log/mysql \
    TZ=Asia/Tokyo

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      mysql-server=${MYSQL_VERSION}* \
      tzdata \
    && rm -rf ${MYSQL_DATA_DIR} \
    && rm -rf /var/lib/apt/lists/* \
    && ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime \
    && dpkg-reconfigure -f noninteractive tzdata
    
COPY entrypoint.sh /sbin/entrypoint.sh

RUN chmod 755 /sbin/entrypoint.sh

EXPOSE 3306/tcp

ENTRYPOINT ["/sbin/entrypoint.sh"]

RUN set -ux \
    \
    && echo "default-character-set = utf8mb4" >> /etc/mysql/conf.d/mysql.cnf \
    && echo "character-set-server = utf8mb4" >> /etc/mysql/mysql.conf.d/mysqld.cnf

CMD ["/usr/bin/mysqld_safe"]
