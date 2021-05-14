#!/bin/bash
echo "TEST"

# Some INFO
echo REMOTE_INIT_DIR: $(pwd) WN: $(/bin/hostname -s) Date: $(date +%s)

# OSG CE: REMOTE_INIT_DIR contains '#' which screws up the eval `scram runtime -sh` and we need to move to the worker node temp directory which is
# $TMPDIR=/scratch/local/_SLURM_JOB_ID_ which is dynamic
for f in * ; do /bin/mv $f $TMPDIR/ ; done # move input files to the worker node temp directory
REMOTE_INIT_DIR=$(pwd) # save it for later
cd $TMPDIR

# The followins two lines are needed at UF because there is no grid env on the worker node. We use the one on cvmfs
# sourcing the setup file will provide the path for voms-proxy-info, gfal-copy, etc.
source /cvmfs/oasis.opensciencegrid.org/osg-software/osg-wn-client/current/el7-x86_64/setup.sh
export X509_CERT_DIR=/cvmfs/cms.cern.ch/grid/etc/grid-security/certificates

voms-proxy-info --all
ls -l
echo "DONE"
export PATH=${PATH}:/cvmfs/cms.cern.ch/common
export CMS_PATH=/cvmfs/cms.cern.ch

export SCRAM_ARCH=slc7_amd64_gcc700
source /cvmfs/cms.cern.ch/cmsset_default.sh
tar -xzf CMSSW_10_6_12.tar.gz
rm -fv CMSSW_10_6_12.tar.gz
# This should be set before sourcing cmsset_default.sh export SCRAM_ARCH=slc7_amd64_gcc700
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
#
# Option 1
# Output is produced, we move them to the REMOTE_INIT_DIR so that condor can transfer the output back to the job submission machine
for f in * ; do /bin/mv $f $REMOTE_INIT_DIR ; done
cd $REMOTE_INIT_DIR
ls

# Option 2: Recommended
# gfal-copy $output davs://cmsio5.rc.ufl.edu:1094/store/user/suho/$output
# or 
# gfal-copy $output davs://___fnal___
#
