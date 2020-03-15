#!/bin/bash
set -e
rm -f /usr/src/household_account_book/tmp/pids/server.pid
exec "$@"