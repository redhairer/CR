#!/bin/bash

read_tsod()
{
#CPU0 Channel 0-3
echo "CPU0 Channel 0-3"
ipmitool -b 6 -t 0x2c raw 0x2E 0x4B 0x57 0x01 0x00 0x00 0x33 0x33 0x00 0x00 0x00 0x00 0x00 0x00

#CPU0 Channel 4-5
echo "CPU0 Channel 4-7"
ipmitool -b 6 -t 0x2c raw 0x2E 0x4B 0x57 0x01 0x00 0x40 0x33 0x00 0x00 0x00 0x00 0x00 0x00 0x00

#CPU1 Channel 0-3
echo "CPU1 Channel 0-3"
ipmitool -b 6 -t 0x2c raw 0x2E 0x4B 0x57 0x01 0x00 0x00 0x00 0x00 0x33 0x33 0x00 0x00 0x00 0x00

#CPU1 Channel 4-5
echo "CPU1 Channel 4-7"
ipmitool -b 6 -t 0x2c raw 0x2E 0x4B 0x57 0x01 0x00 0x40 0x00 0x00 0x33 0x00 0x00 0x00 0x00 0x00

}

send_mailbox_cmd()
{
	echo "Identify DIMM (01h)/Identify (00h)"
	echo "S0 IMC0 CH0 DIMM0"
	ipmitool -b 6 -t 0x2c raw 0x2E  0x49 0x57 0x01 0x00 0x00 0x00 0x01 0x00 0x00 0x00 0x24 0x8
	ipmitool -b 6 -t 0x2c raw 0x2E  0x4a 0x57 0x01 0x00 0x00
	echo "S0 IMC0 CH0 DIMM1"
	ipmitool -b 6 -t 0x2c raw 0x2E  0x49 0x57 0x01 0x00 0x00 0x08 0x01 0x00 0x00 0x00 0x24 0x8
	ipmitool -b 6 -t 0x2c raw 0x2E  0x4a 0x57 0x01 0x00 0x00
	echo "S0 IMC0 CH1 DIMM0"
	ipmitool -b 6 -t 0x2c raw 0x2E  0x49 0x57 0x01 0x00 0x00 0x10 0x01 0x00 0x00 0x00 0x24 0x8
	ipmitool -b 6 -t 0x2c raw 0x2E  0x4a 0x57 0x01 0x00 0x00
	echo "S0 IMC0 CH1 DIMM1"
	ipmitool -b 6 -t 0x2c raw 0x2E  0x49 0x57 0x01 0x00 0x00 0x18 0x01 0x00 0x00 0x00 0x24 0x8
	ipmitool -b 6 -t 0x2c raw 0x2E  0x4a 0x57 0x01 0x00 0x00
	echo "S0 IMC0 CH2 DIMM0"
	ipmitool -b 6 -t 0x2c raw 0x2E  0x49 0x57 0x01 0x00 0x00 0x20 0x01 0x00 0x00 0x00 0x24 0x8
	ipmitool -b 6 -t 0x2c raw 0x2E  0x4a 0x57 0x01 0x00 0x00
	echo "S0 IMC0 CH2 DIMM1"
	ipmitool -b 6 -t 0x2c raw 0x2E  0x49 0x57 0x01 0x00 0x00 0x28 0x01 0x00 0x00 0x00 0x24 0x8
	ipmitool -b 6 -t 0x2c raw 0x2E  0x4a 0x57 0x01 0x00 0x00
	echo "S0 IMC1 CH0 DIMM0"
	ipmitool -b 6 -t 0x2c raw 0x2E  0x49 0x57 0x01 0x00 0x00 0x40 0x01 0x00 0x00 0x00 0x24 0x8
	ipmitool -b 6 -t 0x2c raw 0x2E  0x4a 0x57 0x01 0x00 0x00
	echo "S0 IMC1 CH0 DIMM1"
	ipmitool -b 6 -t 0x2c raw 0x2E  0x49 0x57 0x01 0x00 0x00 0x48 0x01 0x00 0x00 0x00 0x24 0x8
	ipmitool -b 6 -t 0x2c raw 0x2E  0x4a 0x57 0x01 0x00 0x00
	echo "S0 IMC1 CH1 DIMM0"
	ipmitool -b 6 -t 0x2c raw 0x2E  0x49 0x57 0x01 0x00 0x00 0x50 0x01 0x00 0x00 0x00 0x24 0x8
	ipmitool -b 6 -t 0x2c raw 0x2E  0x4a 0x57 0x01 0x00 0x00
	echo "S0 IMC1 CH1 DIMM1"
	ipmitool -b 6 -t 0x2c raw 0x2E  0x49 0x57 0x01 0x00 0x00 0x58 0x01 0x00 0x00 0x00 0x24 0x8
	ipmitool -b 6 -t 0x2c raw 0x2E  0x4a 0x57 0x01 0x00 0x00
	echo "S0 IMC1 CH2 DIMM0"
	ipmitool -b 6 -t 0x2c raw 0x2E  0x49 0x57 0x01 0x00 0x00 0x60 0x01 0x00 0x00 0x00 0x24 0x8
	ipmitool -b 6 -t 0x2c raw 0x2E  0x4a 0x57 0x01 0x00 0x00
	echo "S0 IMC1 CH2 DIMM1"
	ipmitool -b 6 -t 0x2c raw 0x2E  0x49 0x57 0x01 0x00 0x00 0x68 0x01 0x00 0x00 0x00 0x24 0x8
	ipmitool -b 6 -t 0x2c raw 0x2E  0x4a 0x57 0x01 0x00 0x00
	echo "S1 IMC0 CH0 DIMM0"
	ipmitool -b 6 -t 0x2c raw 0x2E  0x49 0x57 0x01 0x00 0x00 0x01 0x01 0x00 0x00 0x00 0x24 0x8
	ipmitool -b 6 -t 0x2c raw 0x2E  0x4a 0x57 0x01 0x00 0x00
	echo "S1 IMC0 CH0 DIMM1"
	ipmitool -b 6 -t 0x2c raw 0x2E  0x49 0x57 0x01 0x00 0x00 0x09 0x01 0x00 0x00 0x00 0x24 0x8
	ipmitool -b 6 -t 0x2c raw 0x2E  0x4a 0x57 0x01 0x00 0x00
	echo "S1 IMC0 CH1 DIMM0"
	ipmitool -b 6 -t 0x2c raw 0x2E  0x49 0x57 0x01 0x00 0x00 0x11 0x01 0x00 0x00 0x00 0x24 0x8
	ipmitool -b 6 -t 0x2c raw 0x2E  0x4a 0x57 0x01 0x00 0x00
	echo "S1 IMC0 CH1 DIMM1"
	ipmitool -b 6 -t 0x2c raw 0x2E  0x49 0x57 0x01 0x00 0x00 0x19 0x01 0x00 0x00 0x00 0x24 0x8
	ipmitool -b 6 -t 0x2c raw 0x2E  0x4a 0x57 0x01 0x00 0x00
	echo "S1 IMC0 CH2 DIMM0"
	ipmitool -b 6 -t 0x2c raw 0x2E  0x49 0x57 0x01 0x00 0x00 0x21 0x01 0x00 0x00 0x00 0x24 0x8
	ipmitool -b 6 -t 0x2c raw 0x2E  0x4a 0x57 0x01 0x00 0x00
	echo "S1 IMC0 CH2 DIMM1"
	ipmitool -b 6 -t 0x2c raw 0x2E  0x49 0x57 0x01 0x00 0x00 0x29 0x01 0x00 0x00 0x00 0x24 0x8
	ipmitool -b 6 -t 0x2c raw 0x2E  0x4a 0x57 0x01 0x00 0x00
	echo "S1 IMC1 CH0 DIMM0"
	ipmitool -b 6 -t 0x2c raw 0x2E  0x49 0x57 0x01 0x00 0x00 0x41 0x01 0x00 0x00 0x00 0x24 0x8
	ipmitool -b 6 -t 0x2c raw 0x2E  0x4a 0x57 0x01 0x00 0x00
	echo "S1 IMC1 CH0 DIMM1"
	ipmitool -b 6 -t 0x2c raw 0x2E  0x49 0x57 0x01 0x00 0x00 0x49 0x01 0x00 0x00 0x00 0x24 0x8
	ipmitool -b 6 -t 0x2c raw 0x2E  0x4a 0x57 0x01 0x00 0x00
	echo "S1 IMC1 CH1 DIMM0"
	ipmitool -b 6 -t 0x2c raw 0x2E  0x49 0x57 0x01 0x00 0x00 0x51 0x01 0x00 0x00 0x00 0x24 0x8
	ipmitool -b 6 -t 0x2c raw 0x2E  0x4a 0x57 0x01 0x00 0x00
	echo "S1 IMC1 CH1 DIMM1"
	ipmitool -b 6 -t 0x2c raw 0x2E  0x49 0x57 0x01 0x00 0x00 0x59 0x01 0x00 0x00 0x00 0x24 0x8
	ipmitool -b 6 -t 0x2c raw 0x2E  0x4a 0x57 0x01 0x00 0x00
	echo "S1 IMC1 CH2 DIMM0"
	ipmitool -b 6 -t 0x2c raw 0x2E  0x49 0x57 0x01 0x00 0x00 0x61 0x01 0x00 0x00 0x00 0x24 0x8
	ipmitool -b 6 -t 0x2c raw 0x2E  0x4a 0x57 0x01 0x00 0x00
	echo "S1 IMC1 CH2 DIMM1"
	ipmitool -b 6 -t 0x2c raw 0x2E  0x49 0x57 0x01 0x00 0x00 0x69 0x01 0x00 0x00 0x00 0x24 0x8
	ipmitool -b 6 -t 0x2c raw 0x2E  0x4a 0x57 0x01 0x00 0x00
}

read_tsod
send_mailbox_cmd


