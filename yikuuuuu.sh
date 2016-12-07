#!/bin/bash
passport='13800000000'
password='000000'

switch_mode=1

ua='User-Agent: Mozilla/5.0'

do_login() {
	passwordmd5=$(echo -n $password | md5sum | cut -d" " -f1)

	# token=$(curl 'https://account.youku.com/loginView.htm?callback=&buid=youku&template=tempA&loginModel=normal%2Cmobile&isQRlogin=true&isThirdPartLogin=true&size=normal&jsonpCallback=jsonp_14811222625633808' -H '$ua' -H 'Referer: http://www.youku.com/' -m 10 -k -c /tmp/youku.cookie 2>/dev/null | grep -Po 'formtoken\":\"\K.*?(?=\")')

  # openwrt ash
	token=$(curl 'https://account.youku.com/loginView.htm?callback=&buid=youku&template=tempA&loginModel=normal%2Cmobile&isQRlogin=true&isThirdPartLogin=true&size=normal&jsonpCallback=jsonp_14811222625633808' -H '$ua' -H 'Referer: http://www.youku.com/' -m 10 -k -c /tmp/youku.cookie 2>/dev/null | grep -Eo 'token":\".[A-F0-9]*')
	token=${token/token\":\"/""}

	#echo $token

	ret=$(curl 'https://account.youku.com/login/confirm.json?passport='$passport'&password='$passwordmd5'&loginType=passport_pwd&formtoken='$token'&rememberMe=true&state=false&buid=youku&template=tempA&mode=popup&actionFrom=&jsToken=0&jsonpCallback=jsonp_14811222976476134' -H '$ua
	' -H 'Referer: http://www.youku.com/' -m 10 -k -b /tmp/youku.cookie -c /tmp/youku.cookie 2>/dev/null)

	echo $ret
}

do_speed_up() {
    result=$(curl -A '$ua' -X POST -b /tmp/youku.cookie -d '' 'http://vip.youku.com/?c=ajax&a=ajax_do_speed_up' -m 10 2>/dev/null)
    echo $result
}

do_switch() {
    result=$(curl -A '$ua' -X POST -b /tmp/youku.cookie -d '' 'http://vip.youku.com/?c=ajax&a=ajax_speedup_service_switch' -m 10 2>/dev/null)
    echo $result
}

result=`do_speed_up`

echo "$result" |grep -q "20011"
if [ $? -eq 0 ]; then
    echo `date +%Y-%m-%d-%H:%M:%S`" 重新登录"
    result=`do_login`
    echo "$result" |grep -q "success"
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
				sleep 2
    fi
fi

result=`do_speed_up`

echo "$result" |grep -q "20023"
if [ $? -eq 0 ]; then
    echo `date +%Y-%m-%d-%H:%M:%S`" 运营商繁忙 sleep 5"
		sleep 5
		result=`do_speed_up`
fi

echo "$result" |grep -q "20021"
if [ $? -eq 0 ]; then
    echo `date +%Y-%m-%d-%H:%M:%S`" 已经提速"
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

echo "其他错误，请在 https://github.com/mengskysama/yikuuuuu/issues 报告"
echo $result
