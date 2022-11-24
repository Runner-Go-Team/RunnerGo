#!/bin/sh

cat > /data/runner/dev.yaml <<EOF
heartbeat:
  port: 8002
  region: "北京"
  duration: 3
  resources: 5
  grpcHost: "kpcontroller.apipost.cn:443"


http:
  address: "0.0.0.0:8002"
  port: 8002
  readTimeout: 5000
  writeTimeout: 5000
  noDefaultUserAgentHeader: true
  maxConnPerHost: 10000
  MaxIdleConnDuration: 5000
  NoDefaultUserAgentHeader: 30000

redis:
  address: "redis-db:6379"
  password: "${REDIS_PASSWD:-123123}"
  db: 0

reportRedis:
  address: "redis-db:6379"
  password: "${REDIS_PASSWD:-123123}"
  db: 0

kafka:
  address: "kafka:9092"
  topIc: "report"


mongo:
  db: "${MONGO_INITDB_DATABASE:-kunpeng}"
  user: "${MONGO_INITDB_USERNAME:-kunpeng}"
  password: "${MONGO_INITDB_PASSWORD:-kunpeng}"
  stressDebugTable: "stress_debug"
  sceneDebugTable: "scene_debug"
  apiDebugTable: "api_debug"
  debugTable: "debug_status"
  address: "mongo-db:27017"


machine:
  maxGoroutines: 20005
  serverType: 1
  netName: ""
  diskName: ""

log:
  path: "/data/log.log"


management:
  address: "http://manage:8080/management/api/v1/plan/notify_stop_stress"
EOF

exec "$@"
