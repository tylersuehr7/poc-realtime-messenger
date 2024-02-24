#!/bin/sh

echo "Making migrations + migrate database…"
python3 manage.py makemigrations
python3 manage.py migrate

echo "Checking if database is already initialized…"
python3 manage.py runscript database_initialize_checker

if [ $? -eq 1 ]
then
echo "Initializing database…"
python3 manage.py flush --no-input
python3 manage.py collectstatic --no-input --clear
python3 manage.py createsuperuser --no-input
python3 manage.py runscript database_initialize
python3 manage.py loaddata templates/admin_interface_theme.json
fi

exec "$@"