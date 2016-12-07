

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
