#!/usr/bin/env bash

docker build -t currycan/stress-app:0.0.5-apline .
docker build -t currycan/stress-app:0.0.5 .

docker push currycan/stress-app:0.0.5
docker push currycan/stress-app:0.0.5-apline
