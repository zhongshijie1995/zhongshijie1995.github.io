# 关于页替换
target_md="source/about/index.md"
NowIP=`curl https://ifconfig.me`
NowIP=`echo $NowIP | grep -E "((2(5[0-5]|[0-4]\d))|[0-1]?\d{1,2})(\.((2(5[0-5]|[0-4]\d))|[0-1]?\d{1,2})){3}"`
echo '获取到当前外网IP：'$NowIP
YetIP=`grep -m 1 -Eo "((2(5[0-5]|[0-4]\d))|[0-1]?\d{1,2})(\.((2(5[0-5]|[0-4]\d))|[0-1]?\d{1,2})){3}" $target_md`
echo '目前在显示外网IP：'$YetIP
if [ "$NowIP" != "$YetIP" ];then
  sed -i "" 's#'"$YetIP"'#'"$NowIP"'#' $target_md
  echo '替换完成！'
fi
# cloud页替换
target_md="source/add_source/cloud.html"
NowIP=`curl https://ifconfig.me`
NowIP=`echo $NowIP | grep -E "((2(5[0-5]|[0-4]\d))|[0-1]?\d{1,2})(\.((2(5[0-5]|[0-4]\d))|[0-1]?\d{1,2})){3}"`
echo '获取到当前外网IP：'$NowIP
YetIP=`grep -m 1 -Eo "((2(5[0-5]|[0-4]\d))|[0-1]?\d{1,2})(\.((2(5[0-5]|[0-4]\d))|[0-1]?\d{1,2})){3}" $target_md`
echo '目前在显示外网IP：'$YetIP
if [ "$NowIP" != "$YetIP" ];then
  sed -i "" 's#'"$YetIP"'#'"$NowIP"'#' $target_md
  echo '替换完成！'
fi
# Lab页替换
target_md="source/add_source/lab.html"
NowIP=`curl https://ifconfig.me`
NowIP=`echo $NowIP | grep -E "((2(5[0-5]|[0-4]\d))|[0-1]?\d{1,2})(\.((2(5[0-5]|[0-4]\d))|[0-1]?\d{1,2})){3}"`
echo '获取到当前外网IP：'$NowIP
YetIP=`grep -m 1 -Eo "((2(5[0-5]|[0-4]\d))|[0-1]?\d{1,2})(\.((2(5[0-5]|[0-4]\d))|[0-1]?\d{1,2})){3}" $target_md`
echo '目前在显示外网IP：'$YetIP
if [ "$NowIP" != "$YetIP" ];then
  sed -i "" 's#'"$YetIP"'#'"$NowIP"'#' $target_md
  echo '替换完成！'
fi