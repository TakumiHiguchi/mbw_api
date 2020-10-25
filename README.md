# music.branchwith api

music.branchwith群のapiです。頑張ってリファクタリングしていますが、コードは汚いと思います。

## 注意
- dockerが使える環境はご自身でご用意してください。

## 使い方
1. music.branchwith apiをcloneしましょう
  ```
  $ git clone https://github.com/TakumiHiguchi/mbw_api.git
  ```

2. ディレクトリに移動しましょう
  ```
  $ cd mbw_api
  ```
  
3. dockerちゃんに全てお任せしましょう
  ```
  $ docker-compose build
  $ docker-compose up
  ```

4. テストデータを流します
  ```
  $ docker-compose run web bundle exec db:seed
  ```

## テストデータ
### music.branchwith WEBGUI
  テストデータを流した後なら以下のadminユーザーが作成されています。
  ```
  Admin
  email: admin@test.com
  password: Administrator1
  ```

  一般ユーザーはmusic.branchwith WEBGUIを起動後、db:seedののちに表示されるURLにアクセスしてパスワードを登録する必要があります。
  ```
  user
  email: test@test.com
  password: 任意（半角6~12文字英大文字・小文字・数字それぞれ１文字以上）
  ```
