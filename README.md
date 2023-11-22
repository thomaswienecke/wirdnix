# Wirdnix

Homelab server (v3) built using nixos, docker, etc

## Nixos

The bare metal OS is nixos. Look into the `nixos` folder for the documentation.

## Kubernetes using FluxCD

Kubernetes is used to orchestrate the docker containers

FluxCD is used to sync the kubernetes cluster with the git repository (pull based)

### Setup
* Make sure the MetalLB IPAddressPool (`/apps/metallb/metallb/config/ipaddresspool.yaml`) is not using any IPs in the DHCP range or static IPs
* SSH into machine by running `ssh wirdnix@wirdnix.wienecke`
* Copy `/etc/rancher/k3s/k3s.yaml` to `~/.kube/config`
  * Change owner to current user by running `sudo chown wirdnix ~/.kube/config`
* Test flux connection by running `flux check --pre`
* Create a github token with all `repo` permissions [here](https://github.com/settings/tokens)
* Setup environment variables
```bash
    export GITHUB_USER=thomaswienecke
    export GITHUB_TOKEN=<token>
```
* install flux by executing `flux bootstrap github --owner=$GITHUB_USER --repository=wirdnix --branch=main --path=./kube --personal`

### Verify installation
Flux should now be installed and sync the cluster with the git repository

* Check for changes by running `flux get kustomizations --watch`
* Check for pods by running `kubectl get pods --all-namespaces`
* Forward port of podinfo by running `sudo kubectl port-forward service/podinfo 9898:9898 --address 0.0.0.0`
* You should now be able to connect via `http://wirdnix.wienecke:9898` (if not, check nixos firewall settings)

