echo '*****zhongshijie Auto Commit******'
git add .
git commit -m 'Auto+1'
git push
echo '*****zhongshijie Auto Deploy******'
npx12 hexo clean
npx12 hexo g
npx12 hexo deploy
echo '*****zhongshijie Auto Deploy Clean******'
npx12 hexo clean
