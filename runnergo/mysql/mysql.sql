SET NAMES utf8mb4;

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
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `team_id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `user_identify` char(12) NOT NULL,
  `category` tinyint(4) NOT NULL DEFAULT '0' COMMENT '日志分组{1:新建，2:修改，3:删除，4:运行}',
  `operate` tinyint(4) DEFAULT NULL COMMENT '{"操作类型":{1:创建文件夹,2:创建接口,3:创建分组,4:创建计划,5:创建场景,6:修改文件夹,7:修改接口,8:修改分组,9:修改计划,10:修改场景,11:克隆计划,12:删除报告,13:删除场景,14:删除计划,15:运行场景,16:运行计划,17:新建预设配置,18:修改并保存预设配置,19:删除预设配置}}',
  `name` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



DROP TABLE IF EXISTS `plan`;

CREATE TABLE `plan` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `team_id` bigint(20) NOT NULL COMMENT '团队ID',
  `rank` bigint(20) NOT NULL COMMENT '团队内份数',
  `name` varchar(255) NOT NULL COMMENT '计划名称',
  `task_type` int(11) DEFAULT NULL COMMENT '计划类型{1:普通任务,2:定时任务}',
  `mode` int(11) DEFAULT NULL COMMENT '压测类型 1 // 并发模式，  2 // 阶梯模式，  3 // 错误率模式，  4 // 响应时间模式，  5 //每秒请求数模式，  6 //每秒事务数模式，',
  `status` tinyint(4) NOT NULL COMMENT '计划状态1:未开始,2:进行中',
  `create_user_identify` char(12) NOT NULL,
  `run_user_identify` char(12) NOT NULL,
  `create_user_id` bigint(20) NOT NULL COMMENT '创建人id',
  `run_user_id` bigint(20) NOT NULL COMMENT '运行人id',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `cron_expr` varchar(255) DEFAULT NULL COMMENT '定时任务表达式',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='计划表';






DROP TABLE IF EXISTS `plan_email`;

CREATE TABLE `plan_email` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `plan_id` bigint(20) DEFAULT NULL COMMENT '计划ID',
  `email` varchar(255) DEFAULT NULL COMMENT '邮箱',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='计划收件人';






DROP TABLE IF EXISTS `preinstall_conf`;

CREATE TABLE `preinstall_conf` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `conf_name` varchar(100) NOT NULL COMMENT '配置名称',
  `team_id` bigint(20) NOT NULL COMMENT '团队ID',
  `user_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '用户ID',
  `user_name` varchar(64) NOT NULL COMMENT '用户名称',
  `task_type` tinyint(2) NOT NULL DEFAULT '0' COMMENT '任务类型',
  `task_mode` tinyint(2) NOT NULL DEFAULT '0' COMMENT '压测模式',
  `mode_conf` text NOT NULL COMMENT '压测配置详情',
  `timed_task_conf` text NOT NULL COMMENT '定时任务相关配置',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted_at` timestamp NULL DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='预设配置表';






DROP TABLE IF EXISTS `report`;

CREATE TABLE `report` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `team_id` bigint(20) NOT NULL COMMENT '团队ID',
  `rank` bigint(20) NOT NULL COMMENT '团队内份数',
  `plan_id` bigint(20) NOT NULL COMMENT '计划ID',
  `plan_name` varchar(255) NOT NULL COMMENT '计划名称',
  `scene_id` bigint(20) NOT NULL COMMENT '场景ID',
  `scene_name` varchar(255) NOT NULL COMMENT '场景名称',
  `task_type` int(11) NOT NULL COMMENT '任务类型',
  `task_mode` int(11) NOT NULL COMMENT '压测模式',
  `status` tinyint(4) NOT NULL COMMENT '报告状态1:进行中，2:已完成',
  `ran_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '启动时间',
  `run_user_identify` char(12) NOT NULL,
  `run_user_id` bigint(20) NOT NULL COMMENT '启动人id',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='报告表';






DROP TABLE IF EXISTS `report_machine`;

CREATE TABLE `report_machine` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `report_id` bigint(20) NOT NULL COMMENT '报告id',
  `ip` varchar(15) NOT NULL COMMENT '机器ip',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;






DROP TABLE IF EXISTS `setting`;

CREATE TABLE `setting` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL COMMENT '用户id',
  `user_identify` char(12) NOT NULL,
  `team_id` bigint(20) NOT NULL COMMENT '当前团队id',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `setting_user_id_uindex` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='设置表';






DROP TABLE IF EXISTS `target`;

CREATE TABLE `target` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `team_id` bigint(20) NOT NULL COMMENT '团队id',
  `target_type` varchar(10) NOT NULL COMMENT '类型：文件夹，接口，分组，场景',
  `name` varchar(255) NOT NULL COMMENT '名称',
  `parent_id` bigint(20) NOT NULL DEFAULT '0' COMMENT '父级ID',
  `method` varchar(16) NOT NULL COMMENT '方法',
  `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序',
  `type_sort` int(11) NOT NULL DEFAULT '0' COMMENT '类型排序',
  `status` tinyint(4) NOT NULL DEFAULT '0',
  `version` int(11) NOT NULL DEFAULT '0',
  `create_user_identify` char(12) NOT NULL,
  `recent_user_identify` char(12) NOT NULL,
  `created_user_id` bigint(20) NOT NULL,
  `recent_user_id` bigint(20) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `source` tinyint(4) NOT NULL DEFAULT '0' COMMENT '来源1正常，2计划',
  `plan_id` bigint(20) NOT NULL DEFAULT '0' COMMENT '计划id',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='目标';






DROP TABLE IF EXISTS `team`;

CREATE TABLE `team` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL COMMENT '团队名称',
  `type` tinyint(4) NOT NULL COMMENT '团队类型 1: 私有团队；2: 普通团队',
  `created_user_id` bigint(20) NOT NULL COMMENT '创建者id',
  `create_user_identify` char(12) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='团队表';






DROP TABLE IF EXISTS `team_user_queue`;

CREATE TABLE `team_user_queue` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `email` varchar(255) DEFAULT NULL COMMENT '邮箱',
  `team_id` bigint(20) DEFAULT NULL COMMENT '团队id',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='邀请待注册队列';






DROP TABLE IF EXISTS `timed_task_conf`;

CREATE TABLE `timed_task_conf` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '表id',
  `plan_id` bigint(11) unsigned NOT NULL DEFAULT '0' COMMENT '计划id',
  `sence_id` bigint(11) unsigned NOT NULL DEFAULT '0' COMMENT '场景id',
  `team_id` bigint(11) unsigned NOT NULL DEFAULT '0' COMMENT '团队id',
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `frequency` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '任务执行频次',
  `task_exec_time` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '任务执行时间',
  `task_close_time` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '任务结束时间',
  `task_type` tinyint(2) NOT NULL DEFAULT '2' COMMENT '任务类型：1-普通任务，2-定时任务',
  `task_mode` tinyint(2) NOT NULL DEFAULT '1' COMMENT '压测模式：1-并发模式，2-阶梯模式，3-错误率模式，4-响应时间模式，5-每秒请求数模式，  6 //每秒事务数模式，',
  `mode_conf` text NOT NULL COMMENT '压测详细配置',
  `status` tinyint(11) NOT NULL DEFAULT '0' COMMENT '任务状态：0-未启用，1-运行中，3-已过期',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted_at` datetime DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='定时任务配置表';






DROP TABLE IF EXISTS `user`;

CREATE TABLE `user` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `email` varchar(64) NOT NULL COMMENT '邮箱',
  `password` varchar(255) NOT NULL COMMENT '密码',
  `nickname` varchar(64) NOT NULL COMMENT '昵称',
  `avatar` varchar(255) DEFAULT NULL COMMENT '头像',
  `last_login_at` datetime DEFAULT NULL COMMENT '最近登录时间',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_email_uindex` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';






DROP TABLE IF EXISTS `user_team`;

CREATE TABLE `user_team` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `user_identify` char(12) DEFAULT NULL,
  `team_id` bigint(20) NOT NULL COMMENT '团队id',
  `role_id` bigint(20) NOT NULL COMMENT '角色id1:超级管理员，2成员，3管理员',
  `invite_user_id` bigint(20) NOT NULL DEFAULT '0' COMMENT '邀请人id',
  `invite_user_identify` char(12) NOT NULL,
  `sort` int(11) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_team_team_id_deleted_at_index` (`team_id`,`deleted_at`),
  KEY `user_team_user_id_deleted_at_index` (`user_id`,`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户团队关系表';






DROP TABLE IF EXISTS `variable`;

CREATE TABLE `variable` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `team_id` bigint(20) NOT NULL COMMENT '团队id',
  `type` tinyint(4) DEFAULT NULL COMMENT '全局变量：1，场景变量：2',
  `var` varchar(255) NOT NULL COMMENT '变量名',
  `val` varchar(255) NOT NULL COMMENT '变量值',
  `description` varchar(255) DEFAULT NULL COMMENT '描述',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  `scene_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='设置变量表';






DROP TABLE IF EXISTS `variable_import`;

CREATE TABLE `variable_import` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `team_id` bigint(20) DEFAULT NULL COMMENT '团队id',
  `scene_id` bigint(20) DEFAULT NULL COMMENT '场景id',
  `name` varchar(128) NOT NULL,
  `url` varchar(255) NOT NULL,
  `uploader_id` bigint(20) NOT NULL COMMENT '上传人id',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='导入变量表';




/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
