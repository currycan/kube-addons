#!/usr/bin/env bash

docker build -t currycan/stress-app:0.0.4 .

docker push currycan/demo/stress-app:0.0.4
