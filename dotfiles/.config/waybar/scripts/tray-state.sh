#!/bin/bash

if [[ -f "/tmp/waybar_tray_toggle" ]]; then
    echo '{"text": "", "alt": "expanded"}'
else
    echo '{"text": "", "alt": "collapsed"}'
fi
