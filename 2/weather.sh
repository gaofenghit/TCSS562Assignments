#!/bin/bash

cd `dirname $0`
set -eu

key=ac63672a3ce44460831b60b5294f47e3

res=""

if [ ! -f ".myipaddr" ]
then
  echo "CALLING API TO QUERY MY IP"
#  loc=`curl -u $TOKEN: ipinfo.io 2>/dev/null | jq '.loc' | sed 's/\"//g'`
  loc=`curl ipinfo.io 2>/dev/null | jq '.loc' | sed 's/\"//g'`
  lat=`echo $loc | awk -F ',' '{print $1}'`
  lon=`echo $loc | awk -F ',' '{print $2}'`
  url="curl -s https://api.weatherbit.io/v2.0/forecast/daily?&key=${key}&lat=${lat}&lon=${lon}"
  res=`$url`
  echo $res > .myipaddr
else
  echo "IP READ FROM CACHE"
  res=`cat .myipaddr`
fi

lat=`echo $res | jq '.| .lat'`
lon=`echo $res | jq '.| .lon'`

echo "Forecast for my lat=${lat}, lon=${lon}"

echo $res | jq -r '.data[] | "Forecast for \(.valid_date) HI: \(.min_temp)°c LOW: \(.max_temp)°c" ' 



