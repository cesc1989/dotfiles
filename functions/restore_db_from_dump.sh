#!/usr/bin/env bash

# Restore (create) local DB from dumped file after running `create_local_dump_from_remote` function
#
# Use:
#
#    restore_db_from_dump -d luna_api_development_X -f ~/Downloads/edge_dump_xxxx
function restore_db_from_dump() {
  if [[ "$#" -eq 0 ]] || [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: restore_db_from_dump -d <dbname> -f <dump_file>"
    echo "Options:"
    echo "  -d <dbname>       Specify the database name."
    echo "  -f <dump_file>    Specify the dump file to restore from."
    echo "  -h, --help        Display this help message."

    return 0
  fi

  while [[ $# -gt 0 ]]; do
    case $1 in
      -d) dbname="$2"; shift 2 ;;
      -f) dump_file="$2"; shift 2 ;;
      -*) echo "Invalid option: $1" >&2; return 1 ;;
      *) echo "Unknown argument: $1" >&2; return 1 ;;
    esac
  done

  echo "Empieza a cargar el dump"
  psql $dbname --host localhost --username francisco < $dump_file
  echo "Terminó de cargarse el dump"
}
