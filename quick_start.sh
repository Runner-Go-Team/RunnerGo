#! /bin/sh
#Install Latest Stable Runner-Go Release

RGVERSION='v2.0.0'  #RunnerGo版本
RG_BASE='/data' #RunnerGo安装目录
os=`uname -a`

if [ "$(uname)" == "Darwin" ];then
    # Mac OS X 操作系统
    echo "不支持Mac OS X安装，请使用Linux系统安装,安装终止"
    exit
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ];then   
    # GNU/Linux操作系统
    echo "检测到Linux系统，准备安装"
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ];then    
    # Windows NT操作系统
    echo "不支持Windows安装,请使用Linux系统安装，安装终止"
    exit    
fi


#查找最快的github服务
git_urls=('github.com' 'hub.fastgit.org' 'ghproxy.com/https://github.com')
for git_url in ${git_urls[*]}
do
        success="true"
        for i in {1..3}
        do
                echo -ne "检测 ${git_url} ... ${i} "
            curl -m 5 -kIs https://${git_url} >/dev/null
                if [ $? != 0 ];then
                        echo "failed"
                        success="false"
                        break
                else
                        echo "ok"
                fi
        done
        if [ ${success} == "true" ];then
                server_url=${git_url}
                break
        fi
done

if [ "x${server_url}" == "x" ];then
    echo "没有找到稳定的下载服务器，请稍候重试"
    exit 1
fi
echo "使用 ${server_url} 下载软件包"

#https://github.com/Runner-Go-Team/RunnerGo/archive/refs/tags/v0.1.tar.gz
DOWNLOAD_URL="https://${server_url}/Runner-Go-Team/RunnerGo/archive/refs/tags/${RGVERSION}.tar.gz"
echo "软件包下载地址${DOWNLOAD_URL}"
wget --no-check-certificate ${DOWNLOAD_URL}
tar zxvf ${RGVERSION}.tar.gz

#进入软件包
echo "进入 RunnerGo-${RGVERSION:1}"
cd "RunnerGo-${RGVERSION:1}"

__current_dir=$(
   cd "$(dirname "$0")"
   pwd
)
function log() {
   message="[RunnerGo Log]: $1 "
   echo -e "${message}" 2>&1 | tee -a ${__current_dir}/install.log
}
set -a
#获取ip
__local_ip=$(hostname -I|cut -d" " -f 1)


#需要判断是全新安装还是升级

#略

log "拷贝安装文件到目标目录"
mkdir -p ${RG_BASE}/runnergo
cp -Rf ./runnergo ${RG_BASE}/runnergo/runnergo

log "======================= 开始安装 ======================="
#Install docker & docker-compose
##Install Latest Stable Docker Release
if which docker >/dev/null; then
   log "检测到 Docker 已安装，跳过安装步骤"
   log "启动 Docker "
   service docker start 2>&1 | tee -a ${__current_dir}/install.log
else
   if [[ -d docker ]]; then
      log "... 离线安装 docker"
      cp docker/bin/* /usr/bin/
      cp docker/service/docker.service /etc/systemd/system/
      chmod +x /usr/bin/docker*
      chmod 754 /etc/systemd/system/docker.service
      log "... 启动 docker"
      service docker start 2>&1 | tee -a ${__current_dir}/install.log

   else
      log "... 在线安装 docker"
      curl -fsSL https://get.docker.com -o get-docker.sh 2>&1 | tee -a ${__current_dir}/install.log
      sudo sh get-docker.sh --mirror Aliyun 2>&1 | tee -a ${__current_dir}/install.log
      log "... 启动 docker"
      service docker start 2>&1 | tee -a ${__current_dir}/install.log
   fi
fi

# 检查docker服务是否正常运行
docker ps 1>/dev/null 2>/dev/null
if [ $? != 0 ];then
   log "Docker 未正常启动，请先安装并启动 Docker 服务后再次执行本脚本"
   exit
fi

##Install Latest Stable Docker Compose Release
if which docker-compose >/dev/null; then
   log "检测到 Docker Compose 已安装，跳过安装步骤"
else
   if [[ -d docker ]]; then
      log "... 离线安装 docker-compose"
      cp docker/bin/docker-compose /usr/bin/
      chmod +x /usr/bin/docker-compose
   else
      log "... 在线安装 docker-compose"
      curl -L https://get.daocloud.io/docker/compose/releases/download/v2.2.3/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose 2>&1 | tee -a ${__current_dir}/install.
log
      chmod +x /usr/local/bin/docker-compose
      ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
   fi
fi

# 检查docker-compose是否正常
docker-compose version 1>/dev/null 2>/dev/null
if [ $? != 0 ];then
   log "docker-compose 未正常安装，请先安装 docker-compose 后再次执行本脚本"
   exit
fi

cd ${__current_dir}
# 加载镜像
if [[ -d images ]]; then
   log "加载镜像"
   for i in $(ls images); do
      docker load -i images/$i 2>&1 | tee -a ${__current_dir}/install.log
   done
else
   log "拉取镜像"
   #docker pull redis:6.2.7 2>&1 | tee -a ${__current_dir}/install.log
   cd -
fi

log "启动服务"
cd ${RG_BASE}/runnergo/runnergo
docker-compose  down  | tee -a ${__current_dir}/install.log
docker-compose  up -d | tee -a ${__current_dir}/install.log

echo -e "======================= 安装完成 =======================\n" 2>&1 | tee -a ${__current_dir}/install.log

echo -e "请通过以下方式访问:\n URL: http://\$LOCAL_IP\n" 2>&1 | tee -a ${__current_dir}/install.log
