CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main main.go
g++ -Wall -o b a.cpp -static
docker build -t example-scratchcp -f Dockerfile.scratch .

docker service create   --name my-web   --publish published=8190,target=8090   --replicas 2   example-scratch

repos registry docker hub
go get github.com/prometheus/client_golang/prometheus
go get github.com/prometheus/client_golang/prometheus/promauto
go get github.com/prometheus/client_golang/prometheus/promhttp
export GOPATH=$GOROOT/bin


ADMIN_USER=admin ADMIN_PASSWORD=admin SLACK_URL=https://hooks.slack.com/services/TOKEN SLACK_CHANNEL=devops-alerts SLACK_USER=alertmanager docker stack deploy -c docker-compose.yml mon

echo "WARNING: High chance of failing on IITB network"
sudo docker pull stefanprodan/caddy
sudo docker pull google/cadvisor
sudo docker pull stefanprodan/swarmprom-grafana:5.3.4
sudo docker pull prom/alertmanager:v0.15.3
sudo docker pull cloudflare/unsee:v0.8.0
sudo docker pull stefanprodan/swarmprom-node-exporter:v0.16.0
sudo docker pull prom/prometheus:v2.5.0
sudo docker pull stefanprodan/caddy
sudo docker pull ssl7522/metricsp
sudo apt-get update && sudo apt-get install -qy docker.io
sudo sysctl fs.inotify.max_user_watches=1048576
sudo ufw allow 2377/tcp
sudo ufw allow 7946/tcp
sudo ufw allow 7946/udp
sudo ufw allow 4789/udp
sudo ufw allow 9323/tcp
sudo echo -e "{\n  "metrics-addr" : "0.0.0.0:9323",\n  "experimental" : true\n}">>/etc/docker/daemon.json
sudo systemctl restart docker


avg(rate(api_requests_total{code="200"}[20s])) by (job)
avg(rate(request_duration_seconds_sum[20s])/rate(request_duration_seconds_count[20s])) by (job)



{
   "receiver":"prometheus-rubberband",
   "status":"resolved",
   "alerts":[
      {
         "status":"resolved",
         "labels":{
            "alertname":"task_high_request_rate",
            "job":"webapp",
            "monitor":"promswarm"
         },
         "annotations":{
            "description":" on '' memory usage is 1.392k.",
            "summary":"Memory alert for Swarm task '' on ''"
         },
         "startsAt":"2019-04-20T13:37:28.069511962Z",
         "endsAt":"2019-04-20T13:42:03.069511962Z",
         "generatorURL":"http://a649de0e017c:9090/graph?g0.expr=avg+by%28job%29+%28rate%28api_requests_total%7Bcode%3D%22200%22%7D%5B20s%5D%29%29+%3E+150\u0026g0.tab=1"
      }
   ],
   "groupLabels":{
      "alertname":"task_high_request_rate",
      "job":"webapp"
   },
   "commonLabels":{
      "alertname":"task_high_request_rate",
      "job":"webapp",
      "monitor":"promswarm"
   },
   "commonAnnotations":{
      "description":" on '' memory usage is 1.392k.",
      "summary":"Memory alert for Swarm task '' on ''"
   },
   "externalURL":"http://db6f31d27ce3:9093",
   "version":"4",
   "groupKey":"{}:{alertname=\"task_high_request_rate\", job=\"webapp\"}"
}

input.alerts[0].status
input.alerts[0].labels.job
watch docker service ls -f "NAME=mon_webapp" --format "{{.Replicas}}"
