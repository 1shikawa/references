# クラウドプロバイダー別スタイルリファレンス

各クラウドプロバイダーのブランドカラーとアイコンスタイルを定義します。

## AWS (Amazon Web Services)

### ブランドカラー

| 用途 | 色コード | 説明 |
|------|----------|------|
| Primary Orange | `#FF9900` | AWSメインカラー |
| Dark Blue | `#232F3E` | 背景・テキスト |
| Light Blue | `#1A73E8` | リンク・アクセント |
| White | `#FFFFFF` | 背景 |

### カテゴリ別カラー

| カテゴリ | 色コード |
|----------|----------|
| Compute | `#FF9900` |
| Storage | `#3F8624` |
| Database | `#3B48CC` |
| Networking | `#8C4FFF` |
| Security | `#DD344C` |
| Analytics | `#8C4FFF` |
| Machine Learning | `#01A88D` |
| Management | `#E7157B` |

### 汎用スタイル

#### EC2インスタンス
```
shape=mxgraph.aws4.resourceIcon;resIcon=mxgraph.aws4.ec2;fillColor=#FF9900;strokeColor=#232F3E;
```

簡易版（アイコンなし）:
```
rounded=1;whiteSpace=wrap;html=1;fillColor=#FF9900;strokeColor=#232F3E;fontColor=#232F3E;
```

#### S3バケット
```
shape=mxgraph.aws4.resourceIcon;resIcon=mxgraph.aws4.s3;fillColor=#3F8624;strokeColor=#232F3E;
```

簡易版:
```
rounded=1;whiteSpace=wrap;html=1;fillColor=#3F8624;strokeColor=#232F3E;fontColor=#FFFFFF;
```

#### RDS/Aurora
```
shape=mxgraph.aws4.resourceIcon;resIcon=mxgraph.aws4.rds;fillColor=#3B48CC;strokeColor=#232F3E;
```

簡易版:
```
shape=cylinder3;whiteSpace=wrap;html=1;boundedLbl=1;backgroundOutline=1;size=15;fillColor=#3B48CC;strokeColor=#232F3E;fontColor=#FFFFFF;
```

#### Lambda
```
shape=mxgraph.aws4.resourceIcon;resIcon=mxgraph.aws4.lambda;fillColor=#FF9900;strokeColor=#232F3E;
```

簡易版:
```
rounded=1;whiteSpace=wrap;html=1;fillColor=#FF9900;strokeColor=#232F3E;fontColor=#232F3E;
```

#### VPC
```
rounded=0;whiteSpace=wrap;html=1;fillColor=none;strokeColor=#8C4FFF;dashed=1;strokeWidth=2;verticalAlign=top;fontStyle=1;
```

#### サブネット（パブリック）
```
rounded=0;whiteSpace=wrap;html=1;fillColor=#E8F5E9;strokeColor=#3F8624;dashed=0;verticalAlign=top;
```

#### サブネット（プライベート）
```
rounded=0;whiteSpace=wrap;html=1;fillColor=#E3F2FD;strokeColor=#3B48CC;dashed=0;verticalAlign=top;
```

#### ALB/ELB
```
shape=mxgraph.aws4.resourceIcon;resIcon=mxgraph.aws4.application_load_balancer;fillColor=#8C4FFF;strokeColor=#232F3E;
```

簡易版:
```
rounded=1;whiteSpace=wrap;html=1;fillColor=#8C4FFF;strokeColor=#232F3E;fontColor=#FFFFFF;
```

#### CloudFront
```
shape=mxgraph.aws4.resourceIcon;resIcon=mxgraph.aws4.cloudfront;fillColor=#8C4FFF;strokeColor=#232F3E;
```

#### API Gateway
```
shape=mxgraph.aws4.resourceIcon;resIcon=mxgraph.aws4.api_gateway;fillColor=#E7157B;strokeColor=#232F3E;
```

---

## GCP (Google Cloud Platform)

### ブランドカラー

| 用途 | 色コード | 説明 |
|------|----------|------|
| Blue | `#4285F4` | Compute, Cloud |
| Green | `#34A853` | Data, Storage |
| Yellow | `#FBBC05` | Networking |
| Red | `#EA4335` | Operations, Security |
| Gray | `#5F6368` | テキスト |

### カテゴリ別カラー

| カテゴリ | 色コード |
|----------|----------|
| Compute | `#4285F4` |
| Storage | `#34A853` |
| Databases | `#4285F4` |
| Networking | `#FBBC05` |
| Security | `#EA4335` |
| Big Data | `#4285F4` |
| AI/ML | `#4285F4` |

### 汎用スタイル

#### Compute Engine
```
shape=mxgraph.gcp2.compute_engine;fillColor=#4285F4;strokeColor=#5F6368;
```

簡易版:
```
rounded=1;whiteSpace=wrap;html=1;fillColor=#4285F4;strokeColor=#5F6368;fontColor=#FFFFFF;
```

#### Cloud Storage
```
shape=mxgraph.gcp2.cloud_storage;fillColor=#34A853;strokeColor=#5F6368;
```

簡易版:
```
rounded=1;whiteSpace=wrap;html=1;fillColor=#34A853;strokeColor=#5F6368;fontColor=#FFFFFF;
```

#### Cloud SQL
```
shape=mxgraph.gcp2.cloud_sql;fillColor=#4285F4;strokeColor=#5F6368;
```

簡易版:
```
shape=cylinder3;whiteSpace=wrap;html=1;boundedLbl=1;backgroundOutline=1;size=15;fillColor=#4285F4;strokeColor=#5F6368;fontColor=#FFFFFF;
```

#### Cloud Functions
```
shape=mxgraph.gcp2.cloud_functions;fillColor=#4285F4;strokeColor=#5F6368;
```

簡易版:
```
rounded=1;whiteSpace=wrap;html=1;fillColor=#4285F4;strokeColor=#5F6368;fontColor=#FFFFFF;
```

#### VPC
```
rounded=0;whiteSpace=wrap;html=1;fillColor=none;strokeColor=#FBBC05;dashed=1;strokeWidth=2;verticalAlign=top;fontStyle=1;
```

#### GKE
```
shape=mxgraph.gcp2.google_kubernetes_engine;fillColor=#4285F4;strokeColor=#5F6368;
```

#### Cloud Load Balancing
```
shape=mxgraph.gcp2.cloud_load_balancing;fillColor=#FBBC05;strokeColor=#5F6368;
```

#### BigQuery
```
shape=mxgraph.gcp2.bigquery;fillColor=#4285F4;strokeColor=#5F6368;
```

#### Pub/Sub
```
shape=mxgraph.gcp2.cloud_pubsub;fillColor=#EA4335;strokeColor=#5F6368;
```

---

## Azure (Microsoft Azure)

### ブランドカラー

| 用途 | 色コード | 説明 |
|------|----------|------|
| Primary Blue | `#0078D4` | Azureメインカラー |
| Dark Blue | `#003087` | 濃いアクセント |
| Light Blue | `#50E6FF` | 明るいアクセント |
| Gray | `#737373` | テキスト |

### カテゴリ別カラー

| カテゴリ | 色コード |
|----------|----------|
| Compute | `#0078D4` |
| Storage | `#0078D4` |
| Databases | `#0078D4` |
| Networking | `#0078D4` |
| Security | `#0078D4` |
| Analytics | `#0078D4` |
| AI/ML | `#0078D4` |

### 汎用スタイル

#### Virtual Machines
```
shape=mxgraph.azure.virtual_machine;fillColor=#0078D4;strokeColor=#003087;
```

簡易版:
```
rounded=1;whiteSpace=wrap;html=1;fillColor=#0078D4;strokeColor=#003087;fontColor=#FFFFFF;
```

#### Blob Storage
```
shape=mxgraph.azure.storage_blob;fillColor=#0078D4;strokeColor=#003087;
```

簡易版:
```
rounded=1;whiteSpace=wrap;html=1;fillColor=#0078D4;strokeColor=#003087;fontColor=#FFFFFF;
```

#### SQL Database
```
shape=mxgraph.azure.sql_database;fillColor=#0078D4;strokeColor=#003087;
```

簡易版:
```
shape=cylinder3;whiteSpace=wrap;html=1;boundedLbl=1;backgroundOutline=1;size=15;fillColor=#0078D4;strokeColor=#003087;fontColor=#FFFFFF;
```

#### Functions
```
shape=mxgraph.azure.function_apps;fillColor=#0078D4;strokeColor=#003087;
```

簡易版:
```
rounded=1;whiteSpace=wrap;html=1;fillColor=#0078D4;strokeColor=#003087;fontColor=#FFFFFF;
```

#### Virtual Network
```
rounded=0;whiteSpace=wrap;html=1;fillColor=none;strokeColor=#0078D4;dashed=1;strokeWidth=2;verticalAlign=top;fontStyle=1;
```

#### AKS
```
shape=mxgraph.azure.kubernetes_services;fillColor=#0078D4;strokeColor=#003087;
```

#### Application Gateway
```
shape=mxgraph.azure.application_gateway;fillColor=#0078D4;strokeColor=#003087;
```

---

## 共通コンポーネント

### インターネット/ユーザー
```
ellipse;shape=cloud;whiteSpace=wrap;html=1;fillColor=#F5F5F5;strokeColor=#666666;
```

### オンプレミス
```
rounded=0;whiteSpace=wrap;html=1;fillColor=#E0E0E0;strokeColor=#424242;dashed=1;verticalAlign=top;fontStyle=1;
```

### ユーザー/クライアント
```
shape=mxgraph.basic.smiley;fillColor=#FFE082;strokeColor=#F57C00;
```

簡易版（人型）:
```
shape=umlActor;verticalLabelPosition=bottom;verticalAlign=top;html=1;outlineConnect=0;
```

### 外部サービス/API
```
rounded=1;whiteSpace=wrap;html=1;fillColor=#FFF3E0;strokeColor=#E65100;dashed=1;
```

### 接続線スタイル

#### 通常の接続
```
edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#666666;strokeWidth=1;
```

#### 双方向接続
```
edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#666666;strokeWidth=1;endArrow=classic;startArrow=classic;
```

#### セキュア接続（HTTPS等）
```
edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#2E7D32;strokeWidth=2;dashed=0;
```

#### データフロー
```
edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#1565C0;strokeWidth=2;
```

#### 非同期/イベント
```
edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#666666;strokeWidth=1;dashed=1;
```

---

## draw.io組み込みライブラリの使用

draw.ioには各クラウドプロバイダーの公式アイコンライブラリが組み込まれています。

### ライブラリの有効化

1. draw.ioを開く
2. 左サイドバーの「+ More Shapes」をクリック
3. 「Networking」セクションで以下を有効化:
   - AWS 17 / AWS 18 / AWS 19
   - GCP Icons
   - Azure

### シェイプの参照方法

アイコンを使用する場合、`shape=mxgraph.[provider].[icon_name]` 形式でスタイルに指定します。

**例:**
- AWS EC2: `shape=mxgraph.aws4.ec2`
- GCP GCE: `shape=mxgraph.gcp2.compute_engine`
- Azure VM: `shape=mxgraph.azure.virtual_machine`
