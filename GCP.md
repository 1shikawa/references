# Common

| 項目     | AWS        | GoogleCloud  | GCP備考 |
| :------- | :--------- | :----------- | :------ |
| テナント | アカウント | プロジェクト |         |

## APIコール

ほぼ全てのリソースがWeb APIで操作 (閲覧/作成/更新/削除)されていいる
![alt text](https://cdn-ak.f.st-hatena.com/images/fotolife/g/ggen-sugimura/20220307/20220307114706.png)

## リソースの階層構造

![alt text](https://cdn-ak.f.st-hatena.com/images/fotolife/g/ggen-sugimura/20221224/20221224173308.png)

## IAM

[これで分かった！Google CloudのIAMの仕組みやAWSとの違い](https://blog.g-gen.co.jp/entry/iam-explained)
![alt text](https://devio2023-media.developers.io/wp-content/uploads/2024/06/5298f76242434edfb914520be5e431f0-640x542.png)
![alt text](https://cdn-ak.f.st-hatena.com/images/fotolife/g/ggen-sugimura/20210929/20210929184431.png)

AWS IAMではIAMPolicyで権限セット(できること)を定義し、それを権限主体(IAMUserやGroup。総称してPrincipal)に紐づけます。
別の言葉で言うと、"どのリソースに対して""何ができるか"という権限セットを人に紐づけるのです。
これはGoogleCloudのIAMが"誰が""何をできるか"を"リソースに紐づける"のとは考えが異なりますね。

| 意味                                        | AWSでの用語    | GoogleCloudの用語  | GCP備考                                                      |
| :------------------------------------------ | :------------- | :----------------- | :----------------------------------------------------------- |
| 権限セット                                  | IAM Policy     | IAM Role           | 各種リソースに対して実行可能な権限のセット                   |
| 権限を実行するIAM主体プリンシパル(人間)     | IAM User       | Googleアカウント   | Google Workspace or Workload Identityで管理                  |
| 権限を実行するIAM主体プリンシパル(サービス) | IAM Role       | サービスアカウント |                                                              |
| 人のIAM主体をまとめるグループ               | IAM Group      | Googleグループ     |                                                              |
| 個々のリソースが持つIAM設定                 | (対応概念なし) | IAM Policy         | 各種リソースに対して「誰が」、「何をできるか」を規定するもの |

![alt text](https://cdn-ak.f.st-hatena.com/images/fotolife/g/ggen-yutakei/20220818/20220818001246.png)

### IAM Policy

```json
{
  "bindings": [
    {
      "members": [
        "user:jie@example.com"
      ],
      "role": "roles/resourcemanager.organizationAdmin"
    },
    {
      "members": [
        "user:divya@example.com",
        "user:jie@example.com"
      ],
      "role": "roles/resourcemanager.projectCreator",
      "condition": {
          "title": "Expires_July_1_2022",
          "description": "Expires on July 1, 2022",
          "expression":
            "request.time < timestamp('2022-07-01T00:00:00.000Z')"
      }
    }
  ],
  "etag": "********",
  "version": 1
}
```

### サービスアカウント

プログラムかGoogleCloudAPIを利用する際は、サービスアカウントを使って認証・認可を行います。
サービスアカウントはGoogleアカウントとは異なりGoogleClouプロジェクトの中に作成するクラウドリソースです。

1. サービスアカウントキー(JSON形式)を読み込ませる
2. プログラムが動作する実行環境(VM等)にサービスアカウントをアタッチする

前者の方法は、サービスアカウントの秘密鍵をJSON形式でダウンロードし、実行環境に配置して、それをプログラムから読み込ませる方法です。
後者の方法は、プログラムの実行環境がGoogleCloud環境である場合にのみ使えます。ComputeEngineVMやCloudRunサービス、CloudFunctions関数などにはサービスアカウントをアタッチすることができます。CloudSDK(クライアントライブラリ)やgcloudコマンドは、認証情報を明示的に指定しなければ、自動的に実行環境にアタッチされたサービスアカウントの認証情報を利用します。

# Network

| 項目            | AWS                                   | GoogleCloud                   | GCP備考                                                           |
| :-------------- | :------------------------------------ | :---------------------------- | :---------------------------------------------------------------- |
| VPC             | リージョナル                          | グローバル                    | Cidr指定無し                                                      |
| サブネット      | ゾーン                                | リージョナル                  | Cidr指定有り                                                      |
| VPCルート       | サブネット単位                        | VPC単位                       | 同一VPCに所属するサブネット同士は自動的にルートが生成され相互通信 |
| NAT             | NAT Gatewayのルートターゲット設定必要 | Cloud NAT作成で自動ルート設定 |                                                                   |
| VPCピアリング   | 1:1                                   | 1:1                           | IP範囲/Cidr重複不可                                               |
| VPCメッシュ接続 | AWS Transit Gateway                   | Network Connectivity Center   | IP範囲/Cidr重複不可                                               |

[VPCネットワークピアリングとの違い](https://blog.g-gen.co.jp/entry/network-connectivity-center-explained#VPC-%E3%83%8D%E3%83%83%E3%83%88%E3%83%AF%E3%83%BC%E3%82%AF%E3%83%94%E3%82%A2%E3%83%AA%E3%83%B3%E3%82%B0%E3%81%A8%E3%81%AE%E9%81%95%E3%81%84)

## Google Cloudネットワーク

![Google Cloudネットワーク](https://cdn-ak.f.st-hatena.com/images/fotolife/g/ggen-ayumikobayashi/20211007/20211007160242.png)
![alt text](https://cdn-ak.f.st-hatena.com/images/fotolife/g/ggen-sugimura/20220424/20220424094723.png)

## AWSネットワーク

![AWSネットワーク](https://cdn-ak.f.st-hatena.com/images/fotolife/g/ggen-ayumikobayashi/20211007/20211007160259.png)

## 共有VPC

共有VPC(Shared VPC) 機能を使うと、あるプロジェクトに置いたVPCを他のプロジェクトと共有することができます。
共有VPCでは1つのホストプロジェクトを決めます。
このホストプロジェクトが、共有VPCの「親」となり、 VPCネットワーク自体の設定、サブネットの追加・削除、セカンダリアドレスレンジの設定、ファイアウォールルールの設定などを行うことができます。
そして共有されたVPCを利用する「子」プロジェクトがサービスプロジェクトです。サービスプロジェクトは、共有VPCに対してCompute EngineのVM等のリソースを配置して利用することができます。
なお、1つのプロジェクトはホストプロジェクトであると同時にサービスプロジェクトになることはできません。
![alt text](https://cdn-ak.f.st-hatena.com/images/fotolife/g/ggen-ayumikobayashi/20211007/20211007144701.png)

## インターネットアクセス

- AWSを例に取ると「パブリックサブネット」「プライベートサブネット」のように通信要件ごとにネットワークセグメントを分けるケースがありますが、 Google Cloud においてはこれは実現できません。実現する場合はVPCごと分割することになります。
セキュリティ上の理由でVPC内のVMとインターネットの接続をさせないようにするには、Cloud Firewallファイアウォールにてインターネットとの通信可否を制御することが多い。
AWSにおける「セキュリティグループ」に相当。

### VMとインターネット間の通信

以下の条件を全て満たしていること。

1. VPCのルートにデフォルトインターネットゲートウェイへの経路が存在している
2. VMがExternal IP (外部IP、いわゆるPublicIP) を持っている
3. VMとインターネット上のノード間の通信がファイアウォールルール/ポリシーで許可されている

### Cloud NAT

以下の条件を全て満たしていること。

1. VMの所属するサブネットがCloud NATを利用するよう紐付けられている
2. VMにExternal IP (外部IP) が割り振られていない
3. VPCのルートにて0.0.0.0/0のネクストホップがデフォルトインターネットゲートウェイになっているルートが存在している
4. ファイアウォールの下り (Egress) ルールで許可されている

## Google Cloudサービスへのプライベートサービスアクセス

AWSのRDSではユーザーのVPC・サブネット内にインスタンスが配置されますが、 Google CloudのCloud SQLでは、ユーザーのVPCの外に専用ネットワークができ、そこにインスタンスが配置されます。そしてユーザーのVPCとサービスプロデューサーのネットワークは、VPCピアリングで接続されユーザーのVMとはピアリング経由で接続するのです。
![alt text](https://cdn-ak.f.st-hatena.com/images/fotolife/g/ggen-sugimura/20220501/20220501103705.png)

## サーバーレスVPCアクセス

Cloud Run、App Engine (Standard)、Cloud Functionsなどサーバーレスの実行環境からVPC内のリソースにアクセスするための仕組みです。
サーバーレスVPCアクセスを設定するとVPC内にコネクターが作成されます。コネクターはVPC内の専用サブネットとコネクタインスタンスで成っています。このコネクタインスタンスはCompute Engineのコンソールからは見えない、 Googleにマネージされたインスタンスです。

## 限定公開の Google アクセス / Private Service Connect(前者拡張版)

VPC内のVM等からGoogle CloudのAPIへアクセスする際に、 Private IPのみでアクセスできるようにするための仕組みです。
Google CloudのAPIはインターネットに口を開けていますので、通常はPublic IPでアクセスすることになりますが、これらの機能を使うことでVM等はPublic IPを持つことなく、 Private IPのみでGoogle APIにアクセスできます。主たる理由は(NATなど含め)インターネットに接していないノードをGoogle APIへアクセスできるようにするため。

限定公開のGoogleアクセスで利用するIPアドレスとして199.36.153.4/30または199.36.153.8/30が許容できる場合は、無償で利用できる限定公開のGoogleアクセスを選択するのがよいでしょう。

## サードパーティサービスへのアクセス

自身のVPC内にあるVMでホストしたサービスを、VPCピアリングを使わずに、他のGoogle Cloudユーザに公開することができます。公開されたサービスへはPrivate Service Connectエンドポイントを介してPrivate IPでアクセスすることができます。
AWSでいうAWS PrivateLink機能に相当。

# LB

TODO:

# Object Storage

| 項目             | AWS                                        | GoogleCloud                                        | GCP備考                |
| :--------------- | :----------------------------------------- | :------------------------------------------------- | :--------------------- |
| サービス         | S3                                         | Cloud Storage                                      |                        |
| オプション       | デフォルトで有効                           |                                                    |                        |
| レプリケーション | クロスリージョンレプリケーション構成が必要 | デュアルリージョン・マルチリージョン設定でシンプル | Cidr指定有り           |
| データ活用基盤   | ログ保管、Redshift、Athenaクエリ           | 非構造化データをメイン                             | 構造化データはBigQuery |

## 基本スペック

- 容量無制限
- 99.999999999% (イレブンナイン)の耐久性
- 複数のデータセンターに冗長化
- 1オブジェクトの最大サイズは5TiB
- IAMやオブジェクトレベルACLによるアクセス制御
- データ保管料金に加えリクエスト回数に対する料金やネットワーク利用料金がかかるなどの課金体系
- Read-after-Writeの強い整合性

## 管理・付加機能

- 監査ログ
- ライフサイクル管理 (自動でストレージクラスを変更したり古いファイルを削除)
- オブジェクトへのメタデータ付与
- メトリクスのモニタリング
- 規制/法令対応のための削除ロック
- 静的ウェブサイトホスティング機能
- オブジェクト変更をトリガとしたメッセージキューイングサービスへの通知

# DB

[Cloud SQLを徹底解説！](https://blog.g-gen.co.jp/entry/cloud-sql-explained#Private-IP-%E3%81%A7%E6%8E%A5%E7%B6%9A)
[AlloyDB for PostgreSQLを徹底解説！](https://blog.g-gen.co.jp/entry/alloydb-for-postgresql-explained#%E6%8E%A5%E7%B6%9A)

| 項目           | AWS                  | GoogleCloud              | GCP備考        |
| :------------- | :------------------- | :----------------------- | :------------- |
| DB             | RDS                  | Cloud SQL                |                |
| クラスターDB   | Aurora               | AlloyDB                  | PostgreSQLのみ |
| クラスター構成 | ライターインスタンス | プライマリインスタンス   |                |
|                | リーダーインスタンス | リードプールインスタンス |                |
| パラメータ     | パラメータグループ   | データベースフラグ |                |

## ネットワーク

- AWSでは、RDSを構築する際はユーザ管理のネットワークに構築しますが、Google CloudのCloud SQLは、ユーザ管理のネットワークに存在せず、Google Cloud側のネットワーク上（サービスプロデューサVPC）に構築されるのが特徴です。ユーザのVPCではなくGoogle Cloudが管理するマネージドなVPCであるという点がポイントです。

### Public IPでの接続

#### 承認済みネットワーク

Public IPを利用してCloudSQL接続を行う場合、特定のIPアドレスまたはアドレス範囲からの接続を受け入れる承認済みネットワークに設定する必要があります。

### Private IPでの接続

CloudSQL/AlloyDBでPrivate IP接続を行いたい場合は、CloudSQL/AlloyDBが存在するGoogle Cloud側のネットワーク（VPC）とユーザ側のネットワーク（VPC）とVPCピアリングをする必要があります。
AlloyDBのインスタンスはプライベートIPしかエンドポイントを持たないため、サービスプロデューサー VPCに接続できるVPCを作成し、プライベートサービスアクセスを構成する必要があります。
![text](https://cdn-ak.f.st-hatena.com/images/fotolife/g/ggen-sugimura/20220804/20220804155630.png)
![text](https://cdn-ak.f.st-hatena.com/images/fotolife/g/ggen-sugimura/20230409/20230409122535.png)

### Cloud SQL Auth Proxy

Cloud SQL Auth Proxyとは、承認済みネットワークやSSLの設定が不要で安全にCloudSQLへの接続をプロキシしてくれるソフトウェアになります。
![text](https://res.cloudinary.com/zenn/image/fetch/s--nAxp8Dec--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_1200/https://storage.googleapis.com/zenn-user-upload/deployed-images/eff6638f340c7be813300f81.png%3Fsha%3D57215004d893b6764e7ff70c7a49f4c7a5f0c4fd)

### AlloyDB Auth proxy

AlloyDB Auth proxyはAlloyDBを利用するアプリケーション側のローカルにインストールする、プロキシソフトウェアです。
![text](https://cdn-ak.f.st-hatena.com/images/fotolife/g/ggen-sugimura/20230411/20230411152144.png)
AlloyDB Auth proxy経由でAlloyDBに接続することで、AlloyDBにIAM権限で認証・認可 (ログイン) することができます。またアプリケーションからデータベースへの通信がTLS (TLS 1.3, 256-bit AES cipher) で暗号化されます。
アプリケーションがCompute EngineやCloud RunなどGoogle Cloud環境で動作している場合、インスタンス等にアタッチされているサービスアカウントの権限 (`roles/alloydb.client`ロール) でデータベースにログインすることが可能です。

#### Auth Proxyを使用してCloud RunからAlloyDBに接続する
![text](https://cdn-ak.f.st-hatena.com/images/fotolife/g/ggen-sugimura/20230522/20230522090018.png)

- ネットワーク関連
  - Auth Proxyがプライベート接続でAlloyDBのメタデータを取得する際にGoogle Cloud APIsにアクセスできる必要があるため、`--enable-private-ip-google-access`で限定公開のGoogleアクセスを有効化します。
  - サービスプロデューサーVPCで使用するIPアドレス範囲を確保します。
  - 作成したIPアドレス範囲をサービスプロデューサー VPCで使用し、VPCとのピアリングを構成します。
  - Cloud RunがVPCを経由してサービスプロデューサーVPCにあるAlloyDBにアクセスできるように、サーバーレスVPCアクセスコネクタを作成します。

## バックアップ・リストア

| 項目                                        | AWS | GoogleCloud                                                                     | GCP備考 |
| :------------------------------------------ | :-- | :------------------------------------------------------------------------------ | :------ |
| 継続バックアップ(Continuous backups)        |     | デフォルトは有効化。ポイントインタイムリカバリを可能にするバックアップ          |         |
| オンデマンドバックアップ(On-demand backups) |     | 手動で採取されたバックアップ。Google Cloud コンソールや gcloud コマンド等で実行 |         |
| 自動バックアップ (Automated backups)        |     | 自動スケジュールで取られたバックアップ。デフォルトで有効 (日次・14日保持) |         |

- 継続バックアップを使い、既存クラスタを任意の時点まで巻き戻す (ポイントインタイムリカバリ) ことが可能です。
- オンデマンドバックアップまたは自動バックアップからのリストアは、新しいクラスタとして行われます。つまり、既存クラスタの中身がバックアップの時点に巻き戻るのではなく、バックアップを取った時点のデータを使って新規クラスタを作成することになります。

## Spanner

TODO:

# Pub/Sub

Pub/Subは「Amazon SNSとAmazon SQSとAmazon Kinesis Data Streamsを合体させたようなサービス」

| ユースケース                              | AWS サービス                | Google Cloud サービス |
| :---------------------------------------- | :-------------------------- | :-------------------- |
| ジョブの非同期・並列処理                  | Amazon SQS                  | Cloud Pub/Sub         |
| ユーザー操作やサーバイベントの取り込み    | Amazon Kinesis Data Streams | Cloud Pub/Sub         |
| IoT からのデータストリーミング            | Amazon Kinesis Data Streams | Cloud Pub/Sub         |
| イベントドリブン処理の実行 (イベントバス) | Amazon EventBridge          | Cloud Pub/Sub         |

[Eventarc と Pub/Sub によるリージョンとプロジェクトをまたいだイベント ルーティング](https://cloud.google.com/blog/ja/topics/developers-practitioners/cross-region-and-cross-project-event-routing-eventarc-and-pubsub)

## データ並行処理

![alt text](https://cdn-ak.f.st-hatena.com/images/fotolife/g/ggen-sugimura/20230426/20230426085511.png)

## サーバーレス

![alt text](https://cdn-ak.f.st-hatena.com/images/fotolife/g/ggen-sugimura/20230426/20230426142922.png)
![alt text](https://cdn-ak.f.st-hatena.com/images/fotolife/g/ggen-sugimura/20230505/20230505194252.png)
https://blog.g-gen.co.jp/entry/googlecloud-compute-explained
![alt text](https://cdn-ak.f.st-hatena.com/images/fotolife/g/ggen-sugimura/20230627/20230627213311.png)
Cloud Pub/Subトピックをcronジョブのターゲットとして利用することで、Pub/SubサブスクライバーとなるCloud FunctionsやCloud Runにリクエストを送信することができ、定期実行タスクの柔軟性がかなり高まります。

なお、Cloud FunctionsやCloud RunではHTTPSエンドポイントが提供されるため、Pub/Subを間に挟むことなく使用することもできます。
しかし、Pub/Subを使用することで、cronジョブと実際の処理部分を疎結合にすることができ、同じcronジョブから複数のサブスクライバーにリクエストを送信するなど処理の柔軟性が向上します。

# CI/CD

## Cloud Build

TODO:

## Cloud Deploy

概要:
https://zenn.dev/cloud_ace/articles/cicd-clouddeploy
https://zenn.dev/knowledgework/articles/cloud-deploy-for-cloud-run

### デリバリーパイプライン

![alt text](https://res.cloudinary.com/zenn/image/fetch/s--EF5NGIrJ--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_1200/https://storage.googleapis.com/zenn-user-upload/deployed-images/48ac08f8d77fd7650dcd288f.png%3Fsha%3D41415c7c61a4ad836559c250456d305ea96abe9e)

### アーキテクチャ

![text](https://res.cloudinary.com/zenn/image/fetch/s--tZHXRStS--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_1200/https://storage.googleapis.com/zenn-user-upload/deployed-images/bb69fa3fbcf5f4057d96bb0a.png%3Fsha%3D5699f4e9806ea4de67c75642513d9acd04528159)

### 必要な構成ファイル

![text](https://res.cloudinary.com/zenn/image/fetch/s--U9n52SIQ--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_1200/https://storage.googleapis.com/zenn-user-upload/deployed-images/a123d261b8b1167623ad1638.png%3Fsha%3Daf29bf4d9ec061ff3e3ab3033da533bcddd9edec)

#### Skaffold

Cloud DeployはSkaffoldというOSSを利用してデプロイを実現します。
Skaffoldは`skaffold.yaml`というYAMLファイルの設定に従い以下を行う。

- コンテナイメージをビルドしてArtifact Registryにプッシュする
- ビルドしたイメージに基づいてCloud Run service YAMLをレンダリングする (以下、`manifest.yaml`)
- レンダリングした`manifest.yaml`をCloud Run serviceにデプロイする

#### 関連リソース

![alt text](https://res.cloudinary.com/zenn/image/fetch/s--NXnesCCA--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_1200/https://storage.googleapis.com/zenn-user-upload/deployed-images/7267d0e90f287b9953b7fd5a.png%3Fsha%3D840306ad14add7689c6442e219e9664340877b5e)

Delivery PipelineはCloud Deployのメインとなるリソースで、何をどういう順番でデプロイするかを定義します。
順番の定義にはStageという概念が使われます。例えばdev、stg、prd環境があるとき、それぞれdevのstage、stgのstage、prdのstageを定義します。
そして各Stageには1つ以上のTargetが紐付きます。

Targetはデプロイ先を表現するリソースで、Cloud Runの場合はデプロイ先のプロジェクトとロケーションを定義します。

##### manifest.yaml

普段Cloud Runを使うだけであればこのYAMLは必要ないのですが、Cloud Deployを使う場合は必要になります。

```yaml
apiVersion: serving.knative.dev/v1
kind: Service
metadata:
  name: hello-app
  annotations:
    run.googleapis.com/ingress: all
spec:
  template:
    spec:
      serviceAccountName: dummy # from-param: ${service_account_name}
      containers:
        - name: hello-app
          image: hello-app
          env:
            - name: MESSAGE
              value: dummy # from-param: ${message}
```

\# from-param: によって設定されるパラメータは[deploy parameters](https://cloud.google.com/deploy/docs/parameters?hl=ja)と呼ばれます。
`deploy parameters`はTargetごとに設定できるため、環境ごとに変化する値を使いたい場合は`deploy parameters`を利用します。

### デプロイの流れ全体像

![alt text](https://res.cloudinary.com/zenn/image/fetch/s--uCB-NRUe--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_1200/https://storage.googleapis.com/zenn-user-upload/deployed-images/a9db33389343b075fca7d168.png%3Fsha%3D67f4be0e6bd406fe6da693f48cf108eef244501b)

# Monitoring

Google Compute Engine (GCE) やCloud SQL 、 Cloud Storageのバケットなど、あらゆるGoogle Cloudリソースから指標 (メトリクス) を収集します。
取得できる指標は、 Google Compute Engine (GCE) やCloud SQLならばCPU使用率やネットワークIO、Cloud StorageならばAPIリクエスト数や総使用バイト数などです。
標準的な指標は利用者が何も設定しなくても、自動的に収集されます。また、課金は発生しません。

## スコーピングプロジェクト

スコーピングプロジェクトを作成して閲覧対象のプロジェクトを追加していくとMetrics Explorerでまとめて閲覧することができます。
![alt text](https://cdn-ak.f.st-hatena.com/images/fotolife/g/ggen-sugimura/20211016/20211016123650.png)

## アラート

### Uptime check (稼働時間チェック)

一般的に「URL監視」あるいは「外形監視」などと呼ばれる監視が簡易的に設定できる機能です。
HTTP, HTTPS, TCP (任意ポート) のいずれかのトラフィックをGoogleから対象リソースに送信し、そのレスポンスを見て、想定状態とことなっていればアラートを発信することができます。

#### Public uptime check (公開の稼働時間チェック)

インターネット公開のHTTPエンドポイントを対象とするuptime checkです。

#### Private uptime check (非公開の稼働時間チェック)

インターネットに公開されていない、 VPC内部のリソースが持つHTTPエンドポイントを対象とするuptime checkです。
ターゲットとしてService Directory Endpointと呼ばれるリソースを作成する必要があります。
このリソースによりVMやL4 Internal Load BalancerのIPアドレスを抽象化し、 uptime checkはそこを目掛けてヘルスチェックを行います。
注意点として、Privateなuptime checkではHTTPまたはHTTPSしか選べません

# Logging

https://blog.g-gen.co.jp/entry/cloud-logging-explained

## ログの保存先

Cloud Loggingの保存先ストレージはログバケット、Cloud Storageバケット、BigQueryデータセットから選択できます。
ログバケットは「Cloud Storageバケット」と名称が似ていますが全く別のものであり、Cloud Loggingの独自ストレージです。
ログバケットに保管されているログだけが、 Cloud Loggingコンソールのログエクスプローラーから閲覧できます。

## ログルーティング

![alt text](https://cdn-ak.f.st-hatena.com/images/fotolife/g/ggen-sugimura/20211023/20211023183105.png)

### シンク

シンクはCloud Loggingに入ってきたログの振り分けをするコンポーネントです。
複数のシンクでフィルタの設定が重複していて、同じログをキャッチするようになっている場合、それら全てのシンクにログが複製されて振り分けられます。

#### 書き込みID

シンクを作成した際、振り分け先が「そのシンクが所属するプロジェクトのログバケット以外」だった場合、 書き込みID (Writer Identity) と呼ばれるサービスアカウントが生成されます。
この書き込みIDに対して、書き込み先への権限を付与する必要があります。

## ログ監視

### ログベースの指標

ログの特定文字列を正規表現で検知し、その検知数を基準にして Cloud Monitoring に指標 (メトリクス) として送信することができます
この指標を Cloud Monitoring の アラートポリシー 機能により検知・発報することで「XXログで Error という文字列を5分間で3個以上検知したらメール通知する」のようなログ監視が可能

### ログベースのアラート

ログ文字列の検知数をいったん Cloud Monitoring の指標化する前述の方法とは異なり、特定文字列を検知すると直接、アラートを発報できます。
文字列検知数を指標化しないため、数値として後から統計が取れない代わりに、より少ないステップで設定可能

# 静的ウェブサイトホスティング

Cloud Storage静的ウェブサイトホスティングではオリジンの保護ができない（Load Balancingを迂回するアクセスを拒否できない）
Load Balancing + Cloud Armorにより、SSLポリシーによる通信の暗号アルゴリズム制限などを実装。
Load Balancingを迂回するアクセスはCloud Armorで保護されないため、オリジンへの直接アクセスできてしまう。
そのため以下の構成となる。
![alt text](https://cdn-ak.f.st-hatena.com/images/fotolife/g/ggen-sugimura/20230610/20230610125444.png)

# ETL

ETLとは「Extract（抽出）、 Transform（変換）、 Load（書き出し）」の略であり、企業内のあらゆるシステムからデータを抽出し共有する機能を搭載したツールです。
ETLを活用することで、複数システムからのデータ抽出や外部への書き出しを実行できるため、企業の生産性向上や業務効率化に直結します。

## Dataflow

Apache Beamのマネージドな実行環境で、Cloud Storage/Cloud Bigtable/Cloud Pub/Sub/Cloud Spanner/BigQueryと連係可能。
