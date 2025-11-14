#!/usr/bin/env bash

# To change between several AWS accounts configured in `~/.aws/config`
#
# Example:
#
#    $ setaws alpha
setaws() {
  if [ $# -eq 0 ]
  then
    echo "No arguments supplied"
    echo "Example: setaws alpha"
  else
    echo "Exporting aws profiles to: $1"
    export AWS_PROFILE=$1
  fi
}

# Convierte un hash de Ruby con credenciales de create_new_auth_token
# en cabeceras HTTP para usar en peticiones GQL desde Postman
#
# Ejemplo:
#
#    ruby_hash='{"access-token"=>"eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJjYTkyZDQwOC1kZjdlLTRiYWUtOTJhMS01ODc0Y2VhYmJlZDQiLCJpYXQiOjE3NDM1MTYwMTh9.dgtHGQEBVnKL6Vok1-jkf3X1okoWnFQmoTBvjXpnhRA", "token-type"=>"Bearer", "client"=>"kPaUWyE92m9eq_q7J20lWg", "expiry"=>"1803516018", "uid"=>"steve+nt@getluna.com", "Authorization"=>"Bearer eyJhY2Nlc3MtdG9rZW4iOiJleUpoYkdjaU9pSklVekkxTmlKOS5leUp6ZFdJaU9pSmpZVGt5WkRRd09DMWtaamRsTFRSaVlXVXRPVEpoTVMwMU9EYzBZMlZoWW1KbFpEUWlMQ0pwWVhRaU9qRTNORE0xTVRZd01UaDkuZGd0SEdRRUJWbktMNlZvazEtamtmM1gxb2tvV25GUW1vVEJ2alhwbmhSQSIsInRva2VuLXR5cGUiOiJCZWFyZXIiLCJjbGllbnQiOiJrUGFVV3lFOTJtOWVxX3E3SjIwbFdnIiwiZXhwaXJ5IjoiMTgwMzUxNjAxOCIsInVpZCI6InN0ZXZlK250QGdldGx1bmEuY29tIn0="}'
#
#    headers_from_ruby_hash "$ruby_hash"
#
# Nota como el hash está en una sola línea. Y clave envolver la variable entre comilla doble.
function headers_from_ruby_hash() {
  # Usar un here-string para evitar problemas con comillas
  ruby_hash=$(cat <<< "$1")

  # Convertir hash Ruby a JSON válido de manera más robusta
  json=$(echo "$ruby_hash" | \
         sed -E 's/=>/:/g' | \
         sed -E 's/: *"/:"/g' | \
         sed -E 's/^\{|\}$//g' | \
         awk '{$1=$1;print}' | \
         sed 's/^/{/' | sed 's/$/}/' | \
         jq '.' 2>/dev/null)

  if [[ $? -ne 0 ]]; then
    echo "Error: No se pudo convertir el hash Ruby a JSON válido." >&2
    echo "Input recibido:" >&2
    echo "$ruby_hash" >&2
    return 1
  fi

  # Convertir JSON a cabeceras HTTP
  echo "$json" | jq -r 'to_entries[] | "\(.key): \(.value)"'
}

# Este hace lo mismo que headers_from_ruby_hash() pero usa Ruby para cargar el Hash y volverlo JSON.
function headers_from_hash_with_ruby() {
  echo "$1" | \
  ruby -r json -e 'puts eval(ARGF.read).to_json' | \
  jq -r 'to_entries[] | "\(.key): \(.value)"'
}

## Convert JSON to one-liner
#
# Usage:
#     json_oneliner [FILE]
#     cat file.json | json_oneliner
function json_oneliner() {
  if [[ $# -eq 0 ]]; then
    jq -c .
  else
    jq -c . "$1"
  fi
}
