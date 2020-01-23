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
sudo hostnamectl set-hostname master-node

echo "Master Network..." >> log.txt
sudo kubeadm init --pod-network-cidr=10.244.0.0/16 >> joincmd.txt

echo "Make $HOME/.kube..." >> log.txt
mkdir -p $HOME/.kube
echo "sudo cp ..." >> log.txt
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
echo "sudo chown..." >> log.txt
sudo chown $(id -u):$(id -g) $HOME/.kube/config

echo "Make flannel network..." >> log.txt
sudo kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

echo "-Log End-" >> log.txt
