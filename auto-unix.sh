echo " ----------- mirrors-pic Auto.sh ----------- "
cd ../mirrors-pic
./auto-commit.sh
cd ../zhongshijie
echo " ----------- zhongshijie Auto.sh ----------- "
echo '*****zhongshijie Auto Replace Pictures******'
python3 auto-replace.py
echo '*****zhongshijie Auto Commit******'
git add .
git commit -m 'AutoCommit'
git push
echo '*****zhongshijie Auto Deploy Push******'
npx hexo clean
npx hexo g
npx hexo deploy
echo '*****zhongshijie Auto Deploy Clean******'
npx hexo clean
