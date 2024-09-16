#!/bin/zsh

# this exists cause my laptop DOES NOT like Roblox Studio (arm64)
# you likely will never need this.

(trap 'kill 0' SIGINT; rojo serve default.project.json & ssh -R 80:localhost:34872 serveo.net & wait)
