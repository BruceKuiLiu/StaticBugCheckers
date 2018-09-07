#!/bin/bash

# Author: Andrew Habib
# Created on: 31 August 2018

[[ ! "${#BASH_SOURCE[@]}" -gt "1" ]] && { source ./scripts/config.sh; }

echo
echo ">>> Downloading the Defects4J framework <<<"

git clone -q https://github.com/rjust/defects4j.git

# This is the original pull request (pr) #112 used in the study.
# However, many of the additional projects (not in the official d4j), have wrong d4j properties
# and they don't compile right away. For the study, we have manually fixed all these errors.
# But adding our ad-hoc fixes to the pr is not easy and is not our goal as it is unofficial anyways.
# One alternative is to either restrict the reproduction to the original d4j. 
# Or use a different and more recent (hopefully cleaner) pull requests such as pr #174
# NOTE: depending on which version is used, python/CheckoutD4j.py should be updated accordingly.
# as it now has the list of Defects projects identifiers and number of bugs encoded manually.
(cd $D4J_ROOT \
	&& git fetch -q origin pull/112/head:extendedD4J \
	&& git checkout -q extendedD4J \
	&& ./init.sh > /dev/null 2>&1 \
)

echo
echo ">>> Checking out and compiling the Defects4J dataset <<<"

python3 ${PY_SCRIPTS_ROOT}/CheckoutD4j.py ${D4J_ROOT} b ${JOBS} > /dev/null 2>&1
python3 ${PY_SCRIPTS_ROOT}/CheckoutD4j.py ${D4J_ROOT} f ${JOBS} > /dev/null 2>&1

#python3 ${PY_SCRIPTS_ROOT}/TryAllCompileD4J.py ${D4J_ROOT}/b $JOBS
#python3 ${PY_SCRIPTS_ROOT}/TryAllCompileD4J.py ${D4J_ROOT}/f $JOBS