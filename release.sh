set -e
echo "Enter release message: "
read Message

read -p "Releasing $Message - are you sure? (y/n)" -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
  echo "=====Releasing $Message ...====="
  # 生产静态文件
  echo "=====Generate static assets...====="
  hugo
  echo "=====Generate static assets Complete!====="\

  cp -r public/. ../kntt.github.io

  # commit kntt.github.io
  cd ../kntt.github.io
  git add -A
  git commit -m "[Release] $Message"
  git push
  echo "=====Release Success!====="
fi