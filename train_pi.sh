#!/bin/bash
# π₀ 微调训练脚本
# 数据集: Hayden09/record-test

# lerobot-train \
#   --policy.path=lerobot/smolvla_base \
#   --dataset.repo_id=Hayden09/record-test \
#   --rename_map='{"observation.images.front":"observation.images.camera1","observation.images.side":"observation.images.camera2","observation.images.top":"observation.images.camera3"}' \
#   --batch_size=16 \
#   --steps=10000 \
#   --output_dir=outputs/train/my_smolvla_10000 \
#   --job_name=my_smolvla_training \
#   --policy.device=cuda \
#   --policy.push_to_hub=true \
#   --policy.repo_id=Hayden09/my_smolvla_finetuned_10000 \
#   --wandb.enable=true

# python src/lerobot/scripts/lerobot_train.py \
#     --dataset.repo_id=Hayden09/record-test \
#     --policy.type=pi0 \
#     --output_dir=./outputs/pi0_training \
#     --job_name=pi0_training \
#     --policy.pretrained_path=lerobot/pi0_base \
#     --policy.repo_id=Hayden09/pi0_finetuned \
#     --policy.compile_model=true \
#     --policy.gradient_checkpointing=true \
#     --policy.dtype=bfloat16 \
#     --policy.freeze_vision_encoder=false \
#     --policy.train_expert_only=false \
#     --steps=1000 \
#     --policy.device=cuda \
#     --batch_size=32


lerobot-train \
  --dataset.repo_id=Hayden09/Pick_Red_Cap_Bottle \
  --policy.type=pi0 \
  --policy.repo_id=Hayden09/pi0_Pick_Red_Cap_Bottle_B \
  --output_dir=outputs/pi0_training/Pick_Red_Cap_Bottle_B \
  --job_name=pi0_pick_red_cap_bottle_B \
  --policy.pretrained_path=lerobot/pi0_base \
  --policy.compile_model=true \
  --policy.gradient_checkpointing=true \
  --policy.dtype=bfloat16 \
  --policy.freeze_vision_encoder=false \
  --policy.train_expert_only=false \
  --policy.optimizer_lr=1e-4 \
  --steps=10000 \
  --policy.device=cuda \
  --num_workers=8 \
  --policy.push_to_hub=true \
  --wandb.enable=true \
  --batch_size=32 \
  --early_stopping=true \
  --early_stopping_patience=10 \
  --early_stopping_min_delta=1e-4


# lerobot-edit-dataset --repo_id Hayden09/Pick_Bottle --operation.type split \
#   --operation.splits "$(python3 -c "import json; print(json.dumps({'20ep': list(range(20))}))")"

#   lerobot-edit-dataset --repo_id Hayden09/Pick_Bottle --operation.type split \
#   --operation.splits "$(python3 -c "import json; print(json.dumps({'50ep': list(range(50))}))")" \
#   --push_to_hub true

#   lerobot-edit-dataset --repo_id Hayden09/Pick_Bottle --operation.type split \
#   --operation.splits "$(python3 -c "import json; print(json.dumps({'100ep': list(range(100))}))")" \
#   --push_to_hub true

## merge all datasets into one
# lerobot-edit-dataset \
#   --repo_id Hayden09/Pick_Bottle \
#   --operation.type merge \
#   --operation.repo_ids "['Hayden09/Pick_Red_Cap_Bottle', 'Hayden09/Pick_Green_Cap_Bottle']" \
#   --push_to_hub true
