# references
色々便利なやつをまとめた

## シーケンス図 by Mermaid
https://dev.classmethod.jp/articles/drawing-a-sequence-diagram-of-a-common-aws-serverless-configuration-with-mermaid/
https://marketplace.visualstudio.com/items?itemName=bierner.markdown-mermaid

### データ一覧取得
```mermaid
sequenceDiagram
    actor クライアント
    participant API as API Gateway<br/>Rest API
    participant Lambda as Data Get<br/>Lambda Function
    participant DataTable as Amazon DynamoDB<br/>Data Table

    クライアント ->>+ API: データ一覧取得
    API ->>+ Lambda: データ一覧取得
    Lambda ->>+ DataTable: データ一覧取得
    DataTable -->>- Lambda: 取得OK
    Lambda -->>- API: データ一覧
    API -->>- クライアント: 200 OK
```

### データ登録
```mermaid
sequenceDiagram
    actor クライアント
    participant API as API Gateway<br/>Rest API
    participant Lambda as Data Get<br/>Lambda Function
    participant DataTable as Amazon DynamoDB<br/>Data Table
    participant SES as Amazon SES

    クライアント ->>+ API: データ登録
    API ->>+ Lambda: データ登録
    Lambda ->> Lambda: バリデーション
    alt バリデーションエラーの場合
      Lambda -->> API: バリデーションエラー
      API -->> クライアント: 400 BadEwquest
    end
    Lambda ->>+ DataTable: データ登録
    DataTable -->>- Lambda: 登録OK
    Lambda ->>+ SES: 登録確認メール送信
    SES ->> クライアント: メール送信
    SES -->>- Lambda: 送信OK
    Lambda-->>-API: 登録OK
    API-->>-クライアント: 200 OK
```
