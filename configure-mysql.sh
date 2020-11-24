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
    mysql_install_db --datadir=\$MYSQL_DATA
    echo 'MySQL: ...done'
  fi

  if ! mysqladmin status
  then
    echo 'MySQL: Starting server...'
    mysqld --datadir=\$MYSQL_DATA &
    while ! mysqladmin status; do
      sleep 1
    done
    echo 'MySQL: ...done'

    echo 'MySQL: Setting password for root user on localhost...'
    mysql -e "SET PASSWORD FOR 'root'@'localhost' = PASSWORD(''');"
    echo 'MySQL: ...done'
  fi
'';
}
EOS
