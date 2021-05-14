#!/bin/bash
echo "TEST"
voms-proxy-info --all
ls -l
echo "DONE"
export PATH=${PATH}:/cvmfs/cms.cern.ch/common
export CMS_PATH=/cvmfs/cms.cern.ch

source /cvmfs/cms.cern.ch/cmsset_default.sh
tar -xzf CMSSW_10_6_12.tar.gz
rm -fv CMSSW_10_6_12.tar.gz
export SCRAM_ARCH=slc7_amd64_gcc700
cd CMSSW_10_6_12/
scramv1 b ProjectRename
eval `scram runtime -sh`
cd ../
#cp ../../*.C .
#cp ../../*.list .
#ls -la
#ls la ../../
echo $1
echo $2
echo $3
echo $4
echo $5
echo $6

 if [[ $6 == "HistTreeCut" ]]
 then
  HistTreeCut -s $1 -a $2 -i $3 -o $4 -n $5
 else
  AppendTrees -s $1 -a $2 -i $3 -o $4 -n $5
 fi
#DrawPUhist -s $1 -a $2 -i $3 -o $4 -n $5
#ROIdrawer -s $1 -a $2 -i $3 -o $4 -n $5
