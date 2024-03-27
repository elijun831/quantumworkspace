#!/bin/bash

envsubst < /app/nginx.conf > /etc/nginx/nginx.conf
nginx
