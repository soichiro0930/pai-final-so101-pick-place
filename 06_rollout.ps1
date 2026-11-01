# =============================================================
# 06_rollout.ps1
# 自律動作の評価：学習済みモデルで実機を動かす
#   各チェックポイントで、記録時と同じ初期姿勢・物体の位置から5回ずつ試行
#   max_relative_target=10 で1回の指令で動ける量を制限（安全対策）
# =============================================================

cd $HOME\lerobot
.\.venv\Scripts\Activate.ps1

$CAMERAS = "{ wrist: {type: opencv, index_or_path: 1, width: 320, height: 240, fps: 15, fourcc: 'MJPG'}, front: {type: opencv, index_or_path: 2, width: 320, height: 240, fps: 15, fourcc: 'MJPG'} }"

# 評価するモデル（例：実験3の30,000ステップ）
#   実験2：act_button_10ep_50000       の 010000〜050000
#   実験3：act_pick_place_50ep_100000  の 010000〜100000
$POLICY_PATH = "$HOME\outputs\train\act_pick_place_50ep_100000\checkpoints\030000\pretrained_model"

lerobot-rollout `
  --strategy.type=base `
  --robot.type=so101_follower --robot.port=COM4 --robot.id=follower_arm `
  --robot.cameras="$CAMERAS" `
  --robot.max_relative_target=10 `
  --policy.path="$POLICY_PATH" `
  --task="Push the button" `
  --duration=30
