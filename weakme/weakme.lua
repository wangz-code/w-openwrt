--[[
Author: wangqz
Date: 2024-12-31
LastEditTime: 2024-12-31
Description: content
--]]
# module 名称
module("luci.controller.weakme", package.seeall)
 
function index()
    # 4 个参数介绍
    # 1.后台访问路径 admin/services/bargo 
    # 2.target 动作（call, template, cbi）call 是调用自定义函数，template 调用 html 模板，cbi 调用 openwrt 的公共表单页面
    # 3.菜单名称 
    # 4.排序
    entry({"admin", "services", "weakme"}, cbi("weakme"), _("Weakme"), 1)
end