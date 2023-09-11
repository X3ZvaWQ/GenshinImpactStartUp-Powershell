# 基于PowerShell调用.Net的白屏检测原神启动！

启原引擎不必基于py  
实现简单 不需要配置任何环境！不需要安装原神！  
有一个win10就能启动の小曲  
虽然由于浏览器安全策略做不到自动播放（x  

## 思路
`PowerShell`可以和`.Net`无缝集成，而现在大多数电脑都有`.Net`和`Powershell`  
所以通过调用`.Net`提供的 `System.Windows.Forms` 以及 `System.Drawing.Graphics` 等程序集实现屏幕检测，像素判断 可以实现判断白屏。再通过powershell原生的语法可以启动原神或者浏览器等各种程序  
为了保证沉浸式体验，使用`edge`的`--kiosk`参数启动页面，退出可以alt+f4（

## 其他启动方式

或许可以实现调用windows的播放器来实现，绕过浏览器的安全策略。  
以及既然都可以调用 `System.Windows.Forms` ，为什么不直接用它画一个窗口调用播放器控件开始播放呢（x  
最终都绕不过要下载视频！浏览器万岁！  

## 如果需要启动真原神
不启动原神是因为YuanShen.exe需要管理员权限启动，脚本需要申请一个管理员权限，在开头加上。
```powershell
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$($MyInvocation.MyCommand.Path)`"" -Verb RunAs
    exit
}
```
原神的路径可以访问注册表获取，`.Net`提供了相应的库，或者通过获取桌面上的原神快捷方式指向。