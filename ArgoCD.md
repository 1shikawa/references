# ArgoCD用ネームスペース作成
`kubectl create namespace argocd`

# ArgoCDインストール
`kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml`

# WebGUIへアクセス
以下ようにPortForwardingしてlocalhost:8080でアクセス\
`kubectl port-forward svc/argocd-server -n argocd 8080:443`
`kubectl -n argocd port-forward svc/argocd-server 8080:80`

Username: admin\
Password: \
`kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo`

# ArgoCD CLIでの確認
```
▶ argocd version
argocd: v2.3.1+b65c169
  BuildDate: 2022-03-10T23:56:27Z
  GitCommit: b65c1699fa2a2daa031483a3890e6911eac69068
  GitTreeState: clean
  GoVersion: go1.17.6
  Compiler: gc
  Platform: darwin/amd64
FATA[0000] Failed to establish connection to localhost:443: dial tcp [::1]:443: connect: connection refused
```
or
`FATA[0000] Argo CD server address unspecified`

接続できないエラー\
→一度ログイン挟む
```
▶ argocd --insecure login localhost:8080
Username: admin
Password:
'admin:login' logged in successfully
Context 'localhost:8080' updated

~ took 2m16s
▶ argocd version
argocd: v2.3.1+b65c169
  BuildDate: 2022-03-10T23:56:27Z
  GitCommit: b65c1699fa2a2daa031483a3890e6911eac69068
  GitTreeState: clean
  GoVersion: go1.17.6
  Compiler: gc
  Platform: darwin/amd64
argocd-server: v2.3.1+b65c169
  BuildDate: 2022-03-10T22:51:09Z
  GitCommit: b65c1699fa2a2daa031483a3890e6911eac69068
  GitTreeState: clean
  GoVersion: go1.17.6
  Compiler: gc
  Platform: linux/amd64
  Ksonnet Version: v0.13.1
  Kustomize Version: v4.4.1 2021-11-11T23:36:27Z
  Helm Version: v3.8.0+gd141386
  Kubectl Version: v0.23.1
  Jsonnet Version: v0.18.0
```

# ArgoCDパスワード変更
```
▶ argocd account update-password
*** Enter password of currently logged in user (admin):
*** Enter new password for user admin:
*** Confirm new password for user admin:
Password updated
Context 'localhost:8080' updated
```
# ArgoCDユーザーアカウント登録
```
kubectl edit cm argocd-cm -n argocd

apiVersion: v1
data:
  accounts.mailpaas: login
  application.instanceLabelKey: argocd.argoproj.io/instance
  url: https://argocd.example.com
kind: ConfigMap
```
# ArgoCDユーザーパスワード設定
```
$ argocd account update-password \
--account mailpaas \
--current-password <adminユーザーのパスワード> \
--new-password mailpaas0427
```

# ArgoCD Project(Role)の作成
参照：[ArgoCDのアカウントにロールを割り当てて権限設定する](https://qiita.com/ipppppei/items/c455c50ba7a45e017b91)
```
kubectl apply -f mailpaas.yaml

apiVersion: argoproj.io/v1alpha1
kind: AppProject
metadata:
  name: mailpaas
  namespace: argocd
spec:
  description: mailpaas project
  sourceRepos:
    - '*'
  destinations:
    - namespace: '*'
      server: '*'
  clusterResourceWhitelist:
    - group: '*'
      kind: '*'
  roles:
    - name: mailpaas
      description: mailpaas role for mailpaas project
      policies:
        - p, mailpaas, applications, get, mailpaas/*, allow
```

# 登録クラスター確認
```
▶ argocd cluster list
SERVER                                   NAME            VERSION  STATUS      MESSAGE                                              PROJECT
https://kubernetes.docker.internal:6443  docker-desktop           Unknown     Cluster has no application and not being monitored.
https://kubernetes.default.svc           in-cluster      1.22     Successful
```

# デプロイ対象クラスターの追加
```

```

# 登録アプリケーション確認
```
▶ argocd app list
NAME                         CLUSTER                         NAMESPACE  PROJECT  STATUS     HEALTH   SYNCPOLICY  CONDITIONS  REPO                                                     PATH                          TARGET
guestbook                    https://kubernetes.default.svc  default    default  Synced     Healthy  <none>      <none>      https://github.com/argoproj/argocd-example-apps.git      guestbook                     HEAD
k8s-request-counter-emitter  https://kubernetes.default.svc  default    default  OutOfSync  Missing  Auto-Prune  SyncError   https://github.com/pokotyan/k8s-request-counter-emitter  k8s/kustomize/overlays/local

~
▶ argocd  app get guestbook
Name:               guestbook
Project:            default
Server:             https://kubernetes.default.svc
Namespace:          default
URL:                https://localhost:8080/applications/guestbook
Repo:               https://github.com/argoproj/argocd-example-apps.git
Target:             HEAD
Path:               guestbook
SyncWindow:         Sync Allowed
Sync Policy:        <none>
Sync Status:        Synced to HEAD (53e28ff)
Health Status:      Healthy

GROUP  KIND        NAMESPACE  NAME          STATUS  HEALTH   HOOK  MESSAGE
       Service     default    guestbook-ui  Synced  Healthy        service/guestbook-ui unchanged
apps   Deployment  default    guestbook-ui  Synced  Healthy        deployment.apps/guestbook-ui unchanged
```

# 本番環境での利用に向けてのベストプラクティス
https://techstep.hatenablog.com/entry/2020/09/22/113404


# loadbalancer
```
▶ helmfile -f helm/helmfile-aws-load-balancer-controller.yaml -e dev sync
Adding repo eks https://aws.github.io/eks-charts
"eks" has been added to your repositories

Affected releases are:
  aws-load-balancer-controller (eks/aws-load-balancer-controller) UPDATED

Upgrading release=aws-load-balancer-controller, chart=eks/aws-load-balancer-controller
Release "aws-load-balancer-controller" does not exist. Installing it now.
NAME: aws-load-balancer-controller
LAST DEPLOYED: Wed Mar 30 14:21:18 2022
NAMESPACE: kube-system
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
AWS Load Balancer controller installed!

Listing releases matching ^aws-load-balancer-controller$
aws-load-balancer-controller	kube-system	1       	2022-03-30 14:21:18.246983 +0900 JST	deployed	aws-load-balancer-controller-1.0.5	v2.0.0


UPDATED RELEASES:
NAME                           CHART                              VERSION
aws-load-balancer-controller   eks/aws-load-balancer-controller     1.0.5
```
