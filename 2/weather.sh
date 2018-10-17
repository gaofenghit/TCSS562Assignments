#!/bin/bash
#  Author: Feng Gao                                            #
#  git clone https://github.com/gaofenghit/TCSS562Assignments  #
#                                                              #
################################################################

cd `dirname $0`
set -eu

key=ac63672a3ce44460831b60b5294f47e3
res=""

if [ ! -f ".myipaddr" ]
then
  echo "CALLING API TO QUERY MY IP"
  res=`curl ipinfo.io 2>/dev/null`
  echo $res > .myipaddr
else
  echo "IP READ FROM CACHE"
  res=`cat .myipaddr`
fi

loc=`echo $res | jq '.loc' | sed 's/\"//g'`
lat=`echo $loc | awk -F ',' '{print $1}'`
lon=`echo $loc | awk -F ',' '{print $2}'`
url="curl -s -g https://api.weatherbit.io/v2.0/forecast/daily?&key=${key}&lat=${lat}&lon=${lon}"
res=`$url`

echo "Forecast for my lat=${lat}°, lon=${lon}°"
echo $res | jq -r '.data[] | "Forecast for \(.valid_date) HI: \(.max_temp)°c LOW: \(.min_temp)°c" ' 

