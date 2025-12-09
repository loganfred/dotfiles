setxkbmap -option caps:swapescape
exec ~/source/status_bar.sh &
feh --bg-center ~/Downloads/snake.png
xrandr --output HDMI-0 --mode 1920x1200 --rotate right --left-of DP-0 --output DP-3 --mode 1920x1200 --above DP-0
xset dpms $(expr 5 \* 60) $(expr 45 \* 60) $(expr 90 \* 60)
xset s off
dunst &
xbindkeys &
xscreensaver &
exec dwm
