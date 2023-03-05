![logo](https://apipost.oss-cn-beijing.aliyuncs.com/kunpeng/images/log.png)

## 基于go语言的一体化性能压测工具

RunnerGo致力于打造成一款全栈式测试平台，采用了较为宽松的Apache-2.0 license开源协议，方便志同道合的朋友一起为开源贡献力量，目前实现了接口测试、场景自动化测试、性能测试等测试能力。随着不断的迭代，我们将会推出更多的测试功能。我们的目的是为研发赋能，让测试更简单。

## 工具特性：
- go语言运行：基于go语言开发，运行速度快、更节省资源
- 智能调度算法：自研的调度算法，合理利用服务器资源，降低资源消耗
- 实时生成测试报告：运行任务后，可实时查看执行结果，快速诊断服务病症
- 丰富的报告图表： 全方位展示各个指标运行曲线图
- 实时修改： 可根据压测模式实时修改并发数、持续时长等
- 实时日志： 可在压测过程中开启日志模式，查看请求响应信息
- 可编辑报告：可在任务运行结束后，针对测试结果进行测试分析，实时编写报告
- Flow场景流：可视化的业务流，通过连线就可快速搭建起来自己的业务流，还可直接调试运行场景，电流般的业务流转
- 多种压测模式：支持并发模式、阶梯模式、错误率模式、响应时间模式、每秒应答数模式等多种压测模式，满足所有业务需求
- 自持接口自动化，采用用例集概念，生成丰富的自动化报告

![interface](https://img.cdn.apipost.cn/runnergo/images/index.jpeg)

### 生成报告
![report](https://img.cdn.apipost.cn/runnergo/images/report.jpeg)

### 官网地址
[http://www.runnergo.cn/](http://www.runnergo.com/)

## 快速开始

仅限linux和macos, 建议使用8c16g配置以上的服务器，配置较低的服务器，可能会报资源不足！！！
1. 准备docker 和 docker-compose 环境
2. 从github 下载Runnergo 开源版本
3. cd runnergo 进入到目录
## 目录说明
```
├── config.env           #  环境变量配置文件
├── docker-compose.yaml  # docker-compose 文件
├── mongo                # mongo 初始化相关脚本
│   └── init-mongo.sh 
└── mysql                 # MySQL相关配置和脚本
    ├── mysql.cnf
    └── mysql.sql
```

4. 配置文件修改, 默认基本可以不用改`config.env`
```bash
# 数据库root密码
MYSQL_ROOT_PASSWORD=123456
# runnergo 使用的数据库名
MYSQL_DATABASE=runnergo
# redis 初始话
REDIS_PASSWD=mypassword
# Mongo数据管理员的用户名
MONGO_INITDB_ROOT_USERNAME=root
# Mongo 数据库管理员的账号
MONGO_INITDB_ROOT_PASSWORD=root
# runnergo  Mongo使用的数据库名
MONGO_INITDB_DATABASE=runnergo
# runnergo Mongo库的用户名
MONGO_INITDB_USERNAME=runnergo
# runnergo Mongo库的密码
MONGO_INITDB_PASSWORD=hello123456
# 最大并非数
MAX_RUNNER_CONCURRENCY=1000
# 上传文件端口号（非必要不要改，这是容器里的）
FILE_SERVER_PORT=80
# Runnergo 应用mongo 配置
RG_MONGO_DSN=mongodb://${MONGO_INITDB_USERNAME}:${MONGO_INITDB_PASSWORD}@mongo-db:27017/${MONGO_INITDB_DATABASE}
RG_MONGO_DATABASE=${MONGO_INITDB_DATABASE}
RG_REDIS_ADDRESS=redis-db:6379
RG_REDIS_PASSWORD=${REDIS_PASSWD}
RG_REDIS_DB=0
# kafka Topic
RG_KAFKA_TOPIC=report
# kafka 地址（如果使用容器不要更改）
RG_KAFKA_ADDRESS=kafka:9092
# kafka 端口号
RG_KAFKA_PORT=9092
# kafka 分区数，（同时并行跑多少任务）
RG_KAFKA_NUM=2
# engine 日志路径
RG_ENGINE_LOG_PATH=/dev/stdout
# collector 日志路径
RG_COLLECTOR_LOG_PATH=/dev/stdout
# 内部互通参数（不要更改）
RG_MANAGEMENT_NOTIFY_STOP_STRESS=http://manage:30000/management/api/v1/plan/notify_stop_stress
RG_MANAGEMENT_NOTIFY_RUN_FINISH=http://manage:30000/management/api/v1/auto_plan/notify_run_finish
RG_DOMAIN=
# mysql  地址
RG_MYSQL_HOST=mysql-db
# mysql  用户
RG_MYSQL_USERNAME=root
# MySQL 密码
RG_MYSQL_PASSWORD=${MYSQL_ROOT_PASSWORD}
# mysql 数据库
RG_MYSQL_DBNAME=${MYSQL_DATABASE}
# JWT
RG_JWT_ISSUER=asfdasfasdfasfd
RG_JWT_SECRET=sdfaswerwrwerwerwer
# MONG
RG_MONGO_PASSWORD=${MONGO_INITDB_PASSWORD}
#  内部互通参数（不要更改）
RG_CLIENTS_ENGINE_RUN_API=http://engine:30000/runner/run_api
RG_CLIENTS_ENGINE_RUN_SCENE=http://engine:30000/runner/run_scene
RG_CLIENTS_ENGINE_STOP_SCENE=http://engine:30000/runner/stop_scene
RG_CLIENTS_ENGINE_RUN_PLAN=http://engine:30000/runner/run_plan
RG_CLIENTS_ENGINE_STOP_PLAN=http://engine:30000/runner/stop
RG_REDIS_REPORT_ADDRESS=redis-db:6379
# #初始化压力机可使用分区
RG_CAN_USE_PARTITION_TOTAL_NUM=${RG_KAFKA_NUM}

## KAFKA 配置
KAFKA_ZOOKEEPER_CONNECT="zookeeper:2181/kafka"
KAFKA_LISTENERS="PLAINTEXT://:9092"
KAFKA_BROKER_ID=0
KAFKA_CREATE_TOPICS="${RG_KAFKA_TOPIC}:${RG_KAFKA_NUM}:1"
```
> 这里要注意点的是redis 密码 这边修改完毕，需要在`docker-compose.yaml`文件中修改如下

![image.png](https://cdn.nlark.com/yuque/0/2023/png/21596669/1677909335248-3196ecbe-1cca-4f6d-9fe7-7ccb4306d366.png#averageHue=%23332622&clientId=u76a21a17-0a80-4&from=paste&height=388&id=u2a967d06&name=image.png&originHeight=388&originWidth=986&originalType=binary&ratio=1&rotation=0&showTitle=false&size=37278&status=done&style=none&taskId=ud0d71f5b-6594-44c7-b825-6834223e00b&title=&width=986)

4. 修改应用暴露的端口号

默认使用是tcp的`9999`端口号，这个是可以修改的  ![image.png](https://cdn.nlark.com/yuque/0/2023/png/21596669/1677909453034-a7fd111b-7df9-4535-8903-049a03fa4b43.png#averageHue=%23322420&clientId=u76a21a17-0a80-4&from=paste&height=164&id=u96774530&name=image.png&originHeight=164&originWidth=986&originalType=binary&ratio=1&rotation=0&showTitle=false&size=14903&status=done&style=none&taskId=u4ecd8c1f-f405-4e68-986d-6afb11ac8d7&title=&width=986)
目前用户只能修改这一个对外访问的端口号，我们这里还用到了tcp`58888``58889`这两个端口号，暂时不可修改，如果本地冲突，则需要看看是否这两个端口号冲突。

5. 启动runnergo
```bash
docker-compose up -d 
```
由于启动的中间件多，请耐心等待2分钟然后使用下面命令查看是否都启动成功
```bash
docker-compose ps 
```

6. 关闭runnergo
```bash
docker-compse stop  

```

7. 删除
```bash
docker-compse down -v 
```



## 技术栈
- 后端: GoLang
- 前端: React.js
- 中间件: MySQL, MongoDB, Kafka, ZooKeeper, Redis
- 基础设施: Docker
- 测试引擎: GoLang

## 技术架构
![struct](https://apipost.oss-cn-beijing.aliyuncs.com/kunpeng/images/struct.png)

## 业务流转图
![flow](https://apipost.oss-cn-beijing.aliyuncs.com/kunpeng/images/flow.png)

## 联系我们
![qrcode](https://apipost.oss-cn-beijing.aliyuncs.com/kunpeng/lianxi.png)
