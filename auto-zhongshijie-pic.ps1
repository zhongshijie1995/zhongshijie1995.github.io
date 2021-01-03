echo " ----------- 提交 mirrors-pic ----------- "
cd ../mirrors-pic
./auto-commit.ps1
cd ../zhongshijie
echo " ----------- 提交 zhongshijie ----------- "
python replace-pic.py
./auto-commit.ps1
python auto-deploy.py