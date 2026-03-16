#!/bin/bash
# SmolVLA 微调训练脚本
# 数据集: Hayden09/record-test

lerobot-train \
  --policy.path=lerobot/smolvla_base \
  --dataset.repo_id=Hayden09/record-test \
  --rename_map='{"observation.images.front":"observation.images.camera1","observation.images.side":"observation.images.camera2","observation.images.top":"observation.images.camera3"}' \
  --batch_size=16 \
  --steps=10000 \
  --output_dir=outputs/train/my_smolvla_10000 \
  --job_name=my_smolvla_training \
  --policy.device=cuda \
  --policy.push_to_hub=true \
  --policy.repo_id=Hayden09/my_smolvla_finetuned_10000 \
  --wandb.enable=true
