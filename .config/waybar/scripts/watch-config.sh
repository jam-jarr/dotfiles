#!/bin/bash

# Waybar Configuration Watcher
# Watches for changes in waybar config files and automatically reloads waybar
# Run manually from terminal: ~/.config/waybar/scripts/watch-config.sh

WAYBAR_DIR="${HOME}/.config/waybar"
PIDFILE="/tmp/waybar-watch.pid"
LAST_RELOAD_FILE="/tmp/waybar-watch-last"
DEBOUNCE_SECONDS=1

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log() {
    echo -e "${BLUE}[$(date '+%Y-%m-%d %H:%M:%S')]${NC} $1"
}

log_info() {
    log "${GREEN}INFO${NC} $1"
}

log_warn() {
    log "${YELLOW}WARN${NC} $1"
}

log_error() {
    log "${RED}ERROR${NC} $1"
}

cleanup() {
    log_info "Shutting down waybar watcher..."
    rm -f "$PIDFILE" "$LAST_RELOAD_FILE"
    exit 0
}

# Handle Ctrl+C and other termination signals
trap cleanup SIGINT SIGTERM EXIT

check_existing_watcher() {
    if [[ -f "$PIDFILE" ]]; then
        local pid
        pid=$(cat "$PIDFILE" 2>/dev/null || true)
        if [[ -n "$pid" ]] && kill -0 "$pid" 2>/dev/null; then
            log_warn "Another watcher is running (PID: $pid)"
            log_warn "Stop it before starting a new one."
            exit 1
        fi
    fi
}

check_dependencies() {
    if ! command -v inotifywait &> /dev/null; then
        log_error "inotifywait not found. Install inotify-tools."
        exit 1
    fi
}

check_waybar_dir() {
    if [[ ! -d "$WAYBAR_DIR" ]]; then
        log_error "Waybar config not found: $WAYBAR_DIR"
        exit 1
    fi
}

reload_waybar() {
    # Check debounce using a file to store last reload time
    local current_time now elapsed
    current_time=$(date +%s)
    
    if [[ -f "$LAST_RELOAD_FILE" ]]; then
        now=$(cat "$LAST_RELOAD_FILE" 2>/dev/null || echo 0)
        elapsed=$((current_time - now))
        if [[ $elapsed -lt $DEBOUNCE_SECONDS ]]; then
            return 0
        fi
    fi
    
    # Update last reload time
    echo "$current_time" > "$LAST_RELOAD_FILE"
    
    log_info "Reloading waybar..."
    
    if pgrep -x waybar > /dev/null 2>&1; then
        killall waybar 2>/dev/null || true
        sleep 0.5
    fi
    
    waybar &
    log_info "Waybar reloaded"
}

should_reload() {
    local file="$1"
    # Only watch relevant file types
    [[ "$file" =~ \.(jsonc|css|sh)$ ]] || return 1
    # Skip temporary files
    [[ "$file" =~ \.(swp|swo|tmp)$ ]] && return 1
    [[ "$file" =~ (~|#.*#)$ ]] && return 1
    return 0
}

watch_config() {
    log_info "Starting waybar watcher"
    log_info "Watching: $WAYBAR_DIR"
    log_info "Press Ctrl+C to stop"
    echo ""
    
    echo $$ > "$PIDFILE"
    
    # Initial start
    reload_waybar
    
    # Process events using process substitution instead of pipe
    # This avoids the subshell variable scoping issue
    while IFS= read -r line; do
        # Parse the output: path event time
        local file event
        file=$(echo "$line" | awk '{print $1}')
        event=$(echo "$line" | awk '{print $2}')
        
        if should_reload "$file"; then
            log_info "Change: $file ($event)"
            reload_waybar
        fi
    done < <(inotifywait -m \
        -r \
        -e modify,close_write,moved_to,create,delete \
        --format '%w%f %e %T' \
        --timefmt '%H:%M:%S' \
        "$WAYBAR_DIR" 2>/dev/null)
}

main() {
    check_dependencies
    check_waybar_dir
    check_existing_watcher
    watch_config
}

main "$@"
