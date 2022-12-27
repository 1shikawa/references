# AWS x GitHub Actions における IaC CI/CDセキュリティ
https://mixi-developers.mixi.co.jp/iac-cicd-security-aws-x-github-actions-dfbd9ca91b9c
- GitHub Actions に AWS 環境の権限を渡すために OIDC 連携による IAM ロールで発行される一時的なキーを使用
- ワークフロー毎に必要な権限のみを付与した IAM ロールを用意し、IAM ロールの使用条件を制限
- GitHub protected branch 設定を導入し、意図しない変更が入らないように
- GitHub PAT の漏洩対策として Fine-grained PAT によるガバナンス整備を検討しましたが断念して運用でカバーするようにしました
