{...}: {
  dconf = {
    enable = true;
    settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
    settings."org/gnome/desktop/interface".accent-color = "orange";
    settings."org/gnome/desktop/interface".clock-format = "12h";
    settings."org/gnome/desktop/interface".clock-show-seconds = true;
    settings."org/gnome/desktop/interface".clock-show-weekday = true;
  };
}
