# Initial Bootstrap Runbook

この文書は、個人GCPプロジェクトへTerraformとCloud Buildを初めて導入する際の
作業順序、実行主体、確認結果を記録するためのものです。

このディレクトリ自体はTerraform rootではありません。一回限りの準備、import、
plan、applyを、通常運用のCloud Build設定と分けて記録します。

## 前提と対象外

前提は次のとおりです。

- 個人GCPプロジェクトが1つ作成済みである
- プロジェクトに請求先アカウントが設定されている
- 個人GitHubアカウントにprivate repositoryが作成済みである
- 開発者PCで`gcloud`、Terraform、Gitを実行できる
- GCPとGitHubの操作には個人アカウントだけを使用する

次のものは、このラボへコピーしません。

- 組織のプロジェクトID、サービスアカウント、バケット名
- 組織のIAM、Organization Policy、認証情報
- 組織固有のCloud Build設定やSecret Managerの値

## Bootstrap値

実行前に値を確定します。秘密情報はこの表やGitへ記録しません。

| 項目 | 値 | 確認方法 |
| --- | --- | --- |
| GCP project ID | 未設定 | GCP Console / `gcloud config get-value project` |
| GCP project number | 未設定 | GCP Console / `gcloud projects describe` |
| Region | 未設定 | TerraformおよびCloud Buildの設定 |
| GitHub repository | `irmnt/gcp-terraform-bootstrap-lab` | GitHub |
| Cloud Build connection name | 未設定 | Cloud Build repositories |
| Linked repository name | 未設定 | Cloud Build repositories |
| Terraform service account | 未設定 | IAM |
| tfstate bucket | 未設定 | Cloud Storage |
| Cloud Build logs bucket | 未設定 | Cloud Storage |
| Target commit SHA | 未設定 | `git rev-parse HEAD` |

## 管理境界

初回Bootstrapで手動作成するものと、最終的にTerraformが管理するものを分けます。

| 対象 | 初回の作成方法 | Bootstrap後の扱い |
| --- | --- | --- |
| GCP project / billing | GCP Console | Terraform管理外 |
| 必須API | Consoleまたは`gcloud` | `env/lab/api`へimport |
| tfstate bucket | Consoleまたは`gcloud` | `env/lab/cloudstorage`へimport |
| Cloud Build logs bucket | Consoleまたは`gcloud` | `env/lab/cloudstorage`へimport |
| GitHub host connection | Cloud BuildとGitHubの認可画面 | Terraform管理外 |
| Linked repository | Cloud Build repositories | `env/lab/cloudbuild`へimport |
| Build service account / IAM | 初回は開発者アカウントでapply | `env/lab/cloudbuild`で管理 |
| Plan / apply trigger | Terraform apply | `env/lab/cloudbuild`で管理 |

GitHub host connectionにはブラウザ上のGitHub App認可が含まれるため、このラボでは
手動のBootstrap prerequisiteとして扱います。リンク済みrepositoryは、import後に
Terraform管理へ移します。

## 実行手順

### 1. コードを準備する

Terraform rootとmoduleを作成し、remote stateへ接続する前に次の静的検証を行います。

```text
terraform fmt -check -diff
terraform init -backend=false
terraform validate
```

この段階では、共有stateに対するimport、plan、applyを行いません。

### 2. 実行対象を固定する

レビュー済みコードを`main`へ反映し、開発者PCで対象commitをcheckoutします。
実行直前に`git rev-parse HEAD`を確認し、そのSHAを「Bootstrap値」に記録します。

### 3. Bootstrap prerequisiteを準備する

必要なAPIを有効化し、tfstateバケットとCloud Buildログバケットを作成します。
tfstateバケットではObject VersioningとUniform bucket-level accessを有効にします。

次にCloud BuildのGitHub host connectionを作成し、このrepositoryをリンクします。
connection、linked repository、triggerで同じregionを使用します。

### 4. Remote backendを初期化する

各Terraform rootで同じtfstateバケットを使用し、異なるprefixを指定します。

```text
terraform/lab/api
terraform/lab/cloudstorage
terraform/lab/cloudbuild
```

backend初期化後、`terraform state list`で既存stateがないことを確認してからimportへ
進みます。既にstateへ登録されているresourceを再importしません。

### 5. 既存リソースをimportする

次の順序を維持します。

1. `env/lab/api`へ手動有効化済みAPIをimportする
2. `env/lab/cloudstorage`へtfstate／ログバケットをimportする
3. 各rootでrefresh結果を含むplanを確認する
4. `env/lab/cloudbuild`へリンク済みrepositoryをimportする
5. Cloud Build rootのplanを確認してapplyする

import IDとresource addressは、Terraform resource定義が確定した段階でこの文書へ
追記します。推測したIDでは実行しません。

### 6. Cloud Buildを検証する

Terraformで作成したtriggerについて、次を確認します。

- PRで`cloudbuild/plan.yaml`が起動する
- `main`へのpushで`cloudbuild/apply.yaml`が起動する
- buildが指定したTerraformサービスアカウントで実行される
- API、Cloud Storage、Cloud Buildの順序が維持される
- 最終的なplanまたはapplyの結果まで確認できる

HTTP成功やbuild起動だけを完了条件にせず、各Terraform処理の終了結果を確認します。

## 停止条件

次の場合は操作を止め、設定と実行対象を確認します。

- `gcloud`のactive projectが予定した個人プロジェクトと異なる
- GitのHEADが記録したtarget commit SHAと異なる
- GCPまたはGitHubに組織アカウントでログインしている
- import対象が既にTerraform stateへ登録されている
- planに意図しない削除、置換、IAM変更が表示される
- Cloud Buildが想定外のサービスアカウントで実行される

## 実行記録

実行時に、宣言したTerraformと実際のGCP状態を分けて記録します。

| 日時 | 実行場所 | 実行identity | 操作 | 結果・証跡 |
| --- | --- | --- | --- | --- |
| 未実行 | - | - | - | - |
