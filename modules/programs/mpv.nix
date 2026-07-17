{inputs, ...}: {
  flake.homeModules.programs = {
    pkgs,
    lib,
    ...
  }: let
    # NOTE: I would love to use this but unfortunately torch-tensorrt isn't in nixpkgs so I have to use the method I'm using if I want tensorrt (which I do)
    # vsrife = pkgs.python3Packages.callPackage ./_vsrife.nix {};
    # vsrifePythonEnv = pkgs.python3.withPackages (ps: [
    #   ps.vapoursynth
    #   vsrife
    #   ps.tensorrt
    # ]);
    mpv-with-vs = pkgs.mpv.override {
      mpv-unwrapped = pkgs.mpv-unwrapped.override {
        vapoursynthSupport = true;
      };
      extraMakeWrapperArgs = [
        "--prefix"
        "PYTHONPATH"
        ":"
        # "${vsrifePythonEnv}/${pkgs.python3.sitePackages}"
        "/home/jonah/persist/vsrife/venv_vsrife/lib/python3.13/site-packages" # NOTE: This is made imperatively

        # NOTE: This is only required when using imperitive venv
        "--prefix"
        "LD_LIBRARY_PATH"
        ":"
        "/run/opengl-driver/lib:/run/opengl-driver-32/lib"
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
    mpv-websocket-script = pkgs.stdenv.mkDerivation {
      name = "mpv-websocket-script";
      src = pkgs.fetchFromGitHub {
        owner = "TheTabbingMan"; # TODO: Make this just a substituteInPlace instead maybe. I'm having to change the rust source to fix another issue though so I have to use a fork either way
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
    artcnn = let
      version = "1.6.2";
    in
      pkgs.stdenv.mkDerivation {
        name = "ArtCNN";
        src = pkgs.fetchFromGitHub {
          owner = "Artoriuz";
          repo = "ArtCNN";
          tag = "v${version}";
          hash = "sha256-/cNJj7ah2Jux8pWGngPEjdhKRG1JsPBmb6EsJnQCCAM=";
        };
        dontUnpack = true;
        installPhase = ''
          mkdir -p $out
          cp $src/GLSL/ArtCNN_C4F32_DS.glsl $out/ArtCNN_C4F32_DS.glsl
          cp $src/GLSL/ArtCNN_C4F16_DS.glsl $out/ArtCNN_C4F16_DS.glsl
        '';
      };
    dualsubtitles = pkgs.stdenv.mkDerivation {
      name = "dualsubtitles";
      src = pkgs.fetchFromGitHub {
        owner = "magnumpv";
        repo = "dualsubtitles";
        rev = "09de738b710a5ce9006526c832dc3bc71c10cc9b";
        hash = "sha256-emjpg+tgul3fAULONA09a4ZK12pRQVOFmkMUCSr86uQ=";
      };
      dontUnpack = true;
      installPhase = ''
        mkdir -p $out
        cp -r $src/scripts/dualsubtitles $out/dualsubtitles
        substituteInPlace $out/dualsubtitles/main.lua \
          --replace-fail 'mp.add_key_binding("k",' 'mp.add_key_binding("Ctrl+j",' \
          --replace-fail 'mp.add_key_binding("K",' 'mp.add_key_binding("Ctrl+J",' \
          --replace-fail 'mp.add_key_binding("u",' 'mp.add_key_binding("S",' \
          --replace-fail 'mp.add_key_binding("Ctrl+r",' '-- mp.add_key_binding("Ctrl+r",' \
          --replace-fail 'mp.add_key_binding("Ctrl+R",' '-- mp.add_key_binding("Ctrl+R",'
      '';
    };
  in {
    programs.mpv = {
      enable = true;
      package = mpv-with-vs;
      config = {
        alang = "jp,jpn,en,eng";
        input-ipc-server = "/tmp/mpv-socket";
        hwdec = "auto";
        profile = "high-quality";
        hr-seek = true;
        volume-max = 200;
        save-position-on-quit = true;
        vo = "gpu-next";
        ytdl-raw-options = "cookies-from-browser=firefox:~/.librewolf/default";

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
      profiles = {
        # inverse_tone_mapping = {
        #   # profile-cond = ''video_params and p["video-params/primaries"] ~= "bt.2020"'';
        #   profile-restore = "copy";
        #   target-trc = "pq";
        #   target-prim = "bt.2020";
        #   tone-mapping = "bt.2446a";
        #   inverse-tone-mapping = true;
        #   target-peak = 1000;
        # };
        # HDR Base Profile: HDR Enables HDR
        # -------------------------------------------------------------------------------------------------

        # This block handles the shared HDR output policy for PQ and HLG sources. The
        # condition syntax is current mpv auto_profiles syntax, not an old legacy form.

        # HDR = {
        #   profile-desc = "Enable HDR output policy for PQ or HLG sources";
        #   profile-cond = ''p["video-params/gamma"] == "pq" or p["video-params/gamma"] == "hlg"'';
        #   profile-restore = "copy";

        #   # When the source is HDR, allow mpv to switch the output path into HDR-aware
        #   # signaling instead of leaving the swapchain in a generic SDR state.
        #   target-colorspace-hint = true;

        #   # source-dynamic tells gpu-next to build output hints from source metadata and,
        #   # when dynamic metadata exists, turn it into scene-varying HDR10-style luminance
        #   # hints. This does not output native Dolby Vision or HDR10+, but it is the most
        #   # useful experimental mode for a high-end Windows HDR chain that responds well
        #   # to scene-varying HDR10-style output hints.
        #   target-colorspace-hint-mode = "source-dynamic";

        #   # Describe the intended HDR output target for this display chain. The panel is
        #   # treated as PQ / BT.2020 container / P3-limited gamut with a practical 800 nit
        #   # peak target rather than an unrealistic paper spec.
        #   target-trc = "pq";
        #   target-prim = "bt.2020";
        #   target-gamut = "dci-p3";
        #   target-peak = 1000;
        #   target-contrast = "inf";

        #   # Keep the shared HDR behavior here and push metadata-specific decisions into
        #   # the conditional profiles below. That separation prevents later profile
        #   # application from accidentally undoing format-specific choices.
        #   gamut-mapping-mode = "perceptual";
        #   hdr-peak-percentile = 99.995;
        #   hdr-contrast-recovery = 0.30;
        # };

        # # -------------------------------------------------------------------------------------------------
        # # HDR Metadata Precedence
        # # -------------------------------------------------------------------------------------------------

        # # This is the generic HDR fallback. It covers plain HDR10 or HLG, Dolby Vision
        # # profile 7 fallback, and unknown Dolby Vision profiles whenever HDR10+ scene
        # # metadata is not present.
        # auto-hdr-generic = {
        #   profile-desc = "Use computed scene analysis for HDR without HDR10+ and without supported DV metadata-specialized profiles";
        #   profile-cond = ''(p["video-params/gamma"] == "pq" or p["video-params/gamma"] == "hlg") and (get("video-params/scene-max-r", 0) <= 0) and (get("video-params/scene-max-g", 0) <= 0) and (get("video-params/scene-max-b", 0) <= 0) and (get("current-tracks/video/dolby-vision-profile", 0) ~= 5) and (get("current-tracks/video/dolby-vision-profile", 0) ~= 8) and (get("current-tracks/video/dolby-vision-profile", 0) ~= 9)'';
        #   profile-restore = "copy";

        #   # When there is no metadata-specific path worth trusting, computed peak analysis
        #   # remains the most robust general-purpose HDR fallback.
        #   hdr-compute-peak = true;
        # };

        # # For streaming-style single-layer Dolby Vision profiles, trust the Dolby
        # # Vision metadata path more than generic frame analysis. This block appears
        # # after the generic fallback so supported DV profiles override it cleanly.
        # auto-dolby-vision-rpu = {
        #   profile-desc = "Prefer Dolby Vision metadata path for profile 5 8 and 9 content";
        #   profile-cond = ''(get("current-tracks/video/dolby-vision-profile", 0) == 5) or (get("current-tracks/video/dolby-vision-profile", 0) == 8) or (get("current-tracks/video/dolby-vision-profile", 0) == 9)'';
        #   profile-restore = "copy";

        #   # Disable compute-peak here so mpv does not fight the DV-derived metadata path
        #   # with a second, less specific scene-analysis policy.
        #   hdr-compute-peak = false;
        # };

        # # If HDR10+ scene metadata exists, prefer mpv's dedicated HDR10+ path. This is
        # # intentionally the last metadata-specialized block so HDR10+ wins if a file
        # # ever exposes both HDR10+ and Dolby Vision-compatible metadata.
        # auto-hdr10plus = {
        #   profile-desc = "Automatically prefer HDR10+ metadata when present";
        #   profile-cond = ''(get("video-params/scene-max-r", 0) > 0) or (get("video-params/scene-max-g", 0) > 0) or (get("video-params/scene-max-b", 0) > 0)'';
        #   profile-restore = "copy";

        #   # Use the HDR10+ tone-mapping path directly and avoid redundant compute-peak
        #   # analysis when real HDR10+ scene metadata is available.
        #   tone-mapping = "st2094-40";
        #   hdr-compute-peak = false;
        # };
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
        "CTRL+SHIFT+s" = ''no-osd change-list glsl-shaders toggle "~~/shaders/SSimSuperRes.glsl"; show-text "SSimSuperRes"'';
        "CTRL+s" = ''no-osd change-list glsl-shaders toggle "~~/shaders/adaptive-sharpen.glsl"; show-text "adaptive-sharpen"'';
        "CTRL+f" = ''no-osd change-list glsl-shaders set "~~/shaders/FSRCNNX_x2_16-0-4-1.glsl"; show-text "FSRCNNX"'';
        "CTRL+a" = ''no-osd change-list glsl-shaders set "~~/shaders/ArtCNN_C4F32_DS.glsl"; show-text "ArtCNN32"'';
        "CTRL+SHIFT+a" = ''no-osd change-list glsl-shaders set "~~/shaders/ArtCNN_C4F16_DS.glsl"; show-text "ArtCNN16"'';
        "CTRL+SHIFT+f" = ''no-osd change-list glsl-shaders set "~~/shaders/FSRCNNX_x2_16-0-4-1.glsl:~~/shaders/SSimSuperRes.glsl"; show-text "FSRCNNX + SSimSuperRes"'';
        "CTRL+9" = ''no-osd change-list glsl-shaders set "~~/shaders/ArtCNN_C4F16_DS.glsl:~~/shaders/SSimSuperRes.glsl"; show-text "ArtCNN16 + SSimSuperRes"'';
        "CTRL+SHIFT+(" = ''no-osd change-list glsl-shaders set "~~/shaders/ArtCNN_C4F32_DS.glsl:~~/shaders/SSimSuperRes.glsl"; show-text "ArtCNN32 + SSimSuperRes"'';

        # CTRL+7  set vf "@vsr:d3d11vpp=scale=2:scaling-mode=nvidia:format=nv12"; show-text "NVIDIA VSR Enabled"
        # CTRL+9 script-binding enable-vsr
        # CTRL+h change-list vf toggle "d3d11vpp=nvidia-true-hd"; show-text "NVIDIA HDR Enabled"

        "CTRL+0" = ''no-osd change-list glsl-shaders clr ""; set vf ""; show-text "GLSL shaders and video filters cleared"'';

        # Hard to get working on nixos
        "CTRL+r" = ''vf toggle @rife:vapoursynth="~~/rife.vpy":4:4'';
        "CTRL+SHIFT+r" = ''vf toggle @rife:vapoursynth="~~/rife-heavy.vpy":4:4'';
        "CTRL+ALT+r" = ''vf toggle @rife:vapoursynth="~~/rife-lite.vpy":4:4'';

        "RIGHT" = "seek 5";
        "LEFT" = "seek -5";
      };
    };
    xdg.configFile = let
      mkRifeScript = model:
      # python
      ''
        import vapoursynth as vs
        from vsrife import rife
        core = vs.core

        # 1. Setup the clip (standard mpv-vapoursynth boilerplate)
        clip = video_in

        # 2. Convert to RGBH (Half-precision FP16)
        # This is vital for performance on RTX cards and uses less VRAM
        clip = core.resize.Bicubic(clip, format=vs.RGBH, matrix_in_s="709")

        # 3. Apply RIFE with Real-Time optimizations
        clip = rife(
            clip,
            model="${model}",
            trt=True,
            auto_download=True, # Shouldn't be enabled if using the nix package vsrife
            factor_num=2,
            sc=True                  # Scene change detection
        )

        # 4. Convert back to YUV for mpv display
        clip = core.resize.Bicubic(clip, format=vs.YUV420P10, matrix_s="709")

        clip.set_output()
      '';
    in {
      "mpv/scripts/osc.lua".source = "${thumbfast-osc}/osc.lua";
      "mpv/mpv_websocket".source = ''${lib.getExe' inputs.mpv_websocket.packages.${pkgs.stdenv.hostPlatform.system}.default "mpv_websocket"}'';
      "mpv/scripts/run_websocket_server.lua".source = "${mpv-websocket-script}/run_websocket_server.lua";
      "mpv/scripts/AnimeAnyK.lua".source = "${animeanyk}/AnimeAnyK.lua";
      "mpv/scripts/SmartCopyPaste.lua".source = "${smartCopyPaste}/SmartCopyPaste.lua";
      "mpv/scripts/trim.lua".source = "${trim}/trim.lua";
      "mpv/scripts/thumbfast.lua".source = "${pkgs.mpvScripts.thumbfast}/share/mpv/scripts/thumbfast.lua";
      "mpv/scripts/mpris.so".source = "${pkgs.mpvScripts.mpris}/share/mpv/scripts/mpris.so";
      "mpv/script-opts/thumbfast.conf".text =
        # ini
        ''
          network=yes
          hwdec=yes
          max_height=400
          max_width=400
        '';
      "mpv/shaders" = {
        source = pkgs.symlinkJoin {
          name = "mpv-shaders";
          paths = [
            "${pkgs.anime4k}"
            "${anime4k-360p-esrgan}"
            "${fsrcnnx}"
            "${SSimSuperRes}"
            "${adaptive-sharpen}"
            "${artcnn}"
          ];
        };
        recursive = true;
      };
      "mpv/rife.vpy".text = mkRifeScript "4.25";
      "mpv/rife-heavy.vpy".text = mkRifeScript "4.25.heavy";
      "mpv/rife-lite.vpy".text = mkRifeScript "4.25.lite";
      "mpv/scripts/dualsubtitles".source = "${dualsubtitles}/dualsubtitles";
      "mpv/script-opts/dualsubtitles.conf".text =
        # ini
        ''
          # Subtitles to Be Auto-Selected on Startup (The First One Has the Highest Priority)
          #
          # FORMAT
          # <code>:<subcodes>
          # code − language code with two letters (required) [language list: https://en.wikipedia.org/wiki/List_of_ISO_639_language_codes]
          # subcodes − script, region, etc. (optional) [region list: https://en.wikipedia.org/wiki/List_of_ISO_3166_country_codes]
          #
          # EXAMPLE
          # en:us = en-us (BCP 47) > en (639-1) / eng (639-2/B) / english (name)
          # ja = ja (639-1) / jpn (639-2/B) / japanese (name)
          # tr = tr (639-1) / tur (639-2/B) / turkish (name)
          # zh:hans-cn = zh-hans-cn (BCP 47) > zh (639-1) / chi (639-2/B) / chinese (name)
          top_languages=en:us
          bottom_languages=ja
          # bottom_languages=en:us,ja

          # Use only the matching subtitles if their titles contain these words.
          preferred_words=

          # Skip subtitles with these words in their title.
          rejected_words=sign,song

          # Set top subtitle as bottom subtitle if bottom subtitle is missing.
          use_top_as_bottom=yes

          # Display the secondary subtitle only when hovering.
          secondary_on_hover=yes

          # Secondary Subtitle Hover Area (50 = the top half of the screen)
          hover_height_percent=20

          # Style Settings for Merged Subtitles
          # In MPV, styling options for secondary subtitles are quite limited. By merging subtitles, you can work around this limitation. If your video file is on an HDD, this process may take 2–3 minutes.
          # Values are given in 1920×1080 resolution.
          #
          # COLOR FORMAT
          # <alpha><alpha><b><b><g><g><r><r>
          # EXAMPLE
          # 370DE2 (RGB) > E20D37 (BGR) > &H00E20D37 (ASS)
          # You can convert any RGB value to BGR by swapping the first and last two characters. Note that the first two characters in an ASS color code represent the alpha channel.
          #
          # Live Preview: https://github.com/magnum357i/mpv-stylesmanager
          top_style=fn:Segoe UI Semibold,fs:60,1c:&H0000DEFF,2c:&H000000FF,3c:&H00000000,4c:&H00000000,b:0,i:0,u:0,s:0,sx:100,sy:100,fsp:0,frz:0,bs:1,bord:4,shad:0,an:8,ml:0,mr:0,mv:40,enc:1
          bottom_style=fn:Calibri,fs:60,1c:&H00FFFFFF,2c:&H000000FF,3c:&H00000000,4c:&H00000000,b:0,i:0,u:0,s:0,sx:100,sy:100,fsp:0,frz:0,bs:1,bord:1.5,shad:0,an:2,ml:0,mr:0,mv:40,enc:1

          # ASS Tags for Merged Subtitles
          # When a line is stripped based on your current settings, these tags will be added to it.
          #
          # ASS Tags Page (official): https://aegisub.org/docs/latest/ass_tags/
          top_tags=
          bottom_tags=\blur4

          # Don’t strip sign lines.
          # If the ASS file contains sign lines (=lines with pos tag) and you don’t want them stripped, you can use this setting.
          #
          # Valid options: bottom, top, and none
          keep_ts=none

          # Removes entries like "(wind blowing)" or "MAN 1:".
          # Don’t expect perfect results. If you have a SDH subtitle, and the cues are very distracting, you might want to try this setting.
          # remove_sdh_entries=yes

          # Enable extended search for external subtitles.
          # Loads subtitles from subfolders with the same name as the video file. Useful for series.
          #
          # NOTE: Do not enable this setting if you are using something similar.
          # expand_subtitle_search=yes

          # Keep italics during merging.
          detect_italics=yes

          # Prevents you from seeing the same text 20 times on the screen.
          remove_repeating_lines=yes

          # Save Settings
          # Example: moviename.dual.srt (if save_path is set to video)
          save_filename=dual
          # Valid options: <empty> = <temp> | video = <samefolderasvideo> | <yourpath>
          save_path=video
        '';
    };
    services = {
      plex-mpv-shim = {
        enable = true;
        settings = {
          adaptive_transcode = false;
          allow_http = false;
          always_transcode = false;
          audio_ac3passthrough = false;
          audio_dtspassthrough = false;
          auto_play = true;
          auto_transcode = true;
          client_profile = "Plex Home Theater";
          client_uuid = "450a9560-4af8-4768-949a-5ffaf26ed441"; # NOTE: Don't know if it matters that this would be the same between hosts
          direct_limit = false;
          enable_gui = true;
          enable_osc = true;
          enable_play_queue = true;
          fullscreen = true;
          http_port = "3000";
          idle_cmd = null;
          idle_cmd_delay = 60;
          idle_when_paused = false;
          kb_debug = "~";
          kb_menu = "c";
          kb_menu_down = "down";
          kb_menu_esc = "esc";
          kb_menu_left = "left";
          kb_menu_ok = "enter";
          kb_menu_right = "right";
          kb_menu_up = "up";
          kb_next = ">";
          kb_pause = "space";
          kb_prev = "<";
          kb_stop = "q";
          kb_unwatched = "u";
          kb_watched = "w";
          log_decisions = false;
          media_ended_cmd = null;
          media_key_seek = false;
          menu_mouse = true;
          mpv_ext = true;
          mpv_ext_ipc = "/tmp/mpv-socket";
          mpv_ext_no_ovr = true;
          mpv_ext_path = null;
          mpv_ext_start = true;
          mpv_log_level = "info";
          pre_media_cmd = null;
          sanitize_output = true;
          seek_down = 0;
          seek_left = -5;
          seek_right = 5;
          seek_up = 0;
          shader_pack_custom = false;
          shader_pack_enable = true;
          shader_pack_profile = null;
          shader_pack_remember = true;
          shader_pack_subtype = "lq";
          skip_credits_always = false;
          skip_credits_prompt = true;
          skip_intro_always = false;
          skip_intro_prompt = true;
          stop_cmd = null;
          stop_idle = false;
          subtitle_color = "#FFFFFFFF";
          subtitle_position = "bottom";
          subtitle_size = 100;
          svp_enable = false;
          svp_socket = null;
          svp_url = "http://127.0.0.1:9901/";
          transcode_kbps = 2000;
        };
      };
      jellyfin-mpv-shim = {
        enable = true;
        settings = {
          allow_transcode_to_h265 = false;
          always_transcode = false;
          audio_output = "hdmi";
          auto_play = true;
          check_updates = false;
          client_uuid = "db49510e-2466-4c54-aa52-3376af901178"; # NOTE: Don't know if it matters that this would be the same between hosts
          connect_retry_mins = 0;
          direct_paths = false;
          discord_presence = false;
          display_mirroring = false;
          enable_gui = true;
          enable_osc = true;
          force_audio_codec = null;
          force_set_played = false;
          force_video_codec = null;
          fullscreen = true;
          health_check_interval = 300;
          idle_cmd = null;
          idle_cmd_delay = 60;
          idle_ended_cmd = null;
          idle_when_paused = false;
          ignore_ssl_cert = false;
          kb_debug = "~";
          kb_fullscreen = "f";
          kb_kill_shader = "k";
          kb_menu = "c";
          kb_menu_down = "down";
          kb_menu_esc = "esc";
          kb_menu_left = "left";
          kb_menu_ok = "enter";
          kb_menu_right = "right";
          kb_menu_up = "up";
          kb_next = ">";
          kb_pause = "space";
          kb_prev = "<";
          kb_stop = "q";
          kb_unwatched = "u";
          kb_watched = "w";
          lang = null;
          lang_filter = "und,eng,jpn,mis,mul,zxx";
          lang_filter_audio = false;
          lang_filter_sub = false;
          local_kbps = 2147483;
          log_decisions = false;
          media_ended_cmd = null;
          media_key_seek = false;
          media_keys = true;
          menu_mouse = true;
          mpv_ext = true;
          mpv_ext_ipc = "/tmp/mpv-socket";
          mpv_ext_no_ovr = true;
          mpv_ext_path = null;
          mpv_ext_start = true;
          mpv_log_level = "info";
        };
      };
    };
  };
  flake.nixosModules.programs = {
    # Needed for plex-mpv-shim
    networking.firewall.allowedTCPPorts = [3000];
  };
}
