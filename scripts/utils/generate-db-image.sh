#!/bin/bash

# Load environment variables
source .env

# Function to generate database image string
generate_db_image() {
    local db_type="$1"
    local db_version="$2"
    
    case "$db_type" in
        "MySQL"|"mysql")
            echo "mysql:${db_version}"
            ;;
        "MariaDB"|"mariadb")
            echo "mariadb:${db_version}"
            ;;
        *)
            echo "mysql:8.0"  # Default fallback
            ;;
    esac
}

# Generate database image for local development
LOCAL_DB_IMAGE=$(generate_db_image "$DEV_DB_TYPE" "$DEV_DB_VERSION")

# Update .env with generated image
if grep -q "^DB_IMAGE=" .env; then
    # Update existing DB_IMAGE
    sed -i.bak "s/^DB_IMAGE=.*/DB_IMAGE=${LOCAL_DB_IMAGE}/" .env
else
    # Add DB_IMAGE if it doesn't exist
    echo "DB_IMAGE=${LOCAL_DB_IMAGE}" >> .env
fi

echo "✅ Generated database image: ${LOCAL_DB_IMAGE}"
echo "📝 Updated .env with DB_IMAGE=${LOCAL_DB_IMAGE}"

# Cleanup backup file
rm -f .env.bak
