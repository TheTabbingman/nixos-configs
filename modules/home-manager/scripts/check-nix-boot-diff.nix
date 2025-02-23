{pkgs}:
pkgs.writeShellApplication {
  name = "cnbd";

  runtimeInputs = with pkgs; [nvd];

  text = ''
    # set -x
    boot=$(find /nix/var/nix/profiles/ -name 'system-*-link' | sort -V | tail -n 1)
    cache=$(cat ~/.config/nix/boot_version.txt)
    # echo "cache $cache"
    # echo "boot $boot"

    if [ "$cache" == "$boot" ]; then
        echo "No changes"
    else
        active=/run/current-system/
        nvd diff "$active" "$boot"
        # echo "$boot"
        echo "$boot" > ~/.config/nix/boot_version.txt
    fi
  '';
}
