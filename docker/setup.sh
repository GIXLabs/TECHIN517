source /home/ubuntu/.bashrc
cd /home/ubuntu/techin517/third_party/lerobot
pip install --break-system-packages 'lerobot[all]'
cd /home/ubuntu/techin517/so101_ws/src/so101_ros2/
bash build.sh
source /home/ubuntu/.bashrc
