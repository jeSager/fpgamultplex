#!/bin/bash
################################################################################
#  dispatch_commands.sh
#  --------------------
#  - Creates tmux session with 16 synced panes
#  - Starts ssh sessions defined by "hosts" array
#  - Note: script assumes passwordless login is setup
#
################################################################################



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
# IFF tmux is NOT open, do all this ...



#======================================
# Create hosts array
hosts=(\
  user@12.12.12.12 \
  user@13.13.13.13 \
  user@14.14.14.14 \
)



#======================================
# Create session and detach
tmux new-session -s fpga -d



#======================================
# Keys for:  sync, zoom, killall
#    Note:  does not sync while zoomed
tmux bind-key -n F2 setw synchronize-panes
tmux bind-key -n F12 resize-pane -Z
tmux bind-key -n F9 confirm-before kill-session



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
for i in $(seq 0 ${#hosts[@]}); do
  host=${hosts[i]}
  tmux send-keys ${host}
  tmux select-pane -t :.+
done



#======================================
# Initialze-sync and Attach
tmux select-pane -t 0
tmux setw synchronize-panes
tmux attach -t fpga



echo " ***************************************************"
echo " * The dispatch_commands script ended successfully *"
echo " *                                                 *"
echo " ***************************************************"
echo



