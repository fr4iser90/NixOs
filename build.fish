#!/usr/bin/env fish

# Function to handle script interruption
function on_interrupt --on-signal SIGINT
  echo "Aborting the script."
  exit 0
end

# Execute checkGPU.fish
if test -f ./build/checkGPU.fish
  echo "Running checkGPU.fish..."
  source ./build/checkGPU.fish
else
  echo "checkGPU.fish not found."
  exit 1
end

# Execute envBuilder.fish
if test -f ./build/envBuilder.fish
  echo "Running envBuilder.fish..."
  source ./build/envBuilder.fish
else
  echo "envBuilder.fish not found."
  exit 1
end

# Re-run the script with sudo for the root part
echo "Re-running script with sudo for root operations..."
exec sudo fish ./build_root.fish
