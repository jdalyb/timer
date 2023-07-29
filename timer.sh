#!/usr/bin/bash

# Define normal color function
function normal_color() {
    # Set gamma channels to normal
    xgamma -gamma 1.0
}

# Define funky color function
function funky_color() {
    # Change these values (1-10) to adjust color for red, green, and blue gamma channels
    xgamma -rgamma 2.0 -ggamma 1.0 -bgamma 1.0
}

# Define set temporary normal color function
function start() {
  echo "Normal colors for 20 minutes. Press CTRL+C to end."  # Say how long there will be normal color.
  normal_color                    # Restore color back to normal
  sleep 1200                      # Wait 20 minutes
  funky_color                     # Change the display back to funky color
}

# Define general temporary normal color function
function t() {
    if [[ "$1" =~ ^[0-9]+$ ]]; then           # If it's a valid number,
        local duration=$(60 * $1)             # multiply the number by 60 so that it's in minutes.
        echo $'\nNormal colors for '$1' minute(s). Press CTRL+C to end.'      # Say how long there will be normal color.
        normal_color                          # Restore color back to normal
        sleep "$duration"                     # Wait for just about the number of minutes entered
        funky_color                           # Change the display back to funky color
    else
        echo "Invalid input. Please provide a valid number."  # Error message
    fi
}

# Define the signal handler function for interrupt (Ctrl+C)
interrupt_handler() {
    normal_color
    echo $'\nEnded timer. Run ./timer.sh to restart.'
    exit 1
}

# Set up the signal handler to catch the interrupt signal (SIGINT)
trap interrupt_handler SIGINT

# Start display with funky colors
funky_color
echo $'\nRun SPACE to get 20 minutes of normal colors.
Run \'t x\' to get x minutes of normal colors.
Press CTRL+C to get normal colors and end.\n'

# loop:
while true; do
read -r input
if [[ "$input" =~ ^[[:space:]]*$ ]]; then
  start
elif [[ "$input" =~ ^t[[:space:]]+[0-9]+$ ]]; then  # if i enter "t", space and a number x from 0-120,
  duration="${input#t }"                            # multiply that number x by 60 (trnslating from seconds to minute)
  t "$duration"                                     # and give me normal colors for that duration.
else
  echo $'\nInvalid command. The options are:
Run SPACE to get normal colors for 20 minutes.
Run \'t x\' to get normal colors for x minutes.
Press CTRL+C to get normal colors and end.\n'
fi
done
