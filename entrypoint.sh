#!/bin/sh -l

cd /home/cmsusr

set  -e

echo "Setting up CMSSSW_4_2_8"
source /opt/cms/cmsset_default.sh
scramv1 project CMSSW CMSSW_4_2_8
cd CMSSW_4_2_8/src
eval `scramv1 runtime -sh`
echo "CMSSW_4_2_8 is at your service."


git clone git://github.com/katilp/CastorDataValidation.git

mv CastorDataValidation/CMSSW_additional_packages.tar .
tar -xvf CMSSW_additional_packages.tar

scram b

cd CastorDataValidation/Commissioning10Analyzer/

cmsRun analyzer_cfg_Commissioning10.py
cmsRun analyzer_cfg_Comm10MC.py

ls -l

cd ../Plots/

python drawValidationPlots_Commissioning10.py
ls -l *.pdf

sudo chown -R cmsusr /github/workspace
chmod 755 /github/workspace
cp *.pdf /github/workspace

echo "::set-output name=my_output::CASTOR_test_Commissioning10.root"
