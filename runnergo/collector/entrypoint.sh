#!/bin/sh

cat > /data/collector/dev.yaml <<EOF
http:
  host: "0.0.0.0:20125"


mongodb:
  dsn: "mongodb://${MONGO_INITDB_USERNAME:-kunpeng}:${MONGO_INITDB_PASSWORD:-kunpeng}@mongo-db:27017/${MONGO_INITDB_DATABASE:-kunpeng}?replicaSet=mgset-509843895"
  database: "${MONGO_INITDB_DATABASE:-kunpeng}"

jwt:
  issuer: "kp"
  secret: "kp#123"

prometheus:
  host: ""
  port: 0

kafka:
  host: "kafka:9092"
  topic: "report"
  key: "kafka:report:partition"

reportRedis:
  address: "redis-db:6379"
  password: "${REDIS_PASSWD:-123123}"
  db: 0

redis:
  address: "redis-db:6379"
  password: "${REDIS_PASSWD:-123123}"
  db: 0

log:
  path: "/data/logs/collector-info.log"

management:
  address: "http://manage:8080/management/api/v1/plan/notify_stop_stress"
EOF

exec "$@"
