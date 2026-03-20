# SSH Port Forwarding Functions

# Forward a port on localhost to a remote host
fip() {
  (($# < 2)) && echo "Usage: fip <host> <port1> [port2] ..." && return 1
  local host="$1"
  shift
  for port in "$@"; do
    ssh -f -N -L "$port:localhost:$port" "$host" && echo "Forwarding localhost:$port -> $host:$port"
  done
}

# Stop forwarding a port on localhost to a remote host
dip() {
  (($# == 0)) && echo "Usage: dip <port1> [port2] ..." && return 1
  for port in "$@"; do
    pkill -f "ssh.*-L $port:localhost:$port" && echo "Stopped forwarding port $port" || echo "No forwarding on port $port"
  done
}

# List active forwards
lip() {
  pgrep -af "ssh.*-L [0-9]+:localhost:[0-9]+" || echo "No active forwards"
}
