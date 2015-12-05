#!/bin/bash

# Config Librarian Puppet

PUPPET_DIR=/etc/puppet/
if [ ! -d "$PUPPET_DIR" ]; then
  mkdir -p $PUPPET_DIR
fi

cp /vagrant/provision/puppet/Puppetfile $PUPPET_DIR

cd $PUPPET_DIR && librarian-puppet update