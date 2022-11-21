#!/bin/sh
cat > /data/manage/dev.yaml <<EOF
base:
  is_debug: true
  domain: "http://${web_ui:-web-ui}/"
  max_concurrency: ${MAX_RUNNER_CONCURRENCY:-1000}

http:
  port: ${manage_port:-8080}

mysql:
  username: "root"
  passport: "${MYSQL_ROOT_PASSWORD}"
  host: "mysql-db"
  port: 3306
  dbname: "${MYSQL_DATABASE:-kunpeng}"
  charset: "utf8mb4"

mongodb:
  dsn: "mongodb://${MONGO_INITDB_USERNAME:-kunpeng}:${MONGO_INITDB_PASSWORD:-kunpeng}@mongo-db:27017/${MONGO_INITDB_DATABASE:-kunpeng}"
  database: "${MONGO_INITDB_DATABASE:-kunpeng}"
  pool_size: 5

jwt:
  issuer: "kp"
  secret: "kp#123"

prometheus:
  host: ""
  port: 0

clients:
  runner:
    run_api: "http://runner:8002/runner/run_api"
    run_scene: "http://runner:8002/runner/run_scene"
    stop_scene: "http://runner:8002/runner/stop_scene"
    run_plan: "http://runner:8002/runner/run_plan"
    stop_plan: "http://runner:8002/runner/stop"

proof:
  info_log: "/dev/stdout"
  err_log: "/dev/stderr"

redis:
  address: "redis-db:6379"
  password: "${REDIS_PASSWD:-123123}"
  db: 0

redisReport:
  address: "redis-db:6379"
  password: "${REDIS_PASSWD:-123123}"
  db: 0

smtp:
  host: ""
  port: 0
  email: ""
  password: ""
EOF

exec "$@"
