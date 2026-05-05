{...}: {
  nix.settings = {
    substituters = [
      # "https://hyprland.cachix.org"
      "https://cache.nixos-cuda.org"
    ];
    trusted-substituters = [
      # "https://hyprland.cachix.org"
      "https://cache.nixos-cuda.org"
    ];
    trusted-public-keys = [
      # "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
    ];
  };
}
