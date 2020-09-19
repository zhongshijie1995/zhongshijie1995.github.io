echo '*****开始自动提交******'
git add .
git commit -m 'Auto+1'
git push
echo '*****开始自动部署******'
npx hexo clean
npx hexo deploy
echo '*****开始自动清理部署文件******'
npx hexo clean
