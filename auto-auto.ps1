echo " ----------- mirrors-pic Auto.sh ----------- "
cd ../mirrors-pic
./auto-commit.ps1
cd ../zhongshijie
echo " ----------- zhongshijie Auto.sh ----------- "
python auto-replace.py
echo '*****zhongshijie Auto Commit******'
git add .
git commit -m 'Auto+1'
git push
echo '*****zhongshijie Auto Deploy******'
npx hexo clean
npx hexo g
npx hexo deploy
echo '*****zhongshijie Auto Deploy Clean******'
npx hexo clean
echo '*****zhongshijie Auto Deploy Clean******'
python auto-deploy.py
