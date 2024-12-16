#!/usr/bin/env bash

# Create a local dump from remote DB URL with pg_dump
#
# Use:
#
#     create_local_dump_from_remote -n edge_alpha -u "postgres://luna_api:Z2N5a7c0M*9bAAwSImLZj*qvrBcarR@dev-francisco-alpha-edge-10-07t14-09.ctvhkhbiykgu.us-west-2.rds.amazonaws.com:5432/luna_api_staging"
function create_local_dump_from_remote() {
  if [[ "$#" -eq 0 ]] || [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: restore_db_from_dump -n <dump_name> -u <url>"
    echo ""
    echo "Important:"
    echo "  Disable history expansion to prevent issues with ! in the password. Disable with: set +H"
    echo ""
    echo "Options:"
    echo "  -n <dump_name>    Specify the dump file name."
    echo "  -u <url>          Specify the remote URL to create the dumb from."
    echo "  -h, --help        Display this help message."

    return 0
  fi

  while [[ $# -gt 0 ]]; do
    case $1 in
      -n) dump_name="$2"; shift 2 ;;
      -u) url="$2"; shift 2 ;;
      -*) echo "Invalid option: $1" >&2; return 1 ;;
      *) echo "Unknown argument: $1" >&2; return 1 ;;
    esac
  done

  current_date=$(date +'%Y_%m_%d')

  user=$(echo $url | sed -E 's/^postgres:\/\/([^:]+):.*@.*$/\1/')
  password=$(echo $url | sed -E 's/^postgres:\/\/[^:]+:([^@]+)@.*$/\1/')
  host=$(echo $url | sed -E 's/^postgres:\/\/[^@]+@([^:]+):.*$/\1/')
  port=$(echo $url | sed -E 's/^postgres:\/\/[^@]+@[^:]+:([0-9]+)\/.*$/\1/')
  dbname=$(echo $url | sed -E 's/^postgres:\/\/[^@]+@[^\/]+\/(.*)$/\1/')

  output_path="$HOME/Downloads/$dump_name"_"$current_date"

  echo $user
  echo $password
  echo $host
  echo $port
  echo $dbname
  echo $output_path

  export PGPASSWORD="${password}"

  pg_dump -h $host -U $user -p $port -f $output_path $dbname

  unset PGPASSWORD

  # Reactiva la expansión de historial
  set -H
}
