#!/bin/bash
mkdir -p ~/.local/share/nautilus-python/extensions
mkdir -p ~/.local/share/nautilus/scripts
cp apps/nautilus-extensions/*/*.py ~/.local/share/nautilus-python/extensions/
cp apps/nautilus-extensions/*/*.sh ~/.local/share/nautilus/scripts/
chmod +x ~/.local/share/nautilus/scripts/*.sh
nautilus -q
