#!/bin/bash
dev=(`lspci|grep -E '(2042|2046|204a)'| awk '{print $1}'`)

for (( i = 0 ; i < ${#dev[@]} ; i++))
do
  echo ${dev[$i]}
  lspci -s ${dev[$i]} -xxxx|grep 150:
done
