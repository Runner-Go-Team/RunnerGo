


#


#






/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
SET NAMES utf8mb4;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE='NO_AUTO_VALUE_ON_ZERO', SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;





DROP TABLE IF EXISTS `auto_plan`;

CREATE TABLE `auto_plan` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `plan_id` varchar(100) NOT NULL COMMENT '计划ID',
  `rank_id` bigint(10) NOT NULL DEFAULT '0' COMMENT '序号ID',
  `team_id` varchar(100) NOT NULL COMMENT '团队ID',
  `plan_name` varchar(255) NOT NULL COMMENT '计划名称',
  `task_type` tinyint(2) NOT NULL DEFAULT '1' COMMENT '计划类型：1-普通任务，2-定时任务',
  `status` tinyint(2) NOT NULL DEFAULT '1' COMMENT '计划状：1-未开始，2-进行中',
  `create_user_id` varchar(100) NOT NULL COMMENT '创建人id',
  `run_user_id` varchar(100) NOT NULL COMMENT '运行人id',
  `remark` text COMMENT '备注',
  `run_count` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '运行次数',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted_at` datetime DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='自动化测试-计划表';






DROP TABLE IF EXISTS `auto_plan_email`;

CREATE TABLE `auto_plan_email` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `plan_id` varchar(100) NOT NULL DEFAULT '0' COMMENT '计划ID',
  `team_id` varchar(100) NOT NULL COMMENT '团队ID',
  `email` varchar(255) NOT NULL COMMENT '邮箱',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `deleted_at` datetime DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='自动化测计划—收件人邮箱表';






DROP TABLE IF EXISTS `auto_plan_report`;

CREATE TABLE `auto_plan_report` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `report_id` varchar(100) NOT NULL COMMENT '报告ID',
  `plan_id` varchar(100) NOT NULL COMMENT '计划ID',
  `rank_id` bigint(20) NOT NULL DEFAULT '0' COMMENT '序号ID',
  `plan_name` varchar(255) NOT NULL COMMENT '计划名称',
  `team_id` varchar(100) NOT NULL COMMENT '团队ID',
  `task_type` int(11) NOT NULL DEFAULT '0' COMMENT '任务类型',
  `task_mode` int(11) NOT NULL DEFAULT '0' COMMENT '运行模式：1-按测试用例运行',
  `control_mode` tinyint(2) NOT NULL DEFAULT '0' COMMENT '控制模式：0-集中模式，1-单独模式',
  `scene_run_order` tinyint(2) NOT NULL DEFAULT '1' COMMENT '场景运行次序：1-顺序执行，2-同时执行',
  `test_case_run_order` tinyint(2) NOT NULL DEFAULT '1' COMMENT '测试用例运行次序：1-顺序执行，2-同时执行',
  `run_duration_time` bigint(20) NOT NULL DEFAULT '0' COMMENT '任务运行持续时长',
  `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '报告状态1:进行中，2:已完成',
  `run_user_id` varchar(100) NOT NULL DEFAULT '0' COMMENT '启动人id',
  `remark` text NOT NULL COMMENT '备注',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间（执行时间）',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted_at` datetime DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='自动化测试计划-报告表';






DROP TABLE IF EXISTS `auto_plan_task_conf`;

CREATE TABLE `auto_plan_task_conf` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '配置ID',
  `plan_id` varchar(100) NOT NULL DEFAULT '0' COMMENT '计划ID',
  `team_id` varchar(100) NOT NULL COMMENT '团队ID',
  `task_type` tinyint(2) NOT NULL DEFAULT '0' COMMENT '任务类型：1-普通模式，2-定时任务',
  `task_mode` tinyint(2) NOT NULL DEFAULT '1' COMMENT '运行模式：1-按照用例执行',
  `scene_run_order` tinyint(2) NOT NULL DEFAULT '1' COMMENT '场景运行次序：1-顺序执行，2-同时执行',
  `test_case_run_order` tinyint(2) NOT NULL DEFAULT '1' COMMENT '用例运行次序：1-顺序执行，2-同时执行',
  `run_user_id` varchar(100) NOT NULL DEFAULT '0' COMMENT '运行人用户ID',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted_at` datetime DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='自动化测试—普通任务配置表';






DROP TABLE IF EXISTS `auto_plan_timed_task_conf`;

CREATE TABLE `auto_plan_timed_task_conf` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '表id',
  `plan_id` varchar(100) NOT NULL DEFAULT '0' COMMENT '计划id',
  `team_id` varchar(100) NOT NULL COMMENT '团队id',
  `frequency` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '任务执行频次: 0-一次，1-每天，2-每周，3-每月',
  `task_exec_time` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '任务执行时间',
  `task_close_time` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '任务结束时间',
  `task_type` tinyint(2) NOT NULL DEFAULT '2' COMMENT '任务类型：1-普通任务，2-定时任务',
  `task_mode` tinyint(2) NOT NULL DEFAULT '1' COMMENT '运行模式：1-按照用例执行',
  `scene_run_order` tinyint(2) NOT NULL DEFAULT '1' COMMENT '场景运行次序：1-顺序执行，2-同时执行',
  `test_case_run_order` tinyint(2) NOT NULL DEFAULT '1' COMMENT '测试用例运行次序：1-顺序执行，2-同时执行',
  `status` tinyint(2) NOT NULL DEFAULT '0' COMMENT '任务状态：0-未启用，1-运行中，2-已过期',
  `run_user_id` varchar(100) NOT NULL DEFAULT '0' COMMENT '运行人用户ID',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted_at` datetime DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='自动化测试-定时任务配置表';






DROP TABLE IF EXISTS `invoice`;

CREATE TABLE `invoice` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `order_id` varchar(100) NOT NULL COMMENT '订单id',
  `team_id` varchar(100) NOT NULL COMMENT '团队id',
  `user_id` varchar(100) NOT NULL DEFAULT '0' COMMENT '开发票人id',
  `invoice_title` varchar(200) NOT NULL COMMENT '发票抬头',
  `invoice_type` tinyint(4) NOT NULL DEFAULT '1' COMMENT '发票类型：1-普通发票，2-专业发票',
  `tax_num` varchar(100) DEFAULT NULL COMMENT '纳税识别号',
  `company_address` varchar(200) NOT NULL COMMENT '公司地址（开票地址）',
  `phone` varchar(50) NOT NULL DEFAULT '0' COMMENT '电话号码',
  `open_bank_name` varchar(200) NOT NULL COMMENT '开户银行名称',
  `bank_account_num` varchar(100) NOT NULL COMMENT '开户行账号',
  `receive_email` varchar(100) NOT NULL COMMENT '接受邮箱',
  `receiver_name` varchar(100) NOT NULL COMMENT '收件人姓名',
  `receiver_phone` varchar(20) NOT NULL COMMENT '收件人电话',
  `receiver_address` varchar(200) NOT NULL COMMENT '收件人地址',
  `open_invoice_mode` tinyint(2) NOT NULL DEFAULT '1' COMMENT '开票方式：1-专票-电子票，2-专票-邮寄',
  `open_invoice_state` tinyint(2) NOT NULL DEFAULT '0' COMMENT '发票申请状态：0-待开票，1-已开票，2-已作废',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `deleted_at` datetime DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='发票表';






DROP TABLE IF EXISTS `machine`;

CREATE TABLE `machine` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `region` varchar(64) NOT NULL COMMENT '所属区域',
  `ip` varchar(16) NOT NULL COMMENT '机器IP',
  `port` int(11) unsigned NOT NULL COMMENT '端口',
  `name` varchar(200) NOT NULL COMMENT '机器名称',
  `cpu_usage` float unsigned NOT NULL DEFAULT '0' COMMENT 'CPU使用率',
  `cpu_load_one` float unsigned NOT NULL DEFAULT '0' COMMENT 'CPU-1分钟内平均负载',
  `cpu_load_five` float unsigned NOT NULL DEFAULT '0' COMMENT 'CPU-5分钟内平均负载',
  `cpu_load_fifteen` float unsigned NOT NULL DEFAULT '0' COMMENT 'CPU-15分钟内平均负载',
  `mem_usage` float unsigned NOT NULL DEFAULT '0' COMMENT '内存使用率',
  `disk_usage` float unsigned NOT NULL DEFAULT '0' COMMENT '磁盘使用率',
  `max_goroutines` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '最大协程数',
  `current_goroutines` bigint(20) NOT NULL DEFAULT '0' COMMENT '已用协程数',
  `server_type` tinyint(2) unsigned NOT NULL DEFAULT '1' COMMENT '机器类型：1-主力机器，2-备用机器',
  `status` tinyint(2) unsigned NOT NULL DEFAULT '1' COMMENT '机器状态：1-使用中，2-已卸载',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `deleted_at` datetime DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`),
  KEY `machine_region_ip_status_index` (`region`,`ip`,`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='压力测试机器表';






DROP TABLE IF EXISTS `operation`;

CREATE TABLE `operation` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `team_id` varchar(100) NOT NULL COMMENT '团队ID',
  `user_id` varchar(100) NOT NULL COMMENT '用户ID',
  `category` tinyint(4) NOT NULL DEFAULT '0' COMMENT '日志类型：1-新建，2-修改，3-删除，4-运行，5-调试，6-执行',
  `operate` tinyint(4) DEFAULT NULL COMMENT '{"操作类型":{1:创建文件夹,2:创建接口,3:创建分组,4:创建计划,5:创建场景,6:修改文件夹,7:修改接口,8:修改分组,9:修改计划,10:修改场景,11:克隆计划,12:删除报告,13:删除场景,14:删除计划,15:运行场景,16:运行计划,17:新建预设配置,18:修改并保存预设配置,19:删除预设配置}}',
  `name` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;






DROP TABLE IF EXISTS `order`;

CREATE TABLE `order` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `order_id` varchar(200) NOT NULL COMMENT '订单号id',
  `pay_trade_no` varchar(200) NOT NULL COMMENT '支付中心订单号',
  `trade_no` varchar(200) NOT NULL COMMENT '第三方订单号',
  `team_id` varchar(100) NOT NULL COMMENT '团队id',
  `googs_name` varchar(200) NOT NULL COMMENT '商品名称',
  `order_type` tinyint(2) NOT NULL DEFAULT '0' COMMENT '订单类型：1-新建团队，2-VUM资源包，3-升级团队，4-增加席位，5-套餐续期',
  `vum_buy_version_type` tinyint(2) NOT NULL DEFAULT '0' COMMENT 'VUM套餐类型：1-A,2-B,3-C,4-D',
  `team_buy_version_type` tinyint(2) NOT NULL DEFAULT '0' COMMENT '团队套餐类型：1-个人版，2-团队版，3-企业版',
  `max_concurrence` int(11) NOT NULL DEFAULT '0' COMMENT '最大并发数',
  `buy_number` bigint(20) NOT NULL DEFAULT '0' COMMENT '购买数量（席位数量/VUM资源包数量）',
  `order_amount` double NOT NULL DEFAULT '0' COMMENT '订单金额',
  `discounts` double NOT NULL DEFAULT '0' COMMENT '优惠金额',
  `real_amount` double NOT NULL DEFAULT '0' COMMENT '实际付款金额',
  `pay_type` tinyint(4) NOT NULL DEFAULT '1' COMMENT '支付方式：0-未知，1-微信，2-支付宝，3-银联，4-PayPal',
  `pay_status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '支付状态：0-待支付，1-支付成功，2-支付失败，3-支付中，4-已过期，5-已关闭',
  `goods_valid_date` int(11) NOT NULL DEFAULT '0' COMMENT '商品的有效期（单位：月）',
  `finish_pay_time` datetime DEFAULT NULL COMMENT '到账时间',
  `open_invoice_state` tinyint(2) NOT NULL DEFAULT '0' COMMENT '发票申请状态：0-待开票，1-已开票，2-已作废',
  `pay_user_id` varchar(100) NOT NULL DEFAULT '0' COMMENT '支付人id',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted_at` datetime DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='订单表';






DROP TABLE IF EXISTS `preinstall_conf`;

CREATE TABLE `preinstall_conf` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `conf_name` varchar(100) NOT NULL COMMENT '配置名称',
  `team_id` varchar(100) NOT NULL COMMENT '团队ID',
  `user_id` varchar(100) NOT NULL DEFAULT '0' COMMENT '用户ID',
  `user_name` varchar(64) NOT NULL COMMENT '用户名称',
  `task_type` tinyint(2) NOT NULL DEFAULT '0' COMMENT '任务类型',
  `task_mode` tinyint(2) NOT NULL DEFAULT '0' COMMENT '压测模式',
  `control_mode` tinyint(2) NOT NULL DEFAULT '0' COMMENT '控制模式：0-集中模式，1-单独模式',
  `mode_conf` text NOT NULL COMMENT '压测配置详情',
  `timed_task_conf` text NOT NULL COMMENT '定时任务相关配置',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted_at` timestamp NULL DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='预设配置表';






DROP TABLE IF EXISTS `report_machine`;

CREATE TABLE `report_machine` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `report_id` varchar(100) NOT NULL COMMENT '报告id',
  `plan_id` varchar(100) NOT NULL DEFAULT '0' COMMENT '计划ID',
  `team_id` varchar(100) NOT NULL COMMENT '团队ID',
  `ip` varchar(15) NOT NULL COMMENT '机器ip',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted_at` datetime DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;






DROP TABLE IF EXISTS `setting`;

CREATE TABLE `setting` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` varchar(100) NOT NULL COMMENT '用户id',
  `team_id` varchar(100) NOT NULL COMMENT '当前团队id',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `setting_user_id_uindex` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='设置表';






DROP TABLE IF EXISTS `sms_log`;

CREATE TABLE `sms_log` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `type` tinyint(2) NOT NULL COMMENT '短信类型: 1-注册，2-登录，3-找回密码',
  `mobile` char(11) NOT NULL DEFAULT '' COMMENT '手机号',
  `content` varchar(200) NOT NULL COMMENT '短信内容',
  `verify_code` varchar(20) NOT NULL COMMENT '验证码',
  `verify_code_expiration_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '验证码有效时间',
  `client_ip` varchar(100) NOT NULL DEFAULT '' COMMENT '客户端IP',
  `send_status` tinyint(2) NOT NULL DEFAULT '1' COMMENT '发送状态：1-成功 2-失败',
  `verify_status` tinyint(2) NOT NULL DEFAULT '1' COMMENT '校验状态：1-未校验 2-已校验',
  `send_response` text NOT NULL COMMENT '短信服务响应',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `deleted_at` datetime DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`),
  KEY `idx_type_mobile_verify_code` (`type`,`mobile`,`verify_code`,`verify_code_expiration_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='短信发送记录表';






DROP TABLE IF EXISTS `stress_plan`;

CREATE TABLE `stress_plan` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `plan_id` varchar(100) NOT NULL DEFAULT '0' COMMENT '计划ID',
  `team_id` varchar(100) NOT NULL COMMENT '团队ID',
  `rank_id` bigint(20) NOT NULL DEFAULT '0' COMMENT '序号ID',
  `plan_name` varchar(255) NOT NULL COMMENT '计划名称',
  `task_type` tinyint(2) NOT NULL DEFAULT '0' COMMENT '计划类型：1-普通任务，2-定时任务',
  `task_mode` tinyint(2) NOT NULL DEFAULT '0' COMMENT '压测类型: 1-并发模式，2-阶梯模式，3-错误率模式，4-响应时间模式，5-每秒请求数模式，6-每秒事务数模式',
  `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '计划状态1:未开始,2:进行中',
  `create_user_id` varchar(100) NOT NULL DEFAULT '0' COMMENT '创建人id',
  `run_user_id` varchar(100) NOT NULL DEFAULT '0' COMMENT '运行人id',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `run_count` bigint(20) unsigned DEFAULT '0' COMMENT '运行次数',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `deleted_at` datetime DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='性能计划表';






DROP TABLE IF EXISTS `stress_plan_email`;

CREATE TABLE `stress_plan_email` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `plan_id` varchar(100) NOT NULL COMMENT '计划ID',
  `team_id` varchar(100) NOT NULL COMMENT '团队ID',
  `email` varchar(255) DEFAULT NULL COMMENT '邮箱',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `deleted_at` datetime DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='性能计划收件人';






DROP TABLE IF EXISTS `stress_plan_report`;

CREATE TABLE `stress_plan_report` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `report_id` varchar(100) NOT NULL COMMENT '报告ID',
  `team_id` varchar(100) NOT NULL COMMENT '团队ID',
  `plan_id` varchar(100) NOT NULL COMMENT '计划ID',
  `rank_id` bigint(20) NOT NULL DEFAULT '0' COMMENT '序号ID',
  `plan_name` varchar(255) NOT NULL COMMENT '计划名称',
  `scene_id` varchar(100) NOT NULL COMMENT '场景ID',
  `scene_name` varchar(255) NOT NULL COMMENT '场景名称',
  `task_type` int(11) NOT NULL COMMENT '任务类型',
  `task_mode` int(11) NOT NULL COMMENT '压测模式',
  `control_mode` tinyint(2) NOT NULL DEFAULT '0' COMMENT '控制模式：0-集中模式，1-单独模式',
  `status` tinyint(4) NOT NULL COMMENT '报告状态1:进行中，2:已完成',
  `remark` text NOT NULL COMMENT '备注',
  `run_user_id` varchar(100) NOT NULL COMMENT '启动人id',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间（执行时间）',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `deleted_at` datetime DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='性能测试报告表';






DROP TABLE IF EXISTS `stress_plan_task_conf`;

CREATE TABLE `stress_plan_task_conf` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '配置ID',
  `plan_id` varchar(100) NOT NULL DEFAULT '0' COMMENT '计划ID',
  `team_id` varchar(100) NOT NULL COMMENT '团队ID',
  `scene_id` varchar(100) NOT NULL COMMENT '场景ID',
  `task_type` tinyint(2) NOT NULL DEFAULT '0' COMMENT '任务类型：1-普通模式，2-定时任务',
  `task_mode` tinyint(2) NOT NULL DEFAULT '0' COMMENT '压测模式：1-并发模式，2-阶梯模式，3-错误率模式，4-响应时间模式，5-每秒请求数模式，6-每秒事务数模式',
  `control_mode` tinyint(2) NOT NULL DEFAULT '0' COMMENT '控制模式：0-集中模式，1-单独模式',
  `mode_conf` text NOT NULL COMMENT '压测模式配置详情',
  `run_user_id` varchar(100) NOT NULL DEFAULT '0' COMMENT '运行人用户ID',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted_at` datetime DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='性能计划—普通任务配置表';






DROP TABLE IF EXISTS `stress_plan_timed_task_conf`;

CREATE TABLE `stress_plan_timed_task_conf` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '表id',
  `plan_id` varchar(100) NOT NULL COMMENT '计划id',
  `sence_id` varchar(100) NOT NULL COMMENT '场景id',
  `team_id` varchar(100) NOT NULL COMMENT '团队id',
  `user_id` varchar(100) NOT NULL COMMENT '用户ID',
  `frequency` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '任务执行频次: 0-一次，1-每天，2-每周，3-每月',
  `task_exec_time` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '任务执行时间',
  `task_close_time` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '任务结束时间',
  `task_type` tinyint(2) NOT NULL DEFAULT '2' COMMENT '任务类型：1-普通任务，2-定时任务',
  `task_mode` tinyint(2) NOT NULL DEFAULT '1' COMMENT '压测模式：1-并发模式，2-阶梯模式，3-错误率模式，4-响应时间模式，5-每秒请求数模式，6 -每秒事务数模式',
  `control_mode` tinyint(2) NOT NULL DEFAULT '0' COMMENT '控制模式：0-集中模式，1-单独模式',
  `mode_conf` text NOT NULL COMMENT '压测详细配置',
  `run_user_id` varchar(100) NOT NULL DEFAULT '0' COMMENT '运行人ID',
  `status` tinyint(11) NOT NULL DEFAULT '0' COMMENT '任务状态：0-未启用，1-运行中，2-已过期',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted_at` datetime DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='性能计划-定时任务配置表';






DROP TABLE IF EXISTS `target`;

CREATE TABLE `target` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `target_id` varchar(100) NOT NULL COMMENT '全局唯一ID',
  `team_id` varchar(100) NOT NULL COMMENT '团队id',
  `target_type` varchar(10) NOT NULL COMMENT '类型：文件夹，接口，分组，场景,测试用例',
  `name` varchar(255) NOT NULL COMMENT '名称',
  `parent_id` varchar(100) NOT NULL DEFAULT '0' COMMENT '父级ID',
  `method` varchar(16) NOT NULL COMMENT '方法',
  `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序',
  `type_sort` int(11) NOT NULL DEFAULT '0' COMMENT '类型排序',
  `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '回收站状态：1-正常，2-回收站',
  `version` int(11) NOT NULL DEFAULT '0' COMMENT '产品版本号',
  `created_user_id` varchar(100) NOT NULL COMMENT '创建人ID',
  `recent_user_id` varchar(100) NOT NULL COMMENT '最近修改人ID',
  `description` varchar(255) DEFAULT NULL COMMENT '备注',
  `source` tinyint(4) DEFAULT '1' COMMENT '数据来源：1-正常来源，2-性能，3-自动化测试',
  `plan_id` varchar(100) NOT NULL DEFAULT '0' COMMENT '计划id',
  `source_id` varchar(100) NOT NULL COMMENT '引用来源ID',
  `is_checked` tinyint(2) NOT NULL DEFAULT '1' COMMENT '是否开启：1-开启，2-关闭',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted_at` datetime DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='创建目标';






DROP TABLE IF EXISTS `target_debug_log`;

CREATE TABLE `target_debug_log` (
  `id` bigint(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `target_id` varchar(100) NOT NULL COMMENT '目标唯一ID',
  `target_type` tinyint(2) NOT NULL COMMENT '目标类型：1-api，2-scene',
  `team_id` varchar(100) NOT NULL COMMENT '团队ID',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted_at` datetime DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='目标调试日志表';






DROP TABLE IF EXISTS `team`;

CREATE TABLE `team` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `team_id` varchar(100) NOT NULL COMMENT '团队ID',
  `name` varchar(64) NOT NULL COMMENT '团队名称',
  `type` tinyint(4) NOT NULL COMMENT '团队类型 1: 私有团队；2: 普通团队',
  `trial_expiration_date` datetime NOT NULL COMMENT '试用有效期',
  `is_vip` tinyint(2) NOT NULL DEFAULT '1' COMMENT '是否为付费团队 1-否 2-是',
  `vip_expiration_date` datetime NOT NULL COMMENT '付费有效期',
  `vum_num` bigint(20) NOT NULL DEFAULT '0' COMMENT '当前可用VUM总数',
  `max_user_num` bigint(20) NOT NULL DEFAULT '0' COMMENT '当前团队最大成员数量',
  `created_user_id` varchar(100) NOT NULL COMMENT '创建者id',
  `team_buy_version_type` int(10) NOT NULL DEFAULT '1' COMMENT '团队套餐类型：1-个人版，2-团队版，3-企业版，4-私有化部署',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='团队表';






DROP TABLE IF EXISTS `team_buy_version`;

CREATE TABLE `team_buy_version` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `title` varchar(50) NOT NULL COMMENT '购买套餐名称',
  `unit_price` double NOT NULL DEFAULT '0' COMMENT '单人单月定价',
  `unit_price_explain` varchar(100) NOT NULL COMMENT '单人单月定价说明',
  `detail` text NOT NULL COMMENT '套餐详情',
  `min_user_num` bigint(20) NOT NULL DEFAULT '0' COMMENT '最少团队成员数',
  `max_user_num` bigint(20) NOT NULL DEFAULT '0' COMMENT '最大团队成员数',
  `max_concurrence` bigint(20) NOT NULL DEFAULT '0' COMMENT '最大并发数',
  `max_api_num` bigint(20) NOT NULL DEFAULT '0' COMMENT '最大接口数',
  `max_run_time` bigint(20) NOT NULL DEFAULT '0' COMMENT '最大运行时长',
  `give_vun_num` bigint(20) NOT NULL DEFAULT '0' COMMENT '赠送VUM配额',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `deleted_at` datetime DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='团队套餐信息表';






DROP TABLE IF EXISTS `team_env`;

CREATE TABLE `team_env` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `team_id` varchar(100) NOT NULL COMMENT '团队ID',
  `name` varchar(100) NOT NULL COMMENT '环境名称',
  `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序',
  `status` tinyint(2) NOT NULL DEFAULT '1' COMMENT '状态：1-正常 2-删除',
  `created_user_id` varchar(100) NOT NULL COMMENT '创建人ID',
  `recent_user_id` bigint(20) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='团队环境管理';






DROP TABLE IF EXISTS `team_env_service`;

CREATE TABLE `team_env_service` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `team_id` varchar(100) NOT NULL COMMENT '团队ID',
  `team_env_id` bigint(20) NOT NULL DEFAULT '0' COMMENT '环境ID',
  `name` varchar(100) NOT NULL DEFAULT '' COMMENT '服务名称',
  `content` varchar(200) NOT NULL DEFAULT '' COMMENT '服务URL',
  `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序',
  `status` tinyint(2) NOT NULL DEFAULT '1' COMMENT '状态：1-正常 2-删除',
  `created_user_id` varchar(100) NOT NULL DEFAULT '0' COMMENT '创建人ID',
  `recent_user_id` bigint(20) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='团队环境服务管理';






DROP TABLE IF EXISTS `team_user_queue`;

CREATE TABLE `team_user_queue` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `email` varchar(255) NOT NULL COMMENT '邮箱',
  `team_id` varchar(100) NOT NULL COMMENT '团队id',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='邀请待注册队列';






DROP TABLE IF EXISTS `user`;

CREATE TABLE `user` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` varchar(100) NOT NULL COMMENT '用户id',
  `email` varchar(64) NOT NULL COMMENT '邮箱',
  `mobile` char(11) NOT NULL COMMENT '手机号',
  `password` varchar(255) NOT NULL COMMENT '密码',
  `nickname` varchar(64) NOT NULL COMMENT '昵称',
  `avatar` varchar(255) DEFAULT NULL COMMENT '头像',
  `wechat_open_id` varchar(100) NOT NULL COMMENT '微信开放的唯一id',
  `utm_source` varchar(50) NOT NULL COMMENT '渠道来源',
  `last_login_at` datetime DEFAULT NULL COMMENT '最近登录时间',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';






DROP TABLE IF EXISTS `user_collect_info`;

CREATE TABLE `user_collect_info` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `user_id` varchar(100) NOT NULL COMMENT '用户id',
  `industry` varchar(100) NOT NULL COMMENT '所属行业',
  `team_size` varchar(20) NOT NULL COMMENT '团队规模',
  `work_type` varchar(20) NOT NULL COMMENT '工作岗位',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `deleted_at` datetime DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;






DROP TABLE IF EXISTS `user_team`;

CREATE TABLE `user_team` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `user_id` varchar(100) NOT NULL COMMENT '用户ID',
  `team_id` varchar(100) NOT NULL COMMENT '团队id',
  `role_id` bigint(20) NOT NULL COMMENT '角色id1:超级管理员，2成员，3管理员',
  `invite_user_id` varchar(100) NOT NULL DEFAULT '0' COMMENT '邀请人id',
  `sort` int(11) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_team_team_id_deleted_at_index` (`team_id`,`deleted_at`),
  KEY `user_team_user_id_deleted_at_index` (`user_id`,`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户团队关系表';






DROP TABLE IF EXISTS `variable`;

CREATE TABLE `variable` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `team_id` varchar(100) NOT NULL COMMENT '团队id',
  `scene_id` varchar(100) NOT NULL COMMENT '场景ID',
  `type` tinyint(4) NOT NULL DEFAULT '0' COMMENT '使用范围：1-全局变量，2-场景变量',
  `var` varchar(255) NOT NULL COMMENT '变量名',
  `val` text NOT NULL COMMENT '变量值',
  `description` text NOT NULL COMMENT '描述',
  `status` tinyint(2) NOT NULL DEFAULT '1' COMMENT '开关状态：1-开启，2-关闭',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `deleted_at` datetime DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='设置变量表';






DROP TABLE IF EXISTS `variable_import`;

CREATE TABLE `variable_import` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `team_id` varchar(100) NOT NULL COMMENT '团队id',
  `scene_id` varchar(100) NOT NULL DEFAULT '0' COMMENT '场景id',
  `name` varchar(128) NOT NULL COMMENT '文件名称',
  `url` varchar(255) NOT NULL COMMENT '文件地址',
  `uploader_id` varchar(100) NOT NULL COMMENT '上传人id',
  `status` tinyint(2) NOT NULL DEFAULT '1' COMMENT '开关状态：1-开，2-关',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `deleted_at` datetime DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='导入变量表';






DROP TABLE IF EXISTS `vum_buy_version`;

CREATE TABLE `vum_buy_version` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `vum_buy_version_type` tinyint(2) NOT NULL DEFAULT '0' COMMENT 'vum套餐类型：1-套餐资源A，2-套餐资源B，3-套餐资源C，4-套餐资源D',
  `title` varchar(50) NOT NULL COMMENT '购买套餐名称',
  `vum_count` bigint(20) NOT NULL DEFAULT '0' COMMENT 'VUM额度',
  `max_concurrent` bigint(20) NOT NULL DEFAULT '0' COMMENT '最大并发数',
  `unit_price` double NOT NULL DEFAULT '0' COMMENT '单价',
  `discounts` double NOT NULL DEFAULT '0' COMMENT '优惠价格',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `deleted_at` datetime DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='VUM套餐信息表';






DROP TABLE IF EXISTS `vum_use_log`;

CREATE TABLE `vum_use_log` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `team_id` varchar(100) NOT NULL COMMENT '团队id',
  `plan_id` varchar(100) NOT NULL COMMENT '计划id',
  `plan_name` varchar(100) NOT NULL COMMENT '计划名称',
  `task_type` tinyint(4) NOT NULL DEFAULT '1' COMMENT '任务类型：1-普通任务，2-定时任务',
  `task_mode` tinyint(4) NOT NULL DEFAULT '1' COMMENT '压测模式：1-并发模式，2-阶梯模式，3-错误率模式，4-响应时间模式，5-每秒请求数模式，6 -每秒事务数模式',
  `run_time` datetime NOT NULL COMMENT '运行时间',
  `run_user_id` varchar(100) NOT NULL COMMENT '执行者id',
  `concurrence_num` int(11) NOT NULL DEFAULT '0' COMMENT '并发数',
  `concurrence_minute` int(11) NOT NULL DEFAULT '0' COMMENT '并发时长（单位分钟）',
  `vum_consume_num` bigint(20) NOT NULL DEFAULT '0' COMMENT 'VUM使用量',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `deleted_at` datetime DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='VUM使用日志表';


