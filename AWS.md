# AWSログイン後の権限有効化
『右上メニュー』⇨『セキュリティ認証情報』⇨『MFAデバイスの管理』からMFA有効化
https://qiita.com/viptakechan/items/6d19aee635b2ab189e47

# AWS CLIの設定
`aws configure` \
`~/.aws`下に情報作成される

# AWS IAMユーザーの確認
```
aws sts get-caller-identity
{
    "UserId": "AIDA52MAICAZRKHYWAG6J",
    "Account": "949993607219",
    "Arn": "arn:aws:iam::949993607219:user/toru.ishikawa"
}
```

# MFA使用時のaws cli 認証方法について
一時的な認証情報を取得し環境変数にexportする(ワンライナー版)
```
eval `aws sts get-session-token --serial-number arn:aws:iam::949993607219:mfa/toru.ishikawa --profile oca-aws --token-code 970759 | \
awk ' $1 == "\"AccessKeyId\":" { gsub(/\"/,""); gsub(/,/,""); print "export AWS_ACCESS_KEY_ID="$2 } \
$1 == "\"SecretAccessKey\":" { gsub(/\"/,""); gsub(/,/,""); print "export AWS_SECRET_ACCESS_KEY="$2} \
$1 == "\"SessionToken\":" { gsub(/\"/,""); gsub(/,/,""); print "export AWS_SESSION_TOKEN="$2 } '`
```

# aws-session-token を取得して環境変数に入れるシェルスクリプト
`set-awssession-token mca-aws {{ MFA_CODE }}` \
https://qiita.com/athagi/items/d0aefd8046ae18108542

## ~/.aws/credentials([oca-aws-mfa])書き換え
```
[default]
aws_access_key_id = AKIA52MAICAZWZN55QEZ
aws_secret_access_key = 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

[aws-2nd]
aws_access_key_id = AKIA52MAICAZ4FNGT7UC
aws_secret_access_key = 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

[oca-aws]
aws_access_key_id = AKIA52MAICAZWZN55QEZ
aws_secret_access_key = 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

[oca-aws-mfa]
AWS_ACCESS_KEY_ID=ASIA52MAICAZ7JDCDX3I
AWS_SECRET_ACCESS_KEY=zrRyBEZGVJ73DlGthPIBTP1A6+yJ040mggggsEGY
AWS_SESSION_TOKEN=FwoGZXIvYXdzEFgaDNVy8RIvjJhKBkosGyKGAX9jYIhbG+p7S6cocpSU4WxIm6SX/XhM8lIhSgS75n6CT7wARS8GdOUxZcmF5q1w+jA+Uq6XSuNIIpnVjZPzxUvj08I4qj3mSncLoPtCAJegSqJHVRxQROHU3zLIZIHrbau26YpiAhH7T1WXTUOwyJqtSQITZpEuv+dRCOMNV4AbfJfyccVcKJXaipIGMihTtuciNqbIwNmkmsRo/THjgwdLz/tG9PORySVGEYZAZ+NJrvUE/k9t
```
# STS一時認証情報を1コマンドでcredentialsファイルに保存する
https://blog.usize-tech.com/sts-temp-credential-by-oneliner/
# S3オブジェクトの中身を見るコマンド
`aws s3 cp s3://ci-cd-test-bucket-averf/tmp/terraform.tfstate -`

# EC2スポットを利用するうえでのベストプラクティス
[EC2スポットを利用するうえでのベストプラクティス](https://docs.aws.amazon.com/ja_jp/AWSEC2/latest/UserGuide/spot-best-practices.html)
# VPC間通信の方法
## Transit Gateway
[Transit Gatewayを利用してVPC間で通信してみた](https://dev.classmethod.jp/articles/transit-gateway-vpc/#toc-10)

[Transit GatewayでVPC間通信する構成をTerraformで作成してみた](https://dev.classmethod.jp/articles/creating-connections-between-vpcs-bia-transit-gateway-by-terraform/)

[【AWS Transit Gateway】複数VPCのアウトバウンド通信を集約する環境を作る](https://dev.classmethod.jp/articles/tgw-outbound-aggregation-2022/)

## VPC Peering
[VPCピアリングを使って別アカウントにあるVPC内のRDSに接続できるようにする設定](https://dev.classmethod.jp/articles/vpc-peering-to-connect-to-vpc-rds-on-another-account/)
![Alt text](https://d1tlzifd8jdoy4.cloudfront.net/wp-content/uploads/2023/02/VPC_Peering_20230201-640x274.png)

## VPC Endpoint
VPC内のリソースとVPC外のAWSリソース等をプライベート通信で連携したい場合に利用する
#### VPCエンドポイントとPrivateLink
VPCエンドポイントとAWSサービスとの通信は、Amazonのネットワーク内で完結する。これを`PrivateLink`と呼ぶ。\
![VPCendpoint_privatelink](./assets/VPCendpoint_privatelink.png) \
上図では、S3以外のサービスはPrivateLinkで通信されている。\
VPCエンドポイントにはいくつか種類があり、PrivateLinkを構成可能なものは「インターフェイスエンドポイント」である。\
インターフェイスエンドポイントの実態は、ENI(Elastic Network Interface)であり、サブネットと紐づけられる。\
S3やDynamoDBは「ゲートウェイエンドポイント」経由で通信される。\
インターフェース型は通信に応じて料金がかかるが、ゲートウェイ型はかからない。

[AWS PrivateLink と統合できる AWS のサービス](https://docs.aws.amazon.com/ja_jp/vpc/latest/privatelink/integrated-services-vpce-list.html)

# ENI(ネットワークインタフェース)削除エラーの場合
以下コマンド実行結果の*Description*で用途を確認する \
`aws ec2 describe-network-interfaces --network-interface-ids <ネットワークインタフェース ID>`

# マルチアカウント管理
### スイッチロールによるIAMユーザーの統一
「認証」するIAMユーザーを1つにし、認可と分ける
![](https://service.plan-b.co.jp/wp/wp-content/uploads/switch-640x280.png)

- プロダクトのアカウントでスイッチするIAMロールに関しては、AWS標準のポリシーのみを利用する
![iam policy](/assets/iam_policy.png)

### AWS Organizationsによる複数アカウントの組織化
- アカウントの役割を明確にし、ツリーでの制御をできるようにする \
  マルチアカウントに分割することで、コストの可視化が容易になり、権限整理もあわせて進む
![](https://service.plan-b.co.jp/wp/wp-content/uploads/organizations-640x280.png)

### AWS SSOによる認証・認可、権限の一括管理
ユーザー(+グループ)」×「ロール」×「アカウント」の権限管理が一括でできる。
- AWS SSOの画面上で一括してユーザーと認可を管理できる。他のアカウントを見に行く必要はない
- IAMユーザーが不要になるのでクレデンシャルを持ち続ける必要がなく、IAMロールの有効期限付きクレデンシャルだけになる
- ログイン後にアカウントとロールの組み合わせが表示されたり、AWS CLI v2で対応していたりと、マルチアカウント間の操作ストレスがかなり低い

[AWS Organizations & IAM Identity Center利用をオススメしてみる(AWS Organizations活用のリアル補足)](https://product.st.inc/entry/2022/12/23/102300)

### AWS Control TowerによるマルチアカウントAWS環境の統制
AWS Control TowerではAccount Factoryという機能を使用して、新規AWSアカウントを作成でき、CloudTrailやConfig、Control Towerで設定されたガードレール（現在はコントロールと呼びます）が自動設定される。また、AWSアカウントの設定はAWS Service Catalogを使用して設定される。\
[AWS マルチアカウント統制の要件検討アプローチ例](https://aws.amazon.com/jp/blogs/news/defining-requirements-of-multi-account-landing-zone/)

- AWS Control Tower で管理できる機能と検討ポイント
![Alt text](https://d2908q01vomqb2.cloudfront.net/b3f0c7f6bb763af1be91d9e74eabfeb199dc1f1f/2022/10/30/AWS-Control-Tower-%E3%81%A7%E7%AE%A1%E7%90%86%E3%81%A7%E3%81%8D%E3%82%8B%E6%A9%9F%E8%83%BD-1.png)

![](assets/ControlTower.png)

# Fargate vs EC2
| 項目 | Fargate | EC2 |
| :-- | :-- | :-- |
| コンピューティングリソース | 割高 | 適正 |
| 設計上の考慮事項 | 少ない | 多い |
| 運用コスト | 低い　 | 高い |
| セキュリティの考慮事項 | 少ない | 多い |

Fargateを採用することで、パフォーマンスに対するコンピューティングコスト +40%という料金インパクトは意外に大きいと感じられたのではないでしょうか。\
NewsPicksでは、コストの観点からECS on EC2でサービスを運用していますが、当初on EC2のデメリットと考えていた設計や運用の問題は「思っていたほど大変ではなかったのでコストメリットが上回るEC2を採用してよかった」というのが率直な感想です。

# RDS vs Aurora
|比較項目|RDS|Aurora|
|:----|:----|:----|
|データベースエンジン|MySQL,PostgreSQL,MongoDB,Oracle,SQL Server|MySQL(互換),PostgreSQL(互換)|
|ストレージアーキテクチャ|EBSがインスタンス付属|Aurora クラスター全体で共有|
|ストレージの自動スケーリング|設定可|デフォルトで自動拡張|
|耐久性|インスタンス付属のミラーリング用EBSで複製|3AZ で6か所に複製|
|可用性|マルチAZのみ|Aurora レプリカ|
|自動復旧時間|マルチAZ時60秒、シングルAZでは復旧不可|60秒~120秒、レプリカなしでもAZ障害以外は自動復旧可（10分以内）|
|読み取りスループット向上|リードレプリカ最大5台|Aurora レプリカ最大15台|
|スケーリング|なし|自動で Aurora レプリカを増減可能|
|バックアップ保持期間|0～35日|1～35日|
|データの復元|ポイントインタイムリカバリで5分前まで秒単位|ポイントインタイムリカバリで5分前まで秒単位|
|キャッシュ|再起動で失われる|DBプロセスとキャッシュが別で管理、再起動後もキャッシュが利用可能|
|価格|起動時間＋ストレージ料金|起動時間＋ストレージ料金＋ストレージI/O|

### RDS と Aurora どっちを使うかフロー
![RDS と Aurora どっちを使うかフロー](https://res.cloudinary.com/zenn/image/fetch/s--ty2eUSve--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_1200/https%3A//storage.googleapis.com/zenn-user-upload/deployed-images/a8d28bcb4af836dbe5f4e9e0.png%3Fsha%3D8ca9be5668e677cf7a03a41d30ac8083faf08b57)

# ALB vs NLB
| 項目           | NLB(L4LB)                           | ALB(L7LB)                        |
| :------------- | :---------------------------------- | :------------------------------- |
| 処理する階層   | トランスポート層 (ネットワーク層？) | アプリケーション層               |
| 振り分け方法   | ポートと IP アドレス                | URL、Cookie、HTTP ヘッダー       |
| 処理内容       | 単純な負荷分散                      | 高度な負荷分散やセキュリティ機能 |
| コスト         | 低い                                | 高い                             |
| 対応プロトコル | TCP/UDP など                        | HTTP, HTTPS                      |
| 古の呼び名     | L4 スイッチ                         | L7 スイッチ                      |

# S3 ストレージクラス選択チャート
![Alt text](https://d1tlzifd8jdoy4.cloudfront.net/wp-content/uploads/2023/04/emiki-s3storageclass-4.jpg)
