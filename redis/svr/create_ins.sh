#!/bin/bash
ins_no=$1
core_no=$2
redis_port=6380
current_redis_port=0

#kill all redis server
pkill redis-server
sleep 10
wait
#Clear OS cache
sync
echo 3 >/proc/sys/vm/drop_caches


#set -x #echo on

#for i in {0..27} {56..83}
#for i in {28..55} {84..111}
#for i in {1..47}
for (( i=0; i<$ins_no; i++))
do
    current_redis_port=$((redis_port + i))
    echo $current_redis_port
    numactl --physcpubind=$i,$((i+core_no*2)) --localalloc redis-server --port $current_redis_port --protected-mode no --save "" &
    #numactl --physcpubind=$i --localalloc redis-server --port $current_redis_port --protected-mode no --save "" &
    #taskset -c $i redis-server --port $current_redis_port  --protected-mode no &
done

sleep 10
#set +x #echo off   
