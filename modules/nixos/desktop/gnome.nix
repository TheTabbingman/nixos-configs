{pkgs, ...}: {
  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  # services.xserver.enable = true;

  # Enable the Gnome Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  environment.gnome.excludePackages = with pkgs; [
    epiphany
  ];

  environment.systemPackages = with pkgs;
    [
      gnome-tweaks
    ]
    ++ (with pkgs.gnomeExtensions; [
      # Example for manually updating extension.
      # The sha256 and metadata come from running
      # The update-extensions.py in the nixpkgs repo.
      # (dash-to-dock.override {
      # version = 102;
      # sha256 = "0b6vcl2abp1wy50wvvrhgswlbppfsk1nyh1l3j9px68mh4y3hjwy";
      # metadata = "ewogICJfZ2VuZXJhdGVkIjogIkdlbmVyYXRlZCBieSBTd2VldFRvb3RoLCBkbyBub3QgZWRpdCIsCiAgImRlc2NyaXB0aW9uIjogIkEgZG9jayBmb3IgdGhlIEdub21lIFNoZWxsLiBUaGlzIGV4dGVuc2lvbiBtb3ZlcyB0aGUgZGFzaCBvdXQgb2YgdGhlIG92ZXJ2aWV3IHRyYW5zZm9ybWluZyBpdCBpbiBhIGRvY2sgZm9yIGFuIGVhc2llciBsYXVuY2hpbmcgb2YgYXBwbGljYXRpb25zIGFuZCBhIGZhc3RlciBzd2l0Y2hpbmcgYmV0d2VlbiB3aW5kb3dzIGFuZCBkZXNrdG9wcy4gU2lkZSBhbmQgYm90dG9tIHBsYWNlbWVudCBvcHRpb25zIGFyZSBhdmFpbGFibGUuIiwKICAiZ2V0dGV4dC1kb21haW4iOiAiZGFzaHRvZG9jayIsCiAgIm5hbWUiOiAiRGFzaCB0byBEb2NrIiwKICAib3JpZ2luYWwtYXV0aG9yIjogIm1pY3hneEBnbWFpbC5jb20iLAogICJzaGVsbC12ZXJzaW9uIjogWwogICAgIjQ1IiwKICAgICI0NiIsCiAgICAiNDciLAogICAgIjQ4IiwKICAgICI0OSIKICBdLAogICJ1cmwiOiAiaHR0cHM6Ly9taWNoZWxlZy5naXRodWIuaW8vZGFzaC10by1kb2NrLyIsCiAgInV1aWQiOiAiZGFzaC10by1kb2NrQG1pY3hneC5nbWFpbC5jb20iLAogICJ2ZXJzaW9uIjogMTAyCn0=";
      # })
      (appindicator.override {
        version = 61;
        sha256 = "0lx8idvjvp7k8h2vavdlfcbg46dj0831vvih2cnczbx4lh0ngflj";
        metadata = "ewogICJfZ2VuZXJhdGVkIjogIkdlbmVyYXRlZCBieSBTd2VldFRvb3RoLCBkbyBub3QgZWRpdCIsCiAgImRlc2NyaXB0aW9uIjogIkFkZHMgQXBwSW5kaWNhdG9yLCBLU3RhdHVzTm90aWZpZXJJdGVtIGFuZCBsZWdhY3kgVHJheSBpY29ucyBzdXBwb3J0IHRvIHRoZSBTaGVsbCIsCiAgImdldHRleHQtZG9tYWluIjogIkFwcEluZGljYXRvckV4dGVuc2lvbiIsCiAgIm5hbWUiOiAiQXBwSW5kaWNhdG9yIGFuZCBLU3RhdHVzTm90aWZpZXJJdGVtIFN1cHBvcnQiLAogICJzZXR0aW5ncy1zY2hlbWEiOiAib3JnLmdub21lLnNoZWxsLmV4dGVuc2lvbnMuYXBwaW5kaWNhdG9yIiwKICAic2hlbGwtdmVyc2lvbiI6IFsKICAgICI0NSIsCiAgICAiNDYiLAogICAgIjQ3IiwKICAgICI0OCIsCiAgICAiNDkiCiAgXSwKICAidXJsIjogImh0dHBzOi8vZ2l0aHViLmNvbS91YnVudHUvZ25vbWUtc2hlbGwtZXh0ZW5zaW9uLWFwcGluZGljYXRvciIsCiAgInV1aWQiOiAiYXBwaW5kaWNhdG9yc3VwcG9ydEByZ2Nqb25hcy5nbWFpbC5jb20iLAogICJ2ZXJzaW9uIjogNjEKfQ==";
      })
      kimpanel
      dash-to-dock
      pop-shell
      blur-my-shell
      search-light
      pkgs.gnome-extension-manager
      clipboard-indicator
      pkgs.dconf-editor
    ]);

  services.udev.packages = with pkgs; [gnome-settings-daemon];

  # qt = {
  #   enable = true;
  #   platformTheme = "gnome";
  #   style = "adwaita";
  # };
}
