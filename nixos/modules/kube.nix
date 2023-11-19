{ pkgs, ... }: {
    networking.firewall.allowedTCPPorts = [
        80 # traefik
        443 # traefik
        6443 # k3s: required so that pods can reach the API server (running on port 6443 by default)
        9000 # k3s traefik dashboard
        9898 # test podinfo deployment should be reachable
    ];
    services.k3s.enable = true;
    services.k3s.role = "server";
    services.k3s.extraFlags = toString [
        # "--kubelet-arg=v=4" # Optionally add additional args to k3s
        "--disable=traefik"
        "--disable=metrics-server"
        "--disable=servicelb"
    ];
    environment.systemPackages = with pkgs; [ 
        k3s
        fluxcd
        helm
    ];
}