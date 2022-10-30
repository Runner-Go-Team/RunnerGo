#!/bin/sh
#cat > /etc/nginx/conf.d/runner.conf <<EOF
#server {
#    listen   0.0.0.0:${RUNNER_UI_PORT:-80};
#    server_name   $HOSTNAME;
#    root   ${NGX_DOC_ROOT:-/usr/share/nginx/html};
#    index  index.html;
#    location / {
#        try_files \$uri /\$uri /index.html;
#    }
#}
#EOF

exec "$@"
