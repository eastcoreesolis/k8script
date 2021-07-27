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
sudo hostnamectl set-hostname arm01-node

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

mkdir -p /var/lib/docker/volumes/jobdata/_data/opencv_xmldata/ && wget https://raw.githubusercontent.com/opencv/opencv/master/data/haarcascades/haarcascade_eye.xml && wget https://raw.githubusercontent.com/opencv/opencv/master/data/haarcascades/haarcascade_eye_tree_eyeglasses.xml && wget https://raw.githubusercontent.com/opencv/opencv/master/data/haarcascades/haarcascade_frontalcatface.xml && wget https://raw.githubusercontent.com/opencv/opencv/master/data/haarcascades/haarcascade_frontalcatface_extended.xml && wget https://github.com/opencv/opencv/blob/master/data/haarcascades/haarcascade_frontalface_alt.xml && wget https://github.com/opencv/opencv/blob/master/data/haarcascades/haarcascade_frontalface_alt2.xml && wget https://github.com/opencv/opencv/blob/master/data/haarcascades/haarcascade_frontalface_alt_tree.xml && wget https://raw.githubusercontent.com/opencv/opencv/master/data/haarcascades/haarcascade_frontalface_default.xml && wget https://raw.githubusercontent.com/opencv/opencv/master/data/haarcascades/haarcascade_fullbody.xml && wget https://raw.githubusercontent.com/opencv/opencv/master/data/haarcascades/haarcascade_lefteye_2splits.xml && wget https://raw.githubusercontent.com/opencv/opencv/master/data/haarcascades/haarcascade_licence_plate_rus_16stages.xml && wget https://github.com/opencv/opencv/blob/master/data/haarcascades/haarcascade_lowerbody.xml && wget https://github.com/opencv/opencv/blob/master/data/haarcascades/haarcascade_profileface.xml && wget https://github.com/opencv/opencv/blob/master/data/haarcascades/haarcascade_righteye_2splits.xml && wget https://github.com/opencv/opencv/blob/master/data/haarcascades/haarcascade_russian_plate_number.xml && wget https://github.com/opencv/opencv/blob/master/data/haarcascades/haarcascade_smile.xml && wget https://github.com/opencv/opencv/blob/master/data/haarcascades/haarcascade_upperbody.xml && mv ./*.xml /var/lib/docker/volumes/jobdata/_data/opencv_xmldata/ && mkdir -p /var/lib/docker/volumes/jobdata/_data/vid_source/payload/ && mkdir -p /var/lib/docker/volumes/jobdata/_data/queue/vframedump/payload/ && cp /home/ubuntu/payload.mp4 /var/lib/docker/volumes/jobdata/_data/vid_source/payload/payload.mp4 && touch /var/lib/docker/volumes/jobdata/_data/queue/vframedump/payload.vframedump && echo "payload" > /var/lib/docker/volumes/jobdata/_data/queue/vframedump/payload.vframedump && docker run --mount source=jobdata,target=/jobdata eastcoreesolis/core:tfinterview bash core payload vframedump && docker run --mount source=jobdata,target=/jobdata eastcoreesolis/core:tfinterview bash core payload vfacedetector && touch /home/ubuntu/$(cat /home/ubuntu/corecommands).eJob && echo $(cat /home/ubuntu/corecommands) > /home/ubuntu/$(cat /home/ubuntu/corecommands).eJob >> log.txt
echo "-Log End-" >> log.txt
