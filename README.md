# music.branchwith api

music.branchwith群のapiです。頑張ってリファクタリングしていますが、コードは汚いと思います。

## 注意
- dockerが使える環境はご自身でご用意してください。

## 使い方
1. [mbw-nginx-proxy](https://github.com/TakumiHiguchi/mbw-nginx-proxy)のページを見て、mbw-nginx-proxyをdocker-compose up -dします
2. music.branchwith apiをcloneしましょう
  ```
  $ git clone https://github.com/TakumiHiguchi/mbw_api.git
  ```

3. ディレクトリに移動しましょう
  ```
  $ cd mbw_api
  ```
  
4. dockerちゃんに全てお任せしましょう
  ```
  $ docker-compose build
  $ docker-compose up
  ```

5. テストデータを流します
  ```
  $ docker-compose run web bundle exec rails db:seed
  ```

music.branchwith群の詳しい起動方法は、[mbw-nginx-proxy](https://github.com/TakumiHiguchi/mbw-nginx-proxy)のREADMEを見てください。

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

### music.branchwith
  テストデータを流した後なら以下のデータが作成されています。
  ```
  Article 100件
  Lyrics 100件
  ```
  Articleを自身で追加したい場合は、music.branchwith WEBGUIを起動後、前述したAdminユーザーでサインインして作成してください。
