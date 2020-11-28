#!/usr/bin/env bash
set -e

echo "Configure MySQL: $RAILS_APP_NAME"
cd $RAILS_APP_NAME

# Automatically setup & start MySQL server when nix-shell starts
mv shell{,.orig}.nix
head -n -1 shell.orig.nix > shell.nix

cat <<EOS >>shell.nix
shellHook = ''
  MYSQL_HOME=$HOME/$RAILS_APP_NAME/tmp/mysql
  MYSQL_DATA=\$MYSQL_HOME/data
  export MYSQL_UNIX_PORT=\$MYSQL_HOME/mysql.sock

  mkdir -p \$MYSQL_HOME

  if [ ! -d \$MYSQL_DATA ]; then
    echo 'MySQL: Installing system tables...'
    mysqld --initialize-insecure --datadir=\$MYSQL_DATA
    echo 'MySQL: ...done'
  fi

  if ! mysqladmin status --user=root
  then
    echo 'MySQL: Starting server...'
    mysqld_safe --datadir=\$MYSQL_DATA &
    while ! mysqladmin status --user=root; do
      sleep 1
    done
    echo 'MySQL: ...done'
  fi
'';
}
EOS
