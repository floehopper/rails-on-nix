#!/usr/bin/env bash

nix --version
if [ $? -eq 0 ]; then
  echo 'nix is already installed (skipping installation)'
else
  set -e
  # https://nixos.org/manual/nix/stable/#sect-multi-user-installation
  sh <(curl -L https://nixos.org/nix/install) --daemon
fi
