#!/bin/bash

# 初始v1.0版本
# 输入 systemctl stop firewalld.service 命令，关闭防火墙，使用 systemctl disable firewalld.service 指令可以永久关闭防火墙
# 输入 systemctl start firewalld 开启防火墙
# 可以手动创建/root/runnergo_sh目录，复制all_install_centos7.sh脚本到/root/runnergo_sh目录执行source all_install_centos7.sh指令
# 判断如果当前路径不存在就创建
if [ ! -d "/root/runnergo_sh/" ];then
    mkdir -p /root/runnergo_sh
	# 获取当前目录路径的变量
	CRTDIR=$(pwd)
	mv $CRTDIR/all_install_centos7.sh /root/runnergo_sh
	echo "请执行source all_install_centos7.sh指令，自动化一键部署启动runnerGO平台"
else
	# 获取当前目录路径的变量
	CRTDIR=$(pwd)
	mv $CRTDIR/all_install_centos7.sh /root/runnergo_sh
    echo "/root/runnergo_sh目录文件夹已经存在，请执行source all_install_centos7.sh指令，自动化一键部署启动runnerGO平台"
fi
# Centos7设置国内yum源
cd /etc/yum.repos.d/
# 创建备份目录将原来的源移动到此目录下
mkdir repo.back
mv ./*.repo repo.back
curl -O http://mirrors.163.com/.help/CentOS7-Base-163.repo
mv CentOS7-Base-163.repo CentOS-Base.repo
sudo yum clean all && rm -rf /var/cache/yum
sudo yum makecache -y
sudo yum upgrade -y// 更新系统时，软件和内核保持原样
sudo yum update -y// 需要更新内核
sudo yum install wget -y
# 安装git环境
sudo yum install curl-devel expat-devel gettext-devel openssl-devel zlib-devel gcc perl-ExtUtils-MakeMaker -y
sudo yum install git -y
sleep 2

# 安装nodejs环境
cd /root/runnergo_sh
echo "install start!"
if [ -e /root/runnergo_sh/node-v16.16.0-linux-x64.tar.xz ];then
    echo "node文件已经存在，无需下载直接解压"
else
	wget https://nodejs.org/download/release/v16.16.0/node-v16.16.0-linux-x64.tar.xz
fi
tar xf node-v16.16.0-linux-x64.tar.xz -C /usr/local/
cd /usr/local/
mv node-v16.16.0-linux-x64/ nodejs
ln -s /usr/local/nodejs/bin/node /usr/local/bin
ln -s /usr/local/nodejs/bin/npm /usr/local/bin
# 修改npm的源为taobao
npm config set registry https://registry.npm.taobao.org
echo "install  success!"
sleep 2

# 安装go环境
cd /root/runnergo_sh
if [ -e /root/runnergo_sh/go1.19.3.linux-amd64.tar.gz ];then
    echo "go文件已经存在，无需下载直接解压"
else
	url=https://storage.googleapis.com/golang/go1.19.3.linux-amd64.tar.gz
	wget $url
fi
tar -C /usr/local -xzf go1.19.3.linux-amd64.tar.gz
echo "setting path successful."
sleep 2

# 安装zookeeper环境
rm -rf /usr/local/zookeeper
sudo yum install java-1.8.0-openjdk java-1.8.0-openjdk-devel -y
cd /root/runnergo_sh
if [ -e /root/runnergo_sh/apache-zookeeper-3.6.4-bin.tar.gz ];then
    echo "apache-zookeeper文件已经存在，无需下载直接解压"
else
	wget https://archive.apache.org/dist/zookeeper/zookeeper-3.6.4/apache-zookeeper-3.6.4-bin.tar.gz
fi
echo "(1/6): 解压Zookeeper安装文件..."
tar -zxvf apache-zookeeper-3.6.4-bin.tar.gz
sleep 10
echo "(1/6): Zookeeper安装文件解压完毕"
echo "(2/6): 配置Zookeeper环境变量..."
mv ./apache-zookeeper-3.6.4-bin/ /usr/local/zookeeper
sleep 2
cat <<'EOF' > /etc/profile.d/zookeeper.sh
export ZOOKEEPER_HOME=/usr/local/zookeeper
export PATH=$PATH:$ZOOKEEPER_HOME/bin
EOF
sleep 1
source /etc/profile.d/zookeeper.sh
echo "ZOOKEEPER_HOME目录:"${ZOOKEEPER_HOME}
echo "(2/6): 配置Zookeeper环境变量完毕"
echo "(3/6): 配置Zookeeper运行参数..."
cp ${ZOOKEEPER_HOME}/conf/zoo_sample.cfg ${ZOOKEEPER_HOME}/conf/zoo.cfg
sed -i "12c dataDir=/usr/local/zookeeper/data" ${ZOOKEEPER_HOME}/conf/zoo.cfg
sed -i "13i dataLogDir=/usr/local/zookeeper/datalog" ${ZOOKEEPER_HOME}/conf/zoo.cfg
echo "(3/6): Zookeeper运行参数配置完毕"
echo "(4/6): 初次启动Zookeeper..."
zkServer.sh start
sleep 2
zkServer.sh status
echo "(4/6): Zookeeper初次启动完毕"
echo "(5/6): 开启2181端口..."
firewall-cmd --zone=public --add-port=2181/tcp --permanent && firewall-cmd --reload
echo "(5/6): 2181端口开启完毕"
echo "(6/6): Zookeeper加入到service服务并设置开机自启..."
cat <<'EOF' > /usr/lib/systemd/system/zookeeper.service
[Unit]
Description=zookeeper.service
After=network.target
[Service]
Type=forking
ExecStart=/usr/local/zookeeper/bin/zkServer.sh start
ExecStop=/usr/local/zookeeper/bin/zkServer.sh stop
ExecReload=/usr/local/zookeeper/bin/zkServer.sh restart
[Install]
WantedBy=multi-user.target
EOF
chmod 754 /usr/lib/systemd/system/zookeeper.service
##然后重启加在服务配置文件
systemctl daemon-reload
systemctl enable zookeeper
echo "(6/6): Zookeeper加入到service服务并设置开机自启完毕"
sleep 2

# 安装kafaka环境
hostIp=$(/sbin/ip route get 1| sed 's/^.*src \(\S*\).*$/\1/;q')
cd /root/runnergo_sh
if [ -e /root/runnergo_sh/kafka_2.13-3.4.1.tgz ];then
    echo "kafka文件已经存在，无需下载直接解压"
else
	wget https://mirrors.ustc.edu.cn/apache/kafka/3.4.1/kafka_2.13-3.4.1.tgz
fi
# declare where the install package
readonly INSTALL_PACKAGE_WAY=/root/runnergo_sh/kafka_2.13-3.4.1.tgz
# declare the install way
readonly INSTALL_WAY=/opt/cloud/middleware
readonly ZOOKEEPER_HOST_PORT=127.0.0.1:2181
readonly ZOOKEEPER_LISTENERS=PLAINTEXT://:9092
readonly ADVERTISED_LISTENERS=PLAINTEXT://${hostIp}:9092
readonly ZOOKEEPER_NUM_PARTITIONS=2
function log_info() {
    echo "[$(date -d today +"%Y-%m-%d %H:%M:%S %:::z")] $1"
}
# do something before install
function pre_install(){
  # make install way
  mkdir -p ${INSTALL_WAY}
}
# do install job
function install_kafka(){
  # unzip the package to install way
  tar -zxvf ${INSTALL_PACKAGE_WAY} -C ${INSTALL_WAY}
}
function config_properties() {
  local key=$1
  local value=$2
  if [[ $(cat ${INSTALL_WAY}/kafka/config/server.properties |grep "^${key}") ]]; then
    sed -i "s/^${key}=.*/${key}=${value//\//\\/}/g" ${INSTALL_WAY}/kafka/config/server.properties
  else
    echo "${key}=${value}" >> ${INSTALL_WAY}/kafka/config/server.properties
  fi
}
function post_install() {
  # create ln of kafka
  local kafka_dir=$(ls -lt ${INSTALL_WAY}|grep kafka|head -1|awk '{print $9}')
  ln -s ${kafka_dir} ${INSTALL_WAY}/kafka
  # config_properties port 9092
  # config_properties host.name ${hostIp}
  config_properties zookeeper.connect ${ZOOKEEPER_HOST_PORT}
  config_properties listeners ${ZOOKEEPER_LISTENERS}
  config_properties advertised.listeners ${ADVERTISED_LISTENERS}
   # 参数指定了新创建的topic有多少分区，指定为配置的2
  config_properties num.partitions ${ZOOKEEPER_NUM_PARTITIONS}
}
function install() {
  pre_install
  install_kafka
  post_install
  start
}
# start kafka
function start() {
  local zookeeper_pid=$(ps -ef|grep zookeeper|grep -vwE "grep|vi|vim|tail|cat|sh"|awk '{print $2}')
  if [[ -z ${zookeeper_pid} ]] ;then
    log_info "please start zookeeper firstly"
    return 0
  fi
  local kafka_pid=$(ps -ef|grep kafka|grep -vwE "grep|vi|vim|tail|cat|sh"|awk '{print $2}')
  if [[ -n ${kafka_pid} ]] ;then
    log_info "kafka has been start"
    return 0
  fi
  # sed -i -e "s/#listeners/listeners/g" ${INSTALL_WAY}/kafka/config/server.properties
  # sed -i -e "s/localhost/127.0.0.1/g" ${INSTALL_WAY}/kafka/config/server.properties
  # sleep 1
  source /etc/profile && ${INSTALL_WAY}/kafka/bin/kafka-server-start.sh ${INSTALL_WAY}/kafka/config/server.properties &
}
install
cat << 'EOF' >> /etc/profile
export PATH=/opt/cloud/middleware/kafka/bin:$PATH
export PATH=/opt/cloud/middleware/kafka_2.13-3.4.1/bin:$PATH
EOF
sleep 1
source /etc/profile
cd /usr/lib/systemd/system/
##来到此目录下
touch kafka.service
echo "[Unit]
Description=kafka project
After=network.target zookeeper.service
[Service]
Type=simple
ExecStart=/opt/cloud/middleware/kafka/bin/kafka-server-start.sh /opt/cloud/middleware/kafka/config/server.properties
ExecStop=/opt/cloud/middleware/kafka/bin/kafka-server-stop.sh
Restart=on-failure
PrivateTmp=true
[Install]
WantedBy=multi-user.target" > /usr/lib/systemd/system/kafka.service
chmod 754 /usr/lib/systemd/system/kafka.service
##然后重启加在服务配置文件
systemctl daemon-reload
systemctl enable kafka
sleep 2

# 安装redis环境
echo "redis install-script start=======$0=================="
#redis安装目录，bin目录也会在这个下面
redis_download='/root/runnergo_sh'
redis_home='/usr/local/redis'
#redis版本，需要安装其他版本可以修改这个，去官网参考
redis_version='redis-6.2.7'
redis_url="https://download.redis.io/releases/$redis_version.tar.gz"
#1.判断安装目录是否存在，存在提示删除。否则结束脚本
if [ -d "$redis_home" ]
then
	read -t 60 -p "目录$redis_home存在，是否删除? (y/n)："  confirm
	echo "输入内容：$confirm"
	case $confirm in
	y | Y)
		if  rm -rf "$redis_home"
		then
			echo "删除$redis_home目录成功"
		fi;;
	n | N)
		echo "安装目录$redis_home存在，脚本运行结束====================end"
		exit;;
	*)
		echo "输入错误或60s未确认，脚本运行结束====================end"
                exit;;
	esac
fi
#2.创建安装目录，保证是最新的文件夹，无其他文件
if [ ! -d $redis_home ]
then
	echo "安装目录$redis_home不存在，创建$redis_home======================="
	mkdir $redis_home
fi

#3.进入到redis_home路径下下载压缩包并解压
cd $redis_download
if [ -e /root/runnergo_sh/redis-6.2.7.tar.gz ];then
	echo "redis文件已经存在，无需下载直接解压"
else
	wget $redis_url
	echo '下载成功======================'
fi
tar -zxvf "$redis_version.tar.gz" -C $redis_home
sleep 2
#4.进入解压目录进行编译
if cd "$redis_home/$redis_version"
then
	if yum install gcc-c++ -y
	then
		if make
		then
			if make install PREFIX=/usr/local/redis
			then
				cp redis.conf ../bin/redis.conf
				echo ""
				echo ""
				echo ""
				echo "========================================================================="
				echo "========================================================================="
				echo "=============Redis安装完成，启动脚本目录/usr/local/redis/bin============="
				echo "=============配置文件已复制到/usr/local/redis/bin目录下=================="
				echo "=============自行修改配置文件配置，开放对应端口=========================="
				echo "=============启动命令：/usr/local/redis/bin/redis-server redis.conf======"
				echo "=============查看是否启动名称：ps -ef|grep redis========================="
				echo "=============默认端口6379，默认不需要密码================================"
				echo "=============卸载：停止程序，删除$redis_home，rm -rf $redis_home========="
				echo "========================================================================="
				echo "========================================================================="
				echo ""	
				echo ""
				echo ""
			fi  >> /usr/local/redis/install.log
		else
			echo "make命令执行异常===================="
			exit
		fi
	fi
else
	echo "解压文件名称不是$redis_version=======，修改脚本部分代码重试========="
fi
echo ""
echo ""
echo "===========Redis安装完成，安装日志查看/usr/local/redis/install.log=========="
echo ""
echo ""
REDIS_CONF=/usr/local/redis/bin/redis.conf
#替换一行中的某部分
#格式：sed 's/要替换的字符串/新的字符串/g'（要替换的字符串可以用正则表达式）
# 设置daemonize yes开机启动
sed -i -e "s/daemonize no/daemonize yes/g" ${REDIS_CONF} #替换daemonize no为daemonize yes
sed -i -e "s/# requirepass foobared/requirepass mypassword/g" ${REDIS_CONF} #替换# requirepass foobared为requirepass mypassword
# 设置远程客户端连接reids
sed -i -e "s/protected-mode yes/protected-mode no/g" ${REDIS_CONF} #替换protected-mode yes为protected-mode no
sed -i -e "s/bind 127.0.0.1 -::1/# bind 127.0.0.1 -::1/g" ${REDIS_CONF} #替换bind 127.0.0.1 -::1为# bind 127.0.0.1 -::1
cat << 'EOF' >> /etc/profile
export PATH=/usr/local/redis/bin:$PATH # 配置redis环境变量
EOF
# ExecReload=/bin/kill -USR2 $MAINPID
sleep 1
source /etc/profile
/usr/local/redis/bin/redis-server /usr/local/redis/bin/redis.conf &
cat > /usr/lib/systemd/system/redis.service <<EOF
[Unit]
Description=Redis Server Manager
After=network.target
[Service]
Type=forking
ExecStart=/usr/local/redis/bin/redis-server /usr/local/redis/bin/redis.conf
ExecStop=/usr/local/redis/bin/redis-cli shutdown
PrivateTmp=true
[Install]
WantedBy=multi-user.target
EOF
# 重新加载系统服务配置
systemctl daemon-reload
# 重新启动redis服务
systemctl enable redis
sleep 2

# 安装mongodb环境
cd /root/runnergo_sh
file=mongodb-linux-x86_64-rhel70-4.4.0.tgz
url=https://fastdl.mongodb.org/linux/$file
db_dir=/data/db
install_dir=/usr/local
port=27017
color () {
    RES_COL=60
    MOVE_TO_COL="echo -en \\033[${RES_COL}G"
    SETCOLOR_SUCCESS="echo -en \\033[1;32m"
    SETCOLOR_FAILURE="echo -en \\033[1;31m"
    SETCOLOR_WARNING="echo -en \\033[1;33m"
    SETCOLOR_NORMAL="echo -en \E[0m"
    echo -n "$2" && $MOVE_TO_COL
    echo -n "["
    if [ $1 = "success" -o $1 = "0" ] ;then
        ${SETCOLOR_SUCCESS}
        echo -n $"  OK  "    
    elif [ $1 = "failure" -o $1 = "1"  ] ;then
        ${SETCOLOR_FAILURE}
        echo -n $"FAILED"
    else
        ${SETCOLOR_WARNING}
        echo -n $"WARNING"
    fi
    ${SETCOLOR_NORMAL}
    echo -n "]"
    echo                                                                                                                              
}
os_type (){
   awk -F'[ "]' '/^NAME/{print $2}' /etc/os-release
}
check () {
    [ -e $db_dir -o -e $install_dir/mongodb ] && { color 1 "MongoDB 数据库已安装";exit; }
    if [ `os_type` = "CentOS" ];then
        rpm -q curl  &> /dev/null || yum install -y -q curl
    elif [ `os_type` = "Ubuntu" ];then
        dpkg -l curl &> /dev/null || apt -y install curl
    else
        color 1 不支持当前操作系统
        exit
    fi
}
file_prepare () {
    if [ ! -e $file ];then
		if [ -e /root/runnergo_sh/mongodb-linux-x86_64-rhel70-4.4.0.tgz ];then
			echo "mongodb文件已经存在，无需下载直接解压"
		else
			curl -O  $url || { color 1  "MongoDB 数据库文件下载失败"; exit; }
		fi
    fi
}
install_mongodb () {
    tar xf $file -C $install_dir
    mkdir -p $db_dir
    ln -s $install_dir/mongodb-linux-x86_64-* $install_dir/mongodb
    echo PATH=$install_dir/mongodb/bin/:'$PATH' > /etc/profile.d/mongodb.sh
    . /etc/profile.d/mongodb.sh
    mongod --dbpath $db_dir --bind_ip_all --port $port --logpath $db_dir/mongod.log --fork
    [ $? -eq 0 ] && color 0 "MongoDB 数据库安装成功!" || color 1 "MongoDB 数据库安装失败!"
	echo "export PATH=$PATH:/usr/local/mongodb-linux-x86_64-rhel70-4.4.0/bin" >> /etc/profile
}
check 
file_prepare
install_mongodb
## 在 /lib/systemd/system/ 目录下新建 mongodb.service 文件
cd /lib/systemd/system/
##来到此目录下
touch mongodb.service
# ExecReload=/bin/kill -s HUP $MAINPID
echo "##创建配置文件，并添加内容
##编写内容：根据自己安装的位置进行修改[service]中的mongod及mogodb.conf的路径
##内容如下
[Unit]
Description=mongodb
After=network.target remote-fs.target nss-lookup.target
[Service]
Type=forking
ExecStart=/usr/local/mongodb-linux-x86_64-rhel70-4.4.0/bin/mongod --dbpath /data/db --bind_ip_all --port 27017 --logpath /data/db/mongod.log --fork
ExecStop=/usr/local/mongodb-linux-x86_64-rhel70-4.4.0/bin/mongod --shutdown --dbpath /data/db
PrivateTmp=true
[Install]
WantedBy=multi-user.target" > /lib/systemd/system/mongodb.service
##设置权限
chmod 754 mongodb.service
##然后重启加在服务配置文件
systemctl daemon-reload
systemctl enable mongodb
sleep 2

# 安装mysql环境
cd /root/runnergo_sh
if [ -e /root/runnergo_sh/mysql-5.7.40-linux-glibc2.12-x86_64.tar.gz ];then
    echo "mysql文件已经存在，无需下载直接解压"
else
	wget https://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-5.7.40-linux-glibc2.12-x86_64.tar.gz
fi
# MySQL安装包所在路径，需要带上包名。示例：PACKAGE_FULL_PATH=/root/mysql-5.7.40-linux-glibc2.12-x86_64.tar.gz
readonly PACKAGE_FULL_PATH=/root/runnergo_sh/mysql-5.7.40-linux-glibc2.12-x86_64.tar.gz
# MySQL安装主目录。示例：INSTALL_HOME=/usr/local/mysql
readonly INSTALL_HOME=/usr/local/mysql
# MySQL数据库root用户密码。示例：123456
readonly USER_PASSWD=123456
# 检查是否为root用户
if [[ "$UID" -ne 0 ]]; then
    echo "ERROR: the script must run as root"
    exit 3
fi
# 记录常规日志
function log_info(){
    echo "[$(date -d today +"%Y-%m-%d %H%M%S %:::z")] $1"
}
# 记录异常日志
function log_error(){
    echo -e "[$(date +"%Y-%m-%d %H%M%S %Z%:z")] [ERROR] $* \n"
    exit 1
}
# 检查结果
function check_result(){
    local ret_code=$1
    shift
    local error_msg=$*
    if [[ ${ret_code} -ne 0 ]]; then
        log_error ${error_msg}
    fi
}
# 校验参数
function check_param(){
    if [[ ! -n ${PACKAGE_FULL_PATH} ]] || [[ ! -n ${INSTALL_HOME} ]] || [[ ! -n ${USER_PASSWD} ]]; then
        log_error "Param: PACKAGE_FULL_PATH INSTALL_HOME USER_PASSWD can not be null"
    fi
    if [[ ! -f ${PACKAGE_FULL_PATH} ]]; then
        log_error "Param: PACKAGE_FULL_PATH is not a directory"
    fi
}
# 检查mysql进程是否存在
function check_mysql_process(){
    local mysql_process_count=`ps -ef | grep ${INSTALL_HOME} | grep -vwE "grep|vi|vim|tail|cat" | wc -l`
    if [[ ${mysql_process_count} -gt 0 ]]; then
        log_error "Please stop and uninstall the mysql first"
    fi
}
# 新建mysql用户组，mysql用户
function add_user(){
    # create group mysql
    grep "^mysql" /etc/group &> /dev/null
    if [[ $? -ne 0 ]]; then
        groupadd mysql
    fi
    # create user mysql
    id mysql &> /dev/null
    if [[ $? -ne 0 ]]; then
        useradd -r -g mysql -s /bin/false mysql
    fi
}
# 初始化my.cnf
function init_my_cnf(){
echo "[mysqld]
default-time_zone = '+8:00'
skip_name_resolve = 1                          # 只能用IP地址检查客户端的登录，不用主机名
character-set-server = utf8mb4                  # 数据库默认字符集,主流字符集支持一些特殊表情符号（特殊表情符占用4个字节）
transaction_isolation = READ-COMMITTED          # 事务隔离级别，默认为可重复读，MySQL默认可重复读级别
collation-server = utf8mb4_general_ci          # 数据库字符集对应一些排序等规则，注意要和character-set-server对应
init_connect='SET NAMES utf8mb4'                # 设置client连接mysql时的字符集,防止乱码
lower_case_table_names = 1                      # 是否对sql语句大小写敏感，1表示不敏感
max_connections = 2000                          # 最大连接数
max_connect_errors = 1000                      # 最大错误连接数
explicit_defaults_for_timestamp = true          # TIMESTAMP如果没有显示声明NOT NULL，允许NULL值
max_allowed_packet = 128M                      # SQL数据包发送的大小，如果有BLOB对象建议修改成1G
#interactive_timeout = 1800                      # MySQL连接闲置超过一定时间后(单位：秒)将会被强行关闭
wait_timeout = 1800                            # MySQL默认的wait_timeout值为8个小时, interactive_timeout参数需要同时配置才能生效
tmp_table_size = 16M                            # 内部内存临时表的最大值 ，设置成128M；比如大数据量的group by ,order by时可能用到临时表；超过了这个值将写入磁盘，系统IO压力增大
max_heap_table_size = 128M                      # 定义了用户可以创建的内存表(memory table)的大小
query_cache_size = 0                            # 禁用mysql的缓存查询结果集功能；后期根据业务情况测试决定是否开启；大部分情况下关闭下面两项
query_cache_type = 0  # 用户进程分配到的内存设置，每个session将会分配参数设置的内存大小
read_buffer_size = 2M                          # MySQL读入缓冲区大小。对表进行顺序扫描的请求将分配一个读入缓冲区，MySQL会为它分配一段内存缓冲区。
read_rnd_buffer_size = 8M                      # MySQL的随机读缓冲区大小
sort_buffer_size = 8M                          # MySQL执行排序使用的缓冲大小
binlog_cache_size = 1M                          # 一个事务，在没有提交的时候，产生的日志，记录到Cache中；等到事务提交需要提交的时候，则把日志持久化到磁盘。默认binlog_cache_size大小32K
back_log = 130                                  # 在MySQL暂时停止响应新请求之前的短时间内多少个请求可以被存在堆栈中；官方建议back_log = 50 + (max_connections / 5),封顶数为900
# 日志设置
# 主从复制设置
# Innodb设置
innodb_open_files = 500                        # 限制Innodb能打开的表的数据，如果库里的表特别多的情况，请增加这个。这个值默认是300
innodb_buffer_pool_size = 64M                  # InnoDB使用一个缓冲池来保存索引和原始数据，一般设置物理存储的60% ~ 70%；这里你设置越大,你在存取表里面数据时所需要的磁盘I/O越少
innodb_log_buffer_size = 2M                    # 此参数确定写日志文件所用的内存大小，以M为单位。缓冲区更大能提高性能，但意外的故障将会丢失数据。MySQL开发人员建议设置为1－8M之间
innodb_flush_method = O_DIRECT                  # O_DIRECT减少操作系统级别VFS的缓存和Innodb本身的buffer缓存之间的冲突
innodb_write_io_threads = 4                    # CPU多核处理能力设置，根据读，写比例进行调整
innodb_read_io_threads = 4
innodb_lock_wait_timeout = 120                  # InnoDB事务在被回滚之前可以等待一个锁定的超时秒数。InnoDB在它自己的锁定表中自动检测事务死锁并且回滚事务。InnoDB用LOCK TABLES语句注意到锁定设置。默认值是50秒
innodb_log_file_size = 32M                      # 此参数确定数据日志文件的大小，更大的设置可以提高性能，但也会增加恢复故障数据库所需的时间
#sql_mode
sql_mode=NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION
" > /etc/my.cnf
}
# 安装MySQL
function install_mysql(){
    rpm -e --nodeps $(rpm -qa | grep mariadb)
    # 创建安装主目录
    mkdir -p ${INSTALL_HOME}
    # 解压mysql安装包到安装主目录
    tar -zxvf ${PACKAGE_FULL_PATH} -C ${INSTALL_HOME} > /dev/null 2>&1
    echo ">>> tar finish"
    check_result $? "unzip MySQL package error"
    local package_name=`ls ${INSTALL_HOME} | grep mysql`
    mv ${INSTALL_HOME}/${package_name}/* ${INSTALL_HOME}
    rm -rf ${INSTALL_HOME}/${package_name}
    cd ${INSTALL_HOME}
    # 创建一个自由目录，可用于dump等操作
    mkdir mysql-files
    chown mysql:mysql mysql-files
    chmod 750 mysql-files
    # 安装并指定用户
    ./bin/mysqld --initialize-insecure --user=mysql
    echo ">>> mysqld finish"
    ./bin/mysql_ssl_rsa_setup
    ./bin/mysqld_safe --user=mysql &
    echo ">>> mysqld_safe finish"
    # 初始化my.cnf
    init_my_cnf
    #配置自启动
    cp -pf ${INSTALL_HOME}/support-files/mysql.server /etc/init.d/mysql.server
    chmod 755 /etc/init.d/mysql.server
    systemctl daemon-reload
    chkconfig --add mysql.server
    # 添加环境变量
    echo "export PATH=${INSTALL_HOME}/bin:\$PATH" >> /etc/profile
    echo "### MySQL_PATH finish"
	source /etc/profile
    # 启动MySQL
    echo ">>> Start MySQL"
    start
    sleep 3
    cd ${INSTALL_HOME}
# 修改MySQL用户的root密码
./bin/mysql -uroot << EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '${USER_PASSWD}';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '${USER_PASSWD}' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF
}
# 启动MySQL
function start() {
    systemctl start mysql
}
# 安装MySQL
function install() {
    log_info "++++++++++ step 1 ++++++++++"
    check_param
    log_info "check_param finish"
    log_info "++++++++++ step 2 ++++++++++"
    check_mysql_process
    log_info "check_mysql_process finish"
    log_info "++++++++++ step 3 ++++++++++"
    add_user
    log_info "add_user finish"
    log_info "++++++++++ step 4 ++++++++++"
    install_mysql
    log_info "install_mysql finish"
}
install
cd /root/runnergo_sh
sleep 2
rm -rf /root/runnergo_sh/node-v16.16.0-linux-x64.tar.xz
rm -rf /root/runnergo_sh/go1.19.3.linux-amd64.tar.gz
rm -rf /root/runnergo_sh/apache-zookeeper-3.6.4-bin.tar.gz
rm -rf /root/runnergo_sh/kafka_2.13-3.4.1.tgz
rm -rf $redis_download/$redis_version.tar.gz
rm -rf /root/runnergo_sh/mongodb-linux-x86_64-rhel70-4.4.0.tgz
rm -rf ${PACKAGE_FULL_PATH}

#################################################################################################################################################

# 创建mongodb数据库
mongo mongodb://localhost:27017 <<EOF > /dev/null
use runnergo
db.runnergo.insert( { x: 1, y: 1 } )
EOF
sleep 2

# 手动创建日志目录
mkdir -p /data/logs/RunnerGo
touch /data/logs/RunnerGo/RunnerGo_management-info.log
touch /data/logs/RunnerGo/RunnerGo_management-err.log
touch /data/logs/RunnerGo/RunnerGo-engine-info.log
touch /data/logs/RunnerGo/RunnerGo-collector-info.log

sleep 2
dir_runnergo_sh=$(find / -name runnergo_sh)
cd $dir_runnergo_sh
# 拉取runnergo-management-open仓库部署
mkdir -p /usr/local/gopath
# cat << 'EOF' >> /etc/profile中>>表示追加的意思
cat << 'EOF' >> /etc/profile
export WORKSPACE=/usr/local/gopath # 设置工作目录
export GO_INSTALL_DIR=/usr/local/go # Go安装目录
export GOROOT=$GO_INSTALL_DIR # GOROOT设置
export GOPATH=$WORKSPACE # GOPATH 设置
export PATH=$GOROOT/bin:$GOPATH/bin:$PATH # 将Go语言自带的和通过go install安装的二进制文件加入到PATH路径中
export GO111MODULE=on # 开启Go moudles特性
export GOPROXY=https://mirrors.aliyun.com/goproxy,https://goproxy.cn,direct # 安装Go模块时，代理服务器设置
export GOSUMDB=off # 关闭校验Go依赖包的哈希值
EOF
sleep 1
source /etc/profile
git clone https://gitee.com/Runner-Go-Team/runnergo-management-open.git
sleep 2
# 修改runnergo_database.sql文件的内容，自动化创建mysql数据库
dir_runnergo_database=$(find / -name runnergo_database.sql)
sed -i -e "s/SET NAMES utf8mb4;/SET NAMES utf8mb4;DROP DATABASE IF EXISTS runnergo;CREATE DATABASE IF NOT EXISTS runnergo DEFAULT CHARSET utf8 COLLATE utf8_general_ci;USE runnergo;/g" ${dir_runnergo_database}
mysql -h127.0.0.1 -P3306 -uroot -p123456 < ${dir_runnergo_database}
# 修改配置文件
dir_runnergo_management_open=$(find / -name runnergo-management-open)
cat > $dir_runnergo_management_open/configs/dev.yaml <<EOF
base:
  is_debug: false
  domain: "http://localhost:8080"
  max_concurrency: 1000000

http:
  port: 58889

mysql:
  username: "root"
  password: "123456"
  host: "127.0.0.1"
  port: 3306
  dbname: "runnergo"
  charset: "utf8mb4"

mongodb:
  dsn: "mongodb://127.0.0.1:27017/runnergo"
  database: runnergo
  pool_size: 20

jwt:
  issuer: "runnergo"
  secret: "kp#test"


clients:
  runner:
    run_api: "http://localhost:8002/runner/run_api" 
    run_scene: "http://localhost:8002/runner/run_scene"
    stop_scene: "http://localhost:8002/runner/stop_scene"
    run_plan: "http://localhost:8002/runner/run_plan"
    stop_plan: "http://localhost:8002/runner/stop"

proof:
  info_log: "/data/logs/RunnerGo/RunnerGo_management-info.log"
  err_log: "/data/logs/RunnerGo/RunnerGo_management-err.log"

log:
  InfoPath: "/data/logs/RunnerGo/RunnerGo_management-info.log"
  ErrPath: "/data/logs/RunnerGo/RunnerGo_management-err.log"

redis:
  address: "127.0.0.1:6379"
  password: "mypassword"
  db: 0

redisReport:
  address: "127.0.0.1:6379"
  password: "mypassword"
  db: 0

smtp:
  host:
  port:
  email:
  password:

sms:
  id:
  secret:

inviteData:
  AesSecretKey: "runnergo"

#初始化压力机可使用分区
canUsePartitionTotalNum: 2

#单台压力机能快速负载的并发数
oneMachineCanConcurrenceNum: 5000

#运行计划相关配置
machineConfig:
  MachineAliveTime: 10      # 压力机上报心跳超时时间，单位：秒
  InitPartitionTotalNum: 2  # 初始化可用kafka分区数量设置
  CpuTopLimit: 65           # 可参与压测的压力机cpu使用率上限
  MemoryTopLimit: 65        # 可参与压测的压力机memory使用率上限
  DiskTopLimit: 55          # 可参与压测的压力机disk使用率上限

# 默认用户登录token的失效时间（单位：小时）
defaultTokenExpireTime: 24

# 保留性能测试的debug日志时间（单位：月）
keepStressDebugLogTime: 1
EOF

# 替换localhost地址为本地地址
ip_addr=$(/sbin/ip route get 1| sed 's/^.*src \(\S*\).*$/\1/;q')
sed -i -e "s/localhost/${ip_addr}/g" /root/runnergo_sh/runnergo-management-open/configs/dev.yaml

echo $dir_runnergo_management_open
cd $dir_runnergo_management_open
go mod tidy
go build -o /root/runnergo_sh/runnergo-management-open/systemd_runnergo_management main.go
/root/runnergo_sh/runnergo-management-open/systemd_runnergo_management &

sleep 2
dir_runnergo_sh=$(find / -name runnergo_sh)
cd $dir_runnergo_sh
# 拉取Runner-go-management-websocket-open仓库部署
# sed -i -e "s/runnergo-management-open/Runner-go-management-websocket-open/g" /etc/profile
# sleep 1
# source /etc/profile
git clone https://gitee.com/Runner-Go-Team/Runner-go-management-websocket-open.git
# 修改配置文件
dir_runnergo_management_websocket_open=$(find / -name Runner-go-management-websocket-open)
cat > $dir_runnergo_management_websocket_open/configs/dev.yaml <<EOF
base:
  is_debug: false
  domain: "http://localhost:8080"
  max_concurrency: 1000000

http:
  port: 58887

mysql:
  username: "root"
  password: "123456"
  host: "127.0.0.1"
  port: 3306
  dbname: "runnergo"
  charset: "utf8mb4"

mongodb:
  dsn: "mongodb://127.0.0.1:27017/runnergo"
  database: runnergo
  pool_size: 20

jwt:
  issuer: "runnergo"
  secret: "kp#test"


clients:
  runner:
    run_api: "http://localhost:8002/runner/run_api" 
    run_scene: "http://localhost:8002/runner/run_scene"
    stop_scene: "http://localhost:8002/runner/stop_scene"
    run_plan: "http://localhost:8002/runner/run_plan"
    stop_plan: "http://localhost:8002/runner/stop"

proof:
  info_log: "/data/logs/RunnerGo/RunnerGo_management-info.log"
  err_log: "/data/logs/RunnerGo/RunnerGo_management-err.log"

log:
  InfoPath: "/data/logs/RunnerGo/RunnerGo_management-info.log"
  ErrPath: "/data/logs/RunnerGo/RunnerGo_management-err.log"

redis:
  address: "127.0.0.1:6379"
  password: "mypassword"
  db: 0

redisReport:
  address: "127.0.0.1:6379"
  password: "mypassword"
  db: 0

smtp:
  host:
  port:
  email:
  password:

sms:
  id:
  secret:

inviteData:
  AesSecretKey: "runnergo"

#初始化压力机可使用分区
canUsePartitionTotalNum: 2

#单台压力机能快速负载的并发数
oneMachineCanConcurrenceNum: 5000

#运行计划相关配置
machineConfig:
  MachineAliveTime: 10      # 压力机上报心跳超时时间，单位：秒
  InitPartitionTotalNum: 2  # 初始化可用kafka分区数量设置
  CpuTopLimit: 65           # 可参与压测的压力机cpu使用率上限
  MemoryTopLimit: 65        # 可参与压测的压力机memory使用率上限
  DiskTopLimit: 55          # 可参与压测的压力机disk使用率上限
EOF

# 替换localhost地址为本地地址
ip_addr=$(/sbin/ip route get 1| sed 's/^.*src \(\S*\).*$/\1/;q')
sed -i -e "s/localhost/${ip_addr}/g" /root/runnergo_sh/Runner-go-management-websocket-open/configs/dev.yaml

cd $dir_runnergo_management_websocket_open
echo $dir_runnergo_management_websocket_open
go mod tidy
go build -o /root/runnergo_sh/Runner-go-management-websocket-open/systemd_runnergo_management_websocket main.go
/root/runnergo_sh/Runner-go-management-websocket-open/systemd_runnergo_management_websocket &

sleep 2
dir_runnergo_sh=$(find / -name runnergo_sh)
cd $dir_runnergo_sh
# 拉取runnergo-engine-open仓库部署
# sed -i -e "s/Runner-go-management-websocket-open/runnergo-engine-open/g" /etc/profile
# sleep 1
# source /etc/profile
git clone https://gitee.com/Runner-Go-Team/runnergo-engine-open.git
# 修改配置文件
dir_runnergo_engine_open=$(find / -name runnergo-engine-open)
cat > $dir_runnergo_engine_open/open.yaml <<EOF


heartbeat:
  port: 8002
  region: "北京"
  duration: 2
  resources: 5


http:
  address: "localhost:8002"                                    #本服务host
  port: 8002                                               #本服务端口
  readTimeout: 5000                                          #fasthttp client完整响应读取(包括正文)的最大持续时间
  writeTimeout: 5000                                         #fasthttp client完整请求写入(包括正文)的最大持续时间
  noDefaultUserAgentHeader: true
  maxConnPerHost: 10000
  MaxIdleConnDuration: 5000                                  #空闲的保持连接将在此持续时间后关闭
  NoDefaultUserAgentHeader: 30000

redis:
  address: "127.0.0.1:6379"
  password: "mypassword"
  db: 0

reportRedis:
  address: "127.0.0.1:6379"
  password: "mypassword"
  db: 0

kafka:
  address: "PLAINTEXT:9092"
  topIc: "runnergo"


mongo:
  dsn: "mongodb://127.0.0.1:27017/runnergo"
  database: "runnergo"
  stressDebugTable: "stress_debug"
  sceneDebugTable: "scene_debug"
  apiDebugTable: "api_debug"
  debugTable: "debug_status"
  autoTable: "auto_report"



machine:
  maxGoroutines: 5000
  serverType: 1
  netName: ""
  diskName: ""


log:
  path: "/data/logs/RunnerGo/RunnerGo-engine-info.log"         #本服务log存放地址


management:
  notifyStopStress: "http://localhost:58889/management/api/v1/plan/notify_stop_stress"                          #management服务停止性能任务接口
  notifyRunFinish: "http://localhost:58889/management/api/v1/auto_plan/notify_run_finish"                           #management服务任务完成接口
EOF

# 替换localhost地址为本地地址
ip_addr=$(/sbin/ip route get 1| sed 's/^.*src \(\S*\).*$/\1/;q')
sed -i -e "s/localhost/${ip_addr}/g" /root/runnergo_sh/runnergo-engine-open/open.yaml
# 针对PLAINTEXT:9092替换设置
sed -i -e "s/PLAINTEXT/${ip_addr}/g" /root/runnergo_sh/runnergo-engine-open/open.yaml

cd $dir_runnergo_engine_open
echo $dir_runnergo_engine_open
go mod tidy
go build -o /root/runnergo_sh/runnergo-engine-open/systemd_runnergo_engine main.go
/root/runnergo_sh/runnergo-engine-open/systemd_runnergo_engine &

sleep 2
dir_runnergo_sh=$(find / -name runnergo_sh)
cd $dir_runnergo_sh
# 拉取runnergo-collector-open仓库部署
# sed -i -e "s/runnergo-engine-open/runnergo-collector-open/g" /etc/profile
# sleep 1
# source /etc/profile
git clone https://gitee.com/Runner-Go-Team/runnergo-collector-open.git
# 修改配置文件
# 修改 config/server.properties
# vim /xx/xx/config/server.properties
# 本地监听的服务器端口
# listeners=PLAINTEXT://:9092
# 提供外网访问时需要配置, 192.168.201.128 是当前服务器 IP
# advertised.listeners=PLAINTEXT://192.168.201.128:9092
dir_runnergo_collector_open=$(find / -name runnergo-collector-open)
cat > $dir_runnergo_collector_open/open.yaml <<EOF
http:
  host: "localhost:20125"

kafka:
  host: "PLAINTEXT:9092"
  topic: "runnergo"
  key: "kafka:report:partition"
  num: 2
  totalKafkaPartition: "TotalKafkaPartition"
  stressBelongPartition: "StressBelongPartition"

reportRedis:
  address: "127.0.0.1:6379"
  password: "mypassword"
  db: 0

redis:
  address: "127.0.0.1:6379"
  password: "mypassword"
  db: 0

log:
  path: "/data/logs/RunnerGo/RunnerGo-collector-info.log"

management:
  notifyStopStress: "http://localhost:58889/management/api/v1/plan/notify_stop_stress"
EOF

# 替换localhost地址为本地地址
ip_addr=$(/sbin/ip route get 1| sed 's/^.*src \(\S*\).*$/\1/;q')
sed -i -e "s/localhost/${ip_addr}/g" /root/runnergo_sh/runnergo-collector-open/open.yaml
# 针对PLAINTEXT:9092替换设置
sed -i -e "s/PLAINTEXT/${ip_addr}/g" /root/runnergo_sh/runnergo-collector-open/open.yaml

cd $dir_runnergo_collector_open
echo $dir_runnergo_collector_open
go mod tidy
go build -o /root/runnergo_sh/runnergo-collector-open/systemd_runnergo_collector main.go
/root/runnergo_sh/runnergo-collector-open/systemd_runnergo_collector &

sleep 2
dir_runnergo_sh=$(find / -name runnergo_sh)
cd $dir_runnergo_sh
# 拉取file-server仓库部署
git clone https://gitee.com/Runner-Go-Team/file-server.git
# 进入对应file_servern服务目录运行项目
dir_file_servern=$(find / -name file-server)
cd $dir_file_servern
echo $dir_file_servern
npm install
node app.js &

sleep 2
dir_runnergo_sh=$(find / -name runnergo_sh)
cd $dir_runnergo_sh
# 拉取runnergo-fe-open仓库部署
git clone https://gitee.com/Runner-Go-Team/runnergo-fe-open.git
# 修改配置文件
dir_runnergo_fe_open=$(find / -name runnergo-fe-open)
cat > $dir_runnergo_fe_open/config/server.js <<EOF
// 后端http接口地址
export const RD_BaseURL = {
    development: 'http://localhost:58889',
    test: '测试环境地址',
    production: '线上环境地址',
};


// 后端websocke地址
export const RD_websocketUrl = {
    development: 'http://localhost:58887',
    test: '测试环境地址',
    production: '线上环境地址'
};


// 后端文件存储地址
export const RD_FileURL = 'http://localhost:20004';


export const RD_BASE_URL = RD_BaseURL[NODE_ENV];
export const RD_WEBSOCKET_URL = RD_websocketUrl[NODE_ENV];


export default {
    RD_BASE_URL,
};
EOF

# 替换localhost地址为本地地址
ip_addr=$(/sbin/ip route get 1| sed 's/^.*src \(\S*\).*$/\1/;q')
sed -i -e "s/localhost/${ip_addr}/g" /root/runnergo_sh/runnergo-fe-open/config/server.js

cd $dir_runnergo_fe_open
echo $dir_runnergo_fe_open
npm install
npm start &

sleep 2
# 设置runnergo-management服务开机自启
cd /usr/lib/systemd/system/
##来到此目录下
touch runnergo_management_open.service
touch /root/runnergo_sh/runnergo_management_open.sh
cat > /root/runnergo_sh/runnergo_management_open.sh <<EOF
#!/bin/bash

/root/runnergo_sh/runnergo-management-open/systemd_runnergo_management
EOF
chmod 777 -R /root/runnergo_sh/runnergo_management_open.sh
touch /root/runnergo_sh/runnergo_management_open_stop.sh
cat > /root/runnergo_sh/runnergo_management_open_stop.sh <<EOF
#!/bin/bash

/bin/kill -p `ps -ef | grep runnergo_management_open | awk '{print $2}'`
EOF
chmod 777 -R /root/runnergo_sh/runnergo_management_open_stop.sh
# 问题描述：Systemd 是所有服务的父进程，/etc/profile等配置的环境变量对其无效
# 需要配置Environment="JAVA_HOME=/opt/jdk1.8.0_192"环境变量，可以配置多个，空格隔开
# 官方告诉可以使用Environment以及EnvironmentFile为服务进程配置环境变量
# 有个大坑就是Type需要设置为forking，如果设置为simple，会启动不起来
# Environment="GOPATH=/root/runnergo_sh/runnergo-management-open"
cat > /usr/lib/systemd/system/runnergo_management_open.service <<EOF
[Unit]
Description=golang web application
After=syslog.target network.target
[Service]
Type=forking
WorkingDirectory=/root/runnergo_sh/runnergo-management-open
Environment="GOPATH=/usr/local/gopath"
ExecStart=/bin/bash -c "/root/runnergo_sh/runnergo_management_open.sh &"
ExecStop=/bin/bash -c "/root/runnergo_sh/runnergo_management_open_stop.sh &"
Restart=on-failure
PrivateTmp=true
[Install]
WantedBy=multi-user.target
EOF
##设置权限
chmod 754 runnergo_management_open.service
##然后重启加在服务配置文件
systemctl daemon-reload
systemctl enable runnergo_management_open

# 设置Runner-go-management-websocket-open服务开机自启
touch Runner_go_management_websocket_open.service
touch /root/runnergo_sh/Runner_go_management_websocket_open.sh
cat > /root/runnergo_sh/Runner_go_management_websocket_open.sh <<EOF
#!/bin/bash

/root/runnergo_sh/Runner-go-management-websocket-open/systemd_runnergo_management_websocket
EOF
chmod 777 -R /root/runnergo_sh/Runner_go_management_websocket_open.sh
touch /root/runnergo_sh/Runner_go_management_websocket_open_stop.sh
cat > /root/runnergo_sh/Runner_go_management_websocket_open_stop.sh <<EOF
#!/bin/bash

/bin/kill -p `ps -ef | grep Runner_go_management_websocket_open | awk '{print $2}'`
EOF
chmod 777 -R /root/runnergo_sh/Runner_go_management_websocket_open_stop.sh
# 问题描述：Systemd 是所有服务的父进程，/etc/profile等配置的环境变量对其无效
# 需要配置Environment="JAVA_HOME=/opt/jdk1.8.0_192"环境变量，可以配置多个，空格隔开
# 官方告诉可以使用Environment以及EnvironmentFile为服务进程配置环境变量
# 有个大坑就是Type需要设置为forking，如果设置为simple，会启动不起来
# Environment="GOPATH=/root/runnergo_sh/Runner-go-management-websocket-open"
cat > /usr/lib/systemd/system/Runner_go_management_websocket_open.service <<EOF
[Unit]
Description=golang web application
After=syslog.target network.target
[Service]
Type=forking
WorkingDirectory=/root/runnergo_sh/Runner-go-management-websocket-open
Environment="GOPATH=/usr/local/gopath"
ExecStart=/bin/bash -c "/root/runnergo_sh/Runner_go_management_websocket_open.sh &"
ExecStop=/bin/bash -c "/root/runnergo_sh/Runner_go_management_websocket_open_stop.sh &"
Restart=on-failure
PrivateTmp=true
[Install]
WantedBy=multi-user.target
EOF
##设置权限
chmod 754 Runner_go_management_websocket_open.service
##然后重启加在服务配置文件
systemctl daemon-reload
systemctl enable Runner_go_management_websocket_open

# 设置runnergo-engine-open服务开机自启
touch runnergo_engine_open.service
touch /root/runnergo_sh/runnergo_engine_open.sh
cat > /root/runnergo_sh/runnergo_engine_open.sh <<EOF
#!/bin/bash

/root/runnergo_sh/runnergo-engine-open/systemd_runnergo_engine
EOF
chmod 777 -R /root/runnergo_sh/runnergo_engine_open.sh
touch /root/runnergo_sh/runnergo_engine_open_stop.sh
cat > /root/runnergo_sh/runnergo_engine_open_stop.sh <<EOF
#!/bin/bash

/bin/kill -p `ps -ef | grep runnergo_engine_open | awk '{print $2}'`
EOF
chmod 777 -R /root/runnergo_sh/runnergo_engine_open_stop.sh
# 问题描述：Systemd 是所有服务的父进程，/etc/profile等配置的环境变量对其无效
# 需要配置Environment="JAVA_HOME=/opt/jdk1.8.0_192"环境变量，可以配置多个，空格隔开
# 官方告诉可以使用Environment以及EnvironmentFile为服务进程配置环境变量
# 有个大坑就是Type需要设置为forking，如果设置为simple，会启动不起来
# Environment="GOPATH=/root/runnergo_sh/runnergo-engine-open"
cat > /usr/lib/systemd/system/runnergo_engine_open.service <<EOF
[Unit]
Description=golang web application
After=syslog.target network.target
[Service]
Type=forking
WorkingDirectory=/root/runnergo_sh/runnergo-engine-open
Environment="GOPATH=/usr/local/gopath"
ExecStart=/bin/bash -c "/root/runnergo_sh/runnergo_engine_open.sh &"
ExecStop=/bin/bash -c "/root/runnergo_sh/runnergo_engine_open_stop.sh &"
Restart=on-failure
PrivateTmp=true
[Install]
WantedBy=multi-user.target
EOF
##设置权限
chmod 754 runnergo_engine_open.service
##然后重启加在服务配置文件
systemctl daemon-reload
systemctl enable runnergo_engine_open

# 设置runnergo-collector-open服务开机自启
touch runnergo_collector_open.service
touch /root/runnergo_sh/runnergo_collector_open.sh
cat > /root/runnergo_sh/runnergo_collector_open.sh <<EOF
#!/bin/bash

/root/runnergo_sh/runnergo-collector-open/systemd_runnergo_collector
EOF
chmod 777 -R /root/runnergo_sh/runnergo_collector_open.sh
touch /root/runnergo_sh/runnergo_collector_open_stop.sh
cat > /root/runnergo_sh/runnergo_collector_open_stop.sh <<EOF
#!/bin/bash

/bin/kill -p `ps -ef | grep runnergo_collector_open | awk '{print $2}'`
EOF
chmod 777 -R /root/runnergo_sh/runnergo_collector_open_stop.sh
# 问题描述：Systemd 是所有服务的父进程，/etc/profile等配置的环境变量对其无效
# 需要配置Environment="JAVA_HOME=/opt/jdk1.8.0_192"环境变量，可以配置多个，空格隔开
# 官方告诉可以使用Environment以及EnvironmentFile为服务进程配置环境变量
# 有个大坑就是Type需要设置为forking，如果设置为simple，会启动不起来
# Environment="GOPATH=/root/runnergo_sh/runnergo-collector-open"
cat > /usr/lib/systemd/system/runnergo_collector_open.service <<EOF
[Unit]
Description=golang web application
After=syslog.target network.target
[Service]
Type=forking
WorkingDirectory=/root/runnergo_sh/runnergo-collector-open
Environment="GOPATH=/usr/local/gopath"
ExecStart=/bin/bash -c "/root/runnergo_sh/runnergo_collector_open.sh &"
ExecStop=/bin/bash -c "/root/runnergo_sh/runnergo_collector_open_stop.sh &"
Restart=on-failure
PrivateTmp=true
[Install]
WantedBy=multi-user.target
EOF
##设置权限
chmod 754 runnergo_collector_open.service
##然后重启加在服务配置文件
systemctl daemon-reload
systemctl enable runnergo_collector_open

# 设置file-server服务开机自启
touch file_server.service
touch /root/runnergo_sh/file_server.sh
cat > /root/runnergo_sh/file_server.sh <<EOF
#!/bin/bash

cd /root/runnergo_sh/file-server
node app.js
EOF
chmod 777 -R /root/runnergo_sh/file_server.sh
touch /root/runnergo_sh/file_server_stop.sh
cat > /root/runnergo_sh/file_server_stop.sh <<EOF
#!/bin/bash

/bin/kill -p `ps -ef | grep file_server | awk '{print $2}'`
EOF
chmod 777 -R /root/runnergo_sh/file_server_stop.sh
# 问题描述：Systemd 是所有服务的父进程，/etc/profile等配置的环境变量对其无效
# 需要配置Environment="JAVA_HOME=/opt/jdk1.8.0_192"环境变量，可以配置多个，空格隔开
# 官方告诉可以使用Environment以及EnvironmentFile为服务进程配置环境变量
# 有个大坑就是Type需要设置为forking，如果设置为simple，会启动不起来
cat > /usr/lib/systemd/system/file_server.service <<EOF
[Unit]
Description=golang web application
After=syslog.target network.target
[Service]
Type=forking
WorkingDirectory=/root/runnergo_sh/file-server
ExecStart=/bin/bash -c "/root/runnergo_sh/file_server.sh &"
ExecStop=/bin/bash -c "/root/runnergo_sh/file_server_stop.sh &"
Restart=on-failure
PrivateTmp=true
[Install]
WantedBy=multi-user.target
EOF
##设置权限
chmod 754 file_server.service
##然后重启加在服务配置文件
systemctl daemon-reload
systemctl enable file_server

# 设置runnergo-fe-open服务开机自启
touch runnergo_fe_open.service
touch /root/runnergo_sh/runnergo_fe_open.sh
cat > /root/runnergo_sh/runnergo_fe_open.sh <<EOF
#!/bin/bash

cd /root/runnergo_sh/runnergo-fe-open
npm start
EOF
chmod 777 -R /root/runnergo_sh/runnergo_fe_open.sh
touch /root/runnergo_sh/runnergo_fe_open_stop.sh
cat > /root/runnergo_sh/runnergo_fe_open_stop.sh <<EOF
#!/bin/bash

/bin/kill -p `ps -ef | grep runnergo_fe_open | awk '{print $2}'`
EOF
chmod 777 -R /root/runnergo_sh/runnergo_fe_open_stop.sh
# 问题描述：Systemd 是所有服务的父进程，/etc/profile等配置的环境变量对其无效
# 需要配置Environment="JAVA_HOME=/opt/jdk1.8.0_192"环境变量，可以配置多个。空格隔开
# 官方告诉可以使用Environment以及EnvironmentFile为服务进程配置环境变量
# 有个大坑就是Type需要设置为forking，如果设置为simple，会启动不起来
cat > /usr/lib/systemd/system/runnergo_fe_open.service <<EOF
[Unit]
Description=golang web application
After=syslog.target network.target
[Service]
Type=forking
WorkingDirectory=/root/runnergo_sh/runnergo-fe-open
ExecStart=/bin/bash -c "/root/runnergo_sh/runnergo_fe_open.sh &"
ExecStop=/bin/bash -c "/root/runnergo_sh/runnergo_fe_open_stop.sh &"
Restart=on-failure
PrivateTmp=true
[Install]
WantedBy=multi-user.target
EOF
##设置权限
chmod 754 runnergo_fe_open.service
##然后重启加在服务配置文件
systemctl daemon-reload
systemctl enable runnergo_fe_open

# 报错mysql操作失败，需要进入到mysql内部执行如下命令
# 1、执行：mysql -h127.0.0.1 -P3306 -uroot -p123456
# 2、use runnergo
# 3、
# alter table preinstall_conf add column debug_mode varchar(100) not null default 'stop' comment 'debug模式：stop-关闭，all-开启全部日志，only_success-开启仅成功日志，only_error-开启仅错误日志' after control_mode;
# alter table stress_plan_report add column debug_mode varchar(100) not null default 'stop' comment 'debug模式：stop-关闭，all-开启全部日志，only_success-开启仅成功日志，only_error-开启仅错误日志' after control_mode;
# alter table stress_plan_task_conf add column debug_mode varchar(100) not null default 'stop' comment 'debug模式：stop-关闭，all-开启全部日志，only_success-开启仅成功日志，only_error-开启仅错误日志' after control_mode;
# alter table stress_plan_timed_task_conf add column debug_mode varchar(100) not null default 'stop' comment 'debug模式：stop-关闭，all-开启全部日志，only_success-开启仅成功日志，only_error-开启仅错误日志' after control_mode;
# 4、重启服务：systemctl restart runnergo_management_open

# 如果出现报错信息：
# 1、server/dispose.go:42	topic  :runnergo, 创建消费者失败: kafka: client has run out of available brokers to talk to: dial tcp 192.168.0.105:9092: connect: connection refused   host:  192.168.0.105:9092
# 2、ERROR	server/dispose.go:49	消费分区错误：分区1, 错误：kafka server: Request was for a topic or partition that does not exist on this broker： 
# 3、请使用 kafka-topics.sh --bootstrap-server 127.0.0.1:9092 --list 指令查找出所有的topics
# 4、使用指令 kafka-topics.sh --bootstrap-server 127.0.0.1:9092 --delete --topic topicname (第三条指令查找出的topic名字)，删除所有的topic
# 5、重启kafka：systemctl restart kafka、重启runnergo_collector_open服务：systemctl restart runnergo_collector_open
