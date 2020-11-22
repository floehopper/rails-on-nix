#!/usr/bin/env bash
set -e

echo "Configure PostgreSQL: $RAILS_APP_NAME"
cd /vagrant/$RAILS_APP_NAME

# Automatically setup & start PostgreSQL server when nix-shell starts
mv shell{,.orig}.nix
head -n -1 shell.orig.nix > shell.nix

cat <<EOS >>shell.nix
shellHook = ''
  export PGHOST=\$HOME/postgres
  export PGDATA=\$PGHOST/data
  export PGDATABASE=postgres
  export PGLOG=\$PGHOST/postgres.log

  mkdir -p \$PGHOST

  if [ ! -d \$PGDATA ]; then
    initdb --auth=trust --no-locale --encoding=UTF8
  fi

  if ! pg_ctl status
  then
    pg_ctl start -l \$PGLOG -o "--unix_socket_directories='\$PGHOST'"
  fi
'';
}
EOS
