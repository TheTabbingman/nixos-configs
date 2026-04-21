{pkgs, ...}: let
  vsrife = pkgs.python3Packages.callPackage ./vsrife.nix {};
  vsrifePythonEnv = pkgs.python3.withPackages (ps: [
    ps.vapoursynth
    vsrife
  ]);
  mpv-with-vs = pkgs.mpv.override {
    mpv-unwrapped = pkgs.mpv-unwrapped.override {
      vapoursynthSupport = true;
    };
    extraMakeWrapperArgs = [
      "--prefix"
      "PYTHONPATH"
      ":"
      "${vsrifePythonEnv}/${pkgs.python3.sitePackages}"
    ];
  };

  thumbfast-osc = pkgs.stdenv.mkDerivation {
    name = "thumbfast";
    src = pkgs.fetchFromGitHub {
      owner = "po5";
      repo = "thumbfast";
      rev = "9d78edc167553ccea6290832982d0bc15838b4ac";
      hash = "sha256-AG3w5B8lBcSXV4cbvX3nQ9hri/895xDbTsdaqF+RL64=";
    };
    installPhase = ''
      mkdir -p $out
      cp player/lua/osc.lua $out
    '';
  };
  mpv-websocket = let
    version = "0.4.4";
  in
    pkgs.stdenv.mkDerivation {
      name = "mpv-websocket";
      src = pkgs.fetchurl {
        url = "https://github.com/kuroahna/mpv_websocket/releases/download/${version}/x86_64-unknown-linux-musl.zip";
        hash = "sha256-m587c87nL+eYCi4hlJR8RxYZim7a3CIgr6xnXGbQjYI=";
      };
      nativeBuildInputs = [pkgs.unzip];
      sourceRoot = ".";
      installPhase = ''
        mkdir -p $out
        cp mpv_websocket $out
        chmod +x $out/mpv_websocket
      '';
    };
  mpv-websocket-script = pkgs.stdenv.mkDerivation {
    name = "mpv-websocket-script";
    src = pkgs.fetchFromGitHub {
      owner = "TheTabbingMan";
      repo = "mpv_websocket";
      rev = "80103c92aac2fec2d67e4faf720351b7ba787d54";
      hash = "sha256-+z53aUC1E72/KTBXnILO5mmNIH13qVSoPm3sxRrBw1Y=";
    };
    installPhase = ''
      mkdir -p $out
      cp mpv/scripts/run_websocket_server.lua $out
    '';
  };
  anime4k-360p-esrgan = pkgs.stdenv.mkDerivation {
    name = "anime4k";
    src = pkgs.fetchFromGitHub {
      owner = "bloc97";
      repo = "Anime4K";
      rev = "7684e9586f8dcc738af08a1cdceb024cc184f426";
      hash = "sha256-F5/n/KmJ7iOiI0qcpwX6q8zvF4ACv6zcJTOxcAv6HSE=";
    };
    installPhase = ''
      mkdir -p $out
      cp glsl/Restore/Anime4K_Restore_GAN_UUL.glsl $out
      cp glsl/Upscale/Anime4K_Upscale_GAN_x4_UUL.glsl $out
    '';
  };
  animeanyk = pkgs.stdenv.mkDerivation {
    name = "animeanyk";
    src = pkgs.fetchFromGitHub {
      owner = "TheTabbingMan";
      repo = "AnimeAnyK-mpv";
      rev = "79a072a7374b6ce7c4cbe34a07b0dc7cd9c78a94";
      hash = "sha256-QW/52/k75+bJjSTng4AJKWMOOWGDVsE1fR7PrMW8iz8=";
    };
    installPhase = ''
      mkdir -p $out
      cp AnimeAnyK.lua $out
    '';
  };
  smartCopyPaste = pkgs.stdenv.mkDerivation {
    name = "SmartCopyPaste";
    src = pkgs.fetchFromGitHub {
      owner = "Eisa01";
      repo = "mpv-scripts";
      rev = "b9e63743a858766c9cc7a801d77313b0cecdb049";
      hash = "sha256-XuFvCBOIiLncgsDZJJjU/qSSJJ5SfNF16pIJjIWUJ+A=";
    };
    installPhase = ''
      mkdir -p $out
      cp scripts/SmartCopyPaste.lua $out
    '';
  };
  trim = pkgs.stdenv.mkDerivation {
    name = "trim";
    src = pkgs.fetchFromGitHub {
      owner = "aerobounce";
      repo = "trim.lua";
      rev = "473c9b1a9900c617ee7bb78521906090b15868d4";
      hash = "sha256-QENf4gvsMaGcAP9RzV7ra6TsQQdij0chaFzeMtjaZ6s=";
    };
    installPhase = ''
      mkdir -p $out
      cp trim.lua $out
    '';
  };
  fsrcnnx = let
    version = "1.1";
  in
    pkgs.stdenv.mkDerivation {
      name = "fsrcnnx";
      src = pkgs.fetchurl {
        url = "https://github.com/igv/FSRCNN-TensorFlow/releases/download/${version}/FSRCNNX_x2_16-0-4-1.glsl";
        hash = "sha256-1aJKJx5dmj9/egU7FQxGCkTCWzz393CFfVfMOi4cmWU=";
      };
      dontUnpack = true;
      installPhase = ''
        mkdir -p $out
        cp $src $out/FSRCNNX_x2_16-0-4-1.glsl
      '';
    };
  SSimSuperRes = pkgs.stdenv.mkDerivation {
    name = "SSimSuperRes";
    src = pkgs.fetchurl {
      url = "https://gist.github.com/igv/2364ffa6e81540f29cb7ab4c9bc05b6b/raw/15d93440d0a24fc4b8770070be6a9fa2af6f200b/SSimSuperRes.glsl";
      hash = "sha256-qLJxFYQMYARSUEEbN14BiAACFyWK13butRckyXgVRg8=";
    };
    dontUnpack = true;
    installPhase = ''
      mkdir -p $out
      cp $src $out/SSimSuperRes.glsl
    '';
  };
  adaptive-sharpen = pkgs.stdenv.mkDerivation {
    name = "adaptive-sharpen";
    src = pkgs.fetchurl {
      url = "https://gist.github.com/igv/8a77e4eb8276753b54bb94c1c50c317e/raw/572f59099cd0e3eb5e321a6da0a3d90a7382e2dc/adaptive-sharpen.glsl";
      hash = "sha256-gn+z1mKsmpG0B16RF/5uHbwcBthZWbpxnNuVTft/uOQ=";
    };
    dontUnpack = true;
    installPhase = ''
      mkdir -p $out
      cp $src $out/adaptive-sharpen.glsl
    '';
  };
in {
  programs.mpv = {
    enable = true;
    package = mpv-with-vs;
    config = {
      input-ipc-server = "/tmp/mpv-socket";
      hwdec = "auto";
      hr-seek = true;
      volume-max = 200;
      save-position-on-quit = true;
      vo = "gpu-next";
      ytdl-raw-options = "cookies-from-browser=firefox";

      # Debanding reduces banding artifacts from low-quality or compressed sources.
      # iterations: number of passes (1-4). Higher = stronger but more GPU cost.
      #   2 is a good balance; 4 is maximum with diminishing returns above 2.
      # threshold: filter strength (0-4096). Higher removes more banding but risks
      #   blurring fine detail. 35 is a reasonable default.
      # range: how far the filter samples (1-64). 16 is standard.
      # grain: adds dynamic noise to mask residual banding (0 = off).
      #   Set to 0 if using a static grain shader instead.
      deband = true;
      deband-iterations = 2;
      deband-threshold = 35;
      deband-range = 16;
      deband-grain = 4;

      keepaspect-window = false;
      auto-window-resize = false;
    };
    bindings = {
      # Optimized shaders for higher-end GPU
      "CTRL+1" = ''no-osd change-list glsl-shaders set "~~/shaders/Anime4K_Clamp_Highlights.glsl:~~/shaders/Anime4K_Restore_CNN_VL.glsl:~~/shaders/Anime4K_Upscale_CNN_x2_VL.glsl:~~/shaders/Anime4K_AutoDownscalePre_x2.glsl:~~/shaders/Anime4K_AutoDownscalePre_x4.glsl:~~/shaders/Anime4K_Upscale_CNN_x2_M.glsl"; show-text "Anime4K: Mode A (HQ)"'';
      "CTRL+2" = ''no-osd change-list glsl-shaders set "~~/shaders/Anime4K_Clamp_Highlights.glsl:~~/shaders/Anime4K_Restore_CNN_Soft_VL.glsl:~~/shaders/Anime4K_Upscale_CNN_x2_VL.glsl:~~/shaders/Anime4K_AutoDownscalePre_x2.glsl:~~/shaders/Anime4K_AutoDownscalePre_x4.glsl:~~/shaders/Anime4K_Upscale_CNN_x2_M.glsl"; show-text "Anime4K: Mode B (HQ)"'';
      "CTRL+3" = ''no-osd change-list glsl-shaders set "~~/shaders/Anime4K_Clamp_Highlights.glsl:~~/shaders/Anime4K_Upscale_Denoise_CNN_x2_VL.glsl:~~/shaders/Anime4K_AutoDownscalePre_x2.glsl:~~/shaders/Anime4K_AutoDownscalePre_x4.glsl:~~/shaders/Anime4K_Upscale_CNN_x2_M.glsl"; show-text "Anime4K: Mode C (HQ)"'';
      "CTRL+4" = ''no-osd change-list glsl-shaders set "~~/shaders/Anime4K_Clamp_Highlights.glsl:~~/shaders/Anime4K_Restore_CNN_VL.glsl:~~/shaders/Anime4K_Upscale_CNN_x2_VL.glsl:~~/shaders/Anime4K_Restore_CNN_M.glsl:~~/shaders/Anime4K_AutoDownscalePre_x2.glsl:~~/shaders/Anime4K_AutoDownscalePre_x4.glsl:~~/shaders/Anime4K_Upscale_CNN_x2_M.glsl"; show-text "Anime4K: Mode A+A (HQ)"'';
      "CTRL+5" = ''no-osd change-list glsl-shaders set "~~/shaders/Anime4K_Clamp_Highlights.glsl:~~/shaders/Anime4K_Restore_CNN_Soft_VL.glsl:~~/shaders/Anime4K_Upscale_CNN_x2_VL.glsl:~~/shaders/Anime4K_AutoDownscalePre_x2.glsl:~~/shaders/Anime4K_AutoDownscalePre_x4.glsl:~~/shaders/Anime4K_Restore_CNN_Soft_M.glsl:~~/shaders/Anime4K_Upscale_CNN_x2_M.glsl"; show-text "Anime4K: Mode B+B (HQ)"'';
      "CTRL+6" = ''no-osd change-list glsl-shaders set "~~/shaders/Anime4K_Clamp_Highlights.glsl:~~/shaders/Anime4K_Upscale_Denoise_CNN_x2_VL.glsl:~~/shaders/Anime4K_AutoDownscalePre_x2.glsl:~~/shaders/Anime4K_AutoDownscalePre_x4.glsl:~~/shaders/Anime4K_Restore_CNN_M.glsl:~~/shaders/Anime4K_Upscale_CNN_x2_M.glsl"; show-text "Anime4K: Mode C+A (HQ)"'';
      "CTRL+7" = ''no-osd change-list glsl-shaders set "~~/shaders/Anime4K_Restore_GAN_UUL.glsl:~~/shaders/Anime4K_Upscale_GAN_x4_UUL.glsl:~~/shaders/Anime4K_Restore_CNN_Soft_M.glsl:~~/shaders/Anime4K_Upscale_CNN_x2_M.glsl"; show-text "Experimental: 360p to 4k SRGAN shaders"'';
      "CTRL+8" = "script-binding toggle-anime4k-jbgyampcwu";
      "CTRL+9" = ''no-osd change-list glsl-shaders set "~~/shaders/SSimSuperRes.glsl:~~/shaders/adaptive-sharpen.glsl"; show-text "SSimSuperRes + Adaptive Sharpen"'';
      "CTRL+s" = ''no-osd change-list glsl-shaders set "~~/shaders/adaptive-sharpen.glsl"; show-text "adaptive-sharpen"'';
      "CTRL+f" = ''no-osd change-list glsl-shaders set "~~/shaders/FSRCNNX_x2_16-0-4-1.glsl:~~/shaders/adaptive-sharpen.glsl"; show-text "FSRCNNX + Adaptive Sharpen"'';

      # CTRL+7  set vf "@vsr:d3d11vpp=scale=2:scaling-mode=nvidia:format=nv12"; show-text "NVIDIA VSR Enabled"
      # CTRL+9 script-binding enable-vsr
      # CTRL+h change-list vf toggle "d3d11vpp=nvidia-true-hd"; show-text "NVIDIA HDR Enabled"

      "CTRL+0" = ''no-osd change-list glsl-shaders clr ""; set vf ""; show-text "GLSL shaders and video filters cleared"'';

      # Hard to get working on nixos
      "CTRL+r" = ''vf toggle @rife:vapoursynth="~~/rife.vpy":4:4'';

      "RIGHT" = "seek 5";
      "LEFT" = "seek -5";
    };
  };
  xdg.configFile."mpv/scripts/osc.lua".source = "${thumbfast-osc}/osc.lua";
  xdg.configFile."mpv/mpv_websocket".source = "${mpv-websocket}/mpv_websocket";
  xdg.configFile."mpv/scripts/run_websocket_server.lua".source = "${mpv-websocket-script}/run_websocket_server.lua";
  xdg.configFile."mpv/scripts/AnimeAnyK.lua".source = "${animeanyk}/AnimeAnyK.lua";
  xdg.configFile."mpv/scripts/SmartCopyPaste.lua".source = "${smartCopyPaste}/SmartCopyPaste.lua";
  xdg.configFile."mpv/scripts/trim.lua".source = "${trim}/trim.lua";
  xdg.configFile."mpv/scripts/thumbfast.lua".source = "${pkgs.mpvScripts.thumbfast}/share/mpv/scripts/thumbfast.lua";
  xdg.configFile."mpv/shaders" = {
    source = pkgs.symlinkJoin {
      name = "mpv-shaders";
      paths = [
        "${pkgs.anime4k}"
        "${anime4k-360p-esrgan}"
        "${fsrcnnx}"
        "${SSimSuperRes}"
        "${adaptive-sharpen}"
      ];
    };
    recursive = true;
  };
}
