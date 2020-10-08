echo '*****替换文章中的本地图片为个人图床图片******'
sed -i "" 's|/Users/zhongshijie/Desktop/01-Projects/mirrors-pic/img/|https://zhongshijie.gitee.io/mirrors-pic/img/|' source/_posts/*
echo '*****开始自动提交******'
git add .
git commit -m 'Auto+1'
git push
echo '*****开始自动部署******'
npx hexo clean
npx hexo deploy
echo '*****开始自动清理部署文件******'
npx hexo clean
