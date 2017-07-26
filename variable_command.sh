#!/bin/bash


#======================================
# Define the Matrix and its Size
#   M[ IP, cmdVar]

declare -A M
numIP=2
numVAR=3



#======================================
# Define Matrix Values
#   M[ IP, cmdVar]

M[0,0]="ip1"
M[0,1]="A"
M[0,2]="B"
M[0,3]="C"

M[1,0]="ip2"
M[1,1]="D"
M[1,2]="E"
M[1,3]="F"



#======================================
# Run the command for each IP (host)

for ((i=0;i<=numIP-1;i++)) do
  file="test"$((i+1))".txt"
  echo "The command variables for ${M[$i,0]}:  \
        ${M[$i,1]} ${M[$i,2]} ${M[$i,3]}" >> $file
  cat $file
  rm $file
done


