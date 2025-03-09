#!/bin/bash
set -e
cp /root/start /data/ro
cp /root/stop /data/ro
exec "$@"
