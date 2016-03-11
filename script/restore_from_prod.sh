#!/bin/sh

set -v

heroku pg:backups capture
curl -o latest.dump `heroku pg:backups public-url`
pg_restore --verbose --clean --no-acl --no-owner -h localhost -U myuser -d mydb COLOR_54d4041969702d0295380301.dump
rm latest.dump
