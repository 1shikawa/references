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

# VPC間通信の方法
## Transit Gateway
[Transit Gatewayを利用してVPC間で通信してみた](https://dev.classmethod.jp/articles/transit-gateway-vpc/#toc-10)

[Transit GatewayでVPC間通信する構成をTerraformで作成してみた](https://dev.classmethod.jp/articles/creating-connections-between-vpcs-bia-transit-gateway-by-terraform/)

[【AWS Transit Gateway】複数VPCのアウトバウンド通信を集約する環境を作る](https://dev.classmethod.jp/articles/tgw-outbound-aggregation-2022/)

## VPC Peering

