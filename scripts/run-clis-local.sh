#!/bin/bash

(
	trap 'kill 0' SIGINT
	rojo serve default.project.json &
	wait
)
