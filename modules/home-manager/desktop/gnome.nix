{...}: {
  dconf = {
    enable = true;
    settings."org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      accent-color = "orange";
      clock-format = "12h";
      clock-show-seconds = true;
      clock-show-weekday = true;
    };
  };
}
