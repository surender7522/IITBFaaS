#! /bin/bash

echo "WARNING: High chance of failing on IITB network"
sudo docker pull stefanprodan/caddy
sudo docker pull google/cadvisor
sudo docker pull stefanprodan/swarmprom-grafana:5.3.4
sudo docker pull prom/alertmanager:v0.15.3
sudo docker pull cloudflare/unsee:v0.8.0
sudo docker pull stefanprodan/swarmprom-node-exporter:v0.16.0
sudo docker pull prom/prometheus:v2.5.0
sudo docker pull stefanprodan/caddy
sudo docker pull ssl7522/surenderbetatest
echo "Downloading Golang dependencies"
go get github.com/prometheus/client_golang/prometheus
go get github.com/prometheus/client_golang/prometheus/promauto
go get github.com/prometheus/client_golang/prometheus/promhttp
