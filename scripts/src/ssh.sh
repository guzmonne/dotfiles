#!/usr/bin/env bash
# @name ssh.sh
# @version 0.1.0
# @description Utility functions to work with SSH
# @author Guzman Monne
# @license MIT
# @default nvim

# @cmd Copy the local "nvim" configuration to a remote server using scp.
# @option -k --key The SSH key to use to connect to the server.
# @option -u --user=ec2-user The user to use to connect to the server.
# @arg ip The IP address of the remote server.
nvim() {
  if [[ -n "$rargs_key" ]]; then
    key="-i $rargs_key"
  else
    key=""
  fi
  scp  -r  $key  ~/.config/nvim/*.vim  ${rargs_user}@${rargs_ip}:/home/ec2-user/.config/nvim
  scp  -r  $key  ~/.config/nvim/*.lua  ${rargs_user}@${rargs_ip}:/home/ec2-user/.config/nvim
  scp  -r  $key  ~/.config/nvim/lua/   ${rargs_user}@${rargs_ip}:/home/ec2-user/.config/nvim/lua
}

