#!/bin/bash

# Create XDG_RUNTIME_DIR for GUI apps like Rerun
export XDG_RUNTIME_DIR=/tmp/runtime-ubuntu
mkdir -p "$XDG_RUNTIME_DIR"
chmod 700 "$XDG_RUNTIME_DIR"

# USB latency fix for serial devices
for tty in /sys/bus/usb-serial/devices/*/latency_timer; do
    if [ -f "$tty" ]; then
        echo 1 | sudo tee "$tty" > /dev/null 2>&1 || true
    fi
done

# Increase USB buffer sizes for better stability
sudo sh -c 'echo 16777216 > /proc/sys/net/core/rmem_max' 2>/dev/null || true
sudo sh -c 'echo 16777216 > /proc/sys/net/core/wmem_max' 2>/dev/null || true

# V4L2 camera buffer settings (helps with camera timeouts)
for video_dev in /dev/video*; do
    if [ -c "$video_dev" ]; then
        sudo chmod 666 "$video_dev" 2>/dev/null || true
    fi
done

# Link huggingface cache to persistent storage
PERSISTENT_HF_DIR="/home/ubuntu/techin517/huggingface"
HF_CACHE_DIR="/home/ubuntu/.cache/huggingface"

# Create parent directory if it doesn't exist
mkdir -p "$(dirname "$HF_CACHE_DIR")"

# Remove existing cache dir/link if it exists, then create symlink
if [ -L "$HF_CACHE_DIR" ]; then
    # Already a symlink, check if it points to the right place
    if [ "$(readlink "$HF_CACHE_DIR")" != "$PERSISTENT_HF_DIR" ]; then
        rm "$HF_CACHE_DIR"
        ln -s "$PERSISTENT_HF_DIR" "$HF_CACHE_DIR"
    fi
elif [ -d "$HF_CACHE_DIR" ]; then
    # Existing directory - move contents to persistent storage and replace with symlink
    cp -rn "$HF_CACHE_DIR"/* "$PERSISTENT_HF_DIR"/ 2>/dev/null || true
    rm -rf "$HF_CACHE_DIR"
    ln -s "$PERSISTENT_HF_DIR" "$HF_CACHE_DIR"
else
    # Doesn't exist, create symlink
    ln -s "$PERSISTENT_HF_DIR" "$HF_CACHE_DIR"
fi

# create conda env
source /opt/conda/etc/profile.d/conda.sh
conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main
conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r
if ! conda env list | grep -q "^lerobot_ros2"; then
    conda create -y -n lerobot_ros2 python=3.10
fi
conda activate lerobot_ros2

# build lerobot
cd /home/ubuntu/techin517/third_party/lerobot
conda install -y ffmpeg=7.1.1 -c conda-forge
pip install --break-system-packages catkin_pkg typeguard
pip install --break-system-packages 'lerobot[all]'
# support 50-series nvidia GPUs
pip uninstall torch torchvision torchaudio -y
pip install torch==2.7.1 torchvision==0.22.1 torchaudio==2.7.1 --index-url https://download.pytorch.org/whl/cu128

# build ros
cd /home/ubuntu/techin517/so101_ws/src/so101_ros2/
bash build.sh
source /home/ubuntu/.bashrc
