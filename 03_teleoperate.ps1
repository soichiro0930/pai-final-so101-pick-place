# =============================================================
# 03_teleoperate.ps1
# テレオペ：リーダーアームでフォロワーアームを動かして動作確認
# カメラ映像と関節角度は rerun で表示される
# =============================================================

cd $HOME\lerobot
.\.venv\Scripts\Activate.ps1

$CAMERAS = "{ wrist: {type: opencv, index_or_path: 1, width: 320, height: 240, fps: 15, fourcc: 'MJPG'}, front: {type: opencv, index_or_path: 2, width: 320, height: 240, fps: 15, fourcc: 'MJPG'} }"

lerobot-teleoperate `
  --robot.type=so101_follower --robot.port=COM4 --robot.id=follower_arm `
  --teleop.type=so101_leader  --teleop.port=COM3 --teleop.id=leader_arm `
  --robot.cameras="$CAMERAS" `
  --display_data=true
