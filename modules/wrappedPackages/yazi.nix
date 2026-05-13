{
  inputs,
  self,
  ...
}: {
  perSystem = {pkgs, ...}: {
    packages.yazi = inputs.wrapper-modules.wrappers.yazi.wrap {
      inherit pkgs;
      extraPackages = with pkgs; [
        ffmpegthumbnailer
        exiftool
      ];
      aliases = ["y"];
      plugins = let
        ffmpegthumbnailer-yazi = pkgs.stdenv.mkDerivation {
          name = "ffmpegthumbnailer-yazi";
          src = pkgs.fetchFromGitHub {
            owner = "ze0987";
            repo = "ffmpegthumbnailer.yazi";
            rev = "b0e5cc8278181a8bdcb9442d2f9307a05d0e0525";
            sha256 = "sha256-CTTeywF+hlxYRi2wgdbGoogyrIGrZoWTNuqTC9wA92g=";
          };
          installPhase = ''
            runHook preInstall
            cp -r . $out
            runHook postInstall
          '';
        };
      in {
        ffmpegthumbnailer = ffmpegthumbnailer-yazi;
      };
      settings = {
        yazi = {
          plugin = {
            prepend_previewers = [
              {
                mime = "video/*";
                run = "ffmpegthumbnailer";
              }
            ];
            prepend_preloaders = [
              {
                mime = "video/*";
                run = "ffmpegthumbnailer";
              }
            ];
          };
        };
      };
    };
  };
  flake.nixosModules.programs = {
    pkgs,
    config,
    ...
  }: {
    environment.systemPackages = let
      yazi = self.packages.${pkgs.stdenv.hostPlatform.system}.yazi.wrap ({lib, ...}: {
        settings.yazi.opener = {
          play = lib.mkIf (config.networking.hostName == "nixos-laptop") [
            # TODO: Make sure that this has actually worked
            {
              run = "mpv --hwdec=auto --vulkan-device='Intel(R) HD Graphics 530 (SKL GT2)' %s";
              orphan = true;
              for = "unix";
            }
          ];
        };
      });
    in [yazi];
  };
}
