#!/usr/bin/env bash

## Author : Aislx
#
## Rofi   : Launcher (Modi Drun, Run, File Browser, Window)
#
dir="$HOME/.config/rofi/launchers/Vertical"
theme='theme'

## Run
rofi \
    -show drun \
    -theme ${dir}/${theme}.rasi
