mkdir -p ~/.local/share/mpd/playlists
touch ~/.local/share/mpd/database 

systemctl --user enable --now mpd

