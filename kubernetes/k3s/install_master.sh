curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--node-name master" sh -

mkdir ~/.kube
sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
sudo chown -R $(id -u):$(id -g) ~/.kube
echo "export KUBECONFIG=~/.kube/config" >> ~/.bashrc
source ~/.bashrc

NODE_TOKEN=$(sudo cat /var/lib/rancher/k3s/server/node-token)

MASTER_IP=$(kubectl get node master -ojsonpath="{.status.addresses[0].address}")