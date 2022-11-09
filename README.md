![logo](https://apipost.oss-cn-beijing.aliyuncs.com/kunpeng/images/logo.png)  

## 基于go语言的一体化性能压测工具

RunnerGo是一款国内开发者自研的性能压测工具，可以进行接口测试、场景自动化测试、性能压测等一系列功能。

## 工具特性：
- go语言运行：基于go语言开发，运行速度快、更节省资源
- 智能调度算法：自研的调度算法，合理利用服务器资源，降低资源消耗
- 实时生成测试报告：运行任务后，可实时查看执行结果，快速诊断服务病症
- Flow场景流：可视化的业务流，通过连线就可快速搭建起来自己的业务流，还可直接调试运行场景，电流般的业务流转
- 多种压测模式：支持并发模式、阶梯模式、错误率模式、响应时间模式、每秒请求时间模式等多种压测模式，满足所有业务需求

![interface](https://apipost.oss-cn-beijing.aliyuncs.com/kunpeng/images/interface1.png)

### 生成报告
![report](https://apipost.oss-cn-beijing.aliyuncs.com/kunpeng/images/report.png)

### 官网地址
[http://www.runnergo.cn/](http://www.runnergo.cn/)

## 快速开始


```
#下载代码
git clone https://github.com/Runner-Go-Team/runner-go.git
# 启动
cd kunpeng # 进入到github 目录
docker-compose  up -d   # 启动
docker-compose  down -v # 删除
```



## 目录说明
```
├── collector
│   ├── build.sh
│   ├── Dockerfile
│   ├── entrypoint.sh
│   └── wait-for-it.sh
├── config
│   ├── config.env
├── docker-compose.yaml
├── file-server
│   ├── data
│   ├── Dockerfile
│   ├── file-server
│   └── file-server.tar.gz
├── kafka
├── manage
│   ├── Dockerfile
│   ├── entrypoint.sh
│   ├── manage
│   └── wait-for-it.sh
├── mongo
│   ├── data
│   └── init-mongo.sh
├── mysql
│   ├── data
│   ├── Dockerfile
│   ├── mysql.cnf
│   └── mysql.sql
├── nginx
│   ├── data
│   ├── Dockerfile
│   ├── entrypoint.sh
│   └── runner.conf
├── redis
│   └── data
└── runner
    ├── build.sh
    ├── Dockerfile
    ├── entrypoint.sh
    └── wait-for-it.sh
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
![qrcode](https://apipost.oss-cn-beijing.aliyuncs.com/kunpeng/images/qrcode.jpeg)
