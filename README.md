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
