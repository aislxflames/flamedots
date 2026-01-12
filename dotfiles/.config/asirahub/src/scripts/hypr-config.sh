#!/bin/bash
# Hyprland config selector script

conf_dir="$HOME/.config/hypr/conf"
TERMINAL="kitty"

if [ ! -d "$conf_dir" ]; then
    notify-send "󰒓 Hyprland Config" "Config directory not found: $conf_dir"
    exit 1
fi

# Get all directories in conf folder
config_dirs=""
for dir in "$conf_dir"/*; do
    if [ -d "$dir" ]; then
        dir_name=$(basename "$dir")
        config_dirs="$config_dirs󰉋  $dir_name\n"
    fi
done

config_dirs=$(echo -e "$config_dirs" | grep -v "^$" | sort)

if [ -z "$config_dirs" ]; then
    notify-send "󰒓 Hyprland Config" "No config directories found"
    exit 1
fi

selected_dir=$(echo -e "$config_dirs" | rofi -dmenu -i -p "󰒓 Select Config Type" -theme ./menu-theme.rasi)

if [ -n "$selected_dir" ]; then
    # Remove icon from selection
    selected_dir=$(echo "$selected_dir" | sed 's/^󰉋  //')
    # Get all .conf files in selected directory
    conf_files="󰝒  Create Config\n"
    selected_path="$conf_dir/$selected_dir"
    
    for file in "$selected_path"/*.conf; do
        if [ -f "$file" ]; then
            file_name=$(basename "$file")
            if [[ "$file_name" == custom-* ]]; then
                conf_files="$conf_files󰈙  $file_name\n"
            else
                conf_files="$conf_files󰈙  $file_name\n"
            fi
        fi
    done
    
    conf_files=$(echo -e "$conf_files" | grep -v "^$")
    
    # Sort but keep Create Config at top
    create_line=$(echo -e "$conf_files" | grep "Create Config")
    other_files=$(echo -e "$conf_files" | grep -v "Create Config" | sort)
    conf_files="$create_line\n$other_files"
    
    if [ -z "$conf_files" ]; then
        notify-send "󰒓 Hyprland Config" "No .conf files found in $selected_dir"
        exit 1
    fi
    
    selected_file=$(echo -e "$conf_files" | rofi -dmenu -i -p "󰒓 Select $selected_dir Config" -theme ./menu-theme.rasi)
    
    if [ -n "$selected_file" ]; then
        # Remove icon from selection
        selected_file=$(echo "$selected_file" | sed 's/^󰈙  //; s/^󰝒  //')
        
        if [ "$selected_file" = "Create Config" ]; then
            # Handle config creation
            create_option=$(echo -e "Empty\nTemplate" | rofi -dmenu -i -p "󰝒 Create Type" -theme ./menu-theme.rasi)
            
            if [ "$create_option" = "Empty" ]; then
                config_name=$(echo "" | rofi -dmenu -i -p "󰝒 Config Name" -theme ./menu-theme.rasi)
                if [ -n "$config_name" ]; then
                    new_file="$selected_path/custom-$config_name.conf"
                    editor_choice=$(echo -e "nvim\nnano" | rofi -dmenu -i -p "󰷈 Choose Editor" -theme ./menu-theme.rasi)
                    $TERMINAL -e $editor_choice "$new_file"
                fi
            elif [ "$create_option" = "Template" ]; then
                # Show template files (non-custom files)
                template_files=""
                for file in "$selected_path"/*.conf; do
                    if [ -f "$file" ]; then
                        file_name=$(basename "$file")
                        if [[ "$file_name" != custom-* ]]; then
                            template_files="$template_files󰈙  $file_name\n"
                        fi
                    fi
                done
                
                template_choice=$(echo -e "$template_files" | rofi -dmenu -i -p "󰝒 Select Template" -theme ./menu-theme.rasi)
                if [ -n "$template_choice" ]; then
                    template_name=$(echo "$template_choice" | sed 's/^󰈙  //')
                    config_name=$(echo "" | rofi -dmenu -i -p "󰝒 Config Name" -theme ./menu-theme.rasi)
                    if [ -n "$config_name" ]; then
                        new_file="$selected_path/custom-$config_name.conf"
                        cp "$selected_path/$template_name" "$new_file"
                        editor_choice=$(echo -e "nvim\nnano" | rofi -dmenu -i -p "󰷈 Choose Editor" -theme ./menu-theme.rasi)
                        $TERMINAL -e $editor_choice "$new_file"
                    fi
                fi
            fi
        elif [[ "$selected_file" == custom-* ]]; then
            # Handle custom file actions
            action=$(echo -e "Execute\nEdit\nDelete" | rofi -dmenu -i -p "󰈙 $selected_file" -theme ./menu-theme.rasi)
            
            case $action in
                "Execute")
                    # Update the corresponding .conf file
                    config_name=$(echo "$selected_dir" | sed 's/s$//')
                    main_conf="$conf_dir/$config_name.conf"
                    
                    if [ -f "$main_conf" ]; then
                        sed -i "s|source = ~/.config/hypr/conf/$selected_dir/.*\.conf|source = ~/.config/hypr/conf/$selected_dir/$selected_file|" "$main_conf"
                        notify-send "󰒓 Hyprland Config" "Updated $config_name.conf with $selected_file"
                    else
                        notify-send "󰒓 Hyprland Config" "Main config file not found: $main_conf"
                    fi
                    ;;
                "Edit")
                    editor_choice=$(echo -e "nvim\nnano" | rofi -dmenu -i -p "󰷈 Choose Editor" -theme ./menu-theme.rasi)
                    $TERMINAL -e $editor_choice "$selected_path/$selected_file"
                    ;;
                "Delete")
                    rm "$selected_path/$selected_file"
                    notify-send "󰒓 Hyprland Config" "Deleted $selected_file"
                    ;;
            esac
        else
            # Handle regular config files
            config_name=$(echo "$selected_dir" | sed 's/s$//')
            main_conf="$conf_dir/$config_name.conf"
            
            if [ -f "$main_conf" ]; then
                sed -i "s|source = ~/.config/hypr/conf/$selected_dir/.*\.conf|source = ~/.config/hypr/conf/$selected_dir/$selected_file|" "$main_conf"
                notify-send "󰒓 Hyprland Config" "Updated $config_name.conf with $selected_file"
            else
                notify-send "󰒓 Hyprland Config" "Main config file not found: $main_conf"
            fi
        fi
    fi
fi
