#!/bin/sh

set -v

heroku pgbackups:capture
curl -o latest.dump `heroku pgbackups:url`
pg_restore --verbose --clean --no-acl --no-owner -h localhost -U myuser -d mydb COLOR_54d4041969702d0295380301.dump
rm latest.dump
