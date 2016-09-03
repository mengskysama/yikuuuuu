#!/bin/sh

username='13800000000'
password='000000'
switch_mode=1

do_login() {
    t="1111111111111"
    data='passport='$username'&password='$password'&captcha=&remember=1&callback=logincallback_'$t'&from=http%3A%2F%2Flogin.youku.com%2F@@@@&wintype=page'
    result=$(curl -A "User-Agent: Mozilla/4.0" -c /tmp/youku.cookie --location --data $data http://login.youku.com/user/login_submit/ 2>/dev/null)
    echo $result
}

do_speed_up() {
    result=$(curl -A "User-Agent: Mozilla/4.0" -X POST -b /tmp/youku.cookie -d '' 'http://vip.youku.com/?c=ajax&a=ajax_do_speed_up' 2>/dev/null)
    echo $result
}

do_switch() {
    result=$(curl -A "User-Agent: Mozilla/4.0" -X POST -b /tmp/youku.cookie -d '' 'http://vip.youku.com/?c=ajax&a=ajax_speedup_service_switch' 2>/dev/null)
    echo $result
}

result=`do_speed_up`

echo "$result" |grep -q "20011"
if [ $? -eq 0 ]; then
    echo `date +%Y-%m-%d-%H:%M:%S`" 重新登录"
    result=`do_login`
    echo "$result" |grep -q "len-2"
    if [ $? -eq 0 ]; then
        echo `date +%Y-%m-%d-%H:%M:%S`" 登录成功"
        echo `date +%Y-%m-%d-%H:%M:%S`" 登录成功" > /tmp/yiku.status
    else
        echo `date +%Y-%m-%d-%H:%M:%S`" 登录失败"
        echo `date +%Y-%m-%d-%H:%M:%S`" 登录失败" > /tmp/yiku.status
        exit
    fi
else
    echo `date +%Y-%m-%d-%H:%M:%S`" 已经登录"
fi

if [ $switch_mode -eq 1 ]; then
    result=`do_switch`
    echo "$result" |grep -q "20000"
    if [ $? -eq 0 ]; then
        echo `date +%Y-%m-%d-%H:%M:%S`" 尝试切换成功"
        echo `date +%Y-%m-%d-%H:%M:%S`" 尝试切换成功" > /tmp/yiku.status
    else
        echo `date +%Y-%m-%d-%H:%M:%S`" 尝试切换失败"
        echo `date +%Y-%m-%d-%H:%M:%S`" 尝试切换失败" > /tmp/yiku.status
        exit
    fi
    echo "$result" |grep -q 'state\":\"2\"'
    if [ $? -eq 0 ]; then
        echo `date +%Y-%m-%d-%H:%M:%S`" 尝试切换启用"
        result=`do_switch`
    fi
fi
exit
result=`do_speed_up`
echo "$result" |grep -q "20021"
if [ $? -eq 0 ]; then
    echo `date +%Y-%m-%d-%H:%M:%S`" 已经提速"
    #exit
fi

echo "$result" |grep -q "20011"
if [ $? -eq 0 ]; then
    echo `date +%Y-%m-%d-%H:%M:%S`" 登录喵喵喵?"
    echo `date +%Y-%m-%d-%H:%M:%S`" 登录喵喵喵?" > /tmp/yiku.status
    exit
fi

echo "$result" |grep -q "20000"
if [ $? -eq 0 ]; then
    echo `date +%Y-%m-%d-%H:%M:%S`" 提速成功"
    echo `date +%Y-%m-%d-%H:%M:%S`" 提速成功" > /tmp/yiku.status
    exit
fi

echo "其他错误"
echo $result
