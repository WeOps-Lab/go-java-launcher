## 嘉为蓝鲸神通数据库监控插件导入说明

### 配置指引
由于监控平台启动的是二进制进程，监控探针由二进制进程拉起，因此平台的进程管理功能无法生效。需要手动修改插件包中的 stop.sh 脚本以实现进程的停止功能。

#### 操作步骤

1. 定位插件目录  
登录节点管理服务器，找到存放监控插件的目录，例如：/data/bkce/bknodeman/download/linux/x86_64/

2. 解压插件包  
找到目标监控插件包，例如：weops_oscar_exporter-1.1.tgz  

3. 解压插件包  
不要在存放监控插件的目录直接进行解压，需要复制插件包到一个临时目录下  
`tar -zxvf weops_oscar_exporter-1.1.tgz`

4. 修改stop.sh脚本
进入解压后的插件目录  
`cd external_plugins/weops_oscar_exporter/`  
将stop.sh的内容替换为以下代码  
   ```shell
   #!/bin/bash

   export LC_ALL=C
   export LANG=C

   if [ "$(dirname ${BASH_SOURCE[0]})" != "." ];then
       cd "${BASH_SOURCE[0]%/*}"
   fi

   source ./parse_yaml.sh
   create_variables etc/env.yaml

   _status_linux_proc () {
       local proc="$1"
       local pids
       local __pids=()

       pids=$(ps xao pid,ppid,command | awk -v PROG="./$proc" '$3 == PROG { print $1 }')
       for pid in ${pids} ; do
           abs_path=$(readlink -f /proc/$pid/exe)
           if [ "${abs_path%/$proc*}" == "${PWD}" ] ; then
               __pids+=("$pid")
           fi
       done
       pids=("${__pids[@]}")

       echo -n "${pids[@]}"

       [ ${#pids[@]} -ne 0 ]
   }

   # 递归获取所有子进程
   _get_child_pids () {
       local parent_pid=$1
       local child_pids=()
    
       for pid in $(ps --ppid ${parent_pid} -o pid=); do
           child_pids+=("$pid")
           child_pids+=($(_get_child_pids $pid))
       done

       echo "${child_pids[@]}"
   }

   _stop_proc_recursive () {
       local pids=("$@")
       for pid in "${pids[@]}"; do
           echo "Killing process $pid..."
           child_pids=$(_get_child_pids $pid)
        
           if [ -n "$child_pids" ]; then
               _stop_proc_recursive $child_pids
           fi
        
           kill -9 $pid 2>/dev/null
       done
   }

   _stop () {
       local pids
       pids=$(_status_linux_proc "$1")
       if [ -n "$pids" ]; then
           _stop_proc_recursive ${pids}
       fi
   }

   _status () {
       _status_linux_proc "$1"
   }

   plugin_id="weops_oscar_exporter"

   echo "stop ${plugin_id} ..."
   _stop "${plugin_id}"

   if ! _status "${plugin_id}"; then
       echo "Done"
       exit 0
   else
       echo "Fail"
       exit 1
   fi
   ```

5. 重新打包插件  
返回上一级目录   
`cd ../../`  
重新打包插件   
`tar -czvf weops_oscar_exporter-1.1.tgz external_plugins/`    
注意： 压缩包的名称必须与节点管理下的原始包名称一致，包括版本号。

6. 将重新打包的插件包覆盖到节点管理服务器  
`cp weops_oscar_exporter-1.1.tgz /data/bkce/bknodeman/download/linux/x86_64/`
