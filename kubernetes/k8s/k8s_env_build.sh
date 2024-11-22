#!/usr/bin/bash



# ==============================================================================
# Check input arguments
# ==============================================================================
if [ "$#" -ge 3 ]; then

    # 두 번째 인자부터 반복하여 IP 형식인지 확인
    ip_regex="^([0-9]{1,3}\.){3}[0-9]{1,3}$"
    for arg in "${@:2}"; do
        if [[ $arg =~ $ip_regex ]]; then
            # IP 주소 형식인 경우 추가 확인
            IFS='.' read -r -a octets <<< "$arg"
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
                echo "$arg"
            else
                echo "오류: $arg 는 네트워크 주소이거나 잘못된 IP 주소입니다."
                exit 1
            fi
        else
            echo "오류: $arg 는 IP 주소 형식이 아닙니다."
            exit 1
        fi
    done
else
    echo "입력된 인자는 최소 3개이어야 합니다."
    exit 1
fi



# ==============================================================================
# Set up swap memory
# ==============================================================================
# swapoff -a to disable swapping
swapoff -a
# sed to comment the swap partition in /etc/fstab (Rmv blank)
sed -i.bak -r 's/(.+swap.+)/#\1/' /etc/fstab

# ==============================================================================
# ==============================================================================
# ==============================================================================
# add kubernetes repo
curl -fsSL https://pkgs.k8s.io/core:/stable:/v$1/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v$1/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list

# ==============================================================================
# ==============================================================================
# ==============================================================================
# add docker-ce repo with containerd
curl -fsSL \
  https://download.docker.com/linux/ubuntu/gpg \
  -o /etc/apt/keyrings/docker.asc
echo \
  "deb [arch=$(dpkg --print-architecture) \
  signed-by=/etc/apt/keyrings/docker.asc] \
  https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
  | tee /etc/apt/sources.list.d/docker.list > /dev/null

# ==============================================================================
# ==============================================================================
# ==============================================================================
# packets traversing the bridge are processed by iptables for filtering
echo 1 > /proc/sys/net/ipv4/ip_forward
# enable br_filter for iptables
modprobe br_netfilter

# ==============================================================================
# ==============================================================================
# ==============================================================================
# local small dns
echo "127.0.0.1 localhost" >> /etc/hosts # localhost name will use by calico-node
echo "$2 k8s-cp" >> /etc/hosts
index=1
for arg in "${@:3}"
do
  echo "$arg k8s-worker-$index" >> /etc/hosts
  index=$((index + 1))
done
