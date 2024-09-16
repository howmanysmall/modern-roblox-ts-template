#!/bin/zsh

# this exists cause my laptop DOES NOT like Roblox Studio (arm64)
# you likely will never need this.

(trap 'kill 0' SIGINT; rojo serve default.project.json & ssh -p 443 -R0:localhost:34872 a.pinggy.io & wait)
