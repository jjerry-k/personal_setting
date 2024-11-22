#!/usr/bin/bash

# ==============================================================================
# Check input arguments
# ==============================================================================
if [ "$#" -ne 2 ]; then
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
# Set up worker node
# ==============================================================================
kubeadm join --token 123456.1234567890123456 \
             --discovery-token-unsafe-skip-ca-verification $1:6443 \
             --node-name k8s-worker-$2
