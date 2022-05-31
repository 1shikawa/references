# Kubernetes導入理由
https://blog.howtelevision.co.jp/entry/2021/11/12/113000 \
- コンテナの振る舞いをマニフェストで記述したうえGitで管理できる
- マニフェストで定義した振る舞いをシンプルに展開できる、リソースコントロールを柔軟にできる、スケーリングが容易にできる
- 強力なエコシステムの恩恵を受けることができる
- 特定のベンダーに依存せず、オープンなものに依存することで拡張性を得ることができる
### 環境ごとのクラスター構成
本番環境稼働・検証環境・開発環境でKubernetesクラスターを分けています。 \
これにより検証環境では、本番環境と同等な状態でのアプリケーションの動作確認と負荷試験の結果を受けたキャパシティプランニングができる \
namespaceで本番環境・検証環境・開発環境を分離する方法も検討しましたが、クラスタ自体が分離されているほうがテストをしやすく、本番環境だけの特別な操作という心理的な負担を減らすことができる
### マニフェスト管理はシンプルに
kustomizeを利用することで環境差分を吸収して、1つのリポジトリで全マニフェストを管理する方法をとっています。 Helmはより柔軟にパラメータの指定ができますが、学習コストが高くマニフェスト管理への障壁になる点

# Kubernetesを中心としたコンテナエコシステムの環境構築や運用ノウハウ
https://developer.mamezou-tech.com/container/

# Kubernetesクラスタを構築
### Podアクセス許可(IRSA)
k8sクラスターからAWSリソースを利用する場合、セキュリティ上IAMで必要最小限のアクセスに制限するのが望ましいです。\
EKSではIRSA(IAM Roles for Service Account)という仕組みが用意されており、Podの単位でIAM Roleを割り当てることが可能です
1. AWSリソースに対してCRUD可能なポリシードキュメントを定義
2. IAM Policy(xxxxxxPolicy)を作成
3. IAM PolicyをアタッチするIAM Roleを作成(TerraformのIAMモジュール使用)。\
    このRoleの引受可能な対象にKubernetesのServiceAccount(system:serviceaccount:${var.env}:xxxxxx)を指定
4. IAM Roleを指定に紐づくServiceAccountを作成

# Ingress導入
### Service (type: LoadBalancer)リソースの場合
ServiceリソースをLoadBalancerとして定義することでL4ロードバランサーを作成(実態はELB)しました。\
この方法はシンプルですが、ルーティング機能が貧弱(L4)で、様々なアプリケーションがデプロイされると、\
エンドポイントごとにロードバランサーを配置する必要がある等、柔軟性やコストの観点で劣ります。

### Ingressリソースとは
Ingressのマニフェストにルーティングのルールを反映すると、1つのロードバランサーで様々なアプリケーションへのエンドポイントを提供することが可能となります。
- AWS Load Balancer Controllerがあればyaml形式でIngressの設定を記載してapplyするだけで簡単にロードバランサーが適切な設定で作成されます。
- AWS Load Balancer ControllerがIngressのリソースを参照して、その内容に合わせて、ロードバランサーを作成します。
- AWS Load Balancer ControllerはNodePortを経由してルーティングを行うため、Serviceリソースに対してtype=NodePortを指定する必要があります。

### 主なIngress Controller
- NGINX Ingress Controller
  - ClusterIPを経由してルーティング
- AWS Load Balancer Controller
  - NodePortを経由してルーティング

### インストール前の準備
![albc](./assets/albc.png)
### Ingress Controllerのインストール
- Helm Chartベースで設定情報を宣言的に管理、インストールする。\
https://artifacthub.io/packages/helm/aws/aws-load-balancer-controller

### Ingressにおけるannotations設定
https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.0/

## カスタムドメイン管理(External-DNS)
https://github.com/kubernetes-sigs/external-dns \
DNSサーバにIngress(ALB)とのマッピングを追加する必要がある。\
Ingressに新しいホストが追加される度に別途DNSでマッピング作業が発生する。\
手動による設定だと抜け漏れミス等が発生する可能性がある。\
Kubernetes上のServiceリソースやIngressリソースを監視しつつDNSレコードを動的に管理できるようになる

### インストール前の準備
- IAM Policy(external-dnsがRoute53を更新する用)
- IAM Role(EKSのOIDCプロバイダ経由でk8sのServiceAccountが引受可能な)
- k8s上にServiceAccountを作成して上記IAM Roleと紐付け
![external-dns](./assets/external-dns.png)
### External-DNSのインストール
- Helm Chartベースで設定情報を宣言的に管理、インストールする。\
https://artifacthub.io/packages/helm/bitnami/external-dns


## HTTPS通信
現時点でALBはACM以外の証明書を使う術ないため、\
AWS Load Balancer Controller の場合はACM利用を前提として、Ingressのannotationでマッピングする。
### 参考
- [Redirect Traffic from HTTP to HTTPS](https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.2/guide/tasks/ssl_redirect/)
- [EKS の LoadBalancerController で http → https のリダイレクト](https://qiita.com/exabugs/items/872e4312258f891e7b19)

#### TLS証明書の管理(Cert Manager)
https://cert-manager.io/docs/
