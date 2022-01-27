#! /bin/bash

# base centos7
docker build -t currycan/centos:7 -f base.Dockerfile .
docker push currycan/centos:7

# docker build -t currycan/open-jdk:8u201 . -f openjdk.Dockerfile

# docker build -t currycan/java:8u201 .
docker build -t currycan/oracle-jdk:8u201 .
docker push currycan/oracle-jdk:8u201
