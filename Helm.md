# KustomizeとHelmの利用シーン
- Kustomize：自分が開発、運用しているシステム内のマイクロサービスをデプロイするためのツール \
  共通部分(`base`)に対して、各環境固有のパッチ(`overlays`)を当てるというスタイル
- Helm：公開されているアプリケーションをKubernetes上にデプロイ（インストール）する、もしくは自分のアプリケーションを公開するツール

# Helm
kubernetesクラスタ上に簡単にアプリケーションをインストールできる。
また、values.yaml と組み合わせれば Helm Chart のデフォルト設定を変更することもできる。
しかし helm コマンドを使って実行する場合，以下のようになり「宣言的に」管理できないという課題 \
↓ \
Helmfile を使うと helm コマンドを実行するときの設定を YAML で「宣言的に」管理できるようになる!!

# helm のconfig values の取得方法
Ex. \
`helm show values gitlab/gitlab-runner > gitlab_runner_helm_config.yml`\
有名どころのKubernetesのプロダクトのほとんどは、Helmチャートとして提供されており、\
[Artifact Hub](https://artifacthub.io/)から検索できます

# Helmfile
helm コマンドの引数になる情報を YAML ファイルに記載する感じ \
helmfile.yaml
```
environments:
  {{ .Environment.Name }}:

repositories:
  - name: gitlab
    url: https://charts.gitlab.io
  - name: argo
    url: https://argoproj.github.io/argo-helm

releases:
  # ArgoCD
  # https://github.com/argoproj/argo-helm/tree/master/charts/argo-cd
  - name: gitlab-runner
    namespace: gitlab
    chart: gitlab/gitlab-runner
    version: 0.37.2
    values:
    - environments/{{ .Environment.Name }}/gitlab-runner.yaml
  - name: argocd
    namespace: argocd
    chart: argo/argo-cd
    version: 3.33.6
    values:
    - environments/{{ .Environment.Name }}/argocd.yaml
```

# Helmfileコマンド
`helmfile -f helm/helmfile.yaml -e dev apply` \
⇨マニフェストに差分がある場合にhelm upgradeでrevision上がる \
`helmfile -f helm/helmfile.yaml -e dev sync` \
⇨差分がなくても毎回helm upgradeでrevisionが上がっていく


# helmfileによるk8sクラスターへのパッケージデプロイ
```
▶ helmfile -f helm/helmfile.yaml -e dev sync
Adding repo gitlab https://charts.gitlab.io
"gitlab" has been added to your repositories

Adding repo argo https://argoproj.github.io/argo-helm
"argo" has been added to your repositories

Affected releases are:
  argocd (argo/argo-cd) UPDATED
  gitlab-runner (gitlab/gitlab-runner) UPDATED

Upgrading release=gitlab-runner, chart=gitlab/gitlab-runner
Upgrading release=argocd, chart=argo/argo-cd
Release "gitlab-runner" does not exist. Installing it now.
NAME: gitlab-runner
LAST DEPLOYED: Mon Mar 28 19:00:31 2022
NAMESPACE: gitlab
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
Your GitLab Runner should now be registered against the GitLab instance reachable at: "https://gitlab.opencanvasatelier.com/"

Runner namespace "gitlab" was found in runners.config template.

Listing releases matching ^gitlab-runner$
gitlab-runner	gitlab   	1       	2022-03-28 19:00:31.013282 +0900 JST	deployed	gitlab-runner-0.37.2	14.7.0

Release "argocd" does not exist. Installing it now.
NAME: argocd
LAST DEPLOYED: Mon Mar 28 19:00:34 2022
NAMESPACE: argocd
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
In order to access the server UI you have the following options:

1. kubectl port-forward service/argocd-server -n argocd 8080:443

    and then open the browser on http://localhost:8080 and accept the certificate

2. enable ingress in the values file `server.ingress.enabled` and either
      - Add the annotation for ssl passthrough: https://github.com/argoproj/argo-cd/blob/master/docs/operator-manual/ingress.md#option-1-ssl-passthrough
      - Add the `--insecure` flag to `server.extraArgs` in the values file and terminate SSL at your ingress: https://github.com/argoproj/argo-cd/blob/master/docs/operator-manual/ingress.md#option-2-multiple-ingress-objects-and-hosts


After reaching the UI the first time you can login with username: admin and the random password generated during the installation. You can find the password by running:

kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

(You should delete the initial secret afterwards as suggested by the Getting Started Guide: https://github.com/argoproj/argo-cd/blob/master/docs/getting_started.md#4-login-using-the-cli)

Listing releases matching ^argocd$
argocd	argocd   	1       	2022-03-28 19:00:34.072919 +0900 JST	deployed	argo-cd-3.33.6	v2.2.5


UPDATED RELEASES:
NAME            CHART                  VERSION
gitlab-runner   gitlab/gitlab-runner    0.37.2
argocd          argo/argo-cd            3.33.6
```
