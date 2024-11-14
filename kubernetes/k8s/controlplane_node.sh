#!/usr/bin/bash

# ==============================================================================
# Check input arguments
# ==============================================================================
if [ "$#" -ne 1 ]; then
    echo "오류: 인자가 없습니다."
    exit 1
fi

ip_regex="^([0-9]{1,3}\.){3}[0-9]{1,3}$"
if [[ $1 =~ $ip_regex ]]; then
    # IP 주소 형식인 경우 추가 확인
    IFS='.' read -r -a octets <<< "$1"
    valid_ip=true

    # 각 octets 범위 0-255 확인
    for octet in "${octets[@]}"; do
        if ((octet < 0 || octet > 255)); then
            valid_ip=false
            break
        fi
    done

    # 네트워크 주소 확인 (마지막 옥텟이 0이면 잘못된 주소 )
    if $valid_ip && [ "${octets[3]}" -ne 0 ]; then
        echo
    else
        echo "오류: $1 는 네트워크 주소이거나 잘못된 IP 주소입니다."
        exit 1
    fi
else
    echo "오류: $1 는 IP 주소 형식이 아닙니다."
    exit 1
fi

# ==============================================================================
# Init kubernetes (w/ containerd)
# ==============================================================================
kubeadm init --token 123456.1234567890123456 --token-ttl 0 \
             --pod-network-cidr=172.16.0.0/16 --apiserver-advertise-address=$1\
             --cri-socket=unix:///run/containerd/containerd.sock \
             --node-name=master

# config for control plane node only
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config

# CNI raw address & config for kubernetes's network
CNI_ADDR="https://raw.githubusercontent.com/sysnet4admin/IaC/main/k8s/CNI"
kubectl apply -f $CNI_ADDR/172.16_net_calico_v3.26.0.yaml

# kubectl completion on bash-completion dir
kubectl completion bash >/etc/bash_completion.d/kubectl

# alias kubectl to k
echo 'alias k=kubectl' >> ~/.bashrc
echo "alias ka='kubectl apply -f'" >> ~/.bashrc
echo 'complete -F __start_kubectl k' >> ~/.bashrc

# extended k8s certifications all
git clone https://github.com/yuyicai/update-kube-cert.git /tmp/update-kube-cert
chmod 755 /tmp/update-kube-cert/update-kubeadm-cert.sh
/tmp/update-kube-cert/update-kubeadm-cert.sh all --cri containerd
rm -rf /tmp/update-kube-cert
echo "Wait 30 seconds for restarting the Control-Plane Node..." ; sleep 30
