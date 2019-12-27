#!/bin/bash
echo "sleeping..." > sleeping.txt
sleep 1m
echo "end sleep." > end_sleep.txt
sudo apt-get update -y
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
sudo apt-get update && sudo apt-get install docker.io -y
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && chmod +x minikube && sudo mv minikube /usr/local/bin/
minikube version > ver.txt
sudo minikube start --vm-driver=none
minikube status > ver2.txt
sleep 1m
git clone "https://github.com/eastcoreesolis/k8script.git"
kubectl create -f ./k8script/namespace.yml
kubectl --namespace=timeserv create -f ./k8script/service.yml
kubectl --namespace=timeserv create -f ./k8script/deployment.yml
sleep 1m
kubectl --namespace=timeserv get pods > podlog.txt
