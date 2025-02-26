#!/bin/bash

# script to set random background wallpapers on my GNOME desktop
# set base path
export wallpaper_path=$HOME/Wallpapers
shopt -s nullglob

# shuffle function for the wallpapers
shuffle() {
    local i tmp size max rand

   # $RANDOM % (i+1) is biased because of the limited range of $RANDOM
   # Compensate by using a range which is a multiple of the array size.
   size=${#wallpapers[*]}
   max=$(( 32768 / size * size ))

   for ((i=size-1; i>0; i--)); do
       while (( (rand=$RANDOM) >= max )); do :; done
       rand=$(( rand % (i+1) ))
       tmp=${wallpapers[i]} wallpapers[i]=${wallpapers[rand]} wallpapers[rand]=$tmp
   done
}

# store all the image file names in wallpapers array
wallpapers=(
    "$wallpaper_path"/*.jpg
    "$wallpaper_path"/*.jpeg
    "$wallpaper_path"/*.png
    "$wallpaper_path"/*.bmp
    "$wallpaper_path"/*.svg
)
# get array length
wallpapers_size=${#wallpapers[*]}

# randomly shuffle the wallpapers at start up
shuffle

# set wallpapers in incremental order
index=0
while [ $index -lt $wallpapers_size ]
do
    gsettings set org.gnome.desktop.background picture-uri "${wallpapers[$index]}"
    //starting
    wal -i "${wallpapers[$index]}"
    # Extract colors from pywal's ~/.cache/wal/colors file
    color1=$(cat ~/.cache/wal/colors | sed -n '1p')
    color2=$(cat ~/.cache/wal/colors | sed -n '2p')
    color3=$(cat ~/.cache/wal/colors | sed -n '3p')
    color4=$(cat ~/.cache/wal/colors | sed -n '4p')
    color5=$(cat ~/.cache/wal/colors | sed -n '5p')
    color6=$(cat ~/.cache/wal/colors | sed -n '6p')
    color7=$(cat ~/.cache/wal/colors | sed -n '7p')
    color8=$(cat ~/.cache/wal/colors | sed -n '8p')
    
    # Update CAVA's config file
    sed -i "s/gradient_color_1 = .*/gradient_color_1 = '$color1'/" ~/.config/cava/config
    sed -i "s/gradient_color_2 = .*/gradient_color_2 = '$color2'/" ~/.config/cava/config
    sed -i "s/gradient_color_3 = .*/gradient_color_3 = '$color3'/" ~/.config/cava/config
    sed -i "s/gradient_color_4 = .*/gradient_color_4 = '$color4'/" ~/.config/cava/config
    sed -i "s/gradient_color_5 = .*/gradient_color_5 = '$color5'/" ~/.config/cava/config
    sed -i "s/gradient_color_6 = .*/gradient_color_6 = '$color6'/" ~/.config/cava/config
    sed -i "s/gradient_color_7 = .*/gradient_color_7 = '$color7'/" ~/.config/cava/config
    sed -i "s/gradient_color_8 = .*/gradient_color_8 = '$color8'/" ~/.config/cava/config
    
    # Rest art CAVA to apply the new gradient
    pkill cava
    cava &
    //waybar
    killall waybar
    waybar
    //ending
    # index is maxing out, so reset it
    if [ $(($index+1)) -eq $wallpapers_size ]
    then
        index=0
    else
        index=$(($index + 1))
    fi
    # keep the wallpaper for the specified time
    sleep 600m
done
