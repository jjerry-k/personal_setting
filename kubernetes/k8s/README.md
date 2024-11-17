# Kubernetes install script

## All nodes
```bash
bash k8s_env_build.sh <k8s_version> <master ip> <worker1 ip> <worker2 ip> ... <workerN ip>
# ex) bash k8s_env_build.sh 1.30 192.168.0.100 192.168.0.101 192.168.0.102 192.168.0.103 192.168.0.104
```

## Master node
```bash
bash k8s_pkg_cfg.sh <k8s_version> <containerd_version> 'CP'
# ex) bash k8s_pkg_cfg.sh 1.30.0-1.1 1.6.31-1 'CP'
bash controlplane_node.sh <master ip>
# ex) bash controlplane_node.sh 192.168.0.100
```

## Worker nodes
```bash
bash k8s_pkg_cfg.sh <k8s_version> <containerd_version> 'W'
# ex) bash k8s_pkg_cfg.sh 1.30.0-1.1 1.6.31-1 'W'
bash worker_nodes.sh <master ip> <worker number>
# ex) bash worker_nodes.sh 192.168.0.101 1
```
