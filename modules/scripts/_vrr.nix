{pkgs}:
pkgs.writeShellApplication {
  name = "vrrcheck";

  # Ensure BOTH libnotify and niri (or whatever package provides the niri binary)
  # are available to the script environment
  runtimeInputs = with pkgs; [libnotify];

  text = ''
    # Run niri and parse the output safely
    vrr_status=$(niri msg outputs | awk '
      # Detect when we enter or leave the DP-3 output block
      /^Output/ {
        if ($0 ~ /\(DP-3\)/) { in_dp3=1 } else { in_dp3=0 }
      }

      # Only extract the status if we are firmly inside the DP-3 section
      in_dp3 && /Variable refresh rate:/ {
        sub(/^.*Variable refresh rate:[ \t]*/, "")
        print $0
        # Removed "exit" to prevent breaking the pipe early
      }
    ')

    # Trim any accidental whitespace/newlines
    vrr_status=$(echo "$vrr_status" | xargs)

    # echo "Detected status: '$vrr_status'"

    # Send a desktop notification pop-up
    if [[ -z "$vrr_status" ]]; then
        notify-send "VRR Status" "DP-3 monitor not found or status empty."
    elif [[ "$vrr_status" == *"enabled"* ]]; then
        notify-send "VRR Status" "VRR is ENABLED on DP-3"
    else
        notify-send "VRR Status" "VRR is DISABLED on DP-3"
    fi
  '';
}
