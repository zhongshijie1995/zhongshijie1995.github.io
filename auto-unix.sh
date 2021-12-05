echo " ----------- zhongshijie-pic Auto.sh ----------- "
cd ../zhongshijie-pic
./auto-commit.sh
cd ../zhongshijie1995.github.io
echo " ----------- zhongshijie Auto.sh ----------- "
echo '*****zhongshijie Img Replace Pictures******'
python3 img-replace.py
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
