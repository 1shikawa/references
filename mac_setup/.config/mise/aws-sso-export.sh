#!/bin/bash
###############################################################################
# aws-sso-export.sh
#
# AWS SSOで認証し、一時認証情報を環境変数にエクスポートする
#
# 使用方法:
#   source ./aws-sso-export.sh [プロファイル名]
#
# 例:
#   source ./aws-sso-export.sh
#   source ./aws-sso-export.sh my-profile
#
# 注意:
#   必ず source コマンドで実行してください
###############################################################################
PROFILE="${1:-default}"

# 既存の認証用環境変数を解除
unset AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN AWS_REGION

 # SSO認証
echo "AWS SSO認証中 (プロファイル: ${PROFILE})..."
aws sso login --profile "${PROFILE}"

echo "認証情報を取得中..."
CREDS=$(aws configure export-credentials --profile "${PROFILE}" --format env-no-export)

export AWS_ACCESS_KEY_ID=$(echo "${CREDS}" | grep AWS_ACCESS_KEY_ID | cut -d'=' -f2)
export AWS_SECRET_ACCESS_KEY=$(echo "${CREDS}" | grep AWS_SECRET_ACCESS_KEY | cut -d'=' -f2)
export AWS_SESSION_TOKEN=$(echo "${CREDS}" | grep AWS_SESSION_TOKEN | cut -d'=' -f2)
export AWS_REGION=$(aws configure get region --profile "${PROFILE}" || echo "ap-northeast-1")

echo "認証情報を環境変数に設定しました"
echo "   Account: $(aws sts get-caller-identity --query Account --output text)"
echo "   Region: ${AWS_REGION}"
