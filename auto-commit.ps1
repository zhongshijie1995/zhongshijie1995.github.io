echo '*****zhongshijie Auto Commit******'
git add .
git commit -m 'Auto+1'
git push
echo '*****zhongshijie Auto Deploy******'
npx hexo clean
npx hexo deploy
echo '*****zhongshijie Auto Deploy Clean******'
npx hexo clean
