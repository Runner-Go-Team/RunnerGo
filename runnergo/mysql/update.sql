-- 1.1.3之前的版本需要进入Mysql数据库执行以下sql语句
alter table preinstall_conf add column debug_mode varchar(100) not null default 'stop' comment 'debug模式：stop-关闭，all-开启全部日志，only_success-开启仅成功日志，only_error-开启仅错误日志' after control_mode;
alter table stress_plan_report add column debug_mode varchar(100) not null default 'stop' comment 'debug模式：stop-关闭，all-开启全部日志，only_success-开启仅成功日志，only_error-开启仅错误日志' after control_mode;
alter table stress_plan_task_conf add column debug_mode varchar(100) not null default 'stop' comment 'debug模式：stop-关闭，all-开启全部日志，only_success-开启仅成功日志，only_error-开启仅错误日志' after control_mode;
alter table stress_plan_timed_task_conf add column debug_mode varchar(100) not null default 'stop' comment 'debug模式：stop-关闭，all-开启全部日志，only_success-开启仅成功日志，only_error-开启仅错误日志' after control_mode;