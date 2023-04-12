# GitHub Actions self-hosted runner
Kubernetes上に[actions-runner-controller](https://github.com/actions/actions-runner-controller/)を構築

## アクションで入力と出力を使用する
多くの場合、アクションは入力を受け入れたり要求したりして、使用できる出力を生成します。 たとえば、アクションでは、ファイルへのパス、ラベルの名前、またはアクション処理の一部として使用するその他のデータを指定する必要がある場合があります。

アクションの入力と出力を確認するには、リポジトリのルート ディレクトリの action.yml または action.yaml を確認します。

この action.yml の例では、inputs キーワードによって file-path という名前の必須の入力が定義され、何も指定されていない場合に使用される既定値が含まれています。 outputs キーワードは、結果を配置する場所を示す results-file という名前の出力を定義します。
```yaml
name: "Example"
description: "Receives file and generates output"
inputs:
  file-path: # id of input
    description: "Path to test script"
    required: true
    default: "test-file.js"
outputs:
  results-file: # id of output
    description: "Path to results file"
```

# AWS x GitHub Actions における IaC CI/CDセキュリティ
https://mixi-developers.mixi.co.jp/iac-cicd-security-aws-x-github-actions-dfbd9ca91b9c
- GitHub Actions に AWS 環境の権限を渡すために OIDC 連携による IAM ロールで発行される一時的なキーを使用
- ワークフロー毎に必要な権限のみを付与した IAM ロールを用意し、IAM ロールの使用条件を制限
- GitHub protected branch 設定を導入し、意図しない変更が入らないように
- GitHub PAT の漏洩対策として Fine-grained PAT によるガバナンス整備を検討しましたが断念して運用でカバーするようにしました

[GitHub Actions で distroless イメージのコンテナ署名を検証する](https://tech.isid.co.jp/entry/verify-distroless-signature-using-cosign-on-github-actions)

[GitHub Actions＋AWS SAM で CI/CD を構築してみた](https://note.com/shift_tech/n/n1bf843ca0a78)
![Alt text](https://assets.st-note.com/img/1673851405520-koRYse9j1s.png?width%3D2000%26height%3D2000%26fit%3Dbounds%26quality%3D85)

