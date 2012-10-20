#!/bin/bash

wget --quiet http://winhelp2002.mvps.org/hosts.txt -O hosts.txt
HOSTNAMES=`awk '{ if ($1 !~ /#/) print $2 }' hosts.txt | grep -v localhost | grep -v '^$' | tr -d '\r'`
ADDON=`awk '{ if ($1 !~ /#/) print $1 }' badhosts.txt`
BEGIN="auth-zones="
ZONE="=/etc/powerdns/null.zone.file,"

sed -i "/auth-zones=/d" recursor.conf

echo -n ${BEGIN} >> recursor.conf

for i in ${HOSTNAMES}; do
  echo -n ${i}${ZONE} >> recursor.conf
done

for i in ${ADDON}; do
  echo -n ${i}${ZONE} >> recursor.conf
done

/etc/init.d/precursor restart
