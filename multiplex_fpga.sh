#!/bin/bash
################################################################################
#  multiplex_fpga.sh
#  --------------------
#  - Creates tmux session with 16 synced panes
#  - Starts ssh sessions defined by "ports" array
#
#  author:    jeSager
#  modified:  Sun Jul 30 18:46:36 EDT 2017
#
################################################################################

echo

#======================================
# No nesting tmux: PUNT
if [ ! -z $TMUX ]; then
  echo "  *************************************************"
  echo "  * ERROR:                                        *"
  echo "  *   Please exit tmux before running this script *"
  echo "  *                                               *"
  echo "  *************************************************"
  echo
  exit
fi

#======================================
# Require tmux
if [ -z $(which tmux) ]; then
  echo "  *************************************************"
  echo "  * ERROR:                                        *"
  echo "  *   This script requires tmux.  Good-bye.       *"
  echo "  *                                               *"
  echo "  *************************************************"
  echo
  exit
fi


#======================================
# IFF tmux is NOT open, do all this ...

echo "  *************************************************"
echo "  *    This script will open 16 terminal panes    *"
echo "  * MAXIMIZE YOUR TERMINAL TO AVOID COMPLICATIONS *"
echo "  *              <ENTER> to continue              *"
echo "  *                                               *"
echo "  *************************************************"
read


#======================================
# Create ports array
ports=(00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15)



#======================================
# Create session and detach
tmux new-session -s fpga -d



#======================================
# Keys for:  sync, zoom, killall, nextpane, mouse(on)
#    Notes:  - Does not sync while zoomed
#            - Mouse param is for newest tmux version
tmux bind-key -n F2 setw synchronize-panes
tmux bind-key -n F12 resize-pane -Z
tmux bind-key -n F9 confirm-before kill-session
tmux bind-key -n C-o select-pane -t :.+
tmux set -g mouse on



#======================================
# Set up panes equally
tmux split -v
tmux split -v
tmux split -v
tmux select-pane -t 0
tmux split -h
tmux split -h
tmux split -h
tmux select-pane -t 4
tmux split -h
tmux split -h
tmux split -h
tmux select-pane -t 8
tmux split -h
tmux split -h
tmux split -h
tmux select-pane -t 12
tmux split -h
tmux split -h
tmux split -h
tmux select-layout tiled      # equally
tmux select-pane -t 0



#======================================
# SSH in each pane
for i in $(seq 0 $(( ${#ports[@]}-1 ))); do
  port=${ports[i]}
  cmd="ssh -p222"$port" linaro@127.0.0.1"
  tmux send-keys "$cmd"
# uncommenting below will auto-press enter
#  tmux send-keys C-m
  tmux select-pane -t :.+
done



#======================================
# Initialze-sync and Attach
# tmux select-pane -t 0
tmux send-keys C-L
tmux setw synchronize-panes
tmux attach -t fpga


clear
echo
echo " ***************************************************"
echo " * The multiplex_fpga script ended successfully    *"
echo " *                                                 *"
echo " ***************************************************"
echo



