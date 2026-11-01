# =============================================================
# 01_setup_env.ps1
# 環境構築：LeRobotの取得・コミット固定・依存関係の導入
# 実行場所：PowerShell（管理者権限は不要）
# =============================================================

# --- 1. LeRobotを取得し、使用したコミットに固定する ---
cd $HOME
git clone https://github.com/huggingface/lerobot.git
cd lerobot
git checkout 146d8474932c8b566717eb2738ba459337ab71c4
git log -1 --oneline   # 146d8474 と表示されればOK

# --- 2. Python 3.12 の仮想環境を作る ---
py -3.12 -m venv .venv
.\.venv\Scripts\Activate.ps1
python --version       # Python 3.12.x
python -m pip install --upgrade pip

# --- 3. LeRobotと必要な追加機能を導入する ---
#   feetech  : SO-101のモーター（Feetech）用
#   dataset  : データ収集・読み込み用
#   viz      : 可視化用
#   training : 学習用（accelerate など）
pip install -e ".[feetech,dataset,viz,training]" --no-cache-dir
pip install deepdiff --no-cache-dir
pip install rerun-sdk==0.33.1 --no-cache-dir

# --- 4. PyTorchをGPU（CUDA 12.8）版に入れ替える ---
#   通常の手順ではCPU版が入り、GPUが使えないため入れ替える
#   ダウンロードは約2.8GB。Cドライブの空き容量に注意
pip uninstall -y torch torchvision
pip install torch==2.11.0 torchvision==0.26.0 --index-url https://download.pytorch.org/whl/cu128 --no-cache-dir

# --- 5. 確認 ---
python -c "import torch; print(torch.__version__, torch.cuda.is_available(), torch.cuda.get_device_name(0) if torch.cuda.is_available() else '-')"
# 例：2.11.0+cu128 True NVIDIA GeForce RTX 4060 Laptop GPU
pip check
# No broken requirements found. と表示されればOK
