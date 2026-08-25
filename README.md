# GCP Terraform Bootstrap Lab

個人のGCPプロジェクトとGitHubリポジトリだけを使用し、Terraformと
Cloud Buildの初回Bootstrap手順を小さな構成で確認するためのラボです。

このリポジトリには、勤務先やその他の組織で使用しているプロジェクトID、
サービスアカウント、バケット名、認証情報、IAM設定を持ち込みません。

## 目的

- 既存のGCPプロジェクトへTerraform管理を導入する順序を確認する
- GCS remote backendを使用し、Terraform rootごとにstateを分離する
- Cloud BuildのGitHub接続、リンク済みrepository、triggerの境界を確認する
- Bootstrap実行者と、その後のCloud Build実行サービスアカウントを区別する
- 手動作成済みリソースをTerraformへimportする手順を記録する

## 対象範囲

このラボでは、既に作成済みの個人GCPプロジェクトを1つ使用します。
GCPプロジェクトの作成、請求先アカウントの設定、組織レベルのポリシーは
Terraformの管理対象外です。

## 予定する構成

```text
.
├── bootstrap
│   └── README.md
├── cloudbuild
│   ├── plan.yaml
│   └── apply.yaml
├── env
│   └── lab
│       ├── api
│       ├── cloudstorage
│       └── cloudbuild
├── modules
│   ├── api
│   ├── cloudstorage
│   └── cicd
├── .gitignore
└── README.md
```

各ディレクトリの責務は次のとおりです。

| Terraform root | 主な管理対象 | state prefix（予定） |
| --- | --- | --- |
| `env/lab/api` | ラボで使用するGoogle Cloud API | `terraform/lab/api` |
| `env/lab/cloudstorage` | tfstateバケット、Cloud Buildログバケット | `terraform/lab/cloudstorage` |
| `env/lab/cloudbuild` | Terraform実行用サービスアカウント、IAM、repository、trigger | `terraform/lab/cloudbuild` |

`modules`には再利用するresource定義を置き、`env/lab`配下をTerraform CLIを
実行するroot moduleとします。

## Bootstrapの基本方針

初回Bootstrapは、次の順序で進めます。

1. Terraformコードを作成し、remote backendへ接続しない静的検証を行う
2. レビュー済みコードを`main`へ反映し、実行対象のcommit SHAを固定する
3. 必要なAPIとtfstate／ログバケットを手動で準備する
4. Cloud BuildのGitHub接続とrepository linkを手動で完了する
5. API、Cloud Storage、Cloud Build repositoryを順番にTerraform stateへimportする
6. 各rootでplanを確認してからapplyする
7. PR用plan triggerと`main`用apply triggerを検証する

具体的な確認項目と証跡は[bootstrap/README.md](bootstrap/README.md)に記録します。

## 実行場所と実行主体

以下を混同しないよう、実行記録には場所とidentityを明記します。

| フェーズ | 実行場所 | 実行主体 |
| --- | --- | --- |
| 初回Bootstrap | 開発者PC（予定） | 個人のGoogleアカウント |
| Bootstrap後のplan/apply | Cloud Build | Terraform実行用サービスアカウント |

Cloud BuildにリンクされたGitHub repositoryはソース参照です。リンクしただけでは
ローカルPCやCloud Shellへリポジトリのファイルは配置されません。

## Git管理方針

- `.terraform.lock.hcl`はroot moduleごとに生成し、Gitへコミットする
- `terraform.tfstate`、`.terraform/`、保存したplanはコミットしない
- 実値の`terraform.tfvars`と`backend.hcl`はコミットしない
- 共有用には`terraform.tfvars.example`と`backend.hcl.example`を使用する
- サービスアカウントキーやその他の認証情報は作成・保存・コミットしない

## 現在の状態

- [x] GitHubリポジトリを作成
- [x] Bootstrap方針と予定構成を文書化
- [ ] Terraform rootとmoduleを作成
- [ ] Cloud Build設定を作成
- [ ] 個人GCPプロジェクトの現状を読み取り確認
- [ ] Bootstrapを実行
- [ ] PR planと`main` applyを検証

