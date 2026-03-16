# Deployment

## Files

- `bootstrap_server.sh`: Run on the target server to install Miniforge, create a Python 3.10 env, install ffmpeg, and install this project.
- `push_and_bootstrap.sh`: Run on the current server to `rsync` the whole `/mnt/hao_new` folder to another server and then trigger the bootstrap script remotely.

## Quick Start

From the current server:

```bash
cd /mnt/hao_new/lerobot
chmod +x deploy/*.sh
./deploy/push_and_bootstrap.sh user@your-server /data/hao_new
```

That will sync `/mnt/hao_new` to `/data/hao_new` on the remote machine and then run:

```bash
bash /data/hao_new/lerobot/deploy/bootstrap_server.sh /data/hao_new/lerobot
```

## Optional extras

Install extra LeRobot features on the remote server:

```bash
ssh user@your-server 'LEROBOT_EXTRAS=feetech,intelrealsense bash /data/hao_new/lerobot/deploy/bootstrap_server.sh /data/hao_new/lerobot'
```

Use `INSTALL_LOCKED=1` if you want the pinned Ubuntu dependency set from `requirements-ubuntu.txt`:

```bash
ssh user@your-server 'INSTALL_LOCKED=1 bash /data/hao_new/lerobot/deploy/bootstrap_server.sh /data/hao_new/lerobot'
```
