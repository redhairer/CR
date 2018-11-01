#!/bin/bash
#
# 20170621
# redhairer collect data script
#


function usage()
{
    echo ""
    echo "./collect.sh"
    echo -e "\t-h --help"
    echo -e "\t-d=[FOLDER NAME]"
    echo ""
}

while [ "$1" != "" ]; do
  PARAM=`echo $1 | awk -F= '{print $1}'`
  VALUE=`echo $1 | awk -F= '{print $2}'`
 
  case $PARAM in
    #Help msg
    -h | --help)
      usage
      exit
      ;;

    #Dump data
    -d)
      NOW=$(date +"%Y%m%d_%H%M%S")
      echo "TIME: "$NOW
      
      DIR="$NOW"_"$VALUE"
      echo "FOLDER NAME: "$DIR
      
      mkdir $DIR
      
      CONFIG=./$DIR/config.log
      
      # Get config
      printf "TIME: $NOW\n\n"		> $CONFIG
      printf "KERNEL VERSION:\n"	>> $CONFIG
      uname -a 				>> $CONFIG
      printf "\n" 			>> $CONFIG
      printf "BIOS VERSION:\n"		>> $CONFIG
      dmidecode -s bios-version 	>> $CONFIG
      printf "\n" 			>> $CONFIG
      printf "IXPDIMM CLI VERSION:\n"	>> $CONFIG
      ipmctl version 		>> $CONFIG
      printf "\n" 			>> $CONFIG
      printf "DCPMM FW VERSION:\n"	>> $CONFIG
      ipmctl show -dimm 		>> $CONFIG
      printf "\n" 			>> $CONFIG
      printf "DCPMM BSR:\n"		>> $CONFIG
      ipmctl show -d bootstatus -dimm >> $CONFIG
      printf "\n" 			>> $CONFIG
      printf "DCPMM TOPOLOGY:\n"		>> $CONFIG
      ipmctl show -topology 	>> $CONFIG
      printf "\n" 			>> $CONFIG
      printf "DCPMM MEMORY RESOURCE:\n"	>> $CONFIG
      ipmctl show -memoryresources >> $CONFIG
      printf "\n" 			>> $CONFIG
      printf "DCPMM SYSTEM CAPABILITY:\n"	>> $CONFIG
      ipmctl show -system -capabilities >> $CONFIG
      printf "\n" 			>> $CONFIG
      printf "DCPMM GOAL:\n"		>> $CONFIG
      ipmctl show -goal 		>> $CONFIG
      printf "\n" 			>> $CONFIG
      printf "DCPMM REGION:\n"		>> $CONFIG
      ipmctl show -region 		>> $CONFIG
      printf "\n" 			>> $CONFIG
      printf "DCPMM NAMESPACE:\n"		>> $CONFIG
      ndctl list	>> $CONFIG
      printf "\n" 			>> $CONFIG
      printf "DCPMM PCD:\n"		>> $CONFIG
      ipmctl show -dimm -pcd	>> $CONFIG
      
      # Get smbios
      dmidecode > ./$DIR/dmidecode_$VALUE.log
      
      # Get e820/system map from dmesg
      dmesg > ./$DIR/dmesg_$VALUE.log
      
      
      # Get SRAT/NFIT/PCAT/HMAT 
      cat /sys/firmware/acpi/tables/SRAT > ./$DIR/srat_$VALUE.aml
      iasl -d ./$DIR/srat_$VALUE.aml
      cat /sys/firmware/acpi/tables/SLIT > ./$DIR/slit_$VALUE.aml
      iasl -d ./$DIR/slit_$VALUE.aml
      cat /sys/firmware/acpi/tables/NFIT > ./$DIR/nfit_$VALUE.aml
      iasl -d ./$DIR/nfit_$VALUE.aml
      ipmctl show -system nfit > ./$DIR/nfit_$VALUE.log
      cat /sys/firmware/acpi/tables/PCAT > ./$DIR/pcat_$VALUE.aml
      iasl -d ./$DIR/pcat_$VALUE.aml
      ipmctl show -system pcat > ./$DIR/pcat_$VALUE.log
      cat /sys/firmware/acpi/tables/HMAT > ./$DIR/hmat_$VALUE.aml
      iasl -d ./$DIR/hmat_$VALUE.aml
      cat /sys/firmware/acpi/tables/PMTT > ./$DIR/pmtt_$VALUE.aml
      iasl -d ./$DIR/pmtt_$VALUE.aml
      ipmctl show -system pmtt > ./$DIR/pmtt_$VALUE.log
      
      # Get meminfo
      cat /proc/meminfo > ./$DIR/meminfo_$VALUE.log
  
      # Get pmem device
      ls /dev/pmem* 	> ./$DIR/pmem_$VALUE.log
      lsblk		>> ./$DIR/pmem_$VALUE.log

      echo ""
      echo ""
      echo "========================"
      echo "====== config.log ======"
      echo "========================"
      echo ""
      echo ""
      cat $CONFIG
      echo "TIME: "$NOW
      echo "FOLDER NAME: "$DIR

      exit
      ;;

    *)
      echo ""
      echo "ERROR: unknown parameter"
      usage
      exit 1
      ;;
  esac
done
