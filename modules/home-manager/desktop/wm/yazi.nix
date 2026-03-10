{
  pkgs,
  inputs,
  lib,
  config,
  osConfig,
  hostname,
  ...
}: {
  programs.yazi = {
    enable = true;
    shellWrapperName = "y";
    plugins = {
      ffmpegthumbnailer = pkgs.fetchFromGitHub {
        owner = "ze0987";
        repo = "ffmpegthumbnailer.yazi";
        rev = "b0e5cc8278181a8bdcb9442d2f9307a05d0e0525";
        sha256 = "sha256-CTTeywF+hlxYRi2wgdbGoogyrIGrZoWTNuqTC9wA92g=";
      };
    };
    settings = {
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
      opener = {
        play = lib.mkIf (hostname == "laptop") [
          {
            run = "mpv --hwdec=auto --vulkan-device='Intel(R) HD Graphics 530 (SKL GT2)' %s";
            orphan = true;
            for = "unix";
          }
        ];
      };
    };
  };

  home.packages = with pkgs; [
    ffmpegthumbnailer
    exiftool
  ];
}
