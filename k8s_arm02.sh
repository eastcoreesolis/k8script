echo "-Log Start-..." > log.txt
echo "apt-get update..." >> log.txt
sudo apt-get update -y
echo "//" >> log.txt

echo "Getting Docker..." >> log.txt
sudo apt-get install docker.io -y
sudo systemctl enable docker
sudo systemctl start docker

docker volume create jobdata

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
    echo "Sleeping 3m" >> log.txt
    sleep 3m
    command $(cat /home/ubuntu/joincmd.txt) >> log.txt
fi

echo "Running TF Interview Payload..." >> log.txt
cp /home/ubuntu/payload.mp4 /var/lib/docker/volumes/jobdata/_data/vid_source/payload/payload.mp4 && mkdir -p /var/lib/docker/volumes/jobdata/_data/queue/vframedump/payload/ && touch /var/lib/docker/volumes/jobdata/_data/queue/vframedump/payload.vframedump && echo "payload" > /var/lib/docker/volumes/jobdata/_data/queue/vframedump/payload.vframedump && docker run --mount source=jobdata,target=/jobdata eastcoreesolis/core:tfinterview bash core payload vframedump && docker run --mount source=jobdata,target=/jobdata eastcoreesolis/core:tfinterview bash core payload vfacedetector && touch /home/ubuntu/$(cat /home/ubuntu/corecommands).eJob && echo $(cat /home/ubuntu/corecommands) > /home/ubuntu/$(cat /home/ubuntu/corecommands).eJob >> log.txt

echo "-Log End-" >> log.txt
