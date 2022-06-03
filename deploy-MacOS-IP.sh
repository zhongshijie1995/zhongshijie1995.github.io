target_md="source/about/index.md"
NowIP="http://"`curl https://ifconfig.me`":"
echo '获取到当前外网IP：'$NowIP
YetIP=`grep -m 1 -Eo "http://*.*.*.*:" $target_md`
echo '目前在显示外网IP：'$YetIP
if [ "$NowIP" != "$YetIP" ];then
  sed -i "" 's#'"$YetIP"'#'"$NowIP"'#' $target_md
  echo '替换完成！'
fi