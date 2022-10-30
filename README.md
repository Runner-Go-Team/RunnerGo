# runner-go
RunnerGo是一款国内开发者自研的性能压测工具，可以进行接口测试、场景自动化测试、性能压测等一系列功能。

## 工具特性：
- go语言运行：基于go语言开发，运行速度快、更节省资源
- 智能调度算法：自研的调度算法，合理利用服务器资源，降低资源消耗
- 实时生成测试报告：运行任务后，可实时查看执行结果，快速诊断服务病症
- Flow场景流：可视化的业务流，通过连线就可快速搭建起来自己的业务流，还可直接调试运行场景，电流般的业务流转
- 多种压测模式：支持并发模式、阶梯模式、错误率模式、响应时间模式、每秒请求时间模式等多种压测模式，满足所有业务需


## 快速开始

```
# 启动
docker-compose -f runner-go-single.yaml
# 关闭
docker-compose -f runner-go-single.yaml down
```

## 目录说明
```
.                                                                 
├── config       #                                              
│   └── config.env      #env_file:                                 
├── docker-compose.yaml                                            
├── kafka                                                          
├── kp-manage                                                      
│   ├── Dockerfile                                                 
│   ├── entrypoint.sh                                              
│   ├── kp-manage                                                  
│   └── kp-manage.tar.gz                                           
├── kp-runner                                                      
│   ├── dev.yaml                                                   
│   ├── Dockerfile                                                 
│   ├── entrypoint.sh                                              
│   └── kp-runner                                                  
├── mongo                                                          
│   └── data                                                       
├── mysql                                                          
│   ├── data                                                       
│   ├── Dockerfile                                                 
│   └── mysql.sql                                                  
├── nginx                                                          
│   ├── data                                                       
│   └── kp-web-ui.conf                                    
└── redis                                                          
    └── data  
```

## 技术栈
- 后端: GoLang
- 前端: React.js
- 中间件: MySQL, MongoDB, Kafka, ZooKeeper, Redis
- 基础设施: Docker
- 测试引擎: GoLang

## 联系我们