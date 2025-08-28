{pkgs}:
pkgs.writeShellApplication {
  name = "chd";

  runtimeInputs = with pkgs; [nvd];

  text = ''
    # set -x
    set +o pipefail
    previous=$(home-manager generations | sed 's/.*-> //' | head -n 2 | tail -n 1)
    set -o pipefail
    cache=$(cat ~/.config/nix/home-manager/version.txt)
    # echo "cache $cache"
    # echo "previous $previous"

    if [ "$cache" == "$previous" ]; then
        echo "No changes"
    else
        set +o pipefail
        current=$(home-manager generations | sed 's/.*-> //' | sed 's/ (current)//' | head -n 1)
        set -o pipefail
        nvd diff "$previous" "$current"
        echo "$previous" > ~/.config/nix/home-manager/version.txt
    fi
  '';
}
