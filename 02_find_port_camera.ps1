# =============================================================
# 02_find_port_camera.ps1
# ポートとカメラの特定、モーターの設定、キャリブレーション
# =============================================================

cd $HOME\lerobot
.\.venv\Scripts\Activate.ps1

# --- 1. ポートの特定 ---
#   実行後、指示に従ってUSBケーブルを1本だけ抜き差しする
#   本環境では リーダー：COM3、フォロワー：COM4 だった
lerobot-find-port

# --- 2. カメラの特定 ---
#   本環境では 手首カメラ：1、俯瞰カメラ：2 だった
lerobot-find-cameras opencv

# --- 3. モーターのID設定（組み立て時に1回だけ） ---
#   モーターを1つずつ接続し、指示に従ってIDを書き込む
lerobot-setup-motors --robot.type=so101_follower --robot.port=COM4
lerobot-setup-motors --teleop.type=so101_leader  --teleop.port=COM3

# --- 4. キャリブレーション ---
#   保存ファイルとモーター内の値が異なる場合は、
#   接続時に「保存済みの値を書き込むか、やり直すか」を聞かれる
lerobot-calibrate --robot.type=so101_follower --robot.port=COM4 --robot.id=follower_arm
lerobot-calibrate --teleop.type=so101_leader  --teleop.port=COM3 --teleop.id=leader_arm
