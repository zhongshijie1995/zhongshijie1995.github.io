echo " ----------- �ύ mirrors-pic ----------- "
cd ../mirrors-pic
./auto-commit.ps1
cd ../zhongshijie
echo " ----------- �ύ zhongshijie ----------- "
python auto-replace.py
./auto-commit.ps1
python auto-deploy.py