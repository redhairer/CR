#!/bin/bash

#folder name
folder_name=$1
#instance number
ins_no=$2
#core per cpu
core_no=$3
#query number
query_no=$4
#server IP
svr_ip=$5

# Server info
IP_ADDR_CPU1=192.168.10.100
IP_ADDR_CPU0=192.168.11.100
redis_port=6380

current_redis_port=0

#set -x #echo on

flushdb()
{
    echo "FLUSHALL START"
    # Clear redis db
    #for i in {0..23}
    #for i in {28..55} {84..111}
    #for i in {28..55}
    for (( i=0; i<$ins_no; i++))
    do
        current_redis_port=$((redis_port + i))
        if [ $i -lt $core_no ]
	then
          redis-cli -h $IP_ADDR_CPU0 -p $current_redis_port flushall &
	else
	  redis-cli -h $IP_ADDR_CPU1 -p $current_redis_port flushall &
	fi
    done

    wait 
    echo "FLUSHALL END"
}

benchmark()
{
    echo "Benchmark START"

    sleep 5
    # start emon
    folder_name+="_set"
    ./expect_emon $folder_name $svr_ip
    sleep 5

    echo "set START"
    #for i in {0..23}
    for (( i=0; i<$ins_no; i++))
    do
        current_redis_port=$((redis_port + i))
        if [ $i -lt $core_no ]
        then
          #redis-benchmark -h $IP_ADDR_CPU0 -p $current_redis_port -t set -d 1024 -n 21000000 -r 21000000 -P 3 -c 5 > $i"_instance_set.log" &
          redis-benchmark -h $IP_ADDR_CPU0 -p $current_redis_port -t set -d 1024 -n $query_no -r $query_no -P 3 -c 5 > $i"_instance_set.log" &
	else
          #redis-benchmark -h $IP_ADDR_CPU1 -p $current_redis_port -t set -d 1024 -n 21000000 -r 21000000 -P 3 -c 5 > $i"_instance_set.log" &
          redis-benchmark -h $IP_ADDR_CPU1 -p $current_redis_port -t set -d 1024 -n $query_no -r $query_no -P 3 -c 5 > $i"_instance_set.log" &
	fi
    done

#    for i in {24..47}
#    do
#        current_redis_port=$((redis_port + i))
#        redis-benchmark -h $IP_ADDR_CPU1 -p $current_redis_port -t set -d 1024 -n 21000000 -r 21000000 -P 3 -c 5 > $i"_instance_set.log" &
#    done

    wait
    echo "set END"

    sleep 5
    ./expect_kill_emon $svr_ip
    sleep 5
    # start emon
    folder_name+="_get"
    ./expect_emon $folder_name $svr_ip
    sleep 5

    echo "get START"
    #for i in {0..23}
    for (( i=0; i<$ins_no; i++))
    do
        current_redis_port=$((redis_port + i))
        if [ $i -lt $core_no ]
        then
          #redis-benchmark -h $IP_ADDR_CPU0 -p $current_redis_port -t get -d 1024 -n 21000000 -r 21000000 -P 3 -c 5 > $i"_instance_get.log" &
          redis-benchmark -h $IP_ADDR_CPU0 -p $current_redis_port -t get -d 1024 -n $query_no -r $query_no -P 3 -c 5 > $i"_instance_get.log" &
        else
          #redis-benchmark -h $IP_ADDR_CPU1 -p $current_redis_port -t get -d 1024 -n 21000000 -r 21000000 -P 3 -c 5 > $i"_instance_get.log" &
          redis-benchmark -h $IP_ADDR_CPU1 -p $current_redis_port -t get -d 1024 -n $query_no -r $query_no -P 3 -c 5 > $i"_instance_get.log" &
        fi
    done


#    for i in {24..47}
#    do
#        current_redis_port=$((redis_port + i))
#        redis-benchmark -h $IP_ADDR_CPU1 -p $current_redis_port -t get -d 1024 -n 21000000 -r 21000000 -P 3 -c 5 > $i"_instance_get.log" &
#    done

    wait
    echo "get END"

    sleep 5
    ./expect_kill_emon $svr_ip
    sleep 5
    echo "Benchmark END"
}


#main function
./expect_create_ins $ins_no $core_no $svr_ip
wait
#./expect_emon $1
#read -p "Confirm emon start, then Press enter to continue"
sleep 5
benchmark

echo "Reuqest No."
#for i in {0..47}
for (( i=0; i<$ins_no; i++))
do
current_redis_port=$((redis_port + i))
#    echo $i"_instance.log"
awk '/requests per second/{ print $1 }' $i"_instance_set.log" >> output_set.log
awk '/requests per second/{ print $1 }' $i"_instance_get.log" >> output_get.log
done

echo "sum"
awk '{sum+= $1};END {print sum}' output_set.log > result_set.log
awk '{sum+= $1};END {print sum}' output_get.log > result_get.log
echo "set"
cat output_set.log
cat result_set.log
echo "get"
cat output_get.log
cat result_get.log

for (( i=0; i<$ins_no; i++))
do
        current_redis_port=$((redis_port + i))

        if [ $i -lt $core_no ]
        then
          redis-cli -h $IP_ADDR_CPU0 -p $current_redis_port info memory > $i"_redis_memory.log"
        else
          redis-cli -h $IP_ADDR_CPU1 -p $current_redis_port info memory > $i"_redis_memory.log"
        fi 
done



mkdir $folder_name
mv *_instance*.log $folder_name
mv *_redis_memory.log $folder_name
mv output_*.log $folder_name
mv result_*.log $folder_name

#./expect_kill_emon 
#read -p "Confirm emon killed, then Press enter to continue"


flushdb
#set +x #echo off
