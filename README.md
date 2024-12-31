<!--
 * @Author: wangqz
 * @Date: 2024-12-31
 * @LastEditTime: 2024-12-31
 * @Description: content
-->
参考: https://www.openwrt.pro/post-677.html
- 先创建控制器文件 /usr/lib/lua/luci/controller/bargo.lua
```lua
# module 名称
module("luci.controller.bargo", package.seeall)
 
function index()
    # 4 个参数介绍
    # 1.后台访问路径 admin/services/bargo 
    # 2.target 动作（call, template, cbi）call 是调用自定义函数，template 调用 html 模板，cbi 调用 openwrt 的公共表单页面
    # 3.菜单名称 
    # 4.排序
    entry({"admin", "services", "bargo"}, cbi("bargo"), _("Bargo Client"), 1)
end

```
- 下面我们来创建插件的配置文件 /etc/config/bargo
```sh
config server
option username ''
option password ''

```

- 创建 cbi 文件 /usr/lib/lua/luci/model/cbi/bargo.lua
```lua
require("luci.sys")
 
# 页面标题和描述
m = Map("bargo", translate("Bargo Client"), translate("Configure Bargo client, Powered By Sinchie."))
 
# 读取配置文件
s = m:section(TypedSection, "server", "")
s.addremove = false
s.anonymous = true
 
# 是否启用的选择框
enable = s:option(Flag, "enable", translate("Enable"))
# 映射我们的配置到输入框
username = s:option(Value, "username", translate("Username"))
pass = s:option(Value, "password", translate("Password"))
pass.password = true
 
# 如果点击了保存按钮
local apply = luci.http.formvalue("cbi.apply")
if apply then
    # 这里是调用我们自己的程序脚本，后面会讲怎么来写这个脚本
    io.popen("/etc/init.d/bargo restart > /dev/null &")
end
 
return m


```

- 上面我们的 cbi 文件中写了 /etc/init.d/bargo restart 这个命令，那么我们来编写这个脚本。
```sh
#!/bin/sh /etc/rc.common
 
# 启动顺序
START=95
 
# start 函数
start() {
    # 载入/etc/config/bargo 中的配置信息，以供我们的程序使用
    config_load bargo
    # 可以判断 enable 是否勾选并执行我们的程序
    ......
    echo "Bargo Client has start."
}
 
stop() {
    # 清理程序产生的内容
    echo "Bargo Client has stoped."
}


```