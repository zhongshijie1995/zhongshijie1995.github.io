for i in `ls source/_posts/*.md`
do
  sed -i "" 's#](img/#](https://zhongshijie1995.github.io/zhongshijie-pic/img/#' $i
  echo '图片替换完毕：'$i
done