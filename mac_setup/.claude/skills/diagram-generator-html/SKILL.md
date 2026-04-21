---
name: diagram-generator-html
description: |
  This skill should be used when the user asks to "HTMLで図を作って", "Tailwindで図解を生成して",
  "アーキテクチャ図を作成して", "フロー図を作って", "比較図を生成して", or needs a technical diagram
  for a blog article using HTML and Tailwind CSS.
allowed-tools: Read, Write, Bash
---

# Diagram Generator HTML

技術ブログ記事用のHTML図解を生成し、PNG画像に変換します。

## Supported Patterns

| パターン | 用途 |
|---------|------|
| アーキテクチャ図 | レイヤード、マイクロサービス、イベント駆動 |
| フロー図 | プロセス、データ、ユーザーフロー |
| 関係図 | ER図、クラス図、シーケンス図 |
| 比較図 | Before/After、オプション比較 |
| コンポーネント図 | システム構成、デプロイメント |
| 概念図 | コンセプトマップ、ツリー構造 |
| 同心円図 | 階層構造、抽象度の層、ベン図ライク |
| ディレクトリツリー図 | ファイル構成、フォルダ階層、プロジェクト構造 |

## Specifications

- **サイズ**: 1280 x 720 px (16:9)
- **技術**: HTML5 + Tailwind CSS + Material Icons
- **出力**: PNG画像
- **保存先**: `docs/article/[feature-name]/images/`

## HTML作成ルール

1. **固定サイズ**: `<body class="w-[1280px] h-[720px] m-0 p-0 overflow-hidden bg-[背景色]">`
2. **外側padding**: `p-8` または `p-10`
3. **要素間隔**: `gap-4`
4. **Tailwind CDN**: `<script src="https://cdn.tailwindcss.com"></script>`
5. **最小フォント**: `text-sm` (14px) 以上
6. **禁止事項**: JavaScript動的要素、アニメーション、カスタムCSS

## Accessibility

- コントラスト比: WCAG Level AA準拠 (4.5:1以上)
- セマンティックHTML: `role="img"`, `aria-label`
- 色依存の回避: 色 + 形状の組み合わせ

## Color Palette

| 用途 | Class |
|------|-------|
| Primary | `bg-blue-500`, `text-blue-900` |
| Secondary | `bg-green-500`, `text-green-900` |
| Accent | `bg-orange-500`, `text-orange-900` |
| Background | `bg-white`, `bg-gray-50` |

## Workflow

### 1. 情報収集

必要な情報:
- 図解タイプ（アーキテクチャ、フロー等）
- 含める要素
- 保存先記事ディレクトリ

### 2. HTML生成

基本テンプレート:

```html
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>[タイトル]</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" />
</head>
<body class="w-[1280px] h-[720px] m-0 p-0 overflow-hidden bg-white">
    <div class="w-full h-full bg-white flex items-center justify-center p-10" role="img" aria-label="[説明]">
        <!-- 図解内容 -->
    </div>
</body>
</html>
```

**詳細なパターン例**: [examples.md](references/examples.md)

### 3. ファイル保存

保存先: `docs/article/[feature-name]/images/[ファイル名].html`

### 4. PNG変換

Playwright MCPを使用して以下に保存
docs/article/[feature-name]/images/[ファイル名].png

# ```bash
# uv run html-screenshot \
#   --file docs/article/[feature-name]/images/[ファイル名].html \
#   --output docs/article/[feature-name]/images/[ファイル名].png
# ```

## Validation Checklist

- [ ] `<!DOCTYPE html>` 宣言がある
- [ ] Tailwind CDN が読み込まれている
- [ ] `<body>` に固定サイズクラスがある
- [ ] 外側divに `p-8` または `p-10` がある
- [ ] JavaScript/アニメーションが含まれていない
- [ ] `role="img"` と `aria-label` が設定されている

## Troubleshooting

| 問題 | 対処 |
|------|------|
| PNG変換失敗 | HTMLファイルのパスを確認、`--force`で上書き |
| 200KB超過 | HTMLを簡素化、サイズを縮小 |
| ディレクトリ不在 | 先に作成してから保存 |
