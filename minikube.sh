#!/bin/bash
echo "-Log Start-..." > log.txt
echo "apt-get update..." >> log.txt
sudo apt-get update -y
echo "//" >> log.txt
echo "Getting K8s..." >> log.txt
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
kubectl version >> log.txt
echo "//" >> log.txt
echo "Getting docker..." >> log.txt
sudo apt-get update && sudo apt-get install docker.io -y
docker version >> log.txt
echo "//" >> log.txt
echo "Getting minikube..." >> log.txt
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && chmod +x minikube && sudo mv minikube /usr/local/bin/
minikube version >> log.txt
echo "//" >> log.txt
echo "Starting minikube..." >> log.txt
minikube start --vm-driver=none
minikube status >> log.txt
echo "//" >> log.txt
echo "Getting App..." >> log.txt
git clone "https://github.com/eastcoreesolis/k8script.git"
echo "//" >> log.txt
echo "Creating App..." >> log.txt
kubectl create -f ./k8script/namespace.yml >> log.txt
kubectl --namespace=timeserv create -f ./k8script/service.yml >> log.txt
kubectl --namespace=timeserv create -f ./k8script/deployment.yml >>log.txt
echo "//" >> log.txt
echo "Sleeping 45s..." >> log.txt
sleep 45s
echo "Checking pod status..." >> log.txt
echo "//" >> log.txt
kubectl --namespace=timeserv get pods >> log.txt
echo "-Log End-" >> log.txt
