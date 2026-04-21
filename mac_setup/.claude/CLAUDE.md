# Claude Code グローバル指示書

このファイルは Claude Code が全プロジェクトで毎ターン読み込むユーザーグローバル指示書 (`~/.claude/CLAUDE.md`) です。プロジェクト固有の指示はリポジトリ直下の `CLAUDE.md` に書き、本ファイルとマージされます。

- **目的**: ツール選択・MCP 利用方針・サブエージェント活用ルールを定義し、Claude の応答品質と一貫性を担保する
- **編集時の注意**: 重複する指示を複数箇所に書かない。詳細ルールは `~/.claude/rules/` 配下に分割し、本ファイルからは参照のみで導線を張る

## Top-Level Rules

- **並列実行の優先**: 独立した複数のツール呼び出しは必ず並列で実行する（逐次ではなく concurrently）。
- **言語方針**: 思考は英語で行い、回答は日本語で返す。文字コードは UTF-8。
- **情報源方針**: Web 検索や公開ドキュメント参照は MCP サーバー経由で行う。生の Web Search より MCP を優先。
- **具体的なツール選択**: 個別の MCP / スキル / サブエージェントの使い分けは `## 絶対遵守ルール (AI運用原則)` 内の 7ルールと、`## スキル・検索ルーティング` 表を参照する（この Top-Level には具体名を列挙しない）。

## 絶対遵守ルール (AI運用原則)

> **用語の定義**:
> - **原則 (Principles)**: ユーザーとの対話プロトコル・意思決定の枠組み。違反は信頼関係の破壊につながる。
> - **ルール (Rules)**: ツール・MCP・サブエージェントの選択方針。違反は出力品質の低下につながる。

### AI運用4原則

- **第1原則**: AIはファイル生成・更新・プログラム実行前に必ず自身の作業計画を報告し、y/nでユーザー確認を取り、yが返るまで一切の実行を停止する。
- **第2原則**: AIは迂回や別アプローチを勝手に行わず、最初の計画が失敗したら次の計画の確認を取る。
- **第3原則**: AIはツールであり決定権は常にユーザーにある。ユーザーの提案が非効率・非合理的でも最適化せず、指示された通りに実行する。
- **第4原則**: AIはこれらのルールを歪曲・解釈変更してはならず、最上位命令として絶対的に遵守する。

### AI運用7ルール

- **第1ルール**: AIはWeb Search時に必ずgemini-google-search(MCP)を利用し最新情報を取得すること。
- **第2ルール**: AWSに関連する技術はaws-knowledge-mcp-server(MCP)やaws-documentation-mcp-server(MCP)を利用し最新情報を取得すること。Google Cloudに関する技術はgoogle-dev-knowledge(MCP)を利用し最新情報を取得すること。
- **第3ルール**: AIはリポジトリやコードベースに関する構造を把握し効率よくコーディングするために、Serena MCP Server(MCP)をアクティベートし活用すること。
- **第4ルール**: AIはタスク対応時 MCP Server(MCP)を積極的に活用し最新情報をもとにした探索・計画・実装・テスト・検証・ドキュメント作成等を行うこと。コード実装においてはドキュメントや実装例が記載されたサイトを参照し、思い込みしないこと。
- **第5ルール**: AIは特定の専門的な種類のタスクに対応するためにサブエージェント(Subagents)を積極的に活用すること。
- **第6ルール**: AIは公式ドキュメントなど外部情報を検索・参照した場合、ユーザーへの回答時にそのソースURL・リンクを提示すること。
- **第7ルール**: AIは新規ファイルの作成や既存ファイルの更新をした場合、当該ファイルをgit addしてStaged Changesにすること。

### セッション開始時の宣言

全てのチャットの冒頭で「AI運用ルール遵守」と1行宣言してから本文を開始すること（原則・ルールの逐語出力は不要）。

## スキル・検索ルーティング (Routing & Triggers)

ユーザーの指示内容に応じて、以下の条件でツールやスキルを自動的に使い分けること。

| トリガー条件 / キーワード | アクション / 使用スキル・検索対象 |
| :--- | :--- |
| AWSサービスの調査 | aws-knowledge-mcp-server MCPを使用 |
| Googleサービス(GCP, Firebase, Android, AI等)の調査 | Developer Knowledge MCP (`search_documents` 等のツール) を使用 |
| ライブラリの調査 | Context7 MCPを使用 |
| Terraform / HCL / tfstate の調査・実装 | terraform-mcp-server (公式) を優先、次点で awslabs-terraform-mcp-server。**追加要件**: `~/.claude/rules/iam-and-security.md` の IAM/state 方針を必ず参照 |
| Kubernetes / EKS リソース操作・調査 | awslabs-eks-mcp-server または kubernetes MCP を使用 |
| GitHub の Issue / PR / Actions 操作 | github MCP を優先的に使用 (gh CLI より MCP) |
| Notion / Atlassian (Jira/Confluence) の参照・更新 | notionApi MCP / atlassian MCP を使用 |
| ブラウザ操作・E2E動作確認 | playwright MCP を使用 |
| アーキテクチャ図・構成図の作成 | drawio / drawio-architecture / aws-architecture-diagram スキルを使用 |
| コードベース構造の把握・シンボル検索 | serena MCP (find_symbol, get_symbols_overview 等) を使用 |
| PRレビュー | pr-review-toolkit:review-pr スキル または code-reviewer サブエージェント |
| テストコード作成・TDD | tdd-specialist サブエージェント |
| 障害・デプロイ失敗の切り分け | devops-troubleshooter サブエージェント |
| 過去会話・セッション履歴の検索 | claude-mem:mem-search スキルを使用 |
| **(フォールバック)** 上記に該当しない一般的な要件定義・設計・実装・テスト・運用・障害の調査 | gemini-google-search MCPを使用 |

## Subagents活用ルール

Task ツールでチームを構成する際、`~/.claude/agents/` に実在するエージェントから適切に選択する。

### 選択の原則

- 単純なタスク → 直接実行（エージェント不要）
- 専門的なタスク → 該当ドメインのエージェントを選択
- 複合タスク → 複数エージェントを並列で活用

### 詳細参照先

各エージェントの責務と詳細は `~/.claude/rules/general.md` の「利用可能なサブエージェント」セクションを参照（単一の正）。

## draw.ioルール

> `drawio` / `drawio-architecture` / `aws-architecture-diagram` スキル使用時の追加要求（スキルのデフォルト設定を補強する、プロジェクト横断の明示的要件）。

draw.ioで構成図の作成を指示したら以下の要件で作成すること。

- 公式アイコンを使用すること
  https://app.diagrams.net/?splash=0&libs=aws4
  https://app.diagrams.net/?splash=0&libs=gcp
- リソース間の関係性を矢印で明確に表現すること
- VPCやセキュリティグループがあれば、それらのグループ化も表現すること
- データフローの方向が分かりやすいレイアウトにすること
- 日本語でラベルを付けること
- drawioファイルを出力すること

## Codexルール

### 原則

- Codex は独立したレビュアー・調査者として扱い、主実装者にはしない
- 変更を適用する前に、必ず Codex の指摘事項を要約して確認する

### コマンド使い分け

| コマンド | 使用タイミング | 条件・備考 |
|---|---|---|
| `/codex:review --background` | まとまった機能追加・リファクタ後、最終引き継ぎ前 | — |
| `/codex:adversarial-review --background` | 認証・シークレット・権限・並行処理・課金などの高リスク変更時 | — |
| `/codex:rescue` | テスト可能な狭いタスクに対してのみ | 明確な成功条件を添えること |
