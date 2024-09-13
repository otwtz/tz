


# tz_inf_list

`tz_inf_list`

## Структура проекта

flutter clean
flutter pub get

flutter build web --base-href /flutter_website/ --release

cd build/web
git init
git add .
git commit -m 'deploy 1'
git remote remove origin
git remote add new-remote-name https://github.com/otwtz/flutter_website.git

git remote add origin https://github.com/otwtz/flutter_website.git
git push -u --force origin main
