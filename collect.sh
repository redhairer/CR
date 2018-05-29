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
      ixpdimm-cli version 		>> $CONFIG
      printf "AEP FW VERSION:\n"	>> $CONFIG
      ixpdimm-cli show -dimm 		>> $CONFIG
      printf "AEP BSR:\n"		>> $CONFIG
      ixpdimm-cli show -d bootstatus -dimm >> $CONFIG
      printf "AEP TOPOLOGY:\n"		>> $CONFIG
      ixpdimm-cli show -topology 	>> $CONFIG
      printf "AEP MEMORY RESOURCE:\n"	>> $CONFIG
      ixpdimm-cli show -memoryresources >> $CONFIG
      printf "AEP SYSTEM CAPABILITY:\n"	>> $CONFIG
      ixpdimm-cli show -system -capabilities >> $CONFIG
      printf "AEP GOAL:\n"		>> $CONFIG
      ixpdimm-cli show -goal 		>> $CONFIG
      printf "AEP POOL:\n"		>> $CONFIG
      ixpdimm-cli show -pool 		>> $CONFIG
      printf "AEP NAMESPACE:\n"		>> $CONFIG
      ixpdimm-cli show -namespace	>> $CONFIG
      printf "AEP PCD:\n"		>> $CONFIG
      ixpdimm-cli show -dimm -pcd	>> $CONFIG
      
      # Get smbios
      dmidecode > ./$DIR/dmidecode_$VALUE.log
      
      # Get e820/system map from dmesg
      dmesg > ./$DIR/dmesg_$VALUE.log
      
      # Get memory resource with cli
      ixpdimm-cli show -memoryresources > ./$DIR/memoryresources_$VALUE.log
      
      # Get NFIT/PCAT/HMAT 
      cat /sys/firmware/acpi/tables/NFIT > ./$DIR/nfit_$VALUE.aml
      iasl -d ./$DIR/nfit_$VALUE.aml
      cat /sys/firmware/acpi/tables/PCAT > ./$DIR/pcat_$VALUE.aml
      iasl -d ./$DIR/pcat_$VALUE.aml
      cat /sys/firmware/acpi/tables/HMAT > ./$DIR/hmat_$VALUE.aml
      iasl -d ./$DIR/hmat_$VALUE.aml
      
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
