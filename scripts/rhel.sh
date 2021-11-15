#!/bin/bash
# set the offline token and checksum parameters
offline_token="eyJhbGciOiJIUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJhZDUyMjdhMy1iY2ZkLTRjZjAtYTdiNi0zOTk4MzVhMDg1NjYifQ.eyJpYXQiOjE2MzU3NzI1MTQsImp0aSI6ImExMmNhZDZlLTE3ZTAtNGExYi04MWM3LWMxYTA0Y2FjYjdhZCIsImlzcyI6Imh0dHBzOi8vc3NvLnJlZGhhdC5jb20vYXV0aC9yZWFsbXMvcmVkaGF0LWV4dGVybmFsIiwiYXVkIjoiaHR0cHM6Ly9zc28ucmVkaGF0LmNvbS9hdXRoL3JlYWxtcy9yZWRoYXQtZXh0ZXJuYWwiLCJzdWIiOiJmOjUyOGQ3NmZmLWY3MDgtNDNlZC04Y2Q1LWZlMTZmNGZlMGNlNjppdHMtaXNoYW5zaGFybWEiLCJ0eXAiOiJPZmZsaW5lIiwiYXpwIjoicmhzbS1hcGkiLCJzZXNzaW9uX3N0YXRlIjoiZThiZGU2ODQtYmRhYS00MzI2LWIyZWUtZjE0ZGVkNTdlZDgzIiwic2NvcGUiOiJvZmZsaW5lX2FjY2VzcyJ9.JFN288LKcr6WIzhhaoGvsjqB_piyMu0BZxztpfcSi6s"
checksum=1f78e705cd1d8897a05afa060f77d81ed81ac141c2465d4763c0382aa96cadd0

# get an access token
access_token=$(curl https://sso.redhat.com/auth/realms/redhat-external/protocol/openid-connect/token -d grant_type=refresh_token -d client_id=rhsm-api -d refresh_token=$offline_token | jq -r '.access_token')

# get the filename and download url
image=$(curl -H "Authorization: Bearer $access_token" "https://api.access.redhat.com/management/v1/images/$checksum/download")
filename=$(echo $image | jq -r .body.filename)
url=$(echo $image | jq -r .body.href)

# download the file
curl $url -o $filename
