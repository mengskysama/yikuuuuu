# yikuuuuu
优酷黄金会员宽带提速脚本 http://vip.youku.com/?c=privilege&a=detail&type=speedup

# 参数设置
```
  会员账号信息
  username='13800000000'
  password='000000'
  这个是加速方式，经过测试上海电信加速过几个小时之后就软了，客服建议我重启光猫重登会员账号均无效，最后发现必须关闭重开这个选项，再进行加速。忍不住吐槽一下客服（我说加速会失效测速压根没提速，他说狡辩说只能加速视频，非要我把视频不能加速的截图给他，还一口咬定只要显示已经成功提速就肯定成功了，我都给他测速截图了，最后我去优酷看超清居然还卡截图给他又开始说我网络有问题，喵的智障），和这个sb的接口。
  switch_mode=1
  
```

# openwrt
```
  opkg install curl
  sh ./yikuuuuu.sh
  then add to crontab
```
