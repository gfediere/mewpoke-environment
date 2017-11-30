#!/bin/bash
apt-get update
apt-get install -y netcat
./run.sh &
echo "Waiting grafana to launch on 3000..."

./run.sh &
while ! nc -z localhost 3000 ; do 
 sleep 1
done

curl -u admin:password -H 'Content-Type: application/json'  -X POST http://localhost:3000/api/datasources --data-binary @/etc/grafana/data-source-prometheus.json
curl -u admin:password -H 'Content-Type: application/json'  -X POST http://localhost:3000/api/dashboards/db --data-binary @/etc/grafana/mewpoke-dashboard.json

pkill -u grafana
./run.sh
