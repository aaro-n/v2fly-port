# 使用说明
  因为VPS经常被封端口，一次两次还行，次数多了烦了，使用Nginx开放多个端口，手工替换链接端口太麻烦，因此有了本项目，本项目是为trojan、vless、vmess协议快速替换端口。
## 前提条件
  拥有GitHub账户、有v2rayNG分享链接。
## 使用步骤
  * 登陆Github，点击[链接](https://github.com/new/import)，会打开导入项目界面，在`Your old repository's clone URL *`中填入`https://github.com/aaro-n/v2fly-port`，`Repository name *`这个项目名称，随意填，重点来了，项目类型要选择`Private`，一定要选择`Private`，选择`Public`意味着是公开项目，任何人都可以访问，最后点击`Begin import`导入项目。
  * 授予GitHub Actions 项目读写权限。GitHub Actions默认拥有读取项目权限，现在要赋予GitHub Actions写项目的权限，否则修改端口后无法上传的到Github仓库。具体操作方法，打开刚刚导入创建的项目，点击`Settings` 进入项目设置界面，注意不是用户`Settings`，是项目`Settings`,进入项目设置界面后，点击`Actions`->`General`，进入项目`GitHub Actions`设置界面，下拉到`Workflow permissions`，选择`Read and write permissions`，点击`Save`保存，这样就赋予了GitHub Actions项目读写权限。
  * 配置文件设置。配置文件是`config`，`config`里每种协议有3个变量，分别是`协议名称_protocol`、`协议名称_link`、`协议名称_port`，，`协议名称_protocol`不要动，默认，`协议名称_link`，从v2rayNG获取的分享链接，`协议名称_port`，想要端口范围，数值只能从小到大，不能从大到小。这3种协议要求都是一样的。`config`文件有范例。按照自己想要的添加链接修改端口后，保存`config`文件，正常大概有1分钟就会将修改后的内容同步到GitHub项目。
# 参考
  * 灵感来于[给你的VPS添加无限个ipv6地址](https://bulianglin.com/archives/ipv6.html)中的批量修改节点端口
  * [Nginx配置文档](http://nginx.org/en/docs/stream/ngx_stream_core_module.html#listen:~:text=Port%20ranges%20(1.15.10)%20are%20specified%20with%20the%20first%20and%20last%20port%20separated%20by%20a%20hyphen%3A)
