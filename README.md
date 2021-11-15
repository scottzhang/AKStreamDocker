避免重复按照.net,mysql,配置3个组件，录像，直接配好了。

mysql:
database:AKStream
username:root
password:AKStream2021@



当前使用的是.net3, 现在因为里面有编译,造成整体偏大，好处是可以修改代码编译.

启动方法:
在host机使用root用户

./prepare.sh

#这个把缺少的dbus权限文件绑定上

./start.sh

#进入docker

docker exec -it akstream_dev bash

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

cd ~/AKStreamKeeper

dotnet AKStreamKeeper.dll > /dev/null &

cd ~/AKStreameWeb

dotnet AKStreamWeb.dll > /dev/null &

cd ~/AKStreamNVR

npm run start &

浏览器打开
http://localhost:3000
就可以用了
