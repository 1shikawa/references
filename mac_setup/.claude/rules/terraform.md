---
paths:
  - "/**/*.tf"
  - "/**/*.hcl"
---

# Terraform / Terragrunt 操作ワークフロー

## 基本手順（毎回この順番で実行する）

1. terraform fmt && terraform validate で構文確認
2. terraform plan -out=tfplan を実行
3. plan 出力を解析して変更内容を日本語で要約する
4. destroy や replace (-/+) がある場合は、理由と影響を説明する
5. apply は人間が別ターミナルで実行する

## import 作業のルール

- 1リソースずつ処理する（複数一括はやらない）
- import 後に terraform plan で差分ゼロを確認してから次へ進む
- lifecycle { ignore_changes } で差分を隠蔽しない

## plan 出力の JSON 変換

plan をそのままテキストで貼らず、JSON に変換してから渡す:
  terraform show -json tfplan > plan.json

JSON 形式だと省略表示がなく、全属性が含まれるため解析精度が上がる。

## 注意が必要なリソース種別

- aws_db_instance, aws_rds_cluster: replace は停止を伴う
- aws_vpc, aws_subnet: replace は依存リソース全体に波及する可能性がある
- aws_ecs_task_definition: replace は基本的に安全（旧revisionが残る）

## 絶対にやってはいけないこと

- terraform apply / destroy / state push を実行しない
  （Hooksでブロック済みだが、そもそも試みない）
- lifecycle { ignore_changes } で差分を隠蔽しない
- ARN をハードコードしない
