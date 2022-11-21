
CREATE TABLE `machine` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `region` varchar(64) NOT NULL COMMENT '地域',
  `ip` varchar(15) NOT NULL COMMENT 'ip',
  `port` int(11) NOT NULL COMMENT '端口',
  `weight` int(11) NOT NULL COMMENT '额外权重',
  `status` tinyint(4) DEFAULT NULL COMMENT '机器状态{1: 空闲, 2: 忙碌}',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `machine_region_ip_status_index` (`region`,`ip`,`status`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COMMENT='机器';




CREATE TABLE `operation` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `team_id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `user_identify` char(12) NOT NULL,
  `category` tinyint(4) NOT NULL DEFAULT '0',
  `operate` tinyint(4) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4618 DEFAULT CHARSET=utf8mb4;


CREATE TABLE `plan` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `team_id` bigint(20) NOT NULL,
  `rank` bigint(20) NOT NULL,
  `name` varchar(255) NOT NULL,
  `task_type` int(11) DEFAULT NULL,
  `mode` int(11) DEFAULT NULL,
  `status` tinyint(4) NOT NULL,
  `create_user_identify` char(12) NOT NULL,
  `run_user_identify` char(12) NOT NULL,
  `create_user_id` bigint(20) NOT NULL,
  `run_user_id` bigint(20) NOT NULL,
  `remark` varchar(255) DEFAULT NULL,
  `cron_expr` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=451 DEFAULT CHARSET=utf8mb4;


CREATE TABLE `plan_email` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `plan_id` bigint(20) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4;


CREATE TABLE `report` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `team_id` bigint(20) NOT NULL,
  `rank` bigint(20) NOT NULL,
  `plan_id` bigint(20) NOT NULL,
  `plan_name` varchar(255) NOT NULL,
  `scene_id` bigint(20) NOT NULL,
  `scene_name` varchar(255) NOT NULL,
  `task_type` int(11) NOT NULL,
  `task_mode` int(11) NOT NULL,
  `status` tinyint(4) NOT NULL,
  `ran_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `run_user_identify` char(12) NOT NULL,
  `run_user_id` bigint(20) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=180 DEFAULT CHARSET=utf8mb4;


CREATE TABLE `report_machine` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `report_id` bigint(20) NOT NULL,
  `ip` varchar(15) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=162 DEFAULT CHARSET=utf8mb4;


CREATE TABLE `setting` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `user_identify` char(12) NOT NULL,
  `team_id` bigint(20) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `setting_user_id_uindex` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1016 DEFAULT CHARSET=utf8mb4;


CREATE TABLE `target` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `team_id` bigint(20) NOT NULL,
  `target_type` varchar(10) NOT NULL,
  `name` varchar(255) NOT NULL,
  `parent_id` bigint(20) NOT NULL DEFAULT '0',
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
  `source` tinyint(4) NOT NULL DEFAULT '0',
  `plan_id` bigint(20) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1782 DEFAULT CHARSET=utf8mb4 COMMENT='目标';


CREATE TABLE `team` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL,
  `type` tinyint(4) NOT NULL COMMENT '1: 私有团队；2: 普通团队',
  `created_user_id` bigint(20) NOT NULL,
  `create_user_identify` char(12) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=172 DEFAULT CHARSET=utf8mb4;


CREATE TABLE `team_user_queue` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `email` varchar(255) DEFAULT NULL,
  `team_id` bigint(20) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=103 DEFAULT CHARSET=utf8mb4;


CREATE TABLE `user` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `email` varchar(64) NOT NULL,
  `password` varchar(255) NOT NULL,
  `nickname` varchar(64) NOT NULL,
  `avatar` varchar(255) DEFAULT NULL,
  `last_login_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_email_uindex` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=133 DEFAULT CHARSET=utf8mb4;


CREATE TABLE `user_team` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `user_identify` char(12) DEFAULT NULL,
  `team_id` bigint(20) NOT NULL,
  `role_id` bigint(20) NOT NULL,
  `invite_user_id` bigint(20) NOT NULL DEFAULT '0',
  `invite_user_identify` char(12) NOT NULL,
  `sort` int(11) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_team_team_id_deleted_at_index` (`team_id`,`deleted_at`),
  KEY `user_team_user_id_deleted_at_index` (`user_id`,`deleted_at`)
) ENGINE=InnoDB AUTO_INCREMENT=362 DEFAULT CHARSET=utf8mb4;






CREATE TABLE `variable` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `team_id` bigint(20) NOT NULL,
  `type` tinyint(4) DEFAULT NULL COMMENT '全局变量：1，场景变量：2',
  `var` varchar(255) NOT NULL,
  `val` varchar(255) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  `scene_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=771 DEFAULT CHARSET=utf8mb4;


CREATE TABLE `variable_import` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `team_id` bigint(20) DEFAULT NULL,
  `scene_id` bigint(20) DEFAULT NULL,
  `name` varchar(128) NOT NULL,
  `url` varchar(255) NOT NULL,
  `uploader_id` bigint(20) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=113 DEFAULT CHARSET=utf8mb4;
