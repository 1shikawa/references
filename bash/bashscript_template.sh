#!/bin/bash
# https://qiita.com/hotwatermorning/items/e345fffcd62faab67236

# Description:
# TODO: スクリプトの目的や実行する処理の内容についての説明を記載する。

set -e -u -o pipefail

realpath() {
  [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
}

SCRIPT_NAME="$(basename "$(realpath "${BASH_SOURCE:-$0}")")"
SCRIPT_DIR="$(dirname "$(realpath "${BASH_SOURCE:-$0}")")"

# stderr にテキストを出力する echo コマンド
function echo_stderr {
  echo "${@}" 1>&2
}

# エラーと分かるテキストを先頭に付加してメッセージを表示するコマンド
function show_error {
  echo_stderr "[ERROR] $1"
}

# Usage テキストの定義。
# TODO: 実際に必要なパラメータや説明を記載する。
function show_usage_impl {
  local ECHO_COMMAND="$1"
  "$ECHO_COMMAND" "Usage: $SCRIPT_NAME [{-h|--help}] {-f|--flag} [{-a|--flag-with-argument} <ARGUMENT>]"
  "$ECHO_COMMAND" ""
  "$ECHO_COMMAND" "Description: <TODO>"
  "$ECHO_COMMAND" ""
  "$ECHO_COMMAND" "Options:"
  "$ECHO_COMMAND" -e "-h, --help\n\tShow this help."
  "$ECHO_COMMAND" -e "-f, --flag\n\tFlag without arguments."
  "$ECHO_COMMAND" -e "-a, --flag-with-argument=[value]\n\tFlag with an argument."
}

function show_usage_stdout {
  show_usage_impl "echo"
}

function show_usage_stderr {
  show_usage_impl "echo_stderr"
}

# 引数なしのとき
# 使用法を表示して正常終了
if [ $# -eq 0 ]; then
  show_usage_stderr
  exit 0
fi

# TODO: 実際にサポートするオプションに合わせて
# オプションの内容を受け取る変数を定義し、
# 解析処理を実装する
FLAG=0
FLAG_WITH_ARG=""

while [ $# -gt 0 ]; do
  case "$1" in
    -h | --help)
      # ヘルプ用のオプションが指定されたときに限り
      # usage テキストを stdout に出力する
      show_usage_stdout
      exit 0
      ;;
    -f | --flag)
      FLAG=1
      shift 1
      ;;
    -a | --flag-with-argument)
      if [[ -z "${2+UNDEF}" ]] || [[ "${2+UNDEF}" =~ ^-+ ]]; then
        show_error "Argument is required for $1"
        show_usage_stderr
        exit 1
      fi
      set -u
      FLAG_WITH_ARG=$2
      shift 2
      ;;
    -*)
      show_error "illegal option -- '$(echo $1 | sed 's/^-*//')'"
      show_usage_stderr
      exit 1
      ;;
    --)
      shift
      break
      ;;
    *)
      show_error "Internal Error! [$1]"
      show_usage_stderr
      exit 1
      ;;
  esac
done

# TODO: 解析したオプションが期待するものかどうか検証
# if [ "$FLAG_WITH_ARG" != "foobar" ]; then
#   show_error "Invalid flag value"
#   exit 1
# fi

# TODO: ビジネスロジックを実装
# do_something "$FLAG" "$FLAG_WITH_ARG"
