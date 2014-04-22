# Set the working application directory
# working_directory "/path/to/your/app"
working_directory "/var/www/journeys"

# Unicorn PID file location
# pid "/path/to/pids/unicorn.pid"
pid "/var/www/journeys/current/pids/unicorn.pid"

# Path to logs
stderr_path "/var/www/journeys/current/log/unicorn.log"
stdout_path "/var/www/journeys/current/log/unicorn.log"

# Unicorn socket
listen "/tmp/unicorn.journeys.sock"

# Number of processes
worker_processes 2

# Time-out
timeout 30
