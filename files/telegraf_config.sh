#!/bin/bash -x 
# configure telegraf
grep -q opvizor\.com /etc/telegraf/telegraf.conf 
if [ $? -ne 0 ]
then

APIKEY_PROPERTY=$(vmtoolsd --cmd "info-get guestinfo.ovfEnv" | grep "guestinfo.opvizor")

  if [ -n "${APIKEY_PROPERTY}" ] 
  then
  
    # backup initial configuration
    cp /etc/telegraf/telegraf.conf /etc/telegraf/telegraf.conf.orig
  
    APIKEY_HEADER="$(echo "${APIKEY_PROPERTY}" | awk -F 'oe:value="' '{print $2}' | awk -F '"' '{print $1}')"
  
    # check if provided key have correct permission
    curl -X 'GET' -v -o /tmp/auth_check.result 'https://cloud.opvizor.com/api/v1/auth/check?permission=integration_list' -H 'accept: application/json'  -H 'X-API-Key: '$APIKEY_HEADER''
  
    grep -q '"authorized":true' /tmp/auth_check.result

    if [ $? -eq 0 ]
    then
      # download  
      curl -X 'POST' --no-progress-meter -o /etc/telegraf/telegraf.conf  'https://cloud.opvizor.com/api/v1/integrate/download' -H 'accept: text/plain'  -H 'Content-Type: application/json'  -d '{ "name": "Linux integration" }'   -H 'X-API-Key: '$APIKEY_HEADER''
  
  
    fi
  
  
  fi
  
fi


