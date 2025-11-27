#!/bin/sh
set -e

echo "Running wait_for_db.py..."
python wait_for_db.py

echo "Running Flask migrations..."
flask db upgrade || echo "Migration failed or no migrations found."

echo "Starting Flask..."
exec flask run --host=0.0.0.0 --port=5000

