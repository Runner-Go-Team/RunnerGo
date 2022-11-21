FROM  nginx:1.23.2-alpine

LABEL auths="jay@apipost.cn"

ENV  NGX_DOC_ROOT="/data"

COPY data   /data/

COPY runner.conf  /etc/nginx/conf.d/runner.conf

ADD entrypoint.sh /bin/

CMD ["/usr/sbin/nginx","-g","daemon off;"]

ENTRYPOINT ["/bin/entrypoint.sh"]


  
