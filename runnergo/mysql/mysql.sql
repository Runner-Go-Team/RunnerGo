


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
  PRIMARY KEY (`id`),
  KEY `idx_plan_id` (`plan_id`),
  KEY `idx_team_id` (`team_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='自动化测试-计划表';



# 转储表 auto_plan_email
# ------------------------------------------------------------

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



# 转储表 auto_plan_report
# ------------------------------------------------------------

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
  PRIMARY KEY (`id`),
  KEY `idx_report_id` (`report_id`),
  KEY `idx_team_id` (`team_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='自动化测试计划-报告表';



# 转储表 auto_plan_task_conf
# ------------------------------------------------------------

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
  PRIMARY KEY (`id`),
  KEY `idx_plan_id` (`plan_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='自动化测试—普通任务配置表';



# 转储表 auto_plan_timed_task_conf
# ------------------------------------------------------------

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
  PRIMARY KEY (`id`),
  KEY `idx_plan_id` (`plan_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='自动化测试-定时任务配置表';



# 转储表 machine
# ------------------------------------------------------------

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



# 转储表 operation
# ------------------------------------------------------------

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
  PRIMARY KEY (`id`),
  KEY `idx_team_id` (`team_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# 转储表 preinstall_conf
# ------------------------------------------------------------

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
  PRIMARY KEY (`id`),
  KEY `idx_team_id` (`team_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='预设配置表';



# 转储表 report_machine
# ------------------------------------------------------------

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
  PRIMARY KEY (`id`),
  KEY `idx_report_id` (`report_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# 转储表 setting
# ------------------------------------------------------------

DROP TABLE IF EXISTS `setting`;

CREATE TABLE `setting` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` varchar(100) NOT NULL COMMENT '用户id',
  `team_id` varchar(100) NOT NULL COMMENT '当前团队id',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='设置表';



# 转储表 sms_log
# ------------------------------------------------------------

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



# 转储表 stress_plan
# ------------------------------------------------------------

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
  `remark` text NOT NULL COMMENT '备注',
  `run_count` bigint(20) unsigned DEFAULT '0' COMMENT '运行次数',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `deleted_at` datetime DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`),
  KEY `idx_plan_id` (`plan_id`),
  KEY `idx_team_id` (`team_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='性能计划表';



# 转储表 stress_plan_email
# ------------------------------------------------------------

DROP TABLE IF EXISTS `stress_plan_email`;

CREATE TABLE `stress_plan_email` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `plan_id` varchar(100) NOT NULL COMMENT '计划ID',
  `team_id` varchar(100) NOT NULL COMMENT '团队ID',
  `email` varchar(255) DEFAULT NULL COMMENT '邮箱',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `deleted_at` datetime DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`),
  KEY `idx_plan_id` (`plan_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='性能计划收件人';



# 转储表 stress_plan_report
# ------------------------------------------------------------

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
  PRIMARY KEY (`id`),
  KEY `idx_report_id` (`report_id`),
  KEY `idx_team_id` (`team_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='性能测试报告表';



# 转储表 stress_plan_task_conf
# ------------------------------------------------------------

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
  PRIMARY KEY (`id`),
  KEY `idx_plan_id` (`plan_id`),
  KEY `idx_scene_id` (`scene_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='性能计划—普通任务配置表';



# 转储表 stress_plan_timed_task_conf
# ------------------------------------------------------------

DROP TABLE IF EXISTS `stress_plan_timed_task_conf`;

CREATE TABLE `stress_plan_timed_task_conf` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '表id',
  `plan_id` varchar(100) NOT NULL COMMENT '计划id',
  `scene_id` varchar(100) NOT NULL COMMENT '场景id',
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
  PRIMARY KEY (`id`),
  KEY `idx_plan_id` (`plan_id`),
  KEY `idx_scene_id` (`scene_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='性能计划-定时任务配置表';



# 转储表 target
# ------------------------------------------------------------

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
  `description` text NOT NULL COMMENT '备注',
  `source` tinyint(4) DEFAULT '1' COMMENT '数据来源：1-正常来源，2-性能，3-自动化测试',
  `plan_id` varchar(100) NOT NULL DEFAULT '0' COMMENT '计划id',
  `source_id` varchar(100) NOT NULL COMMENT '引用来源ID',
  `is_checked` tinyint(2) NOT NULL DEFAULT '1' COMMENT '是否开启：1-开启，2-关闭',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted_at` datetime DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`),
  KEY `idx_target_id` (`target_id`),
  KEY `idx_plan_id` (`plan_id`),
  KEY `idx_team_id` (`team_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='创建目标';



# 转储表 target_debug_log
# ------------------------------------------------------------

DROP TABLE IF EXISTS `target_debug_log`;

CREATE TABLE `target_debug_log` (
  `id` bigint(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `target_id` varchar(100) NOT NULL COMMENT '目标唯一ID',
  `target_type` tinyint(2) NOT NULL COMMENT '目标类型：1-api，2-scene',
  `team_id` varchar(100) NOT NULL COMMENT '团队ID',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted_at` datetime DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`),
  KEY `idx_target_id` (`target_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='目标调试日志表';



# 转储表 team
# ------------------------------------------------------------

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
  PRIMARY KEY (`id`),
  KEY `idx_team_id` (`team_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='团队表';



# 转储表 team_env
# ------------------------------------------------------------

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
  PRIMARY KEY (`id`),
  KEY `idx_team_id` (`team_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='团队环境管理';



# 转储表 team_env_service
# ------------------------------------------------------------

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
  PRIMARY KEY (`id`),
  KEY `idxx_team_id` (`team_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='团队环境服务管理';



# 转储表 team_user_queue
# ------------------------------------------------------------

DROP TABLE IF EXISTS `team_user_queue`;

CREATE TABLE `team_user_queue` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `email` varchar(255) NOT NULL COMMENT '邮箱',
  `team_id` varchar(100) NOT NULL COMMENT '团队id',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_team_id` (`team_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='邀请待注册队列';



# 转储表 user
# ------------------------------------------------------------

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
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';



# 转储表 user_collect_info
# ------------------------------------------------------------

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
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# 转储表 user_team
# ------------------------------------------------------------

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
  KEY `idx_team_id` (`team_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户团队关系表';



# 转储表 variable
# ------------------------------------------------------------

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
  PRIMARY KEY (`id`),
  KEY `idx_team_id` (`team_id`),
  KEY `idx_scene_id` (`scene_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='设置变量表';



# 转储表 variable_import
# ------------------------------------------------------------

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
  PRIMARY KEY (`id`),
  KEY `idx_team_id` (`team_id`),
  KEY `idx_scene_id` (`scene_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='导入变量表';



# 转储表 public_function
# ------------------------------------------------------------

DROP TABLE IF EXISTS `public_function`;

CREATE TABLE `public_function` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `function` varchar(255) NOT NULL COMMENT '函数',
  `function_name` varchar(255) NOT NULL COMMENT '函数名称',
  `remark` text NOT NULL COMMENT '备注',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `deleted_at` datetime DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


# 初始化公共函数数据
INSERT INTO `public_function` (`id`, `function`, `function_name`, `remark`, `created_at`, `updated_at`, `deleted_at`)
VALUES
	(NULL, 'md5(string)', 'md5加密', '{{__MD5(ABC)__}}, 加密字符串', '2023-03-28 14:19:24', '2023-03-28 14:27:24', NULL),
	(NULL, 'SHA256(string)', 'sha256加密', '{{__SHA256(ABC)__}}, 加密字符串', '2023-03-28 14:19:53', '2023-03-28 14:19:53', NULL),
	(NULL, 'SHA512(string)', 'sha512加密', '{{__SHA512(ABC)__}}, 加密字符串', '2023-03-28 14:21:36', '2023-03-28 14:21:47', NULL),
	(NULL, 'IdCard(isEighteen, address, birthday, sex)', '身份证号生成', '{{__IdCard(true, 北京市, 2000, 1)__}}, 北京市男2000年出生18位身份证号。\n\n// IdCard 根据参数生成身份证号\n\n// isEighteen 是否生成18位号码\n\n// address 省市县三级地区官方全称: 如\'北京市\'、\'台湾省\'、\'香港特别行政区\'、\'深圳市\'、\'黄浦区\'\n\n// birthday 出生日期: 如 \'2000\'、\'199801\'、\'19990101\'\n\n// sex 性别: 1为男性, 0为女性', '2023-03-28 14:22:24', '2023-03-28 14:22:24', NULL),
	(NULL, 'RandomIdCard()', '随机生成身份证号', '{{__RandomIdCard()__}}, 随机身份证号', '2023-03-28 14:23:01', '2023-03-28 14:23:01', NULL),
	(NULL, 'VerifyIdCard(cardId, strict)', '身份证号校验', '{{__VerifyIdCard(231231, true)}}, 结果: false', '2023-03-28 14:23:35', '2023-03-28 14:23:43', NULL),
	(NULL, '{{__VerifyIdCard(231231, true)}}, 结果: false', '改变字符串大小写', '{{__ToStringLU(abc, L)__}}, 全部小写', '2023-03-28 14:24:04', '2023-03-28 14:24:04', NULL),
	(NULL, 'RandomInt(start,  end)', '随机数生成(整数)', '{{__RandomInt(start, end)__}}, 随机生成start-end之间的整数', '2023-03-28 14:24:34', '2023-03-28 14:24:34', NULL),
	(NULL, 'RandomFloat0()', '随机数生成(小数)', '{{__RandomFloat0()__}}, 随机生成0-1之间的小数', '2023-03-28 14:25:11', '2023-03-28 14:25:11', NULL),
	(NULL, 'RandomString(num int)', '随机数生成(字符串)', '{{__RandomString(5)__}}, 随机生成5位由a-z、0-9、A-Z之间英文字组成的字符串', '2023-03-28 14:25:35', '2023-03-28 14:26:14', NULL),
	(NULL, 'Uuid()', '生成uuid', '{{__GetUUid()__}}, 随机生成uuid', '2023-03-28 14:25:57', '2023-03-28 14:25:57', NULL),
	(NULL, 'ToTimeStamp(option)', '时间戳', '{{__ToTimeStamp(s)__}}, 生成秒级时间戳字符串\n\noption: s, ms, ns, ws; 分别是秒; 毫秒; 纳秒; 微秒', '2023-03-28 14:26:35', '2023-03-28 14:26:35', NULL);


