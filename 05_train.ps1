# =============================================================
# 05_train.ps1
# 学習：ACTをGPUで学習する（実験1〜3）
#   学習前に：ACアダプター接続、スリープ無効、GPUを使う他アプリを終了
#   学習中は PowerShell を閉じない
# =============================================================

cd $HOME\lerobot
.\.venv\Scripts\Activate.ps1

$DATASET_REPO_ID = "my_local_user/my_button_task"
$DATASET_ROOT    = "$HOME\.cache\huggingface\lerobot\my_local_user\my_button_task_20261025_104656"

# ---------------------------------------------
# 実験1：10本・200ステップ（動作確認用の予備実験）
#   学習時間 約40秒、最終 l1_loss 0.416
# ---------------------------------------------
lerobot-train `
  --dataset.repo_id=$DATASET_REPO_ID `
  --dataset.root="$DATASET_ROOT" `
  --policy.type=act `
  --policy.device=cuda `
  --policy.push_to_hub=false `
  --output_dir="$HOME\outputs\train\act_button_test" `
  --job_name=act_button_test `
  --batch_size=8 `
  --steps=200 `
  --log_freq=10 `
  --save_freq=200 `
  --wandb.enable=false

# ---------------------------------------------
# 実験2：10本・50,000ステップ（約45エポック）
#   学習時間 約1時間56分
# ---------------------------------------------
lerobot-train `
  --dataset.repo_id=$DATASET_REPO_ID `
  --dataset.root="$DATASET_ROOT" `
  --policy.type=act `
  --policy.device=cuda `
  --policy.push_to_hub=false `
  --output_dir="$HOME\outputs\train\act_button_10ep_50000" `
  --job_name=act_button_10ep_50000 `
  --batch_size=8 `
  --steps=50000 `
  --log_freq=100 `
  --save_freq=10000 `
  --wandb.enable=false

# ---------------------------------------------
# 実験3：50本・100,000ステップ（約17.8エポック）
#   データを50本に追加収集してから実行
#   学習時間 4時間27分50秒、最終 l1_loss 0.049
# ---------------------------------------------
lerobot-train `
  --dataset.repo_id=$DATASET_REPO_ID `
  --dataset.root="$DATASET_ROOT" `
  --policy.type=act `
  --policy.device=cuda `
  --policy.push_to_hub=false `
  --output_dir="$HOME\outputs\train\act_pick_place_50ep_100000" `
  --job_name=act_pick_place_50ep_100000 `
  --batch_size=8 `
  --steps=100000 `
  --log_freq=100 `
  --save_freq=10000 `
  --wandb.enable=false

# チェックポイントの保存時刻の確認（学習時間の算出に使用）
# Get-ChildItem "$HOME\outputs\train\act_button_10ep_50000\checkpoints" | Select-Object Name, LastWriteTime
