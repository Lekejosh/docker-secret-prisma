#!/bin/sh

# Function to read a secret and export it as an environment variable
read_secret() {
  local secret_name=$1
  local env_var_name=$2
  local secret_path="/run/secrets/${secret_name}"
  
  if [ -f "${secret_path}" ]; then
    export ${env_var_name}=$(cat "${secret_path}")
  else
    echo "Secret file ${secret_path} not found"
    exit 1
  fi
}

# Read secrets and export them as environment variables

# Read the database URL from the secret file
read_secret "db_url" "DATABASE_URL"

# Start the application
npm run start
