#!/bin/bash

# Check number of parameters
if [[ "$#" -ne 2 ]]; then
    echo "Usage: ${0} <USERNAME> <PASSWORD>" >&2
    exit 2
fi

# Check for xidel
if ! which xidel >/dev/null; then
    echo "The xidel app need for run this script! (https://www.videlibri.de/xidel.html#downloads)" >&2
    exit 2
fi

# Set parameters
USERNAME=${1}
PASSWORD=${2}
COOKIE="/tmp/ihead.cookie"
URL="https://www.ihead.ru/users"

# Delete old cookies and LogIn
rm -f ${COOKIE} && \
curl -s -X POST \
  --data-raw "next=https://www.ihead.ru/users/&action=login&login=${USERNAME}&passw=${PASSWORD}&bindToIP=1&btnSubmit=войти" \
  -b ${COOKIE} -c ${COOKIE} \
  ${URL}/enter.html > /dev/null

# Fetch data
curl -s \
  -b ${COOKIE} -c ${COOKIE} \
  ${URL}/ \
| xidel -s --xpath '/html/body/table[4]/tbody/tr[1]/td[2]/table/tbody/tr/td[3]/a' - \
| paste -sd+ \
| bc

# LogOut
curl -s \
  -b ${COOKIE} -c ${COOKIE} \
  ${URL}/enter.html?action=exit;next=http://www.ihead.ru/
