#!/bin/bash
. ./xbash.sh

APP_TITLE="Demo XBash"
APP_VERSION="0.1"
DEFAULT_COLOR="cyan2"

function __info() { #%nSee info
    # Info
    e "$(ecolor green)Script name: $(script_file_name)"
    e "$(ecolor red)Path: $(current_directory_name)"
    e "Date and time: $(now_date_time)"
        
    # Pause script
    pause
    
    # Check root
    if [ $(is_root) = $TRUE ] ; then
        e "$(ecolor red)ROOT$(ecolor green) user"
    else
        e "$(ecolor green)No $(ecolor red)ROOT$(ecolor green) user"
    fi
}

function __params() { # param1 %nparam1: Text to print.
    e "Text passed: $(ecolor red) '$1'"
}

# Run
run $@
