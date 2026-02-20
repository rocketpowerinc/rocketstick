.{
    git config --global --add safe.directory H:/
    git init
    git remote add origin https://github.com/rocketpowerinc/rocketstick.git 2>$null
    git fetch origin
    git checkout -f origin/main
}