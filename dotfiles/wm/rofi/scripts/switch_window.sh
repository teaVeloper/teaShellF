#!/bin/bash
# no window class in this version
# # Get the list of visible windows with names
# windows=$(xdotool search --onlyvisible --name "" getwindowname %@ | awk 'NF')
#
# # Use Rofi to select a window
# selected=$(echo "$windows" | rofi -dmenu -i -p "Switch to window:")
#
# # Extract the window ID from the selected line
# window_id=$(xdotool search --onlyvisible --name "$selected")
#
# # Switch to the selected window
# if [ -n "$window_id" ]; then
#   xdotool windowactivate "$window_id"
# fi

# Get the list of visible windows with names and their classes
windows=$(xdotool search --onlyvisible --name "" | while read -r id; do
  name=$(xdotool getwindowname "$id")
  class=$(xprop -id "$id" WM_CLASS | awk -F '"' '{print $4}')
  if [ -n "$name" ] && [ -n "$class" ]; then
    echo "$class - $name | $id"
  fi
done)

# Use Rofi to select a window
selected=$(echo "$windows" | rofi -dmenu -i -p "Switch to window:")

# Extract the window ID from the selected entry using the last occurrence of '|'
window_id=$(echo "$selected" | awk -F'|' '{print $NF}' | xargs)

# Switch to the selected window
if [ -n "$window_id" ]; then
  xdotool windowactivate "$window_id"
else
  echo "Invalid window ID: $window_id"
fi
