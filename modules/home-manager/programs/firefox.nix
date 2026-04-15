{
  pkgs,
  inputs,
  ...
}: let
  extensionIds = [
    "{8454caa8-cebc-4486-8b23-9771f187ed6c}" # 600% Sound Volume
    "moz-addon-prod@7tv.app" # 7TV
    "{1be309c5-3e4f-4b99-927d-bb500eb4fa88}" # Augmented Steam
    "{c2c003ee-bd69-42a2-b0e9-6f34222cb046}" # Auto Tab Discard
    "{40539aea-e9a3-4ff1-8ca0-0e2e0187ea42}" # AutoTwitchPoints
    "{446900e4-71c2-419f-a6a7-df9c091e268b}" # Bitwarden Password Manager
    "{e58d3966-3d76-4cd9-8552-1582fbc800c1}" # Buster: Captcha Solver for Humans
    "chatterino_native@chatterino.com" # Chatterino Native Host
    "gdpr@cavi.au.dk" # Consent-O-Matic
    "{12cf650b-1822-40aa-bff0-996df6948878}" # cookies.txt
    "addon@darkreader.org" # Dark Reader
    "{963aa3d4-c342-4dfe-872e-76be742d1bea}" # Disable YouTube Seek by Number
    "@contain-facebook" # Facebook Container
    "FirefoxColor@mozilla.com" # Firefox Color
    "{aa00d7f9-cf31-4dd6-a6d0-ca2c2793368b}" # FlipTube
    "{a2503cd4-4083-4c2f-bef2-37767a569867}" # Furiganaize
    "goodreads-easy-search@jamiebrynes.com" # Goodreads Easy Search
    "holo-schedule@holo.dev" # HoloSchedule
    "jid1-93CWPmRbVPjRQA@jetpack" # Honey
    "{61dff19a-4460-42de-9825-1ed4f0813091}" # jisho-pitcher
    "{86632d71-fe71-4a7b-8eab-3bff42d33f0d}" # Lap Clipboard Inserter
    "{ae865fed-3ca7-4701-bb86-f129e77deef5}" # LiveTL - Translation Filter for Streams
    "{c84d89d9-a826-4015-957b-affebd9eb603}" # MAL-Sync
    "media-controller.extension@tnychn" # Media Controller
    "{5183707f-8a46-4092-8c1f-e4515bcebbad}" # Modrinthify
    "{1b84391e-7c49-4ff3-abab-07bd0a4523e4}" # Multiselect for YouTube™
    "{c2691771-8d07-4c8e-90d5-162a61747d67}" # No Playlist Autoplay For YouTube
    "{e844d8ad-7f10-4de7-ad36-13c95d10aae4}" # oii
    "cavitedev@gmail.com" # osu! subdivide nations
    "{6e3f516b-0653-4d26-87c5-bc71749229ee}" # pp calculator
    "{db722c0c-d10e-4e23-af56-bbb6c3b62cc5}" # QR Code (Generator and Reader)
    "{762f9885-5a13-4abd-9c77-433dcd38b8fd}" # Return YouTube Dislike
    "{73239762-0d26-4b2e-82a5-49bfd13457f0}" # RSS Feed Reader
    "{3c078156-979c-498b-8990-85f7987dd929}" # Sidebery
    "simple-translate@sienori" # Simple Translate
    "sponsorBlocker@ajay.app" # SponsorBlock for YouTube - Skip Sponsorships
    "firefox-extension@steamdb.info" # SteamDB
    "storygraphenhancementtoolsdev@gmail.com" # StoryGraph Enhancement Tools
    "{7a7a4a92-a2a0-41d1-9fd7-1e92480d612d}" # Stylus
    "Tab-Session-Manager@sienori" # Tab Session Manager
    "izer@camelcamelcamel.com" # The Camelizer
    "{84c8edb0-65ca-43a5-bc53-0e80f41486e1}" # Tweaks for YouTube
    "{8fc14e5e-b3fd-43b3-9eec-c61c08781782}" # Twitch Ad Muter
    "{036a55b4-5e72-4d05-a06c-cba2dfcc134a}" # TWP - Translate Web Pages
    "uBlock0@raymondhill.net" # uBlock Origin
    "{d7742d87-e61d-4b78-b8a1-b469842139fa}" # Vimium
    "{aecec67f-0d10-4fa7-b7c7-609a2db280cf}" # Violentmonkey
    "wayback_machine@mozilla.org" # Wayback Machine
    "WebToEpub@Baka-tsuki.org" # WebToEpub
    "@windscribeff" # Windscribe - Free Proxy and Ad Blocker
    "{6b733b82-9261-47ee-a595-2dda294a4d08}" # Yomitan Popup Dictionary
    "youtube-no-playlist@klemens.io" # YouTube No Playlist!
    "{36d78ab3-8f38-444a-baee-cb4a0cadbf98}" # Youtube Playlist Duration Calculator
    "{d8b32864-153d-47fb-93ea-c273c4d1ef17}" # YouTube Screenshot
    "admin@2fas.com" # 2FAS Auth - Two Factor Authentication
    "{da35dad8-f912-4c74-8f64-c4e6e6d62610}" # Auto Refresh Page
    "chartfox.cors-extension@cobaltgrid.com" # ChartFox Browser Extension
    "chrome-mask@overengineer.dev" # Chrome Mask
    "epublifier@maoserr.com" # Epublifier
    "{36bdf805-c6f2-4f41-94d2-9b646342c1dc}" # Export Cookies
    "addon@fastforward.team" # FastForward
    "private-relay@firefox.com" # Firefox Relay
    "{d8d0bc2b-45c2-404d-bb00-ce54305fc39c}" # Flag Cookies
    "{8276b2b6-a974-4254-8647-79c691694b10}" # FreshRSS Watcher
    "{7ff078b3-b3e9-44df-a646-45c702b2e17c}" # Holodex Plus
    "native-dash-hls@cavar.net" # Native MPEG-Dash + HLS Playback
    "nekocaption@gmail.com" # NekoCap
    "Niconico-Downloader@nekojiro.net" # Niconico Downloader
    "{6706d386-2d33-4e1e-bbf1-51b9e1ce47e1}" # Pixiv Toolkit
    "{b06bb7c9-40fe-4882-8b70-37edb66a3b84}" # Play or Pause Tab
    "{d63ee338-4bfe-49ce-b7f4-d368b4db3128}" # Selective Bookmarks Export Tool
    "skipredirect@sblask" # Skip Redirect
    "{76ef94a4-e3d0-4c6f-961a-d38a429a332b}" # TTV LOL PRO
    "@unload-tabs" # UnloadTabs
    "{b9db16a4-6edc-47ec-a1f4-b86292ed211d}" # Video DownloadHelper
    "ycs-cont-public@pymaster.tw" # YCS - YouTube Comment Search (Continued)
  ];
  # Helper to create the policy object for each ID
  mkExtension = id: {
    name = id;
    value = {
      installation_mode = "normal_installed";
      install_url = "https://addons.mozilla.org/firefox/downloads/latest/${id}/latest.xpi";
    };
  };
in {
  programs.firefox = {
    enable = true;
    profiles.default = {
      extensions.force = true;
      settings = {
        "extensions.autoDisableScopes" = 0; # Don't disable extensions automatically
        /**
         **************************************************************************************
        * Smoothfox                                                                            *
        * "Faber est suae quisque fortunae"                                                    *
        * priority: better scrolling                                                           *
        * version: 137                                                                       *
        * url: https://github.com/yokoffing/Betterfox                                          *
        **************************************************************************************
        */
        /**
          **************************************************************************************
         * OPTION: NATURAL SMOOTH SCROLLING V3 [MODIFIED]                                      *
        ***************************************************************************************
        */
        # credit: https://github.com/AveYo/fox/blob/cf56d1194f4e5958169f9cf335cd175daa48d349/Natural%20Smooth%20Scrolling%20for%20user.js
        # recommended for 120hz+ displays
        # largely matches Chrome flags: Windows Scrolling Personality and Smooth Scrolling
        "apz.overscroll.enabled" = true; # DEFAULT NON-LINUX
        "general.smoothScroll" = true; # DEFAULT
        "general.smoothScroll.msdPhysics.continuousMotionMaxDeltaMS" = 12;
        "general.smoothScroll.msdPhysics.enabled" = true;
        "general.smoothScroll.msdPhysics.motionBeginSpringConstant" = 600;
        "general.smoothScroll.msdPhysics.regularSpringConstant" = 650;
        "general.smoothScroll.msdPhysics.slowdownMinDeltaMS" = 25;
        "general.smoothScroll.msdPhysics.slowdownMinDeltaRatio" = "2";
        "general.smoothScroll.msdPhysics.slowdownSpringConstant" = 250;
        "general.smoothScroll.currentVelocityWeighting" = "1";
        "general.smoothScroll.stopDecelerationWeighting" = "1";
        "mousewheel.default.delta_multiplier_y" = 300; # 250-400; adjust this number to your liking
      };
      userChrome = ''
                                        /* Source file https://github.com/MrOtherGuy/firefox-csshacks/tree/master/chrome/autohide_sidebar.css made available under Mozilla Public License v. 2.0
                                See the above repository for updates as well as full license text. */

                                /* Show sidebar only when the cursor is over it.
                                   The border controlling sidebar width will be removed so you'll need to modify
                                   these values to change width.
                                   By default the internal layout of sidebar changes when hovered, but this can
                                   be changed by setting pref "userchrome.autohide-sidebar.static-layout.enabled" to true
                                 */

                                /* Note: If you want only *some* sidebar to be auto-hidden, then you can use [sidebarcommand] attribute selector.
                                   For example, to only affect Sidebery's sidebar replace all instances of #sidebar-box with
                                   #sidebar-box[sidebarcommand="_3c078156-979c-498b-8990-85f7987dd929_-sidebar-action"].
                                   To find the sidebarcommand value for any other sidebar, open that sidebar and use Browser Toolbox to inspect it.
                                   See: https://firefox-source-docs.mozilla.org/devtools-user/browser_toolbox/index.html
                                */
                                :where(#main-window) #browser{
                                  --uc-sidebar-width: 40px;
                                  --uc-sidebar-hover-width: 210px;
                                }
                                #main-window[sizemode="fullscreen"] #browser{
                                  --uc-sidebar-width: 1px;
                                }
                                #sidebar-box{
                                  --uc-autohide-sidebar-delay: 600ms; /* Wait 0.6s before hiding sidebar */
                                  --uc-autohide-transition-duration: 115ms;
                                  --uc-autohide-transition-type: linear;
                                  --browser-area-z-index-sidebar: 3;
                                  position: relative;
                                  min-width: var(--uc-sidebar-width) !important;
                                  width: var(--uc-sidebar-width) !important;
                                  max-width: var(--uc-sidebar-width) !important;
                                  z-index: var(--browser-area-z-index-sidebar,3);
                                  background-color: inherit;
                                  /* This directionality flipper is played so that sidebar "grows" into the right direction */
                                  direction: ltr;
                                  &:is([positionend],[sidebar-positionend]):not(:-moz-locale-dir(rtl)){
                                    direction: rtl;
                                  }
                                }
                                .sidebar-browser-stack{
                                  background: inherit;
                                }
                                #main-window[sizemode="fullscreen"] #browser{ --uc-sidebar-width: 1px; }

                                #sidebar-splitter{ display: none }

                                #sidebar-header{
                                  overflow: hidden;
                                  color: var(--chrome-color, inherit) !important;
                                  padding-inline: 0 !important;
                                }

                                #sidebar-header::before,
                                #sidebar-header::after{
                                  content: "";
                                  display: flex;
                                  padding-left: 8px;
                                }

                                #sidebar-header,
                                #sidebar{
                                  transition: min-width var(--uc-autohide-transition-duration) var(--uc-autohide-transition-type) var(--uc-autohide-sidebar-delay) !important;
                                  min-width: var(--uc-sidebar-width) !important;
                                  will-change: min-width;
                                  direction: ltr;
                                  &:-moz-locale-dir(rtl){
                                    direction: rtl;
                                  }
                                }
                                #sidebar-box:hover > #sidebar-header,
                                #sidebar-box:hover > #sidebar,
                                #sidebar-box:hover > .sidebar-browser-stack > #sidebar{
                                  min-width: var(--uc-sidebar-hover-width) !important;
                                  transition-delay: 0ms !important;
                                }

                                .sidebar-panel{
                                  background-color: transparent !important;
                                  color: var(--newtab-text-primary-color) !important;
                                }

                                .sidebar-panel #search-box{
                                  -moz-appearance: none !important;
                                  background-color: rgba(249,249,250,0.1) !important;
                                  color: inherit !important;
                                }

                                /* Add sidebar divider and give it background */

                                #sidebar,
                                #sidebar-header{
                                  background-color: inherit !important;
                                  border-inline: 1px solid rgb(80,80,80);
                                  border-inline-width: 0px 1px;
                                }

                                #sidebar-box:not([positionend],[sidebar-positionend]) > :-moz-locale-dir(rtl),
                                #sidebar-box:is([positionend],[sidebar-positionend]) > *{
                                  border-inline-width: 1px 0px;
                                }
                                @media -moz-pref("sidebar.revamp") {
                                  #sidebar, #sidebar-header{ border-style: none }
                                  #sidebar-box{ padding: 0 !important; }
                                }
                                /* Move statuspanel to the other side when sidebar is hovered so it doesn't get covered by sidebar */

                                #sidebar-box:not([positionend],[sidebar-positionend]):hover ~ #appcontent #statuspanel{
                                  inset-inline: auto 0px !important;
                                }
                                #sidebar-box:not([positionend],[sidebar-positionend]):hover ~ #appcontent #statuspanel-label{
                                  margin-inline: 0px !important;
                                  border-left-style: solid !important;
                                }
                                @media -moz-pref("userchrome.autohide-sidebar.static-layout.enabled"){
                                  #sidebar-box{
                                    min-width: var(--uc-sidebar-width) !important;
                                    contain: size;
                                    box-shadow: var(--content-area-shadow);
                                  }
                                  #sidebar{
                                    min-width: var(--uc-sidebar-hover-width) !important;
                                  }
                                  .sidebar-browser-stack{
                                    overflow: hidden;
                                    width: 100%;
                                    transition: width var(--uc-autohide-transition-duration) var(--uc-autohide-transition-type) var(--uc-autohide-sidebar-delay);
                                    direction: ltr;
                                    &:hover{
                                      transition-delay: 0ms;
                                      width: var(--uc-sidebar-hover-width);
                                    }
                                    &:-moz-locale-dir(rtl){
                                      transition-property: transform,width !important;
                                    }
                                  }
                                  #sidebar-box[sidebar-positionend]:hover :is(#sidebar-header,#sidebar):-moz-locale-dir(ltr){
                                    transform: translateX(0);
                                    transition-delay: 0ms !important;
                                  }
                                  #sidebar-box:not([sidebar-positionend]):hover .sidebar-browser-stack:-moz-locale-dir(rtl){
                                    transform: translateX(calc(-1 * var(--uc-sidebar-hover-width) + var(--uc-sidebar-width)));
                                  }
                                  #sidebar-box[sidebar-positionend]:hover > .sidebar-browser-stack:-moz-locale-dir(rtl){
                                    transform: translateX(calc(var(--uc-sidebar-hover-width) - var(--uc-sidebar-width)));
                                    transition-delay: 0ms !important;
                                  }
                                }
                                        #sidebar-box{
                                          --uc-sidebar-width: 60px;
                                          --uc-sidebar-hover-width: 300px;
                                          --uc-autohide-sidebar-delay: 0ms; /* Wait 0.6s before hiding sidebar */
                                        }

                        /* Source file https://github.com/MrOtherGuy/firefox-csshacks/tree/master/chrome/hide_tabs_toolbar_v2.css made available under Mozilla Public License v. 2.0
                        See the above repository for updates as well as full license text. */

                        /* This requires Firefox 133+ to work */

                        @media -moz-pref("sidebar.verticalTabs"){
                          #sidebar-launcher-splitter,
                          #sidebar-main{
                            visibility: collapse;
                          }
                        }
                        @media -moz-pref("userchrome.force-window-controls-on-left.enabled"){
                          #nav-bar > .titlebar-buttonbox-container{
                            order: -1 !important;
                            > .titlebar-buttonbox{
                              flex-direction: row-reverse;
                            }
                          }
                        }
                        @media not -moz-pref("sidebar.verticalTabs"){
                          #TabsToolbar:not([customizing]){
                            visibility: collapse;
                          }
                          :root[sizemode="fullscreen"] #nav-bar > .titlebar-buttonbox-container{
                            display: flex !important;
                          }
                          :root[customtitlebar] #toolbar-menubar:is([autohide=""],[autohide="true"]) ~ #nav-bar{
                            > .titlebar-buttonbox-container{
                              display: flex !important;
                            }
                            :root[sizemode="normal"] & {
                              > .titlebar-spacer{
                                display: flex !important;
                              }
                            }
                            :root[sizemode="maximized"] & {
                              > .titlebar-spacer[type="post-tabs"]{
                                display: flex !important;
                              }
                              @media -moz-pref("userchrome.force-window-controls-on-left.enabled"),
                                (-moz-gtk-csd-reversed-placement),
                                (-moz-platform: macos){
                                > .titlebar-spacer[type="post-tabs"]{
                                  display: none !important;
                                }
                                > .titlebar-spacer[type="pre-tabs"]{
                                  display: flex !important;
                                }
                              }
                            }
                          }
                        }
        #sidebar-header {
          display: none !important;
        }
      '';
    };
    policies = {
      ExtensionSettings = builtins.listToAttrs (map mkExtension extensionIds);
    };
  };
  stylix.targets.firefox = {
    profileNames = ["default"];
    colorTheme.enable = true;
  };
}
