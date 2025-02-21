{ pkgs }:

pkgs.writeShellApplication {
    name = "cnd";

    runtimeInputs = with pkgs; [ nvd ];

    text = ''
        # set -x
        previous=$(find /nix/var/nix/profiles/ -name 'system-*-link' | sort -V | tail -n 2 | head -n 1)
        cache=$(cat ~/.config/nix/version.txt)
        # echo "cache $cache"
        # echo "previous $previous"

        if [ "$cache" == "$previous" ]; then
            echo "No changes"
        else
            current=$(find /nix/var/nix/profiles/ -name 'system-*-link' | sort -V | tail -n 1)
            nvd diff "$previous" "$current"
            # echo "$current"
            echo "$previous" > ~/.config/nix/version.txt
        fi
    '';
}
