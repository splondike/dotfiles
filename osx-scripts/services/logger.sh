#/bin/sh

log_base=$HOME/.cache/services-log/
service_name=$(dirname $1)
log_dir="$log_base/$service_name"
mkdir -p $log_dir

exec s6-log T $log_dir
