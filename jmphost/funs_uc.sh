#!/bin/bash
#
# Author:  Trung Thai, tt2189@att.com
#
# Purpose:  Common shared functions defined and used on jumphost server.
#

# Author  Krishna Venkata, kv988c@att.com
#
# Purpose - kubectl wrapper providing some of overwriting behavior from Kubectl
# when users to exectute into utility container.

declare -frx kubectl

function kubectl() {
if [[ $* == *"exec"* ]] && [[ $* == *"bash"* ]]; then
   aft_bash=`echo "$*" | awk -F'bash' '{print $2}'`
   bef_bash=`echo "$*" | awk -F'bash' '{print $1}'`
   if [[ -z  $aft_bash ]]; then
      if [[ $* == *"--"* ]]; then
         `which kubectl` $bef_bash bash -c "export AUSER=$USER;bash;"
      else
         `which kubectl` $bef_bash -- bash -c "export AUSER=$USER;bash;"
      fi
   else
      command=`echo $aft_bash | cut -d' ' -f2-`
      `which kubectl` $bef_bash bash -c "export AUSER=$USER;$command;"
   fi
elif [[ $* == *"exec"* ]] && [[ $* == *"sh"* ]]; then
   aft_sh=`echo "$*" | awk -F'sh' '{print $2}'`
   bef_sh=`echo "$*" | awk -F'sh' '{print $1}'`
   if [[ -z  $aft_sh ]]; then
      if [[ $* == *"--"* ]]; then
         `which kubectl` $bef_sh sh -c "export AUSER=$USER;sh;"
      else
         `which kubectl` $bef_sh -- sh -c "export AUSER=$USER;sh;"
      fi
   else
      command=`echo $aft_sh | cut -d' ' -f2-`
      `which kubectl` $bef_sh sh -c "export AUSER=$USER;$command;"
   fi
elif [[ $* == *"exec"* ]] && [[ $* == *"nccli"* ]]; then
   aft_nccli=`echo "$*" | awk -F'nccli' '{print $2}'`
   bef_nccli=`echo "$*" | awk -F'nccli' '{print $1}'`
   if [[ -z  $aft_nccli ]]; then
      echo "Invalid Command"
   else
      if [[ $* == *"--"* ]]; then
         `which kubectl` $bef_nccli bash -c "export AUSER=$USER;nccli $aft_nccli;"
      else
         `which kubectl` $bef_nccli -- bash -c "export AUSER=$USER;nccli $aft_nccli;"
      fi
   fi
else
   `which kubectl` $*
fi
}