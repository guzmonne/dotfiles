#!/usr/bin/env bash

# This file scours through my most important working folders and pipes
# them through `fzf`. The returning value can be used as input for other
# scripts. For example, to generate new tmux windows or sessions.
{
  find ~ -mindepth 1 -maxdepth 1 -type d & \
  find ~/Projects/Coral/monorepo/branches -mindepth 1 -maxdepth 1 -type d & \
  find ~/Projects/Books -mindepth 1 -maxdepth 1 -type d & \
  find ~/Projects/Coral/slides/branches -mindepth 1 -maxdepth 1 -type d & \
  find ~/Projects/Coral/dwolla-sandbox/branches -mindepth 1 -maxdepth 1 -type d & \
  find ~/Projects/Vntana/vntana-configs/branches -mindepth 1 -maxdepth 1 -type d & \
  find ~/Projects/Vntana/model-ops-configs/branches -mindepth 1 -maxdepth 1 -type d & \
  find ~/Projects/Vntana/model-ops-request-handler/branches -mindepth 1 -maxdepth 1 -type d & \
  find ~/Projects/Vntana/model-ops-request-listener/branches -mindepth 1 -maxdepth 1 -type d & \
  find ~/Projects/Vntana/model-ops-server/branches -mindepth 1 -maxdepth 1 -type d & \
  find ~/Projects/Vntana/model-ops-common/branches -mindepth 1 -maxdepth 1 -type d & \
  find ~/Projects/Vntana/model-ops-thumbnail-generator/branches -mindepth 1 -maxdepth 1 -type d & \
  find ~/Projects/Vntana/model_thumbnail_recorder/branches -mindepth 1 -maxdepth 1 -type d & \
  find ~/Projects/Vntana/model-ops-jenkins-library/branches -mindepth 1 -maxdepth 1 -type d & \
  find ~/Projects/Vntana/vntana-model-viewer-wrapper/branches -mindepth 1 -maxdepth 1 -type d & \
  find ~/Projects -mindepth 1 -maxdepth 2 -type d; \
} | sort -u | fzf
