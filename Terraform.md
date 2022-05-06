# Current state と Desired state
- 望むべきインフラの状態を定義：`main.tf`
- 現在のインフラの状態を管理：`terraform.tfstate`
- 現在の実体： 存在するAWSオブジェクト、リソース

# Remote Backend
複数人による処理バッティングを防ぐ排他制御、バージョン管理、暗号化対応 \
https://blog-benri-life.com/terraform-state-aws-s3-dynamodb-backend/

# コードをフォーマットし、見栄えを揃える
`terraform fmt -recursive` \
`terraform fmt -recursive -check`

# 構文エラーを確認
`terraform validate`

# 初期化処理
```
▶ terraform init
Initializing modules...

Initializing the backend...

Initializing provider plugins...
- Reusing previous version of hashicorp/kubernetes from the dependency lock file
- Reusing previous version of hashicorp/cloudinit from the dependency lock file
- Reusing previous version of terraform-aws-modules/http from the dependency lock file
- Reusing previous version of hashicorp/local from the dependency lock file
- Reusing previous version of hashicorp/aws from the dependency lock file
- Reusing previous version of hashicorp/http from the dependency lock file
- Installing hashicorp/kubernetes v2.9.0...
- Installed hashicorp/kubernetes v2.9.0 (signed by HashiCorp)
- Installing hashicorp/cloudinit v2.2.0...
- Installed hashicorp/cloudinit v2.2.0 (signed by HashiCorp)
- Installing terraform-aws-modules/http v2.4.1...
- Installed terraform-aws-modules/http v2.4.1 (self-signed, key ID B2C1C0641B6B0EB7)
- Installing hashicorp/local v2.2.2...
- Installed hashicorp/local v2.2.2 (signed by HashiCorp)
- Installing hashicorp/aws v4.4.0...
- Installed hashicorp/aws v4.4.0 (signed by HashiCorp)
- Installing hashicorp/http v2.1.0...
- Installed hashicorp/http v2.1.0 (signed by HashiCorp)

Partner and community providers are signed by their developers.
If you'd like to know more about provider signing, you can read about it here:
https://www.terraform.io/docs/cli/plugins/signing.html

Terraform has made some changes to the provider dependency selections recorded
in the .terraform.lock.hcl file. Review those changes and commit them to your
version control system if they represent changes you intended to make.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

# plan結果をファイル出力
`terraform plan -no-color > tfplan.txt`

# apply処理結果
```
module.eks.aws_eks_cluster.this[0]: Still creating... [8m31s elapsed]
module.eks.aws_eks_cluster.this[0]: Still creating... [8m41s elapsed]
module.eks.aws_eks_cluster.this[0]: Still creating... [8m51s elapsed]
module.eks.aws_eks_cluster.this[0]: Still creating... [9m1s elapsed]
module.eks.aws_eks_cluster.this[0]: Creation complete after 9m6s [id=system-dev-test-1shikawa]
module.eks.data.http.wait_for_cluster[0]: Reading...
module.eks.aws_iam_openid_connect_provider.oidc_provider[0]: Creating...
module.eks.aws_iam_role.workers[0]: Creating...
module.eks.data.http.wait_for_cluster[0]: Read complete after 0s [id=https://8344A446F9CC56618FD90C7E6067ACE0.gr7.ap-northeast-1.eks.amazonaws.com/healthz]
data.aws_eks_cluster_auth.eks: Reading...
data.aws_eks_cluster.eks: Reading...
data.aws_eks_cluster_auth.eks: Read complete after 0s [id=system-dev-test-1shikawa]
data.aws_eks_cluster.eks: Read complete after 1s [id=system-dev-test-1shikawa]
module.eks.aws_iam_openid_connect_provider.oidc_provider[0]: Creation complete after 2s [id=arn:aws:iam::949993607219:oidc-provider/oidc.eks.ap-northeast-1.amazonaws.com/id/8344A446F9CC56618FD90C7E6067ACE0]
module.eks.aws_iam_role.workers[0]: Creation complete after 2s [id=system-dev-test-1shikawa20220328092721335100000009]
module.eks.aws_iam_role_policy_attachment.workers_AmazonEKSWorkerNodePolicy[0]: Creating...
module.eks.aws_iam_role_policy_attachment.workers_AmazonEKS_CNI_Policy[0]: Creating...
module.eks.aws_iam_role_policy_attachment.workers_AmazonEC2ContainerRegistryReadOnly[0]: Creating...
module.eks.aws_iam_role_policy_attachment.workers_additional_policies[0]: Creating...
module.eks.kubernetes_config_map.aws_auth[0]: Creating...
module.eks.aws_iam_role_policy_attachment.workers_AmazonEKS_CNI_Policy[0]: Creation complete after 1s [id=system-dev-test-1shikawa20220328092721335100000009-2022032809272359000000000a]
module.eks.aws_iam_role_policy_attachment.workers_AmazonEKSWorkerNodePolicy[0]: Creation complete after 1s [id=system-dev-test-1shikawa20220328092721335100000009-2022032809272360710000000b]
module.eks.kubernetes_config_map.aws_auth[0]: Creation complete after 1s [id=kube-system/aws-auth]
module.eks.aws_iam_role_policy_attachment.workers_AmazonEC2ContainerRegistryReadOnly[0]: Creation complete after 1s [id=system-dev-test-1shikawa20220328092721335100000009-2022032809272380460000000c]
module.eks.module.node_groups.aws_eks_node_group.workers["provisioning"]: Creating...
module.eks.aws_iam_role_policy_attachment.workers_additional_policies[0]: Creation complete after 1s [id=system-dev-test-1shikawa20220328092721335100000009-2022032809272382980000000d]
module.eks.module.node_groups.aws_eks_node_group.workers["provisioning"]: Still creating... [10s elapsed]
module.eks.module.node_groups.aws_eks_node_group.workers["provisioning"]: Still creating... [20s elapsed]
module.eks.module.node_groups.aws_eks_node_group.workers["provisioning"]: Still creating... [30s elapsed]
module.eks.module.node_groups.aws_eks_node_group.workers["provisioning"]: Still creating... [40s elapsed]
module.eks.module.node_groups.aws_eks_node_group.workers["provisioning"]: Still creating... [50s elapsed]
module.eks.module.node_groups.aws_eks_node_group.workers["provisioning"]: Still creating... [1m0s elapsed]
module.eks.module.node_groups.aws_eks_node_group.workers["provisioning"]: Still creating... [1m10s elapsed]
module.eks.module.node_groups.aws_eks_node_group.workers["provisioning"]: Still creating... [1m20s elapsed]
module.eks.module.node_groups.aws_eks_node_group.workers["provisioning"]: Still creating... [1m30s elapsed]
module.eks.module.node_groups.aws_eks_node_group.workers["provisioning"]: Still creating... [1m40s elapsed]
module.eks.module.node_groups.aws_eks_node_group.workers["provisioning"]: Still creating... [1m50s elapsed]
module.eks.module.node_groups.aws_eks_node_group.workers["provisioning"]: Still creating... [2m0s elapsed]
module.eks.module.node_groups.aws_eks_node_group.workers["provisioning"]: Still creating... [2m10s elapsed]
module.eks.module.node_groups.aws_eks_node_group.workers["provisioning"]: Still creating... [2m20s elapsed]
module.eks.module.node_groups.aws_eks_node_group.workers["provisioning"]: Still creating... [2m30s elapsed]
module.eks.module.node_groups.aws_eks_node_group.workers["provisioning"]: Still creating... [2m40s elapsed]
module.eks.module.node_groups.aws_eks_node_group.workers["provisioning"]: Still creating... [2m50s elapsed]
module.eks.module.node_groups.aws_eks_node_group.workers["provisioning"]: Creation complete after 2m54s [id=system-dev-test-1shikawa:system-dev-test-1shikawa-provisioning2022032809272418990000000e]

Apply complete! Resources: 42 added, 0 changed, 0 destroyed.
```
