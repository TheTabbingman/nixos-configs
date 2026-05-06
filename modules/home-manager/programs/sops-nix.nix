{...}: {
  sops = {
    age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
    # It's also possible to use a ssh key, but only when it has no password:
    #age.sshKeyPaths = [ "/home/user/path-to-ssh-key" ];
    defaultSopsFile = ../../../secrets/home-manager.yaml;
    # secrets.test = {
    # sopsFile = ./secrets.yml.enc; # optionally define per-secret files

    # %r gets replaced with a runtime directory, use %% to specify a '%'
    # sign. Runtime dir is $XDG_RUNTIME_DIR on linux and $(getconf
    # DARWIN_USER_TEMP_DIR) on darwin.
    # path = "%r/test.txt";
    # };
  };
}
