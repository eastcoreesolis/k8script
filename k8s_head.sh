echo "-Log Start-..." > log.txt
echo "apt-get update..." >> log.txt
sudo apt-get update -y
echo "//" >> log.txt

echo "Getting Docker..." >> log.txt
sudo apt-get install docker.io -y
sudo systemctl enable docker
sudo systemctl start docker

echo "Adding Repositories..." >> log.txt
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add
sudo apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"
sudo apt-get install kubeadm kubelet kubectl -y --allow-change-held-packages
sudo apt-mark hold kubeadm kubelet kubectl

echo "Disable Swap..." >> log.txt
sudo swapoff a

echo "Set Hostname..." >> log.txt
sudo hostnamectl set-hostname head

echo "Init Head Network..." >> log.txt
sudo kubeadm init --pod-network-cidr=10.244.0.0/16
sudo kubeadm token create --print-join-command > joincmd.txt

echo "Make $HOME/.kube..." >> log.txt
mkdir -p $HOME/.kube
echo "sudo cp ..." >> log.txt
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
echo "sudo chown..." >> log.txt
sudo chown $(id -u):$(id -g) $HOME/.kube/config

echo "Make flannel network..." >> log.txt
sudo kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

echo "//" >> log.txt
echo "Preparing to send files to Arms..." >> log.txt
echo "//" >> log.txt
cd /home/ubuntu/
mv 'C:\Users\Ginaz\key1.pem' key1.pem
cd /
scp -q -o StrictHostKeyChecking=no -i /home/ubuntu/key1.pem ./joincmd.txt ubuntu@$(cat /home/ubuntu/arm01_ip.txt)":"
scp -q -o StrictHostKeyChecking=no -i /home/ubuntu/key1.pem /home/ubuntu/payload.mp4 ubuntu@$(cat /home/ubuntu/arm01_ip.txt)":"
scp -q -o StrictHostKeyChecking=no -i /home/ubuntu/key1.pem /home/ubuntu/corecommands ubuntu@$(cat /home/ubuntu/arm01_ip.txt)":"

scp -q -o StrictHostKeyChecking=no -i /home/ubuntu/key1.pem ./joincmd.txt ubuntu@$(cat /home/ubuntu/arm02_ip.txt)":"
scp -q -o StrictHostKeyChecking=no -i /home/ubuntu/key1.pem /home/ubuntu/payload.mp4 ubuntu@$(cat /home/ubuntu/arm02_ip.txt)":"
scp -q -o StrictHostKeyChecking=no -i /home/ubuntu/key1.pem /home/ubuntu/corecommands ubuntu@$(cat /home/ubuntu/arm02_ip.txt)":"

echo "File sent..." >> log.txt

echo "Getting App..." >> log.txt
git clone "https://github.com/eastcoreesolis/k8script.git"
echo "//" >> log.txt

echo "Creating App..." >> log.txt
kubectl create -f ./k8script/namespace.yml >> log.txt
kubectl --namespace=timeserv create -f ./k8script/service.yml >> log.txt
kubectl --namespace=timeserv create -f ./k8script/deployment.yml >>log.txt

echo "Creating tfinterview App..." >> log.txt
kubectl create -f ./k8script/tfnamespace.yml >> log.txt
kubectl --namespace=tfinterview create -f ./k8script/tfservice.yml >> log.txt
kubectl --namespace=tfinterview create -f ./k8script/tfdeployment.yml >>log.txt

echo "//" >> log.txt
echo "Sleeping 4m..." >> log.txt
sleep 4m
echo "Checking pod status..." >> log.txt
echo "//" >> log.txt
kubectl --namespace=timeserv get pods >> log.txt
kubectl --namespace=tfinterview get pods >> log.txt

echo "//" >> log.txt
echo "-Log End-" >> log.txt
