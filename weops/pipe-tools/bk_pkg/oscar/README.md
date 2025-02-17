## 嘉为蓝鲸神通数据库监控插件使用说明

### 插件功能

通过二进制文件启动Java进程，利用JDBC连接数据库并执行SQL查询，将查询结果转换为监控指标。

### 版本支持：

操作系统支持: linux

是否支持arm: 支持

**组件支持版本：**

神通数据库: 通用

### 使用指引

使用管理员账户登录数据库，创建监控用户并授权所需视图的查询权限。  

 ```bash
# 创建用户: weops 密码: weops123!
CREATE USER weops WITH PASSWORD 'weops123!';

# 授权所需视图的查询权限
GRANT SELECT ON V$GLOBAL_MEMORY TO weops;
GRANT SELECT ON v_sys_datafile_info TO weops;
GRANT SELECT ON v_sys_logfile_info TO weops;
GRANT SELECT ON v_sys_sessions TO weops;
GRANT SELECT ON V$SYSSTAT TO weops;
GRANT SELECT ON V$LOCK_STAT TO weops;
GRANT SELECT ON v_sys_database_info TO weops;
GRANT SELECT ON v_sys_logsegment_info TO weops;
GRANT SELECT ON V$FILE_IO_STAT TO weops;
GRANT SELECT ON V$SPC_STAT TO weops;
 ```

### 参数说明

| **参数名**              | **含义**                                         | **是否必填** | **使用举例**                          |
|----------------------|------------------------------------------------|----------|-----------------------------------|
| JDBC_URL             | JDBC地址(环境变量)                                   | 是        | jdbc:oscar://127.0.0.1:2003/osrdb |
| USERNAME             | 数据库用户名(环境变量)，特殊字符不需要编码转义                       | 是        | weops                             |
| PASSWORD             | 数据库密码(环境变量)，特殊字符不需要编码转义                        | 是        | weops123!                         |
| JAVA_HOME            | JAVA_HOME(环境变量)，填写绝对路径                         | 是        |                                   |
| CONFIG_FILE_PATH     | 监控探针SQL采集配置文件(环境变量) **注意！该参数为文件参数，非探针执行文件参数！** | 是        | 默认已有标准采集指标配置文件                    |
| LAUNCHER_STATIC_FILE | 启动器配置文件(环境变量) **注意！该参数为文件参数，非探针执行文件参数！**       | 是        | 默认已有标准配置文件                        |
| QUARKUS_LOG_LEVEL    | 日志级别(环境变量)                                     | 否        | info                              |
| QUARKUS_HTTP_HOST    | 插件监听IP(下发请保持默认)                                | 否        | 127.0.0.1                         |
| QUARKUS_HTTP_PORT    | 插件监听端口(下发请保持默认)                                | 否        | 9601                              | 

### 指标列表
| **指标ID**                                  | **指标中文名** | **维度ID**                       | **维度含义**         | **单位**  |
|-------------------------------------------|-----------|--------------------------------|------------------|---------|
| jdbc_exporter_up                          | 插件运行状态    | job                            | 任务名称             | -       |
| oscardb_exporter_memory_size              | 内存分布大小    | MEMORY_NAME                    | 内存类型             | bytes   |
| oscardb_exporter_data_file_size           | 数据文件大小    | FILEID, FILENAME, TABLESPACEID | 文件ID, 文件名, 表空间ID | bytes   |
| oscardb_exporter_data_file_free_size      | 数据文件剩余空间  | FILEID, FILENAME, TABLESPACEID | 文件ID, 文件名, 表空间ID | bytes   |
| oscardb_exporter_data_file_usage_percent  | 数据文件空间使用率 | FILEID, FILENAME, TABLESPACEID | 文件ID, 文件名, 表空间ID | percent |
| oscardb_exporter_log_size                 | 日志文件大小    | FILEID, FILENAME               | 文件ID, 文件名        | bytes   |
| oscardb_exporter_log_usage_ratio          | 日志文件使用率   | FILEID, FILENAME               | 文件ID, 文件名        | percent |
| oscardb_exporter_log_total_size           | 日志空间总大小   | DBNAME                         | 数据库名称            | bytes   |
| oscardb_exporter_log_total_usage_percent  | 日志空间总使用率  | DBNAME                         | 数据库名称            | percent |
| oscardb_exporter_archive_mode             | 归档模式状态    | DBNAME, ARCHIVEPATH            | 数据库名称, 归档路径      | -       |
| oscardb_exporter_restart_lsn              | 恢复起始LSN   | DBNAME                         | 数据库名称            | -       |
| oscardb_exporter_archive_lsn              | 归档起始LSN   | DBNAME                         | 数据库名称            | -       |
| oscardb_exporter_log_auto_shrink          | 自动收缩模式    | DBNAME                         | 数据库名称            | -       |
| oscardb_exporter_log_segment_size         | 日志段大小     | FILEID, STATUS                 | 文件ID, 状态         | bytes   |
| oscardb_exporter_current_connections      | 当前连接数     | -                              | -                | -       |
| oscardb_exporter_current_transactions     | 当前事务数     | -                              | -                | -       |
| oscardb_exporter_current_locks            | 当前锁数量     | -                              | -                | -       |
| oscardb_exporter_spc_hit_percent          | 计划缓存命中率   | -                              | -                | percent |
| oscardb_exporter_spc_count                | 计划缓存数量    | -                              | -                | -       |
| oscardb_exporter_spc_size                 | 计划缓存大小    | -                              | -                | bytes   |
| oscardb_exporter_spc_save_success_percent | 计划缓存保存成功率 | -                              | -                | percent |
| oscardb_exporter_lock_wait_time           | 锁等待时间     | LOCK_TYPE                      | 锁类型              | µs      |
| oscardb_exporter_deadlocks                | 死锁次数      | -                              | -                | -       |
| oscardb_exporter_single_read_size         | 单块读取量     | FILEID, FILETYPE_NAME          | 文件ID, 文件类型       | bytes   |
| oscardb_exporter_single_write_size        | 单块写入量     | FILEID, FILETYPE_NAME          | 文件ID, 文件类型       | bytes   |
| oscardb_exporter_multi_read_size          | 多块读取量     | FILEID, FILETYPE_NAME          | 文件ID, 文件类型       | bytes   |
| oscardb_exporter_multi_write_size         | 多块写入量     | FILEID, FILETYPE_NAME          | 文件ID, 文件类型       | bytes   |
| oscardb_exporter_single_reads             | 单块读次数     | FILEID, FILETYPE_NAME          | 文件ID, 文件类型       | -       |
| oscardb_exporter_single_writes            | 单块写次数     | FILEID, FILETYPE_NAME          | 文件ID, 文件类型       | -       |
| oscardb_exporter_multi_reads              | 多块读次数     | FILEID, FILETYPE_NAME          | 文件ID, 文件类型       | -       |
| oscardb_exporter_multi_writes             | 多块写次数     | FILEID, FILETYPE_NAME          | 文件ID, 文件类型       | -       |
| oscardb_exporter_single_read_time         | 单块读耗时     | FILEID, FILETYPE_NAME          | 文件ID, 文件类型       | µs      |
| oscardb_exporter_single_write_time        | 单块写耗时     | FILEID, FILETYPE_NAME          | 文件ID, 文件类型       | µs      |
| oscardb_exporter_multi_read_time          | 多块读耗时     | FILEID, FILETYPE_NAME          | 文件ID, 文件类型       | µs      |
| oscardb_exporter_multi_write_time         | 多块写耗时     | FILEID, FILETYPE_NAME          | 文件ID, 文件类型       | µs      |
| jdbc_scrape_error                         | 采集异常状态    | job                            | 任务名称             | -       |


### 版本日志

#### weops_oscar_exporter 1.0.1
- weops调整
