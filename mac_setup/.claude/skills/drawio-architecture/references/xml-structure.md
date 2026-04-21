# draw.io XML構造リファレンス

draw.ioファイルは、XML形式で図形、接続、メタデータを定義します。

## 基本構造

```xml
<?xml version="1.0" encoding="UTF-8"?>
<mxfile host="app.diagrams.net" modified="2024-01-01T00:00:00.000Z" agent="Claude" version="21.0.0" type="device">
  <diagram id="diagram-1" name="Page-1">
    <mxGraphModel dx="1422" dy="794" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="827" pageHeight="1169" math="0" shadow="0">
      <root>
        <mxCell id="0" />
        <mxCell id="1" parent="0" />
        <!-- コンポーネントはここに配置 -->
      </root>
    </mxGraphModel>
  </diagram>
</mxfile>
```

## 要素の説明

### mxfile（ルート要素）

| 属性 | 説明 | 例 |
|------|------|-----|
| host | 作成元アプリケーション | `app.diagrams.net` |
| modified | 更新日時（ISO 8601形式） | `2024-01-01T00:00:00.000Z` |
| agent | 作成エージェント | `Claude` |
| version | draw.ioバージョン | `21.0.0` |
| type | ファイルタイプ | `device` |

### diagram（ページ要素）

| 属性 | 説明 | 例 |
|------|------|-----|
| id | 一意のID | `diagram-1` |
| name | ページ名 | `Architecture` |

### mxGraphModel（キャンバス設定）

| 属性 | 説明 | デフォルト値 |
|------|------|-------------|
| dx | X方向オフセット | `1422` |
| dy | Y方向オフセット | `794` |
| grid | グリッド表示 | `1` |
| gridSize | グリッドサイズ（px） | `10` |
| guides | ガイド表示 | `1` |
| tooltips | ツールチップ表示 | `1` |
| connect | 接続有効 | `1` |
| arrows | 矢印表示 | `1` |
| fold | 折りたたみ有効 | `1` |
| page | ページ表示 | `1` |
| pageScale | ページスケール | `1` |
| pageWidth | ページ幅 | `827` (A4) |
| pageHeight | ページ高さ | `1169` (A4) |
| math | 数式表示 | `0` |
| shadow | 影効果 | `0` |

### mxCell（図形・接続線）

#### 必須のルートセル

```xml
<mxCell id="0" />
<mxCell id="1" parent="0" />
```

- `id="0"`: ルート要素（必須）
- `id="1"`: デフォルトレイヤー（必須、parent="0"）

#### 図形（vertex）

```xml
<mxCell id="shape-1" value="EC2 Instance" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#FF9900;strokeColor=#232F3E;fontColor=#232F3E;" vertex="1" parent="1">
  <mxGeometry x="100" y="100" width="120" height="60" as="geometry" />
</mxCell>
```

| 属性 | 説明 |
|------|------|
| id | 一意の識別子 |
| value | 表示テキスト（HTMLタグ使用可） |
| style | スタイル定義（セミコロン区切り） |
| vertex | `1`で図形として定義 |
| parent | 親要素のID（通常は`1`） |

#### 接続線（edge）

```xml
<mxCell id="edge-1" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#232F3E;strokeWidth=2;" edge="1" parent="1" source="shape-1" target="shape-2">
  <mxGeometry relative="1" as="geometry" />
</mxCell>
```

| 属性 | 説明 |
|------|------|
| id | 一意の識別子 |
| value | ラベル（空白可） |
| style | 線のスタイル |
| edge | `1`で接続線として定義 |
| parent | 親要素のID |
| source | 接続元図形のID |
| target | 接続先図形のID |

### mxGeometry（位置・サイズ）

#### 図形の場合

```xml
<mxGeometry x="100" y="200" width="120" height="60" as="geometry" />
```

| 属性 | 説明 |
|------|------|
| x | X座標（左上基準） |
| y | Y座標（左上基準） |
| width | 幅 |
| height | 高さ |
| as | 常に`geometry` |

#### 接続線の場合

```xml
<mxGeometry relative="1" as="geometry" />
```

または、経由点を指定：

```xml
<mxGeometry relative="1" as="geometry">
  <Array as="points">
    <mxPoint x="200" y="150" />
    <mxPoint x="300" y="150" />
  </Array>
</mxGeometry>
```

## スタイル属性

### 図形の共通スタイル

| 属性 | 説明 | 例 |
|------|------|-----|
| rounded | 角丸 | `0` or `1` |
| whiteSpace | テキスト折り返し | `wrap` |
| html | HTML表示 | `1` |
| fillColor | 塗りつぶし色 | `#FF9900` |
| strokeColor | 枠線色 | `#232F3E` |
| fontColor | 文字色 | `#232F3E` |
| fontSize | 文字サイズ | `12` |
| fontStyle | 文字スタイル | `0`(通常), `1`(太字), `2`(斜体) |
| opacity | 不透明度 | `100` |
| shadow | 影 | `0` or `1` |
| dashed | 破線 | `0` or `1` |

### 接続線のスタイル

| 属性 | 説明 | 例 |
|------|------|-----|
| edgeStyle | 線のスタイル | `orthogonalEdgeStyle`, `elbowEdgeStyle` |
| rounded | 角丸 | `0` or `1` |
| orthogonalLoop | 直交ループ | `1` |
| jettySize | 接続部分サイズ | `auto` |
| strokeWidth | 線の太さ | `2` |
| endArrow | 終点矢印 | `classic`, `block`, `open`, `none` |
| startArrow | 始点矢印 | `classic`, `block`, `open`, `none` |

### 図形タイプ別スタイル

#### 矩形
```
shape=rect;rounded=0;
```

#### 角丸矩形
```
rounded=1;arcSize=10;
```

#### 楕円
```
ellipse;
```

#### ひし形
```
rhombus;
```

#### 円柱（データベース）
```
shape=cylinder3;whiteSpace=wrap;html=1;boundedLbl=1;backgroundOutline=1;size=15;
```

#### クラウド
```
ellipse;shape=cloud;
```

## グループ化

グループを作成するには、コンテナ図形を定義し、子要素の`parent`をコンテナのIDに設定：

```xml
<!-- グループコンテナ -->
<mxCell id="group-1" value="VPC" style="rounded=0;whiteSpace=wrap;html=1;fillColor=none;strokeColor=#232F3E;dashed=1;verticalAlign=top;fontStyle=1;" vertex="1" parent="1">
  <mxGeometry x="50" y="50" width="400" height="300" as="geometry" />
</mxCell>

<!-- グループ内の要素 -->
<mxCell id="shape-in-group" value="Subnet" style="rounded=1;whiteSpace=wrap;html=1;" vertex="1" parent="group-1">
  <mxGeometry x="20" y="40" width="100" height="50" as="geometry" />
</mxCell>
```

## ID命名規則

推奨するID命名パターン：

- 図形: `shape-1`, `shape-2`, ...
- 接続線: `edge-1`, `edge-2`, ...
- グループ: `group-1`, `group-2`, ...
- AWS: `aws-ec2-1`, `aws-rds-1`, ...
- GCP: `gcp-gce-1`, `gcp-gcs-1`, ...
- Azure: `azure-vm-1`, `azure-sql-1`, ...

## 座標とレイアウト

### 推奨間隔

- コンポーネント間: 80-120px
- グループ内パディング: 20-40px
- ラベルからの距離: 10-20px

### レイアウトパターン

#### 左から右（水平フロー）
```
[Component A] --> [Component B] --> [Component C]
x: 100          x: 300            x: 500
y: 100          y: 100            y: 100
```

#### 上から下（垂直フロー）
```
     [Component A]     x: 200, y: 50
           |
     [Component B]     x: 200, y: 200
           |
     [Component C]     x: 200, y: 350
```

#### 3層アーキテクチャ
```
[Web Tier]      x: 100-400, y: 50-150
[App Tier]      x: 100-400, y: 200-300
[Data Tier]     x: 100-400, y: 350-450
```
