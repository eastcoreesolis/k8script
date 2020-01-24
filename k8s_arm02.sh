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
sudo hostnamectl set-hostname arm02-node

echo "Check for join command..." >> log.txt
join=/home/ubuntu/joincmd.txt
if [ -f "$join" ]; then
    echo "$join exist" >> log.txt
    command $(cat /home/ubuntu/joincmd.txt)
else 
    echo "$join does not exist" >> log.txt
    echo "Sleeping 30s" >> log.txt
    sleep 2m
    command $(cat /home/ubuntu/joincmd.txt) >> log.txt
fi

echo "-Log End-" >> log.txt
