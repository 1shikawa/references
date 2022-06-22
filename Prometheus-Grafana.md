# Prometheusの基本
PrometheusはPULL型のメトリクス収集を採用していますので、Prometheus側から定期的にメトリクスを取りに来ます。PUSH型の場合はアプリケーション側からメトリクスをモニタリングツールに送ります。
# インフラ(Kubernetes)メトリクス収集・可視化
kube-prometheus-stackでは、デフォルトでデータソース(=Prometheus)の設定に加えて、Kubernetesのコンテナ関連のメトリクス収集やGrafanaのダッシュボードがセットアップされています。
したがって、インストールした時点で既に各種メトリクス収集が始まり、Grafanaダッシュボードをメトリクスを確認できます。

# アプリケーションメトリクス収集・可視化
## アプリケーションコード内の実装
自動でNode.jsのメトリクスを生成し、エンドポイントを公開するprometheus-api-metricsを使用します。
後は、エントリーポイントのindex.tsでセットアップ用のコードを追加するだけです。
```
import apiMetrics from 'prometheus-api-metrics';

const app = express();
app.use(express.json());
// Express appに登録
app.use(apiMetrics())
```
これだけで、Prometheus向けのメトリクス収集エンドポイントが/metricsで公開されます[5]。

## Prometheus側でのメトリクス収集定義
Prometheusがこのメトリクスを収集するためには、Prometheus Operatorのカスタムリソース`ServiceMonitor`を作成する必要があります。
```
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: task-service-monitor
  namespace: prod
  labels:
    release: kube-prometheus-stack
spec:
  endpoints:
    - path: /metrics
      targetPort: http
      interval: 30s
  selector:
    matchLabels:
      app: task-service
```
注意点としては`labels`です。デフォルトではPrometheus Operatorはこのラベルがつけられたものをメトリクス収集対象として認識しますので、これがないとメトリクスは収集されません。
それ以外は`endpoints`でアプリケーション側のメトリクス収集のエンドポイントを指定し、`selector`で収集対象のServiceオブジェクトのラベルを指定しています。
これでPrometheusはService経由で`/metrics`のエンドポイントから、30秒間隔でメトリクスを収集するようになります。
アプリケーションのロジックに手を入れることなく、アプリケーションメトリクスを収集、可視化ができる

## アプリケーション特性に沿ったカスタムメトリクス収集
これには、アプリケーション内でカスタムメトリクスをPrometheusに公開し、Grafanaで可視化する必要があります。
アプリケーション側では、Prometheusのクライアントライブラリのprom-client[6]がありますので、これを利用してメトリクスの生成をします。これでメトリクスエンドポイントにカスタムメトリクスが追加で公開されます。

後は、Grafanaの方で、Prometheusクエリ言語のPromQLを使ってメトリクスを取得すれば、Grafanaの豊富な可視化機能を利用できます。
