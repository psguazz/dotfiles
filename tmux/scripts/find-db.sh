#!/usr/bin/env bash

db=""

if [ -f "./config/database.yml" ]; then
  db=$(grep -A5 '^development:' './config/database.yml' | grep 'database:' | awk '{print $2}')
fi

if [ -z "$db" ]; then
  sqlite_file=$(find . -maxdepth 2 -name "*.sqlite3" -type f | head -1)
  if [ -n "$sqlite_file" ]; then
    db="$sqlite_file"
  fi
fi

if [ -z "$db" ]; then
  sqlit
elif [[ "$db" == *"sqlite3" ]]; then
  sqlit connect sqlite --file-path "$db"
else
  sqlit postgresql://root:foo@localhost:5432/"$db"
fi
