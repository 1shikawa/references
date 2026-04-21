# IAM・セキュリティ方針

## 最小権限原則

- IAM ポリシーは AWS マネージドポリシーではなくインラインポリシーで書く
- plan 出力から apply に必要な権限を生成する場合は、
  リソースARNを * にしない（対象を具体的に絞る）

## 機密情報の扱い

- secrets セクションや環境変数に実値を書き込まない
- ARN のハードコードは禁止（data ソースか変数で参照する）

## State ファイル

- state の操作（terraform state mv / rm）は人間が実行する
- terraform state push は Hooks でブロック済み
