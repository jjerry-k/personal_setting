#!/usr/bin/bash

# ==============================================================================
# Check input arguments
# ==============================================================================
if [ "$#" -ne 3 ]; then
    echo "오류: 입력 인자는 3개여야 합니다."
    exit 1
fi

# 마지막 인자가 "W" 또는 "CP"인지 확인
if [ "$3" == "W" ] || [ "$3" == "CP" ]; then
    # update package list
    apt-get update
    # install NFS
    if [ $3 = 'CP' ]; then
    apt-get install nfs-server nfs-common -y
    elif [ $3 = 'W' ]; then
    apt-get install nfs-common -y
    fi
else
    echo "오류: 마지막 인자는 'W' 또는 'CP'여야 합니다."
    exit 1
fi


# ==============================================================================
# Install kubernetes & containerd
# ==============================================================================
# both kubelet and kubectl will install by dependency
# but aim to latest version. so fixed version by manually
apt-get install -y --allow-downgrades kubelet=$1 kubectl=$1 kubeadm=$1 containerd.io=$2

# containerd configure to default and cgroup managed by systemd
containerd config default > /etc/containerd/config.toml
sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml

# avoid WARN&ERRO(default endpoints) when crictl run
cat <<EOF > /etc/crictl.yaml
runtime-endpoint: unix:///run/containerd/containerd.sock
image-endpoint: unix:///run/containerd/containerd.sock
EOF


# ==============================================================================
# ready to install for k8s
# ==============================================================================
systemctl restart containerd ; systemctl enable containerd
systemctl enable --now kubelet
