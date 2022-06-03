# 替换图片
sh ./deploy-MacOS-PicInPost.sh
# 替换IP
sh ./deploy-MacOS-IP.sh
# 提交图片仓库代码
cd ../zhongshijie-pic && git pull && git add .&& git commit -m 'AutoCommit' && git push
# 提交博客仓库代码
cd ../zhongshijie1995.github.io && git pull && git add .&& git commit -m 'AutoCommit' && git push
# 部署博客
npx hexo clean && npx hexo g && npx hexo deploy && npx clean
