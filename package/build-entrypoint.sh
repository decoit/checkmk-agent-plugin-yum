#!/usr/bin/env bash
# CLI steps done like described in https://docs.checkmk.com/latest/en/mkps.html

set -e

SOURCE=/plugin-source
CMK=/omd/sites/cmk

cd $CMK/local

# copy lib
cp -R $SOURCE/lib/check_mk/ ./lib/check_mk/

cd share/check_mk
# copy non-lib
cp -R $SOURCE/agents .
cp -R $SOURCE/checkman .
cp -R $SOURCE/checks .
cp -R $SOURCE/web .

# needed for package config file creation
# has to be done by site user
su - cmk -c "/omd/sites/cmk/bin/check_mk -P create yum"

# modify package config file with correct version number, author etc.
/build-modify-package.py $SOURCE $CMK/var/check_mk/packages/yum

# also to be done by site user is packaging the mkp file
su - cmk -c "/omd/sites/cmk/bin/check_mk -P pack yum"

cat $CMK/var/check_mk/packages/yum

ls -l /omd/sites/cmk