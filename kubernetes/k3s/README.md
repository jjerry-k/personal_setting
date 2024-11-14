# K3S install script

## Master node
```bash
bash install_master.sh
# Check NODE_TOKEN and MASTER_IP
```

## Worker nodes
```bash
bash worker_nodes.sh <NODE_TOKEN> <MASTER_IP>
# ex) bash worker_nodes.sh 123456.1234567890123456 192.168.0.100
```
