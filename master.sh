#!/bin/bash
sudo apt update -y
sudo apt install  -y default-jre
sudo apt-get install -y docker.io
sudo systemctl start docker
sudo systemctl enable docker
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add
sudo apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"
sudo apt update -y
sudo apt-get install kubeadm kubelet kubectl -y
sudo swapoff -a
cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2",
  "storage-opts": [
    "overlay2.override_kernel_check=true"
  ]
}
EOF
mkdir -p /etc/systemd/system/docker.service.d

systemctl daemon-reload
systemctl restart docker
sudo kubeadm init --pod-network-cidr=192.168.1.90/16 --ignore-preflight-errors=NumCPU,Mem
