aliyun docker的地址：
先pull下来，再tag下
```
docker pull registry.cn-hangzhou.aliyuncs.com/jgcx/akstream:v2
docker tag registry.cn-hangzhou.aliyuncs.com/jgcx/akstream:v2 akstream:v2
```

避免重复安装.net,mysql,配置3个组件，录像，直接配好了。

mysql:

database:AKStream

username:root

password:AKStream2021@

mysql_data: 就是mysql的数据文件，使用系统产生的配置都保存在这个里面，docker可以rm再run，这个删了就得从头再来了。

video_record: 保存录像的文件夹。

当前使用的是.net3, 现在因为里面有编译环境和源文件,造成整体偏大，好处是可以修改代码编译打印日志.

启动方法:

在host机使用root用户
```
./prepare.sh
```
#这个把缺少的dbus权限文件绑定上，我发现在openSUSE上需要做这个，在centos7&8的host机上，最好也执行下，虽然前几行centos本来就是好的。opensuse,centos7,centos8的宿主机测试都是好的。
ubuntu没测试。
# 创建docker，只需要创建一次
```
./start.sh
```
# 进入docker
```
docker exec -it akstream_dev bash
```
# 启动和停止
```
docker start akstream_dev
docker stop akstream_dev
```

调整配置：

需要根据部署机器的网络地址，调整Keeper和NVR的配置，改以下2个地方：

/root/AKStreamKeeper/Config/AKStreamKeeper.json
```
{
  "IpV4Address": "xx.xx.xx.xx",
  "IpV6Address": "fe80::8:807:2143:28a1%5",
  "WebApiPort": 6880,
  "MediaServerPath": "/Users/chatop/Projects/Clion/ZLMediaKit/release/mac/Debug/MediaServer",
  "AkStreamWebRegisterUrl": "http://127.0.0.1:5800/MediaServer/WebHook/MediaServerKeepAlive",
  "CutMergeFilePath": "/User/chatop/Projects/CutMergeFile",
  "CustomRecordPathList": [
    "/Users/chatop/Downloads/record1",
    "/Users/chatop/Downloads/record2"
  ],
  "UseSsl": false,
  "MinRtpPort": 10001,
  "MaxRtpPort": 20000,
  "MinSendRtpPort": 20002,
  "MaxSendRtpPort": 20200,
  "RandomPort": false,
  "FFmpegPath": "/usr/local/bin/ffmpeg",
  "AccessKey": "O7O4S089-PGDW6HTM-T4CV6K74-V6RIP1I6-9300G54F-Z03TI40Q",
  "RtpPortCdTime": 3600,
  "HttpClientTimeoutSec": 5,
  "DisableShell": true,
  "ZLMediakitSSLFilePath": "./sslfiles/"
}
```
/root/AKStreamNVR/public/env-config.js
```
window._env_ = {
  REACT_APP_API_HOST: "xx.xx.xx.xx",
  AKSTREAM_WEB_API:"xx.xx.xx.xx:5800",
}
```
xx.xx.xx.xx就是你本机的IP



进入系统后，需要启动AKStreamWeb, AKStreamKeeper, AKStreamNVR 就可以用了

1. 先启动mysql
```
systemctl start mysql
```
2. 再启动keeper
```
cd ~/AKStreamKeeper

dotnet AKStreamKeeper.dll > /dev/null &
```

3. 再启动Web
```
cd ~/AKStreameWeb

dotnet AKStreamWeb.dll > /dev/null &
```
4. 再启动NVR
```
cd ~/AKStreamNVR

npm run start &
```
5. 
浏览器打开
http://localhost:3000
或者
http://xx.xx.xx.xx:3000
就可以用了


常见问题：

## mysql无法启动,提示dbus error

那个prepare.sh执行下，然后重启下docker
```
docker stop akstream_dev
docker start akstream_dev
```

## 启动组件失败，提示端口占用
因为这个docker使用的是-net选项，所以直接共享了宿主的网络，可以尝试关闭主机的apache，mysql服务，再尝试启动。

## 使用nvr添加摄像头，视频广场无法看到
本质是nvr这个程序，那个自动断流选项即使不选，默认值null会被直接存进了数据库，在AKStreamWeb/MediaSerivce里AddVideoChannel处理下就会好，如果不行可以直接进mysql，改VideoChannel表的NoPlayerBreak设置为0，就会好。

## 录像怎么用
NVR这个使用稍微有点绕，先建recordPlan，名字一定不要太复杂，记住，下面那个周1-7，然后选时间，比较令人困惑，我是周一到周7，每个建一行，时间从今天选到2050年，注意看那个时间框，虽然只是显示时间00:00:00,实际里面是带日期的，所以一定要用他那个控件选，不要手工输入。
再改摄像头，recordplan字段填上这个，最下面有个自动录像的选项，填上就好了。


## 其他问题
也许你翻翻AKStreamWeb的AutoTask下的文件就可以解答了，这个是个定时任务，其他的基本都是Service。

