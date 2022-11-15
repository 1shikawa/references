# 認証と認可
認証：「お前誰？」\
認可：「君の素性はわかった、しかし許可は持っているのか？」 \
![認証と認可](https://storage.googleapis.com/zenn-user-upload/8df5d696e30d-20221111.png)

### HTTTPレスポンスでの違い
- 401 Unauthorized → 認証失敗　「君誰ですのん」
- 403 Forbidden → 認可の不足　　「素性はわかっておるが、許可できん」

# SAML
SAMLとは、Security Assertion Markup Language の略で、\
標準化団体 OASIS によって策定された、XML をベースにした異なるインターネットドメイン間でユーザー認証を行うための標準規格。\
一度のログインで複数のサービスにログインできる SSO を実現するために活用される。

## SAML 認証の登場人物
SAML認証では、ユーザー・IdP・SP の三者間で認証情報をやり取りします。
- ユーザー
  利用者。主にブラウザを用いてやり取りする。
- IdP
  Identity Providerの略。SSOの仕組みを提供するサービスを指す。
- SP
  Service Providerの略。ログインしたいクラウドサービスを指す。

## 認証の流れ
SAML認証には２パターンの流れがある。
### SP Initiated
SPを起点とした認証の流れ。
![SP Initiated](/assets/SAML_SP_Initiated.png)

1. ユーザーが SP にアクセスする
2. SP がSAML認証要求を作成し、ユーザーに応答する
3. ユーザーは SP から受け取ったSAML認証要求を IdP に送信する
4. IdP の認証画面が表示される
5. ユーザーは認証情報を入力して IdP との間で認証処理を行なう
6. 認証が成功すると、IdP からSAML認証応答が発行される
7. ユーザーは IdP から受け取ったSAML認証応答を SP に送信する
8. SP にSAML認証応答が届くとログインができる

### Idp Initiated
IdPを起点とした認証の流れ。 \
https://qiita.com/taka-k/items/785d1be8725f76f3bad9


# Open ID Connect (OIDC)
OIDCは、OAuth 2.0フレームワークの上に構築されています。\
OIDCは、JSONベースのWebトークン（JWT）を使用してデータを構造化します。\
JWTは、両者の間でクレームを表して安全に転送するためのルールを定義する業界標準です。\
クレームとは、IDの管理と検証をサポートするために使用される、暗号化された機密性の高いユーザデータと考えてください。\
トランスポートのために、OIDCはデフォルトのHTTPSフローを使用します。
