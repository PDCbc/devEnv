#!/bin/bash
#
# Exit on errors or unitialized variables
#
set -e -o nounset


# Vagrant SSH starts in the Vagrant (synchronized) folder
#
if (! grep --quiet 'cd /vagrant/' /home/vagrant/.bashrc )
then
  (
    echo
    echo
    echo '# Start in Vagrant (sync) directory'
    echo '#'
    echo 'cd /vagrant/'
  ) | tee -a /home/vagrant/.bashrc
fi


# Update clock (skews when VM put to sleep)
#
if (! grep --quiet 'ca.pool.ntp.org' /home/vagrant/.bashrc )
then
  (
    echo
    echo
    echo '# Fix for Vagrant clock skew'
    echo '#'
    echo "sudo ntpdate ca.pool.ntp.org"
  ) | tee -a /home/vagrant/.bashrc
fi


# Update and install packages
#
apt-get update
apt-get install -y \
  build-essential \
  curl \
  git \
  lynx
apt-get autoremove -y


# Create a list of subdirs (non-hidden) and run any Makefiles
#
cd /vagrant/
PROJECTS=$(find . -maxdepth 1 -type d -not -name ".*")
echo Project subdirectories found: $PROJECTS
#
for p in $PROJECTS
do
  cd $p
  test ! -e Makefile || make                # Either no Makefile OR run Makefile
  cd ..
done
