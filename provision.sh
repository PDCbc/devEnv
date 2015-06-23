#!/bin/bash
#
# Exit on errors or unitialized variables
#
set -e -o nounset


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


# Configure .vimrc
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


# Pick fastest mirrors
#
if(! grep --quiet 'mirror://mirrors' /etc/apt/sources.list )
then
  (
    echo 'deb mirror://mirrors.ubuntu.com/mirrors.txt trusty main restricted universe multiverse'; \
    echo 'deb mirror://mirrors.ubuntu.com/mirrors.txt trusty-updates main restricted universe multiverse'; \
    echo 'deb mirror://mirrors.ubuntu.com/mirrors.txt trusty-backports main restricted universe multiverse'; \
    echo 'deb mirror://mirrors.ubuntu.com/mirrors.txt trusty-security main restricted universe multiverse'
  ) | tee /etc/apt/sources.list
fi


# Update, upgrade and run anything that had been held back (w/ dist-upgrade)
#
apt-get update
apt-get upgrade -y
apt-get dist-upgrade -y


# Install packages
#
apt-get install -y \
  build-essential \
  curl \
  git \
  lynx \
  mongodb \
  nodejs \
  nodejs-legacy \
  npm \
  ntp


# Fix dependencies and remove unnecessary packages
#
apt-get install -f
apt-get autoremove
