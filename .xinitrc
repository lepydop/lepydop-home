~/.xconfig
(sleep 10; xconfig) &

sudo wauto &
pulseaudio --start &
sudo bluetooth off &
sudo fan auto &
taffybar &

exec xmonad
