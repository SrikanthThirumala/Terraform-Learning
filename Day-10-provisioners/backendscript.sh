#!/bin/bash
sudo dnf install -y nginx
sudo systemctl enable nginx
sudo systemctl start nginx
a