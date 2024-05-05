#!/bin/bash
echo "Examinando la instalación de software:"
awk -W version 2> /dev/null | head -1
jq --version
xmlstarlet --version
apt list --installed csvkit
screen --version
curl --version | head -1
apt -qq list build-essential
ss -ltn |grep 22
