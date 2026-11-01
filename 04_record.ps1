# =============================================================
# 04_record.ps1
# データ収集：テレオペでお手本の動作を記録する
#   30fps、1エピソード30秒、リセット10秒
#   --resume=true で既存のデータセットに追記（1回の実行で3本ずつ）
#   合計：実験1・2は10本、実験3は50本
#
# ※ データセット名とタスク文（my_button_task / "Push the button"）は、
#    当初ボタン押しを予定していた名残。中身はすべてピック＆プレース。
# =============================================================

cd $HOME\lerobot
.\.venv\Scripts\Activate.ps1

$DATASET_REPO_ID = "my_local_user/my_button_task"
$DATASET_ROOT    = "$HOME\.cache\huggingface\lerobot\my_local_user\my_button_task_20261025_104656"
$CAMERAS = "{ wrist: {type: opencv, index_or_path: 1, width: 320, height: 240, fps: 15, fourcc: 'MJPG'}, front: {type: opencv, index_or_path: 2, width: 320, height: 240, fps: 15, fourcc: 'MJPG'} }"

lerobot-record `
  --robot.type=so101_follower --robot.port=COM4 --robot.id=follower_arm `
  --teleop.type=so101_leader  --teleop.port=COM3 --teleop.id=leader_arm `
  --robot.cameras="$CAMERAS" `
  --display_data=true `
  --resume=true `
  --dataset.repo_id=$DATASET_REPO_ID `
  --dataset.root="$DATASET_ROOT" `
  --dataset.single_task="Push the button" `
  --dataset.num_episodes=3 `
  --dataset.episode_time_s=30 `
  --dataset.reset_time_s=10 `
  --dataset.push_to_hub=false

# 記録したエピソードの確認（例：0番目）
# lerobot-dataset-viz --repo-id $DATASET_REPO_ID --root "$DATASET_ROOT" --episode-index 0
