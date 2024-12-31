require("luci.sys")

-- 页面标题和描述
m = Map("weakme", translate("Weakme"), translate("Configure Weakme, Powered By wz"))

-- 读取配置文件
s = m:section(TypedSection, "server", "")
s.addremove = false
s.anonymous = true

-- 是否启用的选择框
enable = s:option(Flag, "enable", translate("Enable"))

-- 映射我们的配置到输入框
mac = s:option(Value, "mac", translate("Mac"))

-- 如果点击了保存按钮
local apply = luci.http.formvalue("cbi.apply")
if apply then
    -- 读取 mac 值
    local mac_value = luci.http.formvalue("mac")
    -- 调用我们的程序脚本，拼接 mac 值
    if mac_value then
        io.popen("etherwake -i br-lan " .. mac_value)
    end
end

return m
