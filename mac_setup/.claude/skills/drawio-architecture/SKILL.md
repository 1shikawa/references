---
name: drawio-architecture
description: アーキテクチャ図をdraw.io形式（XML/.drawio）で生成するスキル。Use when: アーキテクチャ図をdraw.io形式で作成依頼された時。
triggers:
  - drawio
  - draw.io
  - アーキテクチャ図
  - 構成図
---

# draw.io アーキテクチャ図生成スキル

このスキルは、システムアーキテクチャ図をdraw.io互換のXML形式で生成します。

## トリガー条件

以下のキーワードが含まれる場合にこのスキルが適用されます：
- `drawio` または `draw.io`
- `アーキテクチャ図`
- `構成図をdraw.io形式で`

## 出力形式

- `.xml` ファイル: draw.ioでインポート可能なXML
- `.drawio` ファイル: draw.ioネイティブ形式（内容はXMLと同一）

## 生成手順

### Step 1: システム構成の把握

ユーザーから以下の情報を収集：
- 使用するクラウドプロバイダー（AWS, GCP, Azure, マルチクラウド）
- 主要コンポーネント（コンピュート、ストレージ、ネットワーク、データベース等）
- コンポーネント間の接続関係
- セキュリティ境界（VPC、サブネット等）

### Step 2: XML構造の生成

`references/xml-structure.md` を参照し、以下の構造でXMLを生成：

```xml
<mxfile host="app.diagrams.net" modified="[日時]" agent="Claude" version="21.0.0">
  <diagram id="[一意のID]" name="[ページ名]">
    <mxGraphModel dx="1422" dy="794" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="827" pageHeight="1169" math="0" shadow="0">
      <root>
        <mxCell id="0" />
        <mxCell id="1" parent="0" />
        <!-- コンポーネントをここに配置 -->
      </root>
    </mxGraphModel>
  </diagram>
</mxfile>
```

### Step 3: コンポーネントの配置

`references/cloud-styles.md` を参照し、各クラウドプロバイダーのスタイルを適用：

#### 基本的なmxCell構造

**図形（vertex）:**
```xml
<mxCell id="[一意のID]" value="[ラベル]" style="[スタイル]" vertex="1" parent="1">
  <mxGeometry x="[X座標]" y="[Y座標]" width="[幅]" height="[高さ]" as="geometry" />
</mxCell>
```

**接続線（edge）:**
```xml
<mxCell id="[一意のID]" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;" edge="1" parent="1" source="[接続元ID]" target="[接続先ID]">
  <mxGeometry relative="1" as="geometry" />
</mxCell>
```

### Step 4: レイアウト調整

- グリッドサイズ: 10px単位で配置
- コンポーネント間隔: 80-120px
- グループ化: 論理的なグループ（VPC、サブネット等）を矩形で囲む

### Step 5: ファイル出力

1. XMLコンテンツをコードブロックで提示
2. ./docフォルダにファイル出力
2. ユーザーが以下のいずれかの方法で使用可能
   - draw.ioで「ファイル」→「インポート」
   - `.drawio`拡張子で保存して直接開く

## クラウドプロバイダー別スタイル

詳細は `references/cloud-styles.md` を参照。

### AWS
- 背景色: `#FF9900`（オレンジ）
- アイコン: AWS公式シェイプライブラリを使用

### GCP
- 背景色: `#4285F4`（青）, `#34A853`（緑）, `#FBBC05`（黄）, `#EA4335`（赤）
- アイコン: GCP公式シェイプライブラリを使用

### Azure
- 背景色: `#0078D4`（青）
- アイコン: Azure公式シェイプライブラリを使用

## テンプレート

`assets/templates/` ディレクトリに基本テンプレートを配置：
- `aws-basic.drawio`: AWS基本構成
- `gcp-basic.drawio`: GCP基本構成
- `multi-cloud.drawio`: マルチクラウド構成

## 注意事項

- IDは一意である必要がある（`id-1`, `id-2` のような連番を使用）
- `parent="1"` は通常のキャンバス上の配置を意味する
- グループ内に配置する場合は `parent` をグループのIDに設定
- XMLは整形式（well-formed）である必要がある
- mxGraphModel に defaultFontFamily="フォント名" を設定
- すべてのテキスト要素の style に fontFamily=フォント名; を追加
- フォントサイズは標準の1.5倍 (18px程度) を使用
- 矢印は XML の先頭に配置 (最背面)
- 矢印とラベルは 20px 以上離す
- 日本語テキストの width は十分に確保 (1文字あたり 30-40px)
- 背景色は設定しない (透明)
- page="0" を設定
