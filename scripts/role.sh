#!/usr/bin/env bash

# res=$(psql postgres -t -A -c 'show transaction_read_only;' 2>/dev/null || echo 'off')
# if [ $res == 'off' ]; then
#   echo 'M'
# else
#   echo 'R'
# fi
