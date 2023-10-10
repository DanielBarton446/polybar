#!/bin/bash

function listen {
    firstrun=0
    flipped=0
    echo "DOING SOMETHING"

    pactl subscribe 2>/dev/null | {
        while true; do 
            {
                if [ $firstrun -eq 0 ]
                then
                    firstrun=1
                    continue
                else
                    read -r event 
                    if echo "$event" | grep -e "remove" -e "new"
                    then
                        flipped=1
                    elif echo "$event" | grep -e "change" && [ flipped -eq 1 ]
                    then
                        flipped=0
                        break
                    fi
                    # white space is SUPER important here
                    if ! echo "$event" | grep -e "on sink " | grep "change"
                    then
                        # Avoid double events
                        flipped=0
                        continue
                    fi
                fi
            } &>/dev/null
            restart_bars
        done
    }
}

function restart_bars {
  # this will update the sinks for the bars
  echo "Switch"
  # polybar-msg cmd restart
}

listen
