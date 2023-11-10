{ pkgs, ... }: {
    networking.firewall.allowedTCPPorts = [
        6443 # k3s: required so that pods can reach the API server (running on port 6443 by default)
    
        9898 # test podinfo deployment should be reachable
    ];
    services.k3s.enable = true;
    services.k3s.role = "server";
    services.k3s.extraFlags = toString [
        # "--kubelet-arg=v=4" # Optionally add additional args to k3s
    ];
    environment.systemPackages = with pkgs; [ 
        k3s
        fluxcd
    ];
}